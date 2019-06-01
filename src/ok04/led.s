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
    str         r2, [r0, #4]        @; reset request code
    str         r2, [r0, #16]       @; reset request/response size
    mov         r2, #130
    str         r2, [r0, #20]       @; reset pin number

    str         r1, [r0, #24]       @; overwrite the led state
    add         r0, #8              @; add the channel 8 as the last 4 bits of the message
    bl          mailbox_write       @; write the message to mailbox
    mov         r0, #8              @; the channel to read the message from
    bl          mailbox_read        @; read the message to prevent the FIFO queue to get full
    pop         {pc}                @; return

.section .data
.align 4                            @; last 4 bits of the next label set to 0 (16-byte alligned)
message:
    .int    size                    @; #0 message header contains the size of the message
    .int    0                       @; #4 request code 0

    .int    0x00038041              @; #8 header tag ID
    .int    8                       @; #12 size of tag data
    .int    0                       @; #16 request/response size 

    .int    130                     @; #20 pin number
    .int    1                       @; #24 pin state
    .int    0                       @; #28 signal the GPU that the message is over
size:
    .int    . - message             @; size of the message

