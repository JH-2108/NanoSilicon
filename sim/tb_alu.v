`timescale 1ns/1ps 
module tb_alu;
    reg [7:0] a;
    reg [7:0] b;
    reg [3:0] alu_op;
    wire [7:0] result;
    wire carry;
    wire zero_flag;
    wire negative_flag;

    jh8_alu dut (
        .a(a),
        .b(b),
        .alu_op(alu_op),
        .result(result),
        .carry(carry),
        .zero_flag(zero_flag),
        .negative_flag(negative_flag)
    );

    initial begin 
        a = 8'h19; b = 8'h0A; alu_op = 4'h3; #1;
        $display("ADD: %02h + %02h = %02h | Carry = %b", a, b, result, carry);

        a = 8'h19; b = 8'h0A; alu_op = 4'h4; #1; 
        $display("SUB: %02h - %02h = %02h | Carry=%b", a, b, result, carry);

        a = 8'hF0; b = 8'h0F; alu_op = 4'h5; #1;
        $display ("AND: %02h & %02h = %02h | Zero=%b", a, b, result, zero_flag); 

        a = 8'hF0; b=8'h0F; alu_op = 4'h6; #1; $display("OR: %02h | %02h = %02h", a, b, result); 

        a = 8'hAA; b=8'hFF; alu_op = 4'h7; #1; $display("XOR: %02h ^ %02h = %02h", a, b, result); 

        a = 8'h0F; b = 8'h00; alu_op = 4'h8; #1; $display("NOT: ~%02h = %02h | Negative=%b", a, result, negative_flag);

        a = 8'hFF; b = 8'h01; alu_op = 4'h3; #1;
        $display ("OVERFLOW ADD: %02h | Carry = %b Zero = %b", result, carry, zero_flag);

        a = 8'h00; b = 8'h01; alu_op = 4'h4; #1;
        $display ("UNDERFLOW SUB: %02h | Carry = %b Negative = %b", result, carry, negative_flag);

        a = 8'h7F; b = 8'h01; alu_op = 4'h3; #1;
        $display("SIGNED BOUNDARY ADD: %02h | Carry = %b Negative = %b", result, carry, negative_flag);

        $finish; 
    end
endmodule