
`timescale 1ns/1ps

module tb_jh8_alu;

    reg [7:0] a;
    reg [7:0] b;
    reg [3:0] alu_op;

    wire [7:0] result;
    wire carry;
    wire zero_flag;
    wire negative_flag;

    integer errors;

    jh8_alu uut (
        .a(a),
        .b(b),
        .alu_op(alu_op),
        .result(result),
        .carry(carry),
        .zero_flag(zero_flag),
        .negative_flag(negative_flag)
    );

    task check_result;
        input [7:0] expected_value;
        input expected_carry;
        begin
            #10;

            if (result !== expected_value ||
                carry !== expected_carry) begin

                $display("FAIL: OP=%h RESULT=%h EXPECTED=%h",
                    alu_op, result, expected_value);

                errors = errors + 1;
            end
            else begin
                $display("PASS: OP=%h RESULT=%h",
                    alu_op, result);
            end
        end
    endtask

    initial begin

        errors = 0;

        a=25;
        b=10;

        alu_op = 4'h3;
        check_result(35, 0);

        alu_op = 4'h4;
        check_result(15, 1);

        alu_op = 4'h5;
        check_result(8, 0);

        alu_op = 4'h6;
        check_result(27, 0);

        alu_op = 4'h7;
        check_result(19, 0);

        alu_op = 4'h8;
        check_result(230, 0);

        a = 255;
        b = 1;
        alu_op = 4'h3;
        check_result(0, 1);

        a = 5;
        b = 10;
        alu_op = 4'h4;
        check_result(251, 0);

        if (errors == 0)
            $display("ALL ALU TESTS PASSED");
        else
            $display("ALU TESTS FAILED: %0d errors", errors);

        $finish;

    end

endmodule
