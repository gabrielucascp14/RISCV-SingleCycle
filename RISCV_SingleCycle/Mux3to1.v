// Multiplexer 3 entradas (3:1 Mux)

module Mux3to1 (
    input  [1:0] sel,       // seletor 2 bits para 3 entradas
    input  [31:0] A1,       // entrada 0
    input  [31:0] B1,       // entrada 1
    input  [31:0] C1,       // entrada 2
    output reg [31:0] Mux_out
);

always @(*) begin
    case (sel)
        2'b00: Mux_out = A1;
        2'b01: Mux_out = B1;
        2'b10: Mux_out = C1;
        default: Mux_out = 32'b0;  // valor default caso sel = 2'b11
    endcase
end

endmodule
