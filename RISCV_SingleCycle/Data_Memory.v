module Data_Memory(
    input clk,
    input reset,
    input MemWrite,
    input MemRead,
    input [31:0] Address,
    input [31:0] write_data,
    output reg [31:0] Read_Data
);

reg [31:0] Dmemory[0:255]; // 1KB (256 palavras de 32 bits)
integer k;

initial begin
    $readmemh("vetor_data.hex", Dmemory); // Arquivo gerado a partir da .data + .rodataclear
end

// Escrita sincronizada
always @(posedge clk) begin
    /*if (reset == 1'b1) begin              
        for (k = 0; k < 256; k = k + 1)
            Dmemory[k] <= 32'b0;
    end else if (MemWrite == 1'b1) begin
        Dmemory[(Address - 32'd1024) >> 2] <= write_data;
    end*/
    if (MemWrite) begin
        Dmemory[(Address - 32'd1024) >> 2] <= write_data;
    end
end

// Leitura combinacional
always @(*) begin
    if (MemRead == 1'b1)
        Read_Data = Dmemory[(Address - 32'd1024) >> 2];
    else
        Read_Data = 32'b0;
end

endmodule
