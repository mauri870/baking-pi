@;
@; Functions to draw on the screen
@;

.section .text
.global DrawPixel
DrawPixel:
    px      .req r0
    py      .req r1
    addr    .req r2

    ldr     addr, =graphicsAddress                  @; load address into r2
    ldr     addr, [addr]                            @; load the value into r2

    height  .req r3
    ldr     height, [addr, #4]                      @; load the height into r3
    sub     height, #1                              @; subtract 1 from height
    cmp     py, height                              @; cmp py with the actual height
    movhi   pc, lr                                  @; return if higher
    .unreq height

    width  .req r3
    ldr     width, [addr, #0]                       @; load the width into r3
    sub     width, #1                               @; subtract 1 from width
    cmp     px, width                               @; cmp py with the actual width
    movhi   pc, lr                                  @; return if higher

    ldr     addr, [addr, #32]                       @; get the gpu pointer for the framebuffer response
    and     addr, #0x3FFFFFFF                       @; convert bus address to physical address used by the ARM CPU

    add     width, #1                               @; add 1 to r3
    mla     px, py, width, px                       @; multiply px with width, adds px and store the least significant 32 bits into px
    .unreq  width
    .unreq  py
    add     addr, px, lsl #1                        @; adds px and addr and left shift by 1
    .unreq  px
    fore    .req r3
    ldr     fore, =foreColor                        @; load forecolor address into r3
    ldrh    fore, [fore]                            @; load half word from fore into r3

    strh    fore, [addr]                            @; store half word from fore into gpu framebuffer pointer
    .unreq  fore
    .unreq  addr
    mov     pc, lr                                  @; return

.global DrawLine
DrawLine:
    push    {r4,r5,r6,r7,r8,r9,r10,r11,r12,lr}      @; push registers into stack to preserve values
    x0      .req r9
    x1      .req r10
    y0      .req r11
    y1      .req r12

    mov     x0, r0                                  @; move function args into registers
    mov     x1, r2
    mov     y0, r1
    mov     y1, r3

    dx      .req r4
    dyn     .req r5                                 @; delta y negative stored for speed
    sx      .req r6
    sy      .req r7
    err     .req r8

    cmp     x0, x1                                  @; compare x0 and x1
    subgt   dx, x0, x1                              @; if x0 greater than x1 subtract and store into dx
    movgt   sx, #-1                                 @; if x0 greater than x1 move -1 to step x
    suble   dx, x1, x0                              @; if x0 less than or equal x1 subtract and store into dx
    movle   sx, #1                                  @; if x0 less than or equal x1 move 1 into step x

    cmp     y0, y1
    subgt   dyn, y1, y0
    movgt   sy, #-1
    suble   dyn, y0, y1
    movle   sy, #1

    add     err, dx, dyn
    add     x1, sx
    add     y1, sy

    pixelLoop$:
        teq     x0, x1
        teqne   y0, y1
        popeq   {r4,r5,r6,r7,r8,r9,r10,r11,r12,pc}

        mov     r0, x0
        mov     r1, y0
        bl      DrawPixel

        cmp     dyn, err, lsl #1
        addle   err, dyn
        addle   x0, sx

        cmp     dx, err, lsl #1
        addge   err, dx
        addge   y0, sy

        b       pixelLoop$

    .unreq x0
    .unreq x1
    .unreq y0
    .unreq y1
    .unreq dx
    .unreq dyn
    .unreq sx
    .unreq sy
    .unreq err

.global SetForeColor
SetForeColor:
    cmp     r0, #0x10000                            @; compare color to max integer
    movhs   pc, lr                                  @; return according to cmp flags (higher or same)
    ldr     r1, =foreColor                          @; load forecolor into register r1
    strh    r0, [r1]                                @; store half word from r0 into r1
    mov     pc, lr                                  @; return

.global SetGraphicsAddress
SetGraphicsAddress:
    ldr     r1, =graphicsAddress                    @; load graphics address into r1
    str     r0, [r1]                                @; store r0 into r1
    mov     pc, lr                                  @; return

.section .data
.align 1
foreColor:
    .hword 0xFFFF                                   @; half word with the forecolor (white)

.align 2
graphicsAddress:
    .int 0                                          @; graphics address (default 0)
