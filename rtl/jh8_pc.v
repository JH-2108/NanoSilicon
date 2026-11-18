module jh8_pc (
    input wire clk,
    input wire reset,
    input wire enable,
    input wire [7:0] next_pc,
    output reg [7:0] pc
);
    always @(posedge clk) begin
        if (reset) begin
            pc <= 8'h00;
        end
        else if (enable) begin
            pc <= next_pc;
        end 
    end
endmodule