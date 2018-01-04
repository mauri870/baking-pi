@;
@;  A simple program to draw lines to the screen at random positions
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

    lastRandom  .req r7
    lastX       .req r8
    lastY       .req r9
    color       .req r10
    x           .req r5
    y           .req r6

    mov         lastRandom, #0                  @; reset registers
    mov         lastX, #0
    mov         r9, #0
    mov         r10, #0

    render$:
        mov     r0, lastRandom
        bl      Random
        mov     x, r0
        bl      Random
        mov     y, r0
        mov     lastRandom, r0

        mov     r0, color
        add     color, #1
        lsl     color, #16
        lsr     color, #16
        bl      SetForeColor
            
        mov     r0, lastX
        mov     r1, lastY
        lsr     r2, x, #22
        lsr     r3, y, #22

        cmp     r3, #768
        bhs     render$
        
        mov     lastX, r2
        mov     lastY, r3
        
        bl      DrawLine

        b       render$

	.unreq x
	.unreq y
	.unreq lastRandom
	.unreq lastX
	.unreq lastY
	.unreq color

error:
    mov     r0, #1                  @; let state (1 = on)
    bl      SetACTLedState          @; set led state
    loop$:
        b   loop$                   @; keep the cpu busy forever
