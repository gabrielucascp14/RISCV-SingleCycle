// Registrador de operandos para a ALU

module Register_File (clk, reset, Rs1, Rs2, Rd, Write_data, RegWrite, Read_data1, Read_data2);

input clk, reset, RegWrite; // single bit inputs
input [4:0] Rs1, Rs2, Rd;  
input [31:0] Write_data;
output [31:0] Read_data1, Read_data2;

reg [31:0] Registers [31:0]; // 32 registers of 32 bits

always @(posedge clk, posedge reset)
begin 
	if(reset==1'b1)
	begin
		Registers[0] = 0;
//		Registers[2] = 32;
/*		Registers[1] = 3;
		Registers[2] = 6;
		Registers[3] = 34;
		Registers[4] = 5;
		Registers[5] = 8;
		Registers[6] = 2;
		Registers[8] = 67;
		Registers[9] = 56;
		Registers[10] = 45;
		Registers[11] = 50;
		Registers[12] = 41;
		Registers[13] = 24;
		Registers[14] = 23;
		Registers[15] = 24;
		Registers[16] = 35;
		Registers[17] = 46;
		Registers[18] = 57;
		Registers[19] = 68;
		Registers[20] = 29;
		Registers[21] = 30;
		Registers[22] = 41;
		Registers[23] = 52;
		Registers[24] = 53;
		Registers[25] = 44;
		Registers[26] = 75;
		Registers[27] = 56;
		Registers[28] = 57;
		Registers[29] = 48;
		Registers[30] = 39;
		Registers[31] = 91; */
	end
	else if (RegWrite == 1'b1 && Rd != 5'd0) // o registrador x0 (Registers[0]) é sempre zero e não pode ser escrito
	begin
		Registers[Rd] = Write_data; // Se receber o sinal de controle de RegWrite, aloca no endereço Rd o valor lido da memoria Write_data
	end
end

assign Read_data1 = Registers[Rs1]; // a saida do operando1 sera do endereço Rs1 vindo da instruçao
assign Read_data2 = Registers[Rs2];
	
endmodule	