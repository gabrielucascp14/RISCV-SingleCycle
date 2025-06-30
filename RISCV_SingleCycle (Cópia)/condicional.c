int main() {
    int a = 10;
    int b = 20;
    int result = 0;

    if (a < b) {
        result = 1;
    } else {
        result = 2;
    }

    asm volatile("mv a0, %0" : : "r"(result));  // move resultado para a0 // Espera 1
    asm volatile("ecall");
    return 0;
}
