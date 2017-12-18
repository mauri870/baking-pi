@;
@;  A simple program to turn on the OK/ACT LED on Raspberry Pi 3
@;

.section .init                      @; kernel initialization code must be on 0x8000
.global _start                      @; define _start label globally available for the linker
_start:
    ldr         r0, =0x3f00b880     @; load the hex number 0x3f00b880 into register r0
                                    @; this is the base address of the mailboxes
    wait$:
        ldr     r1, [r0, #0x38]     @; load r1 with the address of the offset 0x38 for mailbox 1 (ARM -> VC)
        tst     r1, #0x80000000     @; check if the FIFO queue is full
        bne     wait$               @; branch to wait$ label if the queue is full

    ldr         r1, =message        @; load the message into r1
    add         r1, #8              @; add the channel 8 as the last 4 bits of the message
    str         r1, [r0, #0x20]     @; put the message into mailbox 1 write address, which is at offset 0x20 from the base address

    loop$:                          @; keep the cpu busy forever in the loop
        b       loop$

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
