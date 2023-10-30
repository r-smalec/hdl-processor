`include "instructions.v"

module alu(
    input               clk,
    input       [3:0]   alu_instruction_code,
    input       [7:0]   acu,
    input       [7:0]   reg_file,

    output reg  [7:0]   acumulator,
    output reg          flag_z,
    output reg          flag_cy,
    output reg          flag_ov,
    output reg          flag_p,
    output reg          flag_s
);

always @ (posedge clk) begin
    case(alu_instruction_code)
        `NOT:   acumulator <= ~acu;
        `XOR:   acumulator <= acu ^ reg_file;
        `OR:    acumulator <= acu | reg_file;
        `AND:   acumulator <= acu & reg_file;
        `SUB:   acumulator <= acu - reg_file;
        `ADD:   {flag_cy, acumulator} <= acu + reg_file;
        `RR:    acumulator <= acu >> 1;
        `RL:    acumulator <= acu << 1;
        `DEC:   acumulator <= acu - 1;
        `INC:   acumulator <= acu + 1;
    endcase

    flag_z <= acumulator == 0 ? 1'b1 : 1'b0;
    flag_p <= ~^acumulator;
    flag_s <= acumulator[7];
end

endmodule