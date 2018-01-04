@;
@;  A simple program to draw text to the screen
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

    mov         r0, #9                          @; the tag to read from (cmdline)
    bl          FindTag                         @; read the tag from the ARM processor
    ldr         r1, [r0]                        @; load address into r1
    lsl         r1, #2                          @; logical left shift r1 by 2
    sub         r1, #8                          @; get the lenght of cmdline 
    add         r0, #8                          @; get cmdline string address
    mov         r2, #0                          @; X position
    mov         r3, #0                          @; Y position
    bl          DrawString

    hang$:
        b       hang$                           @; keep the cpu busy forever

error:
    mov     r0, #1                              @; let state (1 = on)
    bl      SetACTLedState                      @; set led state
    loop$:
        b   loop$
