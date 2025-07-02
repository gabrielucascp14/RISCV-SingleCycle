#include <stdint.h>
#include <math.h>
#include <stdio.h>

//#define N 4

void fft(int *real, int *imag, int N) {
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
    int N = 4;
    int real[N];
    real[0] = 1000;
    real[1] = 0;
    real[2] = -1000;
    real[3] = 0;

    int imag[N];
    imag[0] = 0;
    imag[1] = 0;
    imag[2] = 0;
    imag[3] = 0;

    fft(real, imag, N);

    // Finaliza execução
    asm volatile("mv a0, %0" : : "r"(real[3]));  // move resultado para a0
    asm volatile ("ecall");

    return 0;
}
