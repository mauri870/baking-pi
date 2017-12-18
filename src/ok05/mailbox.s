@;
@;  Functions to interact with the mailbox
@;

.section .text
.global mailbox_write
mailbox_write:
    ldr         r1, =0x3f00b880     @; load the hex number =0x3f00b880 into register r1
                                    @; this is the base address of the mailboxes
    wait$:
        ldr     r2, [r1, #0x38]     @; load r2 with the address of the status for mailbox 1 (ARM -> VC)
        tst     r2, #0x80000000     @; check if the FIFO queue is full
        bne     wait$               @; branch to wait$ label if the queue is full

    str         r0, [r1, #0x20]     @; put the message into mailbox 1 write register, which is at offset 0x20 from the base address
    mov         pc, lr              @; return
