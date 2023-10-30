// instruction's bits:
//  15, 14, 13, 12,     11, ... 8,      7,  ... 0
//          R1  R0      instr code      data

module rom_mem #(
    parameter CELL00 = 16'b0000_0000_0000_0000,
    parameter CELL01 = 16'b0000_0000_0000_0000,
    parameter CELL02 = 16'b0000_0000_0000_0000,
    parameter CELL03 = 16'b0000_0000_0000_0000,

    parameter CELL04 = 16'b0000_0000_0000_0000,
    parameter CELL05 = 16'b0000_0000_0000_0000,
    parameter CELL06 = 16'b0000_0000_0000_0000,
    parameter CELL07 = 16'b0000_0000_0000_0000,
    
    parameter CELL08 = 16'b0000_0000_0000_0000,
    parameter CELL09 = 16'b0000_0000_0000_0000,
    parameter CELL10 = 16'b0000_0000_0000_0000,
    parameter CELL11 = 16'b0000_0000_0000_0000,

    parameter CELL12 = 16'b0000_0000_0000_0000,
    parameter CELL13 = 16'b0000_0000_0000_0000,
    parameter CELL14 = 16'b0000_0000_0000_0000,
    parameter CELL15 = 16'b0000_0000_0000_0000
) (
    input               oe,
    input      [4:0]    addr,
    output reg [15:0]   cell_data
);

    always @ (*) begin
        if(oe) begin
            case(addr)
                5'd0:   cell_data <= CELL00;
                5'd1:   cell_data <= CELL01;
                5'd2:   cell_data <= CELL02;
                5'd3:   cell_data <= CELL03;

                5'd4:   cell_data <= CELL04;
                5'd5:   cell_data <= CELL05;
                5'd6:   cell_data <= CELL06;
                5'd7:   cell_data <= CELL07;

                5'd8:   cell_data <= CELL08;
                5'd9:   cell_data <= CELL09;
                5'd10:  cell_data <= CELL10;
                5'd11:  cell_data <= CELL11;

                5'd12:  cell_data <= CELL12;
                5'd13:  cell_data <= CELL13;
                5'd14:  cell_data <= CELL14;
                5'd15:  cell_data <= CELL15;

                default:cell_data <= 16'd0;
            endcase
        end
        else
            cell_data <= 16'd0;
    end

endmodule