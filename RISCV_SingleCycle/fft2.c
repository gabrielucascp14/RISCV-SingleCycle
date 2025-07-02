#include <stdint.h>
#include <math.h>
#include <stdio.h>


#define N 8
int real[N] = {1000, 0, -1000, 0, 1000, 0, -1000, 0};
int imag[N] = {0};

void fft(int *real, int *imag) {
    for (int step = 1; step < N; step *= 2) {
        for (int i = 0; i < N; i += 2*step) {
            for (int j = 0; j < step; ++j) {
                int t_real = real[i+j+step];
                int t_imag = imag[i+j+step];
                real[i+j+step] = real[i+j] - t_real;
                imag[i+j+step] = imag[i+j] - t_imag;
                real[i+j] += t_real;
                imag[i+j] += t_imag;
            }
        }
    }
}

int main() {
 //   int real[N] = {1000, 0, -1000, 0};
//  int imag[N] = {0};

    fft(real, imag);
    /*for (int i = 0; i < N; ++i) {
        printf("X[%d] = %d + %di\n", i, real[i], imag[i]);

    }*/
    // Finaliza execução
    asm volatile("mv a0, %0" : : "r"(real[3]));  // move resultado para a0
    asm volatile ("ecall");

    return 0;
}