module jh8_ram (
    input wire clk,
    input wire write_enable,
    input wire [7:0] address,
    input wire [7:0] write_data,
    output wire [7:0] read_data
);
    reg [7:0] memory [0:255];
    assign read_data = memory[address];
    genvar i;
    generate
        for (i = 0; i < 256; i = i + 1) begin : ram_write
            wire selected;
            assign selected = write_enable && (address == i);

            always @(posedge clk) begin
                if (selected)
                    memory[i] <= write_data;
            end
        end
    endgenerate
endmodule
