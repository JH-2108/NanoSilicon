module jh8_registers (
    input wire clk,
    input wire reset,
    input wire [1:0] read_addr_a,
    output reg [7:0] read_data_a,
    input wire [1:0] read_addr_b,
    output reg [7:0] read_data_b,
    input wire write_enable,
    input wire [1:0] write_addr,
    input wire [7:0] write_data
);
    reg [7:0] registers [0:3];
    always @(*) begin
        read_data_a = registers[read_addr_a];
        read_data_b = registers[read_addr_b];
    end
    always @(posedge clk) begin
        if (reset) begin
            registers[0]<= 8'b0;
            registers[1]<= 8'b0;
            registers[2]<= 8'b0;
            registers[3]<= 8'b0;
        end
        else if (write_enable) begin
            registers[write_addr] <= write_data;
        end
    end
endmodule
