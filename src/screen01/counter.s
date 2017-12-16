@;
@;  Counter functions to be used by this exercise
@;

.section .text
.global delay
delay:
    ldr         r1, =0x3F000000     @; pi peripheral address
    orr         r1, r1, #0x3000     @; r1 = r1 | 0x3000 = 0x3F003000 timer base address
    ldr         r2, [r1, #0x4]      @; time in microseconds given by the timer
    delay1$:
        ldr     r3, [r1, #0x4]      @; get timer in microseconds in each iteration
        sub     r3, r3, r2          @; current timer - initial timer
        cmp     r3, r0              @; compare time elapsed with desired timer
        blt     delay1$             @; if elapsed time < desired timer repeat the loop
    mov         pc, lr              @; return
