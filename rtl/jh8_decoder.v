
module jh8_decoder (
    input wire [7:0] instruction,
    output reg [1:0] instruction_length,
    output reg [3:0] opcode,
    output reg [1:0] destination,
    output reg [1:0] source,
    output reg [3:0] alu_operation,
    output reg register_write,
    output reg memory_read,
    output reg memory_write,
    output reg immediate_load,
    output reg jump,
    output reg jump_zero,
    output reg jump_not_zero,
    output reg compare,
    output reg halt,
    output reg nop,
    output reg [1:0] writeback_select,
    output reg flag_write
);
    always @(*) begin
        opcode = instruction[7:4];
        destination = instruction[3:2];
        source = instruction[1:0];
        alu_operation =4'h0;
        register_write = 1'b0;
        memory_read = 1'b0;
        memory_write = 1'b0;
        immediate_load = 1'b0;
        jump = 1'b0;
        jump_zero = 1'b0;
        jump_not_zero = 1'b0;
        compare =1'b0;
        halt = 1'b0;
        nop = 1'b0;
        writeback_select = 2'b00;
        flag_write = 1'b0;
        instruction_length = 2'd1;

        case (opcode)
            4'h0: nop = 1'b1;

            4'h1: begin
                register_write = 1'b1;
                writeback_select = 2'b01;
            end

            4'h2: begin
                register_write = 1'b1;
                immediate_load = 1'b1;
                writeback_select = 2'b10;
                instruction_length = 2'd2;
            end
            4'h3: begin
                register_write = 1'b1;
                alu_operation = 4'h3;
                flag_write = 1'b1;
            end

            4'h4: begin
                register_write = 1'b1;
                alu_operation = 4'h4;
                flag_write = 1'b1;
            end

            4'h5: begin
                register_write = 1'b1;
                alu_operation = 4'h5;
                flag_write = 1'b1;
            end

            4'h6: begin
                register_write = 1'b1;
                alu_operation = 4'h6;
                flag_write = 1'b1;
            end
            4'h7: begin
                register_write = 1'b1;
                alu_operation = 4'h7;
                flag_write = 1'b1;
            end

            4'h8: begin
                register_write= 1'b1;
                alu_operation = 4'h8;
                flag_write = 1'b1;
            end

            4'h9: begin
                jump = 1'b1;
                instruction_length = 2'd2;
            end

            4'hA: begin
                jump_zero =1'b1;
                instruction_length = 2'd2;
            end

            4'hB: begin
                jump_not_zero = 1'b1;
                instruction_length = 2'd2;
            end

            4'hC: begin
                register_write = 1'b1;
                memory_read = 1'b1;
                writeback_select = 2'b11;
                instruction_length = 2'd2;
            end

            4'hD: begin
                memory_write = 1'b1;
                instruction_length = 2'd2;
            end
            4'hE: begin
                compare = 1'b1;
                alu_operation = 4'h4;
                flag_write = 1'b1;
            end
            4'hF: halt = 1'b1;
            default: nop = 1'b1;
        endcase
    end
endmodule
