@;
@;  A simple program to print formatted strings
@;

.section .init                                  @; kernel initialization code must be on 0x8000
.global _start                                  @; define _start label globally available for the linker
_start:
    mov         sp, #0x8000                     @; set up the stack pointer
    b           _main                           @; branch to main routine

.section .text
_main:
    mov         r0, #1024                       @; screen width
    mov         r1, #768                        @; screen height
    mov         r2, #16                         @; bit depth (high color)
    bl          InitializeFrameBuffer           @; initialize the frame buffer and return its address

    teq         r0, #0                          @; check if function result is 0 (error)
    beq         error                           @; handle error

    bl          SetGraphicsAddress

    mov         r4, #0
    loop$:
        ldr     r0, =format
        ldr     r1, =formatLen
        ldr     r2, =formatLen
        lsr     r3, r4, #4
        push    {r3}
        push    {r3}
        push    {r3}
        push    {r3}
        bl      FormatString
        add     sp, #16

        mov     r1, r0
        ldr     r0,=formatLen
        mov     r2, #0
        mov     r3, r4

        cmp     r3, #768-16
        subhi   r3, #768
        addhi   r2, #256
        cmp     r3, #768-16
        subhi   r3, #768
        addhi   r2, #256
        cmp     r3, #768-16
        subhi   r3, #768
        addhi   r2, #256

        bl      DrawString

        add     r4, #16
        b       loop$

error:
    mov     r0, #1                              @; let state (1 = on)
    bl      SetACTLedState                      @; set led state
    loopErr$:
        b   loopErr$

.section .data
    format:
        .ascii  "%d=0b%b=0x%x=0%o='%c'"
    formatLen:
        .int    . - format
