# OK02 - Blinking the 'OK' or 'ACT' LED on the Raspberry Pi 3

This exercise make use of a delay in order to blink the OK/ACT led. I've used some aditional concepts (like function calls and the use of the stack) that are not intended to be made here, but in OK03. So, this exercise is a resolution for both OK02 and OK03.

## Notes

I was stuck for a while with this exercise because I use the stack without setting the stack pointer address (sp register) properly. I managed to solve it by myself, as you can see in the code but the OK03 page explain this part in detail.