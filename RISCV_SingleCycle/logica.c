int main() {
    int a = 5;
    int b = 3;

    int r1 = a + b;    // add
    int r2 = a - b;    // sub
    int r3 = a & b;    // and
    int r4 = a | b;    // or
    int r5 = a ^ b;    // xor

    return r1 + r2 + r3 + r4 + r5;  // Esperado: 8 + 2 + 1 + 7 + 6 = 24
}

