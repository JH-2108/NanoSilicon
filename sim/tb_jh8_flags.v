`timescale 1ns/1ps
module tb_jh8_flags;
    reg clk;
    reg reset;
    reg write_enable;
    reg zero_in;
    reg carry_in;
    reg negative_in;
    wire zero_flag;
    wire carry_flag;
    wire negative_flag;
    integer errors;
    jh8_flags uut (
        .clk(clk),
        .reset(reset),
        .write_enable(write_enable),
        .zero_in(zero_in),
        .carry_in(carry_in),
        .negative_in(negative_in),
        .zero_flag(zero_flag),
        .carry_flag(carry_flag),
        .negative_flag(negative_flag)
    );
    always #5 clk =  ~clk;
    task check_flags;
        input expected_zero;
        input expected_carry;
        input expected_negative;
        begin
            #1;
            if (zero_flag !== expected_zero ||
                carry_flag !== expected_carry ||
                negative_flag !== expected_negative) begin
                $display("FAIL: Z=%b C=%b N=%b",
                    zero_flag, carry_flag, negative_flag);
                errors = errors + 1;
            end
            else begin
                $display("PASS: Z=%b C=%b N=%b",
                    zero_flag, carry_flag, negative_flag);
            end
        end
    endtask
    initial begin

        clk = 0;
        reset = 1;
        write_enable = 0;

        zero_in = 0;
        carry_in = 0;
        negative_in = 0;

        errors = 0;

        @(negedge clk);
        check_flags(0, 0, 0);
        reset = 0;
        write_enable = 1;

        zero_in = 1;
        carry_in = 1;
        negative_in = 1;
        @(posedge clk);
        #1;
        check_flags(1, 1, 1);
        @(negedge clk);
        write_enable = 0;

        zero_in = 0;
        carry_in = 0;
        negative_in = 0;

        @(posedge clk);
        #1;
        check_flags(1, 1, 1);

        @(negedge clk);
        write_enable=  1;
        @(posedge clk);
        #1;
        check_flags(0, 0, 0);
        if (errors == 0)
            $display("ALL FLAG TESTS PASSED");
        else
            $display("FLAG TESTS FAILED: %0d errors", errors);
        $finish;
    end
endmodule