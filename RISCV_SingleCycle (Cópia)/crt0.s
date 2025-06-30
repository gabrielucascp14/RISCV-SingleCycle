.section .text
.global _start
_start:
    /* 1. Configura a pilha */
    la sp, _stack_start
 /*   la gp, __gp*/

    /* 2. Zera a seção .bss */
    la a0, _bss_start
    la a1, _bss_end
    bgeu a0, a1, skip_bss_zero
zero_bss_loop:
    sw zero, 0(a0)
    addi a0, a0, 4
    bltu a0, a1, zero_bss_loop
skip_bss_zero:

    # Chama a main
    call main

    /* 4. Loop infinito caso main retorne */
infinity_loop:
    j infinity_loop
