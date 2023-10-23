module alu(
    input               clk,
    input       [3:0]   alu_instruction_code,
    input       [7:0]   acu,
    input       [7:0]   reg_file,

    output reg  [7:0]   data,
    output reg          flag_z,
    output reg          flag_cy,
    output reg          flag_ov,
    output reg          flag_p,
    output reg          flag_s
);

always @ (posedge clk) begin
    case(alu_instruction_code)
        `NOT:   data <= ~acu;
        `XOR:   data <= acu ^ reg_file;
        `OR:    data <= acu | reg_file;
        `AND:   data <= acu & reg_file;
        `SUB:   data <= acu - reg_file;
        `ADD:   {flag_cy, data} <= acu + reg_file;
        `RR:    data <= acu >> 1;
        `RL:    data <= acu << 1;
        `DEC:   data <= acu - 1;
        `INC:   data <= acu + 1;
    endcase

    flag_z <= data == 0 ? 1'b1 : 1'b0;
    flag_p <= ~^data;
    falg_s <= data[7];
end

endmodule