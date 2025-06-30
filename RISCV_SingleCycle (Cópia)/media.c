int main() {
    int a = 10;
    int b = 20;
    int c = 30;
    int d = 40;

    int sum = a + b + c + d;
    int avg = sum / 4;

    asm volatile("mv a0, %0" : : "r"(avg));  // move resultado para a0 // deve retornar 25
    asm volatile("ecall"); // Para sinalizar fim de programa na simulação
    return 0;
}

