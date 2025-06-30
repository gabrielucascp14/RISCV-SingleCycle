`timescale 1ns/1ps

module tb_RISCV_TOP;

// Sinais de entrada e saída
 reg clk, reset;
 wire [1:0] ALUOpTop, Mem_PC4_toReg, PCSel;
 wire [3:0] ALUControlTop;
 wire RegWriteTop, ALUSrc_Top, MemWriteTop, BranchTop, zeroTop, jumpTop, jalrTop, and_outTop, MemReadTop, ALUSrc1_Top;
 wire [6:0] opcode;
 wire [4:0] rd, rs1, rs2;
 wire [31:0] instruction_outTop, PC_outTop, ALUresultTop, read_data1Top, read_data2Top, ImmExt_top, ALU_mux1Top, ALU_mux2Top, PC_Adder_outTop, RegFile_writeTop, Dmemory_outTop, PC_inTop, Adder_outTop;

// Geração de clock
//a cada 5 unidades de tempo (por exemplo, 5 ns se o timescale for 1ns/1ps), o sinal clk será invertido. 
initial clk = 0;
always #5 clk = ~clk; // clock de 10 ns (100MHz)

// Instancianção de DUT é a sigla para Device Under Test

RISCV_TOP dut(
.clk(clk), 
.reset(reset),
.ALUOpTop(ALUOpTop), 
.Mem_PC4_toReg(Mem_PC4_toReg), 
.PCSel(PCSel),
.ALUControlTop(ALUControlTop),
.RegWriteTop(RegWriteTop), 
.ALUSrc_Top(ALUSrc_Top), 
.MemWriteTop(MemWriteTop), 
.BranchTop(BranchTop), 
.zeroTop(zeroTop), 
.jumpTop(jumpTop), 
.jalrTop(jalrTop), 
.MemReadTop(MemReadTop), 
.ALUSrc1_Top(ALUSrc1_Top),
.opcode(opcode),
.rd(rd), 
.rs1(rs1), 
.rs2(rs2),
.instruction_outTop(instruction_outTop), 
.PC_outTop(PC_outTop), 
.ALUresultTop(ALUresultTop), 
.read_data1Top(read_data1Top), 
.read_data2Top(read_data2Top), 
.ImmExt_top(ImmExt_top),
.ALU_mux1Top(ALU_mux1Top), 
.ALU_mux2Top(ALU_mux2Top), 
.PC_Adder_outTop(PC_Adder_outTop),
.RegFile_writeTop(RegFile_writeTop), 
.Dmemory_outTop(Dmemory_outTop),
.PC_inTop(PC_inTop), 
.Adder_outTop(Adder_outTop)
);

// Fazendo reset inicial

initial begin
  $display("Iniciando simulação...");
  reset = 1;
  #10;
  reset = 0;
  $display("Reset feito.");
end

// Gerando Waveform
initial begin
    $dumpfile("waveform.vcd");

//serve para registrar as variáveis e sinais do módulo tb_RISCV_TOP (e seus submódulos) no arquivo de dump de simulação (geralmente .vcd)
//O primeiro argumento 0 indica que você quer registrar tudo
//tb_RISCV_TOP é o nome da instância do testbench ou do módulo top-level que você quer observar.
    $dumpvars(0, tb_RISCV_TOP);
end

// Monitoramento pelo terminal
always @(posedge clk) begin
    $display("Ciclo %t PC=%d | Instr=%08h | Op=%b | rs1=%d | rs2=%d | ALU=%d",
            $time, PC_outTop,instruction_outTop, opcode, read_data1Top, read_data2Top, ALUresultTop);
    $display("Ciclo %t Imme=%d | MemR = %d | MemW=%d | DMem=%d | WRegFile=%d",
            $time, ImmExt_top, MemReadTop, MemWriteTop, Dmemory_outTop, RegFile_writeTop);
    // Detectar endcall colocado no código em C para não ter que ficar
    // Colocando um tempo específico em que o programa ainda não terminou
    if (instruction_outTop == 32'h00000073) begin  // ECALL
      $display("ECALL detectado — encerrando simulação.");
      $finish;
    end
end

endmodule