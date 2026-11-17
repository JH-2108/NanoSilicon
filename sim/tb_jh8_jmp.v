`timescale 1ns/1ps
module tb_jh8_jmp;
    reg clk;
    reg reset;
    wire [7:0] pc;
    wire halted;
    integer cycles;
    jh8_cpu #(
        .ROM_INIT_FILE("sim/jmp_test.hex")
    ) uut (
        .clk(clk),
        .reset(reset),
        .pc(pc),
        .halted(halted)
    );
    always #5 clk = ~clk;
    initial begin
        clk = 0;
        reset= 1;
        cycles = 0;

        #12;
        reset = 0;
        while (!halted && cycles < 30) begin
            @(posedge clk);
            #1;
            cycles = cycles + 1;
            $display("Cycle %2d | PC=%h | Instruction=%h | R0=%h",
                cycles, pc, uut.instruction,
                uut.registers.registers[0]);
        end
        if (!halted)
            $fatal(1, "FAIL: JMP test did not halt");

        if (uut.registers.registers[0] !== 8'h22)
            $fatal(1, "FAIL: JMP did not reach the correct instruction");

        $display("PASS: Unconditional JMP works!");
        $finish;
    end
endmodule
