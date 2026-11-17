module jh8_registers (
    input wire clk,
    input wire reset,
    input wire [1:0] read_addr_a,
    output reg [7:0] read_data_a,
    input wire [1:0]read_addr_b,
    output reg [7:0] read_data_b,
    input wire write_enable,
    input wire [1:0] write_addr,
    input wire [7:0] write_data
);
    reg [7:0] registers [0:3];
    wire [3:0] select_a;
    wire [3:0] select_b;
    wire write_reg0;
    wire write_reg1;
    wire write_reg2;
    wire write_reg3;
    assign select_a = 4'b0001 << read_addr_a;
    assign select_b = 4'b0001 << read_addr_b;
    assign write_reg0 = write_enable &&(write_addr == 2'd0);
    assign write_reg1 = write_enable && (write_addr == 2'd1);
    assign write_reg2 = write_enable && (write_addr == 2'd2);
    assign write_reg3 = write_enable && (write_addr == 2'd3);
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
        if (reset)
            registers[0] <= 8'b0;
        else if (write_reg0)
            registers[0] <= write_data;
    end
    always @(posedge clk) begin
        if (reset)
            registers[1] <= 8'b0;
        else if (write_reg1)
            registers[1] <= write_data;
    end
    always @(posedge clk) begin
        if (reset)
            registers[2] <= 8'b0;
        else if (write_reg2)
            registers[2] <= write_data;
    end
    always @(posedge clk) begin
        if (reset)
            registers[3] <= 8'b0;
        else if (write_reg3)
            registers[3] <= write_data;
    end
endmodule
