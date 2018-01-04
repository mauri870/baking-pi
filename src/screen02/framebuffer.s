@;
@; Functions to define framebuffers to interact with the GPU
@;

.section .text
.global InitializeFrameBuffer
InitializeFrameBuffer:
    width       .req r0                         @; set up alias
    height      .req r1
    bitDepth    .req r2

    cmp         width, #4096                    @; compare width with 4096
    cmpls       height, #4096                   @; compare height with 4096 if width is less or equal to 4096
    cmpls       bitDepth, #32                   @; compare bitDepth with 32 if height is less or equal to 4096
    result      .req r0
    movhi       result, #0                      @; mov 0 to result if last cmp C and Z flag are clear (higher)
    movhi       pc, lr                          @; return if last cmp C and Z flag are clear (higher)

    push        {r4, lr}                        @; save the address the function should return to

    fbInfoAddr  .req r4
    ldr         fbInfoAddr, =FrameBufferInfo    @; load frame buffer addr into register
    str         width, [fbInfoAddr]             @; store width into fbInfoAddr offset 0
    str         height, [fbInfoAddr, #4]        @; store height into fbInfoAddr offset 4
    str         width, [fbInfoAddr, #8]         @; store width into fbInfoAddr offset 8
    str         height, [fbInfoAddr, #12]       @; store height into fbInfoAddr offset 12
    str         bitDepth, [fbInfoAddr, #20]     @; store bitDepth into fbInfoAddr offset 20
    .unreq      width                           @; unset alias
    .unreq      height
    .unreq      bitDepth

    mov         r1, #0
    str         r1, [fbInfoAddr, #16]           @; reset framebuffer
    str         r1, [fbInfoAddr, #24]
    str         r1, [fbInfoAddr, #28]
    str         r1, [fbInfoAddr, #32]
    str         r1, [fbInfoAddr, #36]

    mov         r0, fbInfoAddr
    bl          FrameBufferWrite                @; write message to mailbox
    teq         result, #0                      @; check if last function succeed
    movne       result, #0                      @; if result not equal to 0, set result to 0
    popne       {r4, pc}                        @; return if result not equal to 0

    mov         result, fbInfoAddr              @; mov frame buffer info address to r0
    .unreq      result
    .unreq      fbInfoAddr
    pop         {r4, pc}                        @; return

.global FrameBufferWrite
FrameBufferWrite:
    push        {lr}
    orr         r0, #0xC0000000                 @; signal the GPU to not flush its cache
    mov         r1, #1                          @; channel for mailbox write
    bl          MailboxWrite                    @; write message to mailbox channel 1

    mov         r0, #1                          @; channel for mailbox read
    bl          MailboxRead                     @; read the response from mailbox channel 1
    pop         {pc}

.section .data
.align 4
.global FrameBufferInfo
FrameBufferInfo:
    .int        1024                            @; #0 Physical Width
    .int        768                             @; #4 Physical Height
    .int        1024                            @; #8 Virtual Width
    .int        768                             @; #12 Virtual Height
    .int        0                               @; #16 GPU - Pitch
    .int        16                              @; #20 Bit Depth
    .int        0                               @; #24 X
    .int        0                               @; #28 Y
    .int        0                               @; #32 GPU - Pointer
    .int        0                               @; #36 GPU - Size
