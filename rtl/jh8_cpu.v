module jh8_cpu #(
    parameter ROM_INIT_FILE = "sim/program.hex"
)(
    input wire clk,
    input wire reset,
    output wire [7:0] pc,
    output reg halted
);
    wire[7:0] instruction;
    wire [7:0]immediate_data;
    jh8_rom #( 
        .INIT_FILE(ROM_INIT_FILE)
    ) rom (
        .address(pc),
        .instruction(instruction),
        .immediate_address(pc+8'd1),
        .immediate_data(immediate_data)
    );
    wire [3:0]opcode;
    wire [1:0] destination;
    wire[1:0]source;
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
    wire[1:0] instruction_length;
    wire[1:0]writeback_select;
    wire flag_write;

    jh8_decoder decoder (
        .instruction(instruction),
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
        .instruction_length(instruction_length),
        .writeback_select(writeback_select),
        .flag_write(flag_write)
    );
    wire[7:0] register_data_d;
    wire [7:0]register_data_s;
    wire [7:0]register_write_data;

    jh8_registers registers (
        .clk(clk),
        .reset(reset),

        .read_addr_a(destination),
        .read_data_a(register_data_d),

        .read_addr_b(source),
        .read_data_b(register_data_s),

        .write_enable(register_write && !halted),
        .write_addr(destination),
        .write_data(register_write_data)
    );

    wire [7:0] alu_result;
    wire alu_carry;
    wire alu_zero;
    wire alu_negative;
    jh8_alu alu (
        .a(register_data_d),
        .b(register_data_s),
        .alu_op(alu_operation),
        .result(alu_result),
        .carry(alu_carry),
        .zero_flag(alu_zero),
        .negative_flag(alu_negative)
    );

    wire [7:0] ram_read_data;
    jh8_ram ram (
        .clk(clk),
        .write_enable(memory_write && !halted),
        .address(immediate_data),
        .write_data(register_data_d),
        .read_data(ram_read_data)
    );
    reg[7:0] selected_writeback;
    always @(*) begin
        case (writeback_select)
            2'b00: selected_writeback = alu_result;
            2'b01: selected_writeback = register_data_s;
            2'b10: selected_writeback = immediate_data;
            2'b11: selected_writeback = ram_read_data;
            default: selected_writeback = 8'h00;
        endcase
    end
    assign register_write_data = selected_writeback;
    wire zero_flag;
    wire carry_flag;
    wire negative_flag;
    jh8_flags flags (
        .clk(clk),
        .reset(reset),
        .write_enable(flag_write && !halted),
        .zero_in(alu_zero),
        .carry_in(alu_carry),
        .negative_in(alu_negative),
        .zero_flag(zero_flag),
        .carry_flag(carry_flag),
        .negative_flag(negative_flag)
    );
    wire jump_taken;
    wire [7:0]next_pc;
    assign jump_taken =
        jump ||
        (jump_zero && zero_flag) ||
        (jump_not_zero && !zero_flag);

    assign next_pc = jump_taken
        ? immediate_data
        : pc + {6'b000000, instruction_length};
    jh8_pc program_counter (
        .clk(clk),
        .reset(reset),
        .enable(!halted),
        .next_pc(next_pc),
        .pc(pc)
    );
    always @(posedge clk) begin
        if(reset) begin
            halted<= 1'b0;
        end
        else if(!halted && halt) begin
            halted <= 1'b1;
        end
    end
endmodule
