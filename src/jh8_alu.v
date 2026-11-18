module jh8_alu (
    input wire [7:0] a,
    input wire [7:0] b,
    input wire [3:0] alu_op,
    output reg [7:0] result,
    output reg carry,
    output wire zero_flag,
    output wire negative_flag
);
    wire [7:0] add_p;
    wire [7:0] add_g;
    wire [8:0] add_c;
    wire [7:0] add_result;
    assign add_p = a ^ b;
    assign add_g = a & b;
    assign add_c[0] = 1'b0;
    assign add_c[1] = add_g[0];
    assign add_c[2] =
        add_g[1] |
        (add_p[1] & add_g[0]);
    assign add_c[3] =
        add_g[2] |
        (add_p[2] & add_g[1]) |
        (add_p[2] & add_p[1] & add_g[0]);
    assign add_c[4] =
        add_g[3] |
        (add_p[3] & add_g[2]) |
        (add_p[3] & add_p[2] & add_g[1]) |
        (add_p[3] & add_p[2] & add_p[1] & add_g[0]);
    assign add_c[5] =
        add_g[4] |
        (add_p[4] & add_g[3]) |
        (add_p[4] & add_p[3] & add_g[2]) |
        (add_p[4] & add_p[3] & add_p[2] & add_g[1]) |
        (add_p[4] & add_p[3] & add_p[2] & add_p[1] & add_g[0]);
    assign add_c[6] =
        add_g[5] |
        (add_p[5] & add_g[4]) |
        (add_p[5] & add_p[4] & add_g[3]) |
        (add_p[5] & add_p[4] & add_p[3] & add_g[2]) |
        (add_p[5] & add_p[4] & add_p[3] & add_p[2] & add_g[1]) |
        (add_p[5] & add_p[4] & add_p[3] & add_p[2] & add_p[1] & add_g[0]);
    assign add_c[7] =
        add_g[6] |
        (add_p[6] & add_g[5]) |
        (add_p[6] & add_p[5] & add_g[4]) |
        (add_p[6] & add_p[5] & add_p[4] & add_g[3]) |
        (add_p[6] & add_p[5] & add_p[4] & add_p[3] & add_g[2]) |
        (add_p[6] & add_p[5] & add_p[4] & add_p[3] & add_p[2] & add_g[1]) |
        (add_p[6] & add_p[5] & add_p[4] & add_p[3] & add_p[2] & add_p[1] & add_g[0]);
    assign add_c[8] =
        add_g[7] |
        (add_p[7] & add_g[6]) |
        (add_p[7] & add_p[6] & add_g[5]) |
        (add_p[7] & add_p[6] & add_p[5] & add_g[4]) |
        (add_p[7] & add_p[6] & add_p[5] & add_p[4] & add_g[3]) |
        (add_p[7] & add_p[6] & add_p[5] & add_p[4] & add_p[3] & add_g[2]) |
        (add_p[7] & add_p[6] & add_p[5] & add_p[4] & add_p[3] & add_p[2] & add_g[1]) |
        (add_p[7] & add_p[6] & add_p[5] & add_p[4] & add_p[3] & add_p[2] & add_p[1] & add_g[0]);

    assign add_result = add_p ^ add_c[7:0];

    wire [7:0] sub_p;
    wire [7:0] sub_g;
    wire [8:0] sub_c;
    wire [7:0] sub_result;
    assign sub_p = a ^ ~b;
    assign sub_g = a & ~b;
    assign sub_c[0] = 1'b1;
    assign sub_c[1] = sub_g[0] | sub_p[0];
    assign sub_c[2] =
        sub_g[1] |
        (sub_p[1] & sub_g[0]) |
        (sub_p[1] & sub_p[0]);
    assign sub_c[3] =
        sub_g[2] |
        (sub_p[2] & sub_g[1]) |
        (sub_p[2] & sub_p[1] & sub_g[0]) |
        (sub_p[2] & sub_p[1] & sub_p[0]);
    assign sub_c[4] =
        sub_g[3] |
        (sub_p[3] & sub_g[2]) |
        (sub_p[3] & sub_p[2] & sub_g[1]) |
        (sub_p[3] & sub_p[2] & sub_p[1] & sub_g[0]) |
        (sub_p[3] & sub_p[2] & sub_p[1] & sub_p[0]);
    assign sub_c[5] =
        sub_g[4] |
        (sub_p[4] & sub_g[3]) |
        (sub_p[4] & sub_p[3] & sub_g[2]) |
        (sub_p[4] & sub_p[3] & sub_p[2] & sub_g[1]) |
        (sub_p[4] & sub_p[3] & sub_p[2] & sub_p[1] & sub_g[0]) |
        (sub_p[4] & sub_p[3] & sub_p[2] & sub_p[1] & sub_p[0]);
    assign sub_c[6] =
        sub_g[5] |
        (sub_p[5] & sub_g[4]) |
        (sub_p[5] & sub_p[4] & sub_g[3]) |
        (sub_p[5] & sub_p[4] & sub_p[3] & sub_g[2]) |
        (sub_p[5] & sub_p[4] & sub_p[3] & sub_p[2] & sub_g[1]) |
        (sub_p[5] & sub_p[4] & sub_p[3] & sub_p[2] & sub_p[1] & sub_g[0]) |
        (sub_p[5] & sub_p[4] & sub_p[3] & sub_p[2] & sub_p[1] & sub_p[0]);
    assign sub_c[7] =
        sub_g[6] |
        (sub_p[6] & sub_g[5]) |
        (sub_p[6] & sub_p[5] & sub_g[4]) |
        (sub_p[6] & sub_p [5] & sub_p[4] & sub_g[3]) |
        (sub_p[6] & sub_p[5] & sub_p[4] & sub_p[3] & sub_g[2]) |
        (sub_p[6] & sub_p[5] & sub_p[4] & sub_p[3] & sub_p[2] & sub_g[1]) |
        (sub_p[6] & sub_p[5] & sub_p[4] & sub_p[3] & sub_p[2] & sub_p[1] & sub_g[0]) |
        (sub_p[6] & sub_p[5] & sub_p[4] & sub_p[3] & sub_p[2] & sub_p[1] & sub_p[0]);

    assign sub_c[8] =
        sub_g[7] |
        (sub_p[7] & sub_g[6]) |
        (sub_p[7] & sub_p[6] & sub_g[5]) |
        (sub_p[7] & sub_p[6] & sub_p[5] & sub_g[4]) |
        (sub_p[7] & sub_p[6] & sub_p[5] & sub_p[4] & sub_g[3]) |
        (sub_p[7] & sub_p[6] & sub_p[5] & sub_p[4] & sub_p[3] & sub_g[2]) |
        (sub_p[7] & sub_p[6] & sub_p[5] & sub_p[4] & sub_p[3] & sub_p[2] & sub_g[1]) |
        (sub_p[7] & sub_p[6] & sub_p[5] & sub_p[4] & sub_p[3] & sub_p[2] & sub_p[1] & sub_g[0]) |
        (sub_p[7] & sub_p[6] & sub_p[5] & sub_p[4] & sub_p[3] & sub_p[2] & sub_p[1] & sub_p[0]);

    assign sub_result = sub_p ^ sub_c[7:0];
    always @(*) begin
        result = 8'b0;
        carry = 1'b0;
        case (alu_op)
            4'h3: begin
                result = add_result;
                carry = add_c[8];
            end
            4'h4: begin
                result = sub_result;
                carry = sub_c[8];
            end
            4'h5: result = a & b;
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
