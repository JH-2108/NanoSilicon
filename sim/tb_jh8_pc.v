`timescale 1ns/1ps
module tb_jh8_pc;
    reg clk;
    reg reset;
    reg enable;
    reg[7:0] next_pc;
    wire[7:0] pc;
    jh8_pc uut (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .next_pc(next_pc),
        .pc(pc)
    );
    always #5 clk = ~clk;
    initial begin
        clk = 0;
        reset = 1;
        enable = 0;
        next_pc = 0;
        @(posedge clk);
        #1;
        if (pc !== 8'h00)
            $fatal(1, "FAIL: Reset");
        reset = 0;
        enable = 1;
        next_pc = 8'h01;
        @(posedge clk);
        #1;
        if(pc !== 8'h01)
            $fatal(1, "FAIL: One-byte instruction");

        next_pc = 8'h03;
        @(posedge clk);
        #1;
        if(pc !== 8'h03)
            $fatal(1, "FAIL: Two-byte instruction");

        next_pc = 8'h80;
        @(posedge clk);
        #1;
        if (pc !== 8'h80)
            $fatal(1, "FAIL: Jump");

        enable = 0;
        next_pc = 8'hFF;
        @(posedge clk);
        #1;
        if(pc !== 8'h80)
            $fatal(1, "FAIL: Hold");

        $display("ALL PC TESTS PASSED");
        $finish;
    end
endmodule
