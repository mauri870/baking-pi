@;
@;  A simple program to blink the OK/ACT LED on Raspberry Pi 3
@;

.global _start                          @; define _start label globally available for the linker

.section .text
_start:
    mov         sp, #0x8000         @; set up the stack pointer

    loop$:                          @; main loop

    bl          delay               @; branch to delay function

    @; enable led
    mov         r0, #1              @; led state 1 = on
    bl          set_led_state       @ set led state

    bl          delay               @; branch to delay function

    @; disable led
    mov         r0, #0              @; led state 0 = off
    bl          set_led_state       @; set led state

    b           loop$               @; branch to main loop$

delay:
    mov         r0, #0xF0000    @; start counter with a large value
    delay1$:
        sub     r0, #1          @; subtract 1 from the counter
        cmp     r0, #0          @; check if counter reaches zero
        bne     delay1$         @; if not, branch to the delay1$ label
    mov         pc, lr          @; return

set_led_state:
    push        {lr}                @; save address the function should return to
    mov         r1, r0              @; move the led state to r1
    ldr         r0, =message        @; load the message into r0
    mov         r2, #0
    str         r2, [r0, #0x4]      @; reset request code
    str         r2, [r0, #0x10]     @; reset request/response size
    mov         r2, #130
    str         r2, [r0, #0x14]     @; reset pin number

    str         r1, [r0, #0x18]     @; overwrite the led state
    add         r0, #8              @; add the channel 8 as the last 4 bits of the message
    bl          mailbox_write
    pop         {pc}                @; return

mailbox_write:
    ldr         r1, =0x3f00b880     @; load the hex number =0x3f00b880 into register r1
                                    @; this is the base address of the mailboxes
    wait$:
        ldr     r2, [r1, #0x18]     @; load r2 with the address of the offset 0x18 for mailbox 0 (read mailbox)
        tst     r2, #0x80000000     @; check if the full flag is set
        bne     wait$               @; branch to wait$ label if the full flag is not set

    str         r0, [r1, #0x20]     @; put the message into mailbox 1 write register, which is at offset 0x20 from the base address
    mov         pc, lr              @; return

.section .data
.align 4                @; last 4 bits of the next label set to 0 (16-byte alligned)
message:
    .int    size        @; message header contains the size of the message
    .int    0           @; request code 0

    .int    0x00038041  @; header tag ID
    .int    8           @; size of tag data
    .int    0           @; request/response size 

    .int    130         @; pin number
    .int    1           @; pin state
    .int    0           @; signal the GPU that the message is over
size:
    .int    . - message @; size of the message