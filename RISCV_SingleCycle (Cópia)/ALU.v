module ALU(
  input [31:0] A, B,
  input [3:0] ALUControl_in,
  output reg [31:0] ALU_result,
  output reg zero
);

wire [4:0] shamt = B[4:0];  // shift amount

always @(*) begin
  zero = 0;
  case (ALUControl_in)
    4'b0000: ALU_result = A & B;               // AND
    4'b0001: ALU_result = A | B;               // OR
	 4'b0011: ALU_result = A ^ B;               // XOR 
    4'b0010: ALU_result = A + B;               // ADD
    4'b0110: begin                             // SUB
      ALU_result = A - B;
      zero = (A == B);                         // usado em BEQ
    end
    4'b1000: ALU_result = A << shamt;          // SLL
    4'b1001: ALU_result = A >> shamt;          // SRL
    4'b1010: ALU_result = $signed(A) >>> shamt;// SRA

    // Comparações de branch
    4'b1011: begin  // BNE
      ALU_result = A - B;
      zero = (A != B);
    end
    4'b1100: begin  // BLT (signed)
      ALU_result = 0;
      zero = ($signed(A) < $signed(B));
    end
    4'b1101: begin  // BGE (signed)
      ALU_result = 0;
      zero = ($signed(A) >= $signed(B));
    end
    4'b1110: begin  // BLTU (unsigned)
      ALU_result = 0;
      zero = (A < B);
    end
    4'b1111: begin  // BGEU (unsigned)
      ALU_result = 0;
      zero = (A >= B);
    end

    default: ALU_result = A;
  endcase
end

endmodule
