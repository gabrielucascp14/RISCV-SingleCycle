int main() {
    int sum = 0;

    for (int i = 0; i < 5; i++) {
        sum += i;
    }
    asm volatile("mv a0, %0" : : "r"(sum));  // move resultado para a0 // Esperado: 0+1+2+3+4 = 10
    asm volatile ("ecall");
    return 0;  
}
