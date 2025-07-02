// Include para icarus ou verilator, mas comentar se usar quartu/*

`include "ALU.v"
`include "ALUControl.v"
`include "Adder.v"
`include "Control_Unit.v"
`include "Data_Memory.v"
`include "immediate_Generator.v"
`include "Instruction_Memory.v"
`include "Mux.v"
`include "Mux3to1.v"
`include "PCplus4.v"
`include "Program_Counter.v"
`include "Register_File.v"

module RISCV_TOP(
 input clk, reset,
 output [1:0] ALUOpTop, Mem_PC4_toReg, PCSel,
 output [3:0] ALUControlTop,
 output RegWriteTop, ALUSrc_Top, MemWriteTop, BranchTop, zeroTop, jumpTop, jalrTop, and_outTop, MemReadTop, ALUSrc1_Top,
 output [6:0] opcode,
 output [4:0] rd, rs1, rs2,
 output [31:0] instruction_outTop, PC_outTop, ALUresultTop, read_data1Top, read_data2Top, ImmExt_top, ALU_mux1Top, ALU_mux2Top, PC_Adder_outTop, RegFile_writeTop, Dmemory_outTop, PC_inTop, Adder_outTop
);


assign opcode = instruction_outTop[6:0];
assign rd = instruction_outTop[11:7];
assign rs1 = instruction_outTop[19:15];
assign rs2 = instruction_outTop[24:20];
// conexoes entre modulos
// wire [31:0] ; // wire de conexao entre pc_counter e instruction memory
//wire [3:0] ALUControlTop; 
//wire [1:0] ALUOpTop;

// instantiation of modules



Program_Counter PC
(
 .clk(clk), 
 .reset(reset), 
 .PC_in(PC_inTop), 
 .PC_out(PC_outTop)
);

PCplus4 PC_Adder
( 
 .clk(clk),
 .reset(reset),
 .fromPC(PC_outTop),
 .NextoPC(PC_Adder_outTop)
);
 
 Instruction_Memory Instruction_Memory
(
  .reset(reset), 
  .read_address(PC_outTop), 
  .instruction_out(instruction_outTop)
);

Control_Unit Control_Unit
(
 .OPcode(opcode), 
 .branch(BranchTop), 
 .MemRead(MemReadTop), 
 .Mem_PC4_toReg(Mem_PC4_toReg), 
 .MemWrite(MemWriteTop), 
 .ALUSrc(ALUSrc_Top),
 .ALUSrc1(ALUSrc1_Top), 
 .RegWrite(RegWriteTop),
 .jump(jumpTop),
 .jalr(jalrTop),
 .ALUOp_out(ALUOpTop)
);

Register_File Register_File
(
 .clk(clk), 
 .reset(reset), 
 .Rs1(rs1), 
 .Rs2(rs2), 
 .Rd(rd), 
 .Write_data(RegFile_writeTop), 
 .RegWrite(RegWriteTop), 
 .Read_data1(read_data1Top), 
 .Read_data2(read_data2Top)
 );
 
 ALUControl ALUControl
(
 .ALUOp_in(ALUOpTop), 
 .func7(instruction_outTop[31:25]), 
 .func3(instruction_outTop[14:12]), 
 .ALUControl_out(ALUControlTop)
);
 
 ALU ALU
 (
  .A(ALU_mux2Top), 
  .B(ALU_mux1Top), 
  .zero(zeroTop), 
  .ALUControl_in(ALUControlTop), 
  .ALU_result(ALUresultTop)
 );
 
 Data_Memory DMemory
  (
  .clk(clk), 
	.reset(reset), 
	.MemWrite(MemWriteTop), 
	.MemRead(MemReadTop), 
	.Address(ALUresultTop), 
	.write_data(read_data2Top), 
	.Read_Data(Dmemory_outTop)
);
  
immediate_Generator ImmGen
( 
 .Opcode(opcode), 
 .instruction(instruction_outTop), 
 .ImmExt(ImmExt_top)
);

Mux ALU_Mux1 // Mux (reg2 | Imme)
(
 .sel(ALUSrc_Top), 
 .A1(read_data2Top), 
 .B1(ImmExt_top), 
 .Mux_out(ALU_mux1Top)
);

Mux ALU_Mux2 // Mux (reg1 | PC)
(
 .sel(ALUSrc1_Top), 
 .A1(read_data1Top), 
 .B1(PC_outTop), 
 .Mux_out(ALU_mux2Top)
);


Adder Adder
(
 .in_1(PC_outTop), 
 .in_2(ImmExt_top), 
 .sum(Adder_outTop)
);

///////////////////////////////////////////////////////////////// Bloco que define mux para PC
assign PCSel = jumpTop     ? 2'b01 :  // jal
               BranchTop & zeroTop ? 2'b01 :  // branch taken
               jalrTop     ? 2'b10 :  // jalr
               2'b00;             // PC + 4

Mux3to1 PC_Mux
(  
 .sel(PCSel),       
 .A1(PC_Adder_outTop),       
 .B1(Adder_outTop),       
 .C1(ALUresultTop),       
 .Mux_out(PC_inTop)
);

/*
Mux Dmemory_Mux
(
 .sel(MemtoReg_Top), 
 .A1(ALUresultTop), 
 .B1(Dmemory_outTop), 
 .Mux_out(RegFile_writeTop)
);
*/

Mux3to1 Mux_Mem_or_PC4 	// Mux que decide entre Memoria, ALU, ou PC4 para registrar no RegFile (PC4 para instrs Jal e JALr
(  
 .sel(Mem_PC4_toReg),       
 .A1(ALUresultTop),       
 .B1(Dmemory_outTop),       
 .C1(PC_Adder_outTop),       
 .Mux_out(RegFile_writeTop)
);

	
endmodule