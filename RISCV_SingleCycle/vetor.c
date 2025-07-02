#define SIZE 4

int main() {
    // Vetor inicializado estaticamente (irá para .data ou .rodata)
    int vector[SIZE] = {10, 20, 30, 40};

    // Variável de resultado (irá para a pilha ou .data)
    int sum = 0;

    // Soma os elementos do vetor
    for (int i = 0; i < SIZE; i++) {
        sum += vector[i];
    }

    // Retorna a soma (para verificação no simulador/registrador)
    asm volatile("mv a0, %0" : : "r"(sum));  // move resultado para a0
    asm volatile("ecall");
    return 0;
}
