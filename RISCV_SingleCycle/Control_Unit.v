// Control Unit, receives the instruction and distributes 
// control signals of read and write do memory and register, and
// control signals og muxes and ALUControl

module Control_Unit(OPcode, branch, MemRead, Mem_PC4_toReg, MemWrite, ALUSrc, ALUSrc1, RegWrite, jump, jalr, ALUOp_out);

input [6:0] OPcode;
output reg branch, MemRead, MemWrite, ALUSrc, ALUSrc1, RegWrite, jump, jalr;
output reg [1:0] Mem_PC4_toReg;
output reg [1:0] ALUOp_out;

always @(*) begin
  case (OPcode)
    // R-type (ADD, SUB, AND, OR, ...)
    7'b0110011: begin
      ALUSrc     = 0; // Sel do mux (reg2 | Imme)
      ALUSrc1    = 0; // Sel do mux (reg1 | PC)
      Mem_PC4_toReg = 2'b00;
      RegWrite   = 1;
      MemRead    = 0;
      MemWrite   = 0;
      branch     = 0;
		jump		  = 0;
		jalr		  = 0;
      ALUOp_out  = 2'b10;  // R-type
    end

    // I-type (ADDI, ANDI, ORI, SLTI, SRAI, SRLI, LW)
    7'b0010011: begin // OP-IMM
      ALUSrc     = 1;
      ALUSrc1    = 0;
      Mem_PC4_toReg = 2'b00;
      RegWrite   = 1;
      MemRead    = 0;
      MemWrite   = 0;
      branch     = 0;
		jump		  = 0;
		jalr		  = 0;
      ALUOp_out  = 2'b11;  // novo código para OP-IMM
    end

    7'b0000011: begin // LW
      ALUSrc     = 1;
      ALUSrc1    = 0;
      Mem_PC4_toReg = 2'b01;
      RegWrite   = 1;
      MemRead    = 1;
      MemWrite   = 0;
      branch     = 0;
		jump		  = 0;
		jalr		  = 0;
      ALUOp_out  = 2'b00;  // load/store
    end

    // S-type (SW)
    7'b0100011: begin
      ALUSrc     = 1;
      ALUSrc1    = 0;
      Mem_PC4_toReg = 2'b00;
      RegWrite   = 0;
      MemRead    = 0;
      MemWrite   = 1;
      branch     = 0;
		jump		  = 0;
		jalr		  = 0;
      ALUOp_out  = 2'b00;
    end

    // B-type (BEQ, BNE, BLT, BGE, BLTU, BGEU)
    7'b1100011: begin
      ALUSrc     = 0;
      ALUSrc1    = 0;
      Mem_PC4_toReg = 2'b00;
      RegWrite   = 0;
      MemRead    = 0;
      MemWrite   = 0;
      branch     = 1;
		jump		  = 0;
		jalr		  = 0;
      ALUOp_out  = 2'b01;
    end
	 
	 // J-type (JAL)
    7'b1101111: begin
      ALUSrc     = 1;    // Não importa
      ALUSrc1    = 0;
      Mem_PC4_toReg = 2'b10;    // PC+4 será escrito no rd
      RegWrite   = 1;
      MemRead    = 0;
      MemWrite   = 0;
      branch     = 0;
		jump		  = 1;
		jalr		  = 0;
      ALUOp_out  = 2'b00; // ou novo valor se quiser tratar JAL separado
    end

	// AUIPC Pega o valor atual do PC (o endereço da instrução) e Soma com o imediato da instrução, deslocado 12 bits à esquerda.
		7'b0010111: begin 
		ALUSrc     = 1;     // Usa imediato
		ALUSrc1    = 1;
		Mem_PC4_toReg = 2'b00;     // O resultado da ALU vai para o registrador
		RegWrite   = 1;     // Escreve em rd
		MemRead    = 0;
		MemWrite   = 0;
		branch     = 0;
		jump       = 0;     // Não é jump nem branch
		jalr		  = 0;
		ALUOp_out  = 2'b00; // funciona como load/store 
	end

  // jalr
  7'b1100111: begin  
  ALUSrc     = 1;     // Usa imediato para calcular o endereço
  ALUSrc1    = 0;     // Usa registrador rs1 (geralmente PC ou registrador base)
  Mem_PC4_toReg = 2'b10;    // PC+4 será salvo em rd
  RegWrite   = 1;     // Escreve em rd o endereço de retorno
  MemRead    = 0;
  MemWrite   = 0;
  branch     = 0;
  jump       = 0;     // ativa o sinal de jump (mas para jalr, pode tratar separadamente)
  jalr		 = 1;
  ALUOp_out  = 2'b00; // Opcional: pode definir um código específico para jalr se precisar de ALU específica
  end

    default: begin
      ALUSrc     = 0;
      ALUSrc1    = 0;
		Mem_PC4_toReg = 2'b00;
      RegWrite   = 0;
      MemRead    = 0;
      MemWrite   = 0;
      branch     = 0;
		jump		  = 0;
		jalr		  = 0;
      ALUOp_out  = 2'b00;
    end
  endcase
end

endmodule
	
	
