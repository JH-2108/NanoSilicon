`timescale 1ns/1ps
module tb_jh8_ram;
    reg clk;
    reg write_enable;
    reg[7:0] address;
    reg [7:0] write_data;
    wire[7:0] read_data;
    integer errors;
    jh8_ram uut(
        .clk(clk),
        .write_enable(write_enable),
        .address(address),
        .write_data(write_data),
        .read_data(read_data)
    );
    always #5 clk = ~clk;
    task write_memory;
        input [7:0] location;
        input [7:0]value;

        begin
            @(negedge clk);
            address = location;
            write_data = value;
            write_enable = 1;  

            @(negedge clk);
            write_enable = 0;
        end
    endtask
    task check_memory;
        input [7:0] location;
        input [7:0] expected_value;
        begin 
            address = location;
            #1;
            if (read_data !== expected_value) begin

                $display(
                    "FAIL: ADDRESS=%h DATA=%h EXPECTED=%h",
                    address, read_data, expected_value
                );
                errors = errors + 1;
            end
            else begin
                $display(
                    "PASS: ADDRESS=%h DATA=%h",
                    address, read_data
                );
            end
        end
    endtask
    initial begin
        clk = 0;
        write_enable = 0;
        address = 0;
        write_data = 0;
        errors = 0;
        write_memory(8'd0, 8'd25) ;  
        write_memory(8'd1, 8'd10);
        write_memory(8'd128, 8'd35);
        write_memory(8'd255, 8'd200);
        check_memory(8'd0, 8'd25);
        check_memory(8'd1, 8'd10);
        check_memory(8'd128, 8'd35);
        check_memory(8'd255, 8'd200);
        write_memory(8'd128, 8'd99);
        check_memory(8'd128, 8'd99);
        if (errors == 0)
            $display("ALL RAM TESTS PASSED");
        else
            $display("RAM TESTS FAILED: %0d errors", errors);
        $finish;
    end
endmodule