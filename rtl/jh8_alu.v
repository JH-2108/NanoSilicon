module jh8_alu (
    input wire [7:0] a,
    input wire [7:0] b,
    input wire [3:0] alu_op,
    output reg [7:0] result,
    output reg carry,
    output wire zero_flag,
    output wire negative_flag
);

    reg [8:0] temp;

    always @(*) begin
        result = 8'b0;
        carry = 1'b0;
        temp =9'b0;
        case (alu_op)

            4'h3: begin
                temp = {1'b0, a} + {1'b0, b};
                result = temp[7:0];
                carry = temp[8];
            end
            4'h4: begin
                result = a - b;
                carry =(a >= b);
            end

            4'h5:result = a & b;
            4'h6: result = a | b;
            4'h7: result = a ^ b;
            4'h8: result = ~a;

            default: begin
                result = 8'b0;
                carry = 1'b0;
            end
        endcase
    end
    assign zero_flag = (result == 8'b0);
    assign negative_flag = result[7];
endmodule
