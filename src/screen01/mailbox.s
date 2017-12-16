@;
@;  Functions to interact with the mailbox
@;

.section .text
.global GetMailboxBase
GetMailboxBase:
    ldr         r0, =0x3f00b880                 @; move the mailbox base address to r0
    mov         pc, lr                          @; return

.global MailboxWrite
MailboxWrite:
    push        {lr}                            @; push the address the function should return to
    channel     .req r1                         @; set an alias for the mailbox id
    message     .req r2                         @; set an alias for the message
    mov         message, r0                     @; save the message in a temporary register
    bl          GetMailboxBase                  @; get mailbox base address
    mailbox     .req r0                         @; set an alias for r0

    wait_write$:
        status  .req r3                         @; set an alias for r3
        ldr     status, [mailbox, #0x38]        @; get status of mailbox 1
        tst     status, #0x80000000             @; check if mailbox is full
        .unreq  status                          @; unset alias
        bne     wait_write$                     @; branch to wait$ label if the full flag is not set

    add         message, channel                @; set channel as the last bits of message
    .unreq      channel                         @; unset alias
    str         message, [mailbox, #0x20]       @; put the message into mailbox 1 write register, which is at offset 0x20 from the base address

    .unreq      message                         @; unset alias
    .unreq      mailbox                         @; unset alias
    pop         {pc}                            @; return

.global MailboxRead
MailboxRead:
    push        {lr}                            @; push the address the function should return to
    channel     .req r1                         @; set up alias
    mov         channel, r0                     @; save the channel in r1
    bl          GetMailboxBase                  @; get mailbox base address
    mailbox     .req r0                         @; set up alias

    right_mail$:
        wait_read$:
            status  .req r2                     @; set up alias
            ldr     status, [mailbox, #0x18]    @; get status of mailbox 0 (VC -> ARM)
            tst     status, #0x40000000         @; check if the mailbox is empty
            .unreq  status                      @; unset alias
            bne     wait_read$                  @; if VC FIFO queue is empty branch to wait_read

        mail    .req r2                         @; set up alias
        ldr     mail, [mailbox]                 @; load the address of response data

        inchan  .req r3                         @; set up alias
        and     inchan, mail, #0b1111           @; extract the channel, the lowest 4 bits
        teq     inchan, channel                 @; check if the response channel is the same we want
        .unreq  inchan                          @; unset alias
        bne     right_mail$                     @; if the channel is wrong branch to wait_read
        .unreq  mailbox                         @; unset alias
        .unreq  channel

    and         r0, mail, #0xfffffff0           @; move the response (top 28 bits of mail) into r0
    .unreq      mail                            @; unset alias
    pop         {pc}                            @; return

