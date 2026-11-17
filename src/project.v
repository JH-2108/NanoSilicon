`default_nettype none

module tt_um_nanosilicon (
    input  wire [7:0] ui_in,
    output wire [7:0] uo_out,
    input  wire [7:0] uio_in,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,
    input  wire       ena,
    input  wire       clk,
    input  wire       rst_n
);

    wire [7:0] pc;
    wire halted;

    jh8_cpu #(
        .ROM_INIT_FILE("..src/program.hex")
    ) cpu (
        .clk(clk),
        .reset(~rst_n),
        .pc(pc),
        .halted(halted)
    );
    assign uo_out = pc;

    assign uio_out = {7'b0, halted};
    assign uio_oe  = 8'b00000001;
    wire _unused = &{ena, ui_in, uio_in, 1'b0};
endmodule

`default_nettype wire
