module jh8_rom #(
    parameter INIT_FILE = "sim/program.hex"
) (
    input wire [7:0] address,
    output wire[7:0] instruction,
    input wire [7:0] immediate_address,
    output wire [7:0] immediate_data
);
    reg [7:0] memory [0:255];
    initial begin
        $readmemh(INIT_FILE, memory);
    end
    assign instruction = memory[address];
    assign immediate_data = memory[immediate_address];
endmodule