`timescale 1ns / 1ps
`include "instructions.v"

module alu(
    input       [5:0]   instr_code,
    input       [7:0]   in_data,
    input       [7:0]   reg_file,

    output reg  [7:0]   alu_result,
    output reg          flag_z,
    output reg          flag_cy,
    output reg          flag_ov,
    output reg          flag_p,
    output reg          flag_s
);

always @ (*) begin
    case(instr_code)
        `NOT:   alu_result <= ~in_data;
        `XOR:   alu_result <= in_data ^ reg_file;
        `OR:    alu_result <= in_data | reg_file;
        `AND:   alu_result <= in_data & reg_file;
        `SUB:   alu_result <= in_data - reg_file;
        `ADD:   {flag_cy, alu_result} <= in_data + reg_file;
        `RR:    alu_result <= in_data >> 1;
        `RL:    alu_result <= in_data << 1;
        `DEC:   alu_result <= in_data - 1;
        `INC:   alu_result <= in_data + 1;
    endcase

    flag_z <= alu_result == 0 ? 1'b1 : 1'b0;
    flag_p <= ~^alu_result;
    flag_s <= alu_result[7];
end

endmodule