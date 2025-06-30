#include <stdint.h>
#include <math.h>
#include <stdio.h>

void func(int *a, int *b, int *r) {
    *r = *a + *b;
}

int main() {
    int c = 4;
    int d = 3;
    int e;

    func(&c, &d, &e);

    // Finaliza execução
    asm volatile("mv a0, %0" : : "r"(e));  // move resultado para a0
    asm volatile ("ecall");

    return 0;
}
