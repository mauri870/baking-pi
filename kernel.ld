MEMORY
{
  /*
   * Memory for the stack and sections
   */
  RAM (rwx)  : ORIGIN = 0x8000, LENGTH = 1024K
}

SECTIONS {
  /* Put the initialization code at 0x8000, leaving room for ARM
   * and the stack. It also conforms to the standard expectations.
   */
  .init : {
    *(.init)
  } > RAM

  /* Put the rest of code next */
  .text : {
    *(.text)
  } > RAM

  /* Put the data after the code */
  .data : {
    *(.data)
  } > RAM
}