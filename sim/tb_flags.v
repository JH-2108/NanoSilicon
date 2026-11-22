`timescale 1ns/1ps
module tb_flags;
    reg clk;
    reg reset;
    reg write_enable;
    reg zero_in;
    reg carry_in;
    reg negative_in;
    wire zero_flag;
    wire carry_flag;
    wire negative_flag;

    jh8_flags dut (
        .clk(clk),
        .reset (reset),
        .write_enable(write_enable),
        .zero_in(zero_in),
        .carry_in(carry_in),
        .negative_in(negative_in),
        .zero_flag(zero_flag),
        .carry_flag(carry_flag),
        .negative_flag(negative_flag)
    );
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        write_enable = 0;
        zero_in = 0;
        carry_in = 0;
        negative_in = 0;
        #10;
        reset = 0;
        write_enable = 1;
        zero_in = 1;
        carry_in = 1;
        negative_in = 1;
        #10;

        $display("WRITE: Z=%b C=%b N=%b",
            zero_flag, carry_flag, negative_flag);

        write_enable = 0;
        zero_in = 0;
        carry_in = 0;
        negative_in = 0;
        #10;

        $display("HOLD: Z=%b C=%b N=%b",
            zero_flag, carry_flag, negative_flag);

        write_enable = 1;
        zero_in = 0;
        carry_in = 1;
        negative_in = 0;
        #10;

        $display("UPDATE: Z=%b C=%b N=%b",
            zero_flag, carry_flag, negative_flag);
        $finish;
    end
endmodule