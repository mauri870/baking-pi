@;
@;  Functions to interact with the leds
@;

.section .text
.global set_led_state
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

.section .data
.align 4                            @; last 4 bits of the next label set to 0 (16-byte alligned)
message:
    .int    size                    @; message header contains the size of the message
    .int    0                       @; request code 0

    .int    0x00038041              @; header tag ID
    .int    8                       @; size of tag data
    .int    0                       @; request/response size 

    .int    130                     @; pin number
    .int    1                       @; pin state
    .int    0                       @; signal the GPU that the message is over
size:
    .int    . - message             @; size of the message
