@;
@;  A simple program to blink the OK/ACT LED on Raspberry Pi 3
@;

.section .init                      @; kernel initialization code must be on 0x8000
.global _start                      @; define _start label globally available for the linker
_start:
    mov         sp, #0x8000         @; set up the stack pointer
    b           _main               @; branch to main routine

.section .text
_main:
    loop$:                          @; main loop

        bl      delay               @; branch to delay function

        @; enable led
        mov     r0, #1              @; led state 1 = on
        bl      set_led_state       @; set led state

        bl      delay               @; branch to delay function

        @; disable led
        mov     r0, #0              @; led state 0 = off
        bl      set_led_state       @; set led state

        b       loop$               @; branch to main loop$
