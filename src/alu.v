`include "instructions.v"

module alu(
    input       [3:0]   instr_code,
    input       [7:0]   acumulator,
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
        `NOT:   alu_result <= ~acumulator;
        `XOR:   alu_result <= acumulator ^ reg_file;
        `OR:    alu_result <= acumulator | reg_file;
        `AND:   alu_result <= acumulator & reg_file;
        `SUB:   alu_result <= acumulator - reg_file;
        `ADD:   {flag_cy, alu_result} <= acumulator + reg_file;
        `RR:    alu_result <= acumulator >> 1;
        `RL:    alu_result <= acumulator << 1;
        `DEC:   alu_result <= acumulator - 1;
        `INC:   alu_result <= acumulator + 1;
    endcase

    flag_z <= alu_result == 0 ? 1'b1 : 1'b0;
    flag_p <= ~^alu_result;
    flag_s <= alu_result[7];
end

endmodule