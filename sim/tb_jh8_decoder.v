module tb_jh8_decoder;
    reg [7:0] instruction;
    wire[3:0] opcode;
    wire [1:0]destination;
    wire[1:0] source;
    wire [3:0]alu_operation;
    wire register_write;
    wire memory_read;
    wire memory_write;
    wire immediate_load;
    wire jump;
    wire jump_zero;
    wire jump_not_zero;
    wire compare;
    wire halt;
    wire nop;
    wire[1:0]writeback_select;
    wire flag_write;
    wire[1:0] instruction_bytes;
    jh8_decoder dut (
        .instruction (instruction), 
        .opcode(opcode),
        .destination(destination), 
        .source(source), 
        .alu_operation(alu_operation),
        .register_write(register_write), 
        .memory_read(memory_read),
        .memory_write(memory_write), 
        .immediate_load(immediate_load),
        .jump(jump), 
        .jump_zero(jump_zero), 
        .jump_not_zero(jump_not_zero),
        .compare(compare), 
        .halt(halt), 
        .nop(nop),
        .writeback_select(writeback_select),
        .flag_write(flag_write), 
        .instruction_bytes(instruction_bytes)
    );
    initial begin
        instruction =8'h00; 
        #10;
        if (!nop || register_write ||instruction_bytes != 1)
            $fatal(1, "NOP test failed");
        instruction = 8'h11;
        #10;
        if (!register_write || writeback_select != 2'b01)
            $fatal(1, "MOV test failed");

        instruction = 8'h24;
        #10;
        if (!register_write || !immediate_load ||
            writeback_select != 2'b10 || instruction_bytes != 2)
            $fatal(1, "LDI test failed");

        instruction = 8'h31;
        #10;
        if (!register_write || !flag_write || alu_operation != 4'h3)
            $fatal(1, "ADD test failed");

        instruction = 8'h80;
        #10;
        if (!register_write ||!flag_write | | alu_operation != 4'h8)
            $fatal(1, "NOT test failed");
        instruction = 8'h90;
        #10;
        if (!jump || instruction_bytes != 2)
            $fatal(1, "JMP test failed");

        instruction = 8'hA0;
        #10;
        if (!jump_zero || instruction_bytes != 2)
            $fatal(1, "JZ test failed");
        instruction = 8'hB0;
        #10;
        if (!jump_not_zero || instruction_bytes != 2)
            $fatal(1, "JNZ test failed");
        instruction = 8'hC0;
        #10;
        if (!register_write || !memory_read ||
            writeback_select != 2'b11 || instruction_bytes != 2)
            $fatal(1,"LD test failed"); 

        instruction = 8'hD0;
        #10;
        if (!memory_write || instruction_bytes != 2)
            $fatal(1, "ST test failed");

        instruction = 8'hE1;
        #10;
        if (!compare || !flag_write || register_write)
            $fatal(1, "CMP test failed");
        instruction = 8'hF0;
        #10;
        if (!halt)
            $fatal(1, "HLT test failed");
        $display("All decoder tests passed.");
        $finish;
    end
endmodule
