#include <stdint.h>
#include <math.h>
#include <stdio.h>

int c = 4;
int d = 3;

void func(int *a, int *b, int *r) {
    *r = *a + *b;
}

int main() {
    int e;

    func(&c, &d, &e);
    // printf("Resultado = %d\n", e);
    // Finaliza execução
    asm volatile("mv a0, %0" : : "r"(e));  // move resultado para a0
    asm volatile ("ecall");

    return 0;
}
