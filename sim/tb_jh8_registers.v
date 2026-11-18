
`timescale 1ns/1ps

module tb_jh8_registers;

    reg clk;
    reg reset;

    reg [1:0] read_addr_a;
    reg[1:0] read_addr_b;
    wire[7:0] read_data_a;
    wire [7:0] read_data_b;
    reg write_enable;
    reg[1:0] write_addr;
    reg [7:0] write_data;

    integer errors;

    jh8_registers uut (
        .clk(clk),
        .reset(reset),
        .read_addr_a(read_addr_a),
        .read_data_a(read_data_a),
        .read_addr_b(read_addr_b),
        .read_data_b(read_data_b),
        .write_enable(write_enable),
        .write_addr(write_addr),
        .write_data(write_data)
    );

    always #5 clk = ~clk;

    task write_register;
        input [1:0] address;
        input[7:0] value;
        begin
            @(negedge clk);
            write_enable = 1;
            write_addr = address;
            write_data = value;

            @(negedge clk);
            write_enable = 0;
        end
    endtask

    task check_register;
        input [1:0] address_a;
        input [1:0] address_b;
        input[7:0] expected_a;
        input[7:0] expected_b;

        begin
            read_addr_a = address_a;
            read_addr_b = address_b;

            #1;

            if (read_data_a !== expected_a ||
                read_data_b !== expected_b) begin

                $display("FAIL: R%0d=%h expected=%h, R%0d=%h expected=%h",
                    address_a, read_data_a, expected_a,
                    address_b, read_data_b, expected_b);

                errors = errors + 1;
            end
            else begin
                $display("PASS: R%0d=%h, R%0d=%h",
                    address_a, read_data_a,
                    address_b, read_data_b);
            end
        end
    endtask
    initial begin
        clk= 0;
        reset= 1;
        write_enable= 0;
        write_addr= 0;
        write_data= 0;
        read_addr_a= 0;
        read_addr_b= 0;
        errors= 0;
        @(negedge clk);
        reset= 0;
        check_register(0, 1, 0, 0);
        write_register(0, 25);
        write_register(1, 10);
        write_register(2, 100);
        write_register(3, 200);
        check_register(0, 1, 25, 10);
        check_register(2, 3, 100, 200);
        check_register(3, 0, 200, 25);
        @(negedge clk);
        reset = 1;
        @(negedge clk);
        reset = 0;

        check_register(0, 1, 0, 0);
        check_register(2, 3, 0, 0);

        if (errors == 0)
            $display("ALL REGISTER TESTS PASSED");
        else
            $display("REGISTER TESTS FAILED: %0d errors", errors);

        $finish;
    end

endmodule
