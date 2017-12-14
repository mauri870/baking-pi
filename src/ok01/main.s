@;
@;  A simple program to turn on the OK/ACT LED on Raspberry Pi 3
@;

.global _start                          @; define _start label globally available for the linker

.section .text
_start:
    ldr         r0, =0x3f00b880     @; load the hex number 0x3f00b880 into register r0
                                    @; this is the base address of the mailboxes
    wait$:
        ldr     r1, [r0, #0x18]     @; load r1 with the address of the offset 0x18 for mailbox 0 (read mailbox)
        tst     r1, #0x80000000     @; check if the full flag is set
        bne     wait$               @; branch to wait$ label if the full flag is not set

    ldr         r1, =message        @; load the message into r1
    add         r1, #8              @; add the channel 8 as the last 4 bits of the message
    str         r1, [r0, #0x20]     @; put the message into mailbox 1 write register, which is at offset 0x20 from the base address

    loop$:                          @; keep the cpu busy forever in the loop
    b loop$

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
