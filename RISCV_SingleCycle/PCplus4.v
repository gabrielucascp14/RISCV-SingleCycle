// PC Adder
// O cálculo PC + 4 é um cálculo imediato necessário no mesmo ciclo em que a instrução está sendo buscada.
module PCplus4(clk, reset, fromPC, NextoPC);

input clk, reset;
input [31:0] fromPC;
output [31:0] NextoPC;

assign NextoPC = fromPC + 4;



endmodule
