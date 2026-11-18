`timescale 1ns/1ps
module tb_jh8_rom;
    reg [7:0] address;
    wire [7:0] instruction;
    integer errors;
    jh8_rom uut (
        .address(address),
        .instruction(instruction)
    );
    task check_rom;
        input [7:0] test_address;
        input [7:0] expected_value;

        begin
            address = test_address;
            #10;
            if(instruction !== expected_value)begin

                $display(
                    "FAIL: ADDRESS=%h DATA=%h EXPECTED=%h",
                    address, instruction, expected_value
                );

                errors = errors + 1;
            end
            else begin

                $display(
                    "PASS: ADDRESS=%h DATA=%h",
                    address, instruction
                );
            end
        end
    endtask
    initial begin
        errors = 0;
        check_rom(8'd0, 8'h20);
        check_rom(8'd1, 8'h19);
        check_rom(8'd2, 8'h21);
        check_rom(8'd3, 8'h0A);
        check_rom(8'd4, 8'h30);
        check_rom(8'd5, 8'hD0);
        check_rom(8'd6, 8'h80);
        check_rom(8'd7, 8'hF0);

        if (errors == 0)
            $display("ALL ROM TESTS PASSED");
        else
            $display("ROM TESTS FAILED: %0d errors", errors);
        $finish;
    end
endmodule