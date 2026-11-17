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
    wire [3:0] select_a;
    wire [3:0] select_b;
    assign select_a = 4'b0001 << read_addr_a;
    assign select_b = 4'b0001 << read_addr_b;
    always @(*) begin
        read_data_a =
            ({8{select_a[0]}} & registers[0]) |
            ({8{select_a[1]}} & registers[1]) |
            ({8{select_a[2]}} & registers[2]) |
            ({8{select_a[3]}} & registers[3]);
        read_data_b =
            ({8{select_b[0]}} & registers[0]) |
            ({8{select_b[1]}} & registers[1]) |
            ({8{select_b[2]}} & registers[2]) |
            ({8{select_b[3]}} & registers[3]);
    end
    always @(posedge clk) begin
        if(reset) begin
            registers[0] <= 8'b0;
            registers[1] <= 8'b0;
            registers[2] <= 8'b0;
            registers[3] <= 8'b0;
        end
        else if (write_enable) begin
            registers[write_addr] <= write_data;
        end
    end
endmodule
