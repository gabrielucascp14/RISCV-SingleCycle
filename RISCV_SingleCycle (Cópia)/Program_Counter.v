// RISC-V Single-Cycle Processor

// Program Counter
// Registrador de PC com endereços de instruçoes
// Recebe PC_in que e calculado externamente com PC_out+4
// clk atualiza o contador e reset reinicia para valor inicial 32'b00
// PC_in e o proximo valor e o PC_out e o atual. Possuem 32 bits
module Program_Counter(clk, reset, PC_in, PC_out);

input clk, reset;
input [31:0] PC_in;      
output reg [31:0] PC_out;

// --> reg é um tipo de dado usado para variáveis que mantêm um valor entre as atribuições em blocos de procedimento (always, initial, etc.).
// Não significa que será um registrador físico (flip-flop) no hardware! Isso depende de como o reg é usado.
// É obrigatório usar reg para variáveis que são atribuídas dentro de blocos procedurais (como always ou initial

// bloco de logica sequencial
// bloco acionado por posedge: borda de subida
always @(posedge clk or posedge reset)
begin
if(reset == 1'b1) 
	PC_out <= 32'h0000000; //valor hex de 32 bits. <tamanho>'<base><valor>
else
	PC_out <= PC_in;
end

endmodule