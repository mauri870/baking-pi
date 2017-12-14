@;
@;  Counter functions to be used by this exercise
@;

.section .text
.global delay
delay:
    mov         r0, #0xF0000        @; start counter with a large value
    delay1$:
        sub     r0, #1              @; subtract 1 from the counter
        cmp     r0, #0              @; check if counter reaches zero
        bne     delay1$             @; if not, branch to the delay1$ label
    mov         pc, lr              @; return
