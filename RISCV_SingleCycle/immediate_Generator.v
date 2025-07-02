//The branch instruction operates by adding the PC with the 12 bits of the
//instruction shifted left by 1 bit.
//a 12-bit offset used to compute the branch target address relative to
//the branch instruction address beq x1, x2, offset
// To compute the branch target address, the branch datapath includes an immediate generation unit and an adder.

//(a)Instruction format for I-type load instructions (opcode = 3ten). The register rs1 is the base register that 
//is added to the 12-bit immediate field to form the memory address.Field rd is the destination register for the loaded value. 
//(c) Instruction format for S-type store instructions (opcode = 35ten). The register rs1 is
//the base register that is added to the 12-bit immediate field to form the memory address. (The immediate field is split into a 7-bit piece and a
//5-bit piece.) Field rs2 is the source register whose value should be stored into memory. 
//(d) Instruction format for SB-type conditional branch instructions (opcode = 99ten). The registers rs1 and rs2 compared. The 12-bit immediate 
//address field is sign-extended, shifted left 1 bit, and added to the PC to compute the branch target address.

module immediate_Generator (Opcode, instruction, ImmExt);

input [6:0] Opcode;
input [31:0] instruction;
output reg [31:0] ImmExt;

always @(*) begin
  case (Opcode)
    7'b0000011,        // LW
    7'b0010011,        // ADDI, SLTI, etc
    7'b1100111:        // JALR
      ImmExt = {{20{instruction[31]}}, instruction[31:20]}; // Tipo I

    7'b0100011:        // SW
      ImmExt = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]}; // Tipo S

    7'b1100011:        // BEQ, BNE, etc
      ImmExt = {{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0}; // Tipo B Ja inclui Shift Left

    7'b0010111,        // AUIPC
    7'b0110111:        // LUI
      ImmExt = {instruction[31:12], 12'b0}; // Tipo U

    7'b1101111:        // JAL
    //ImmExt = {{12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], 1'b0};
		ImmExt = {{11{instruction[31]}}, instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0}; // ja inclui Shift Left

    default:
      ImmExt = 32'b0;
  endcase
end																																
endmodule
