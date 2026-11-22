`timescale 1ns/1ps 

module tb_register_check; 
    reg clk = 0;
    reg reset = 1;
    wire [7:0] pc;
    wire halted;

    jh8_cpu dut (
        .clk(clk),
        .reset(reset),
        .pc(pc),
        .halted(halted)
    );

    always #5 clk = ~clk;

    initial begin
        repeat (2) @(posedge clk);
        #1 reset = 0;

        wait (halted == 1'b1);
        #1;

    $display ("PC = 0x%02h", pc);
    $display("HALTED = %b", halted);
    $display("R2 = 0x%02h", dut.registers.registers[0]);
    $display("R3 = 0x%02h", dut.registers.registers[1]);
    $display("RAM[0x90] = 0x%02h", dut.ram.memory [8'h90]);

    if (dut.registers.registers[0] === 8'h2A && dut.registers.registers[1] === 8'h2A) begin 
            $display ("RAM READ TEST: PASSED");
        end else begin 
            $display ("RAM READ TEST: FAILED");
        end 

        $finish; 
    end 
endmodule 