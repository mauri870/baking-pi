@; 
@; Functions to interact with the ARM processor tags
@; 

.section .text
.global FindTag
FindTag:
    tag     .req r0
    tagList .req r1
    tagAddr .req r2

    sub     tag, #1
    cmp     tag, #8
    movhi   tag, #0
    movhi   pc, lr                                  @; return if tag > 9

    ldr     tagList, =tagCore                       @; load tagCore into r1
    tagRet$:
        add     tagAddr, tagList, tag, lsl #2       @; get address of the respective tag from tagCore
        ldr     tagAddr, [tagAddr]                  @; Load address pointed by r2

        teq     tagAddr, #0                         @; check if tag is already detected
        movne   r0, tagAddr
        movne   pc,lr

        ldr     tagAddr, [tagList]                  @; load tagList address
        teq     tagAddr, #0                         @; check if tag is already detected
        movne   r0, #0
        movne   pc, lr

        mov     tagAddr, #0x100                     @; point tagAddr to 0x100
        push    {r4}
        tagIdx  .req r3
        oldAddr .req r4
        tagLoop$:
            ldrh    tagIdx, [tagAddr,#4]            @; load word from tag item
            subs    tagIdx, #1                      @; subtract 1 from r3 and compare to zero
            poplt   {r4}
            blt     tagRet$

            add     tagIdx, tagList, tagIdx, lsl #2 @; taglist + (tagIdx << 2)
            ldr     oldAddr, [tagIdx]
            teq     oldAddr, #0
            .unreq  oldAddr
            streq   tagAddr, [tagIdx]               @; store if equal

            ldr     tagIdx, [tagAddr]               @; next index
            add     tagAddr, tagIdx, lsl #2
            b       tagLoop$

    .unreq  tag
    .unreq  tagList
    .unreq  tagAddr
    .unreq  tagIdx

.section .data
    tagCore:        .int 0
    tag_mem:        .int 0
    tag_videotext:  .int 0
    tag_ramdisk:    .int 0
    tag_initrd2:    .int 0
    tag_serial:     .int 0
    tag_revision:   .int 0
    tag_videolfb:   .int 0
    tag_cmdline:    .int 0