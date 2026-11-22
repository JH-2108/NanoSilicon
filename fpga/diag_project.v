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
    reg[7:0] counter;

    always @(posedge clk) begin 
        if (!rst_n)
            counter <= 8'h00;
        else
            counter <= counter + 1'b1;
    end 
    assign uo_out = counter;
    assign uio_out = 8'h00; 
    assign uio_oe = 8'h00; 

endmodule 
