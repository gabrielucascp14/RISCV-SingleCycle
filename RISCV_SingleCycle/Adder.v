// Adder for shifting instructions

module Adder(in_1, in_2, sum);

input [31:0] in_1, in_2;
output [31:0] sum;

assign sum = in_1 + in_2;

endmodule