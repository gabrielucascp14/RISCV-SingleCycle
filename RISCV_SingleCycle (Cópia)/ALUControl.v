module ALUControl (ALUOp_in, func7, func3, ALUControl_out);
  input [1:0] ALUOp_in;
  input [6:0] func7;
  input [2:0] func3;
  output reg [3:0] ALUControl_out;

  always @(*) begin
    casex ({ALUOp_in, func7, func3})
      // Load/store
      12'b00_xxxxxxx_xxx : ALUControl_out = 4'b0010;  // ADD

      // Branch (ALUOp = 01)
      12'b01_xxxxxxx_000 : ALUControl_out = 4'b0110;  // BEQ -> SUB + zero == 1
      12'b01_xxxxxxx_001 : ALUControl_out = 4'b1011;  // BNE -> SUB + zero == 0
      12'b01_xxxxxxx_100 : ALUControl_out = 4'b1100;  // BLT (signed)
      12'b01_xxxxxxx_101 : ALUControl_out = 4'b1101;  // BGE (signed)
      12'b01_xxxxxxx_110 : ALUControl_out = 4'b1110;  // BLTU (unsigned)
      12'b01_xxxxxxx_111 : ALUControl_out = 4'b1111;  // BGEU (unsigned)

      // R-type
      12'b10_0000000_000 : ALUControl_out = 4'b0010;  // ADD
      12'b10_0100000_000 : ALUControl_out = 4'b0110;  // SUB
      12'b10_0000000_111 : ALUControl_out = 4'b0000;  // AND
      12'b10_0000000_110 : ALUControl_out = 4'b0001;  // OR
		  12'b10_0000000_100 : ALUControl_out = 4'b0011;  // XOR 
      12'b10_0000000_001 : ALUControl_out = 4'b1000;  // SLL
      12'b10_0000000_101 : ALUControl_out = 4'b1001;  // SRL
      12'b10_0100000_101 : ALUControl_out = 4'b1010;  // SRA

      // I-type shift
      12'b11_0000000_001 : ALUControl_out = 4'b1000;  // SLLI
      12'b11_0000000_101 : ALUControl_out = 4'b1001;  // SRLI
      12'b11_0100000_101 : ALUControl_out = 4'b1010;  // SRAI

      // I-type simples
      12'b11_xxxxxxx_000 : ALUControl_out = 4'b0010;  // ADDI
      12'b11_xxxxxxx_111 : ALUControl_out = 4'b0000;  // ANDI
      12'b11_xxxxxxx_110 : ALUControl_out = 4'b0001;  // ORI
		  12'b11_xxxxxxx_100 : ALUControl_out = 4'b0011;  // XORI

      default: ALUControl_out = 4'b0000; // Default para segurança
    endcase
  end
endmodule
