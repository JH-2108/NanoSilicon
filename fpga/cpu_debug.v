//this is only a debug file and serves no purpose other than for debugging the FPGA board problem (I'll js leave this here)
module tt_um_nanosilicon (
    input wire [7:0] ui_in,
    output wire [7:0] uo_out,
    input wire [7:0] uio_in, 
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,
    input wire ena,
    input wire clk,
    input wire rst_n
); 
    wire [7:0] pc;
    wire halted;

    jh8_cpu cpu(
        .clk(clk),
        .reset(~rst_n),
        .pc(pc),
        .halted(halted)
    );

    assign uo_out = {halted, pc[6:0]};
    assign uio_out = {7'b0, halted};
    assign uio_oe = 8'h01; 
endmodule 
