module jh8_ram (

    input wire clk,
    input wire write_enable,
    input wire[7:0] address,
    input wire[7:0] write_data,
    output wire[7:0] read_data
);

    reg [7:0] memory [0:255];
    assign read_data = memory[address];

    always @(posedge clk) begin
        if (write_enable) begin
            memory[address] <= write_data;
        end
    end
endmodule