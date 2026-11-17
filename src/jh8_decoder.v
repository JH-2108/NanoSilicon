module jh8_decoder (
    input wire [7:0] instruction,
    output wire [1:0] instruction_length,
    output wire [3:0] opcode,
    output wire [1:0] destination,
    output wire [1:0] source,
    output wire [3:0] alu_operation,
    output wire register_write,
    output wire memory_read,
    output wire memory_write,
    output wire immediate_load,
    output wire jump,
    output wire jump_zero,
    output wire jump_not_zero,
    output wire compare,
    output wire halt,
    output wire nop,
    output wire [1:0] writeback_select,
    output wire flag_write
);
    assign opcode = instruction[7:4];
    assign destination = instruction[3:2];
    assign source = instruction[1:0];
    wire op0 = (opcode == 4'h0);
    wire op1 = (opcode == 4'h1);
    wire op2 = (opcode == 4'h2);
    wire op3 = (opcode == 4'h3);
    wire op4 = (opcode == 4'h4);
    wire op5 = (opcode == 4'h5);
    wire op6 = (opcode == 4'h6);
    wire op7 = (opcode == 4'h7);
    wire op8 = (opcode == 4'h8);
    wire op9 = (opcode == 4'h9);
    wire opA = (opcode == 4'hA);
    wire opB = (opcode == 4'hB);
    wire opC = (opcode == 4'hC);
    wire opD = (opcode == 4'hD);
    wire opE = (opcode == 4'hE);
    wire opF = (opcode == 4'hF);
    assign nop = op0;
    assign register_write = op1 | op2 | op3 | op4 | op5 | op6 | op7 | op8 | opC;
    assign memory_read = opC;
    assign memory_write = opD;
    assign immediate_load = op2;
    assign jump = op9;
    assign jump_zero = opA;
    assign jump_not_zero = opB;
    assign compare = opE;
    assign halt = opF;
    assign flag_write = op3 | op4 | op5 | op6 | op7 | op8 | opE;
    assign instruction_length =
        (op2 | op9 | opA | opB | opC | opD) ? 2'd2 : 2'd1;
    assign writeback_select =
        op1 ? 2'b01 :
        op2 ? 2'b10 :
        opC ? 2'b11 :
              2'b00;
    assign alu_operation =
        op3 ? 4'h3 :
        (op4 | opE) ? 4'h4 :
        op5 ? 4'h5 :
        op6 ? 4'h6 :
        op7 ? 4'h7 :
        op8 ? 4'h8 :
              4'h0;
endmodule
