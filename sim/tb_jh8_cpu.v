`timescale 1ns/1ps
module tb_jh8_cpu;
    reg clk;
    reg reset;
    wire [7:0] pc;
    wire halted;
    integer cycles;
    jh8_cpu uut (
        .clk(clk),
        .reset(reset),
        .pc(pc),
        .halted(halted)
    );
    always #5 clk = ~clk;
    initial begin
        clk = 0;
        reset = 1;
        cycles = 0;
        #12;
        reset = 0;

        $display("Starting JH-8 execution");
        $display("Cycle | PC | Instruction | Opcode | Length | Halt");

        while (!halted && cycles < 100) begin
            @(posedge clk);
            #1;
            cycles = cycles + 1;

            $display(
                "%5d | %h | %h| %h | %d| %b",
                cycles,
                pc,
                uut.instruction,
                uut.opcode,
                uut.instruction_length,
                halted
            );
        end
        $display("");
        $display("R0 = %d", uut.registers.registers[0]);
        $display("R1 = %d", uut.registers.registers[1]);
        $display("RAM[128] = %d", uut.ram.memory[128]);
        $display("Final PC = %d", pc);
        $display("Halted = %b", halted);

        if (!halted)
            $display("FAIL: CPU did not halt");
        else if (uut.registers.registers[0] !== 8'd35)
            $display("FAIL: R0 incorrect");
        else if (uut.registers.registers[1] !== 8'd10)
            $display("FAIL: R1 incorrect");
        else if (uut.ram.memory[128] !== 8'd35)
            $display("FAIL: RAM[128] incorrect");
        else
            $display("PASS: CPU integration test successful");
        $finish;
    end
endmodule
