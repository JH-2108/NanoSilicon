module jh8_flags (
    input wire clk,
    input wire reset,
    input wire write_enable,
    input wire zero_in,
    input wire carry_in,
    input wire negative_in,
    output reg zero_flag,
    output reg carry_flag,
    output reg negative_flag
);
    always @(posedge clk) begin

        if(reset) begin

            zero_flag <=1'b0;
            carry_flag <= 1'b0;
            negative_flag <= 1'b0;
        end
        else if(write_enable) begin
            zero_flag <= zero_in;
            carry_flag <= carry_in;
            negative_flag <= negative_in;
        end
    end
endmodule