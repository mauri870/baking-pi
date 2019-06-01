@;
@;  Functions to interact with the mailbox
@;

.section .text
.global mailbox_write
mailbox_write:
    ldr         r1, =0x3f00b880                 @; load the hex number =0x3f00b880 into register r1
                                                @; this is the base address of the mailboxes
    wait$:
        ldr     r2, [r1, #0x38]                 @; load r2 with the address of the status for mailbox 1 (ARM -> VC)
        tst     r2, #0x80000000                 @; check if the FIFO queue is full
        bne     wait$                           @; branch to wait$ label if the queue is full

    str         r0, [r1, #0x20]                 @; put the message into mailbox 1 write register, which is at offset 0x20 from the base address
    mov         pc, lr                          @; return

.global mailbox_read
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
