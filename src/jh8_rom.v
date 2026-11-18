module jh8_rom #(
    parameter INIT_FILE = "sim/program.hex"
)(
    input wire [7:0] address, 
    output wire [7:0] instruction,
    input wire [7:0] immediate_address,
    output wire [7:0] immediate_data
);
    function [7:0] rom_byte;
        input [7:0] addr; 
        begin
            case (addr)
                8'd0: rom_byte =8'h20; 
                8'd1: rom_byte = 8'h19;
                8'd2: rom_byte = 8'h24;
                8'd3: rom_byte = 8'h0A; 
                8'd4: rom_byte = 8'h31;
                8'd5: rom_byte = 8'hD0;
                8'd6: rom_byte = 8'h80;
                8'd7: rom_byte = 8'hF0; 
                default: rom_byte = 8'h00; 
            endcase
        end
    endfunction 
    assign instruction = rom_byte(address); 
    assign immediate_data = rom_byte(immediate_address);
endmodule
