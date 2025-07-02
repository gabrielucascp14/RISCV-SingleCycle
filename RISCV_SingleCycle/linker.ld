MEMORY
{
    ROM (rx)  : ORIGIN = 0x00000000, LENGTH = 0x400     /* Memória de instrução */
    RAM (rwx) : ORIGIN = 0x00000400, LENGTH = 0x400   /* 0x400 = 1024 bytes ou 256 words (com 4 bytes cada)*/
}

SECTIONS
{
  /* Código fica na ROM */
    .text : {
        *(.text .text.*)
    } > ROM

  .rodata : {
    *(.rodata)
    *(.rodata.*)
    } > RAM

    .data : {
    *(.data)
    *(.data.*)
    *(.sdata)
    *(.sdata.*)
    } > RAM

    .bss : {
        _bss_start = .;
        *(.bss .bss.*)
        _bss_end = .;
    } > RAM

    /* Definir símbolos para uso no CRT0 */
    _stack_start = ORIGIN(RAM) + LENGTH(RAM) -4;

    /* Símbolo do ponto médio para o gp*/
    /*__gp = ORIGIN(RAM) + LENGTH(RAM)/2; *//* Meio da RAM, 0x200 */
}
