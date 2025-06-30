// Instruction Memory que recebe endereço do PC_counter
// e tem como saída a instrução que informa os operandos
// do registrador, o controle da ALU
module Instruction_Memory(reset, read_address, instruction_out);

input reset;
input [31:0] read_address;
output [31:0] instruction_out;

reg [31:0] memory[0:255]; // 1KB

// A instrução é buscada com base no índice da palavra, não no offset de byte
assign instruction_out = memory[read_address[9:2]];


initial begin
    $readmemh("vetor_instr.hex",memory);
end


/*
initial begin
    // Cada linha abaixo representa uma instrução RISC-V codificada em 32 bits
    memory[0] = 32'h00940333; // add  t1, s0, s1
    memory[1] = 32'h413903b3; // sub  t2, s2, s3
    memory[2] = 32'h035a02b3; // mul  t0, s4, s5
    memory[3] = 32'h017b4e33; // xor  t3, s6, s7
    memory[4] = 32'h019c1eb3; // sll  t4, s8, s9
    memory[5] = 32'h01bd5f33; // srl  t5, s10, s11
    memory[6] = 32'h00d67fb3; // and  t6, a2, a3
    memory[7] = 32'h00f768b3; // or   a7, a4, a5
end
*/

endmodule
