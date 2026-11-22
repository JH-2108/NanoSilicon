`timescale 1ns/1ps
module tb_branch;
    reg clk;
    reg reset;
    wire [7:0] pc;
    wire halted;

    jh8_cpu dut(
        .clk(clk),
        .reset(reset),
        .pc(pc),
        .halted(halted)
    );

    always #5 clk = ~clk;
    integer cycles;
    initial begin
        clk = 0;
        reset = 1;
        cycles = 0; 
        #10;
        reset = 0;

        dut.rom.memory[0] = 8'h20;
        dut.rom.memory[1] = 8'h2A;
        dut.rom.memory[2] = 8'hD0;
        dut.rom.memory[3] = 8'h90;
        dut.rom.memory[4] = 8'h24;
        dut.rom.memory[5] = 8'h55;
        dut.rom.memory[6] = 8'hD4;
        dut.rom.memory[7] = 8'h91;
        dut.rom.memory[8] = 8'hC8;
        dut.rom.memory[9] = 8'h90;
        dut.rom.memory[10] = 8'hCC;
        dut.rom.memory[11] = 8'h91;
        dut.rom.memory[12] = 8'hF0;

        reset = 1;
        #10;
        reset = 0;
        while (!halted && cycles <20) begin 
            @(posedge clk);
            #1;
            cycles = cycles + 1;
        end

        $display("R2=%h R3=%h RAM[90]=%h RAM[91]=%h PC=%h HALTED=%b",
            dut.registers.registers[2],
            dut.registers.registers[3],
            dut.ram.memory[8'h90],
            dut.ram.memory[8'h91],
            pc, halted);
        
        if (dut.registers.registers[2] == 8'h2A &&
            dut.registers.registers[3] == 8'h55 &&
            dut.ram.memory[8'h90] == 8'h2A &&
            dut.ram.memory[8'h91] == 8'h55 &&
            pc == 8'h0D && halted) begin 
            $display("RAM READ/WRITE TEST: PASSED!");
        end 
        else begin 
            $display("RAM READ/WRITE TEST: FAILED");
        end
        $finish; 
    end
endmodule 

