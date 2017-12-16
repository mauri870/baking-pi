@;
@;  A simple program to draw a gradient to the screen
@;

.section .init                              @; kernel initialization code must be on 0x8000
.global _start                              @; define _start label globally available for the linker
_start:
    mov         sp, #0x8000                 @; set up the stack pointer
    b           _main                       @; branch to main routine

.section .text
_main:
    mov         r0, #1024                   @; screen width
    mov         r1, #768                    @; screen height
    mov         r2, #16                     @; bit depth (high color)
    bl          InitializeFrameBuffer       @; initialize the frame buffer and return its address

    teq         r0, #0                      @; check if function result is 0 (error)
    beq         error                       @; handle error

    fbInfoAddr  .req r4                     @; set up alias
    mov         fbInfoAddr, r0              @; frame buffer address returned by the function

    render$:
        fbAddr  .req r3
        ldr     fbAddr, [fbInfoAddr, #32]
        and     fbAddr, #0x3FFFFFFF         @; convert bus address to physical address used by the ARM CPU

        color   .req r0
        y       .req r1
        mov     y, #768                     @; set y with the first row pixel
        drawRow$:
            x   .req r2
            mov x, #1024                    @; set x with the first screen row
            drawPixel$:
                strh    color, [fbAddr]     @; store low half word at fb pointer
                add     fbAddr, #2          @; skip half word to the next address
                sub     x, #1               @; subtract 1 from the screen width
                teq     x, #0               @; check if x reaches 0
                bne     drawPixel$          @; proceed to next pixel

            sub y, #1                       @; decrement screen height
            add color, #1                   @; increment color value
            teq y, #0                       @; check of y reaches 0
            bne drawRow$                    @; proceed to next row

        b   render$                         @; keep updating the screen

    .unreq  fbInfoAddr                      @; unset alias
    .unreq  fbAddr
    .unreq  y
    .unreq  x

error:
    mov     r0, #1                  @; let state (1 = on)
    bl      SetACTLedState          @; set led state
    loop$:
        b   loop$                   @; keep the cpu busy forever
