@;
@;  A simple program to flash the SOS message in Morse using the OK/ACT led
@;

.section .init                      @; kernel initialization code must be on 0x8000
.global _start                      @; define _start label globally available for the linker
_start:
    mov         sp, #0x8000         @; set up the stack pointer
    b           _main               @; branch to main routine

.section .text
_main:
    ldr         r2, =sos            @; load the address of the sos data
    ldr         r2, [r2]            @; load the binary content into r2
    mov         r3, #0              @; use r3 to keep track of the position

    loop$:                          @; main loop
        mov     r0, #1              @; r0 start value
        lsl     r0, r3              @; left shift r3 one place to the left
        and     r0, r2              @; and between the r0 value and the current message place

        bl      set_led_state       @; set led state

        ldr     r0, =0x7A120        @; delay in microseconds (0.5s)
        bl      delay               @; branch to delay function

        add     r3, #1              @; increment our position tracker
        and     r3, #0b11111        @; reset the sequence to 0 if >= 32

        b       loop$               @; branch to main loop$

.section .data
.align 2
sos:
.int 0b11111111101010100010001000101010
