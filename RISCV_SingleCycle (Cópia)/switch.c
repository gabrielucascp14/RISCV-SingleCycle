int main() {
    int op = 2;
    int result = 0;

    switch (op) {
        case 1:
            result = 10;
            break;
        case 2:
            result = 20;
            break;
        default:
            result = -1;
    }

    asm volatile("mv a0, %0" : : "r"(result));  // move resultado para a0 // Esperado: 20
    asm volatile("ecall");
    return 0;  
}
