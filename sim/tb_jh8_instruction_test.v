`timescale 1ns/1ps
module tb_jh8_instruction_test;
    reg clk;
    reg reset;
    wire [7:0] pc;
    wire halted;
    integer cycles;
    jh8_cpu #(
        .ROM_INIT_FILE("sim/instruction_test.hex")
    ) uut (
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
        $display("Starting extended JH-8 instruction test");
        $display("Cycle | PC| Instr| R0 | R1 | R2 | R3 |RAM128 ");
    
        while (!halted && cycles < 100) begin 
            @(posedge clk); 
            #1;
            cycles = cycles + 1; 
            $display(
                "%3d | %h | %h | %h | %h |%h| %h |%h",   
                cycles, 
                pc, 
                uut.instruction, 
                uut.registers.registers[0], 
                uut.registers.registers[1], 
                uut.registers.registers[2],
                uut.registers.registers[3],
                uut.ram.memory[128]
            );
            $display(
                "    RegWrite=%b MemWrite=%b MemRead=%b Addr=%h Data=%h",
                uut.register_write,
                uut.memory_write, 
                uut.memory_read,
                uut.immediate_data, 
                uut.register_data_d
            );
        end
        $display("");
        $display("Final R0 = %h", uut.registers.registers[0]);
        $display("Final R1 = %h", uut.registers.registers[1]);
        $display("Final R2 = %h", uut.registers.registers[2]);
        $display("Final R3 = %h", uut.registers.registers[3]);
        $display("RAM[128] = %h", uut.ram.memory[128]);
        $display("PC = %h", pc);
        $display("Halted = %b", halted);
        $finish;
    end
endmodule
