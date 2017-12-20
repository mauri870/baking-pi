@;
@;  A simple program to blink the OK/ACT LED on Raspberry Pi 3
@;

.section .init                      @; kernel initialization code must be on 0x8000
.global _start                      @; define _start label globally available for the linker
_start:
    mov         sp, #0x8000         @; set up the stack pointer

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

delay:
    mov         r0, #0xF0000        @; start counter with a large value
    delay1$:
        sub     r0, #1              @; subtract 1 from the counter
        cmp     r0, #0              @; check if counter reaches zero
        bne     delay1$             @; if not, branch to the delay1$ label
    mov         pc, lr              @; return

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
    bl          mailbox_write       @; write the message to turn the led on
    mov         r0, #8              @; the mailbox channel to read from
    bl          mailbox_read        @; read the mailbox to prevent it to get full 
    pop         {pc}                @; return

mailbox_write:
    ldr         r1, =0x3f00b880     @; load the hex number =0x3f00b880 into register r1
                                    @; this is the base address of the mailboxes
    wait$:
        ldr     r2, [r1, #0x38]     @; load r2 with the address of the status for mailbox 1 (ARM -> VC)
        tst     r2, #0x80000000     @; check if the FIFO queue is full
        bne     wait$               @; branch to wait$ label if the queue is full

    str         r0, [r1, #0x20]     @; put the message into mailbox 1 write address, which is at offset 0x20 from the base address
    mov         pc, lr              @; return

mailbox_read:
    push        {lr}                            @; push the address the function should return to
    mov         r1, r0                          @; save the channel in r1
    ldr         r0, =0x3f00b880                 @; load mailbox base address into r0

    right_mail$:
        wait_read$:
            ldr     r2, [r0, #0x18]             @; get status of mailbox 0 (VC -> ARM)
            tst     r2, #0x40000000             @; check if the mailbox is empty
            bne     wait_read$                  @; if VC FIFO queue is empty branch to wait_read

        ldr     r2, [r0]                        @; load the address of response data

        and     r3, r2, #0b1111                 @; extract the channel, the lowest 4 bits
        teq     r3, r1                          @; check if the response channel is the same we want
        bne     right_mail$                     @; if the channel is wrong branch to wait_read

    and         r0, r2, #0xfffffff0             @; move the response (top 28 bits of mail) into r0
    pop         {pc}                            @; return


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
