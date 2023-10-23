`include "counter.v"
`include "rom_mem.v"
`include "instruction_decoder.v"
`include "instructions.v"

module processor (
    input           clk,
    input           rstn_ext,

    output [4:0]    prog_cnt,
    output          rstn_inter,
    output          acumulator_ce,
    output          reg_file_ce,
    output [7:0]    instruction_code
);

wire            rstn;
wire            counter_ce;
wire    [3:0]   alu_instruction_code;

assign rstn = rstn_ext && rstn_inter;
assign counter_ce = 1'b1;

counter counter_0(
    .clk(clk),
    .rstn(rstn),
    .ce(counter_ce),
    
    .cnt(prog_cnt)
);

rom_mem #(
    .CELL00(8'b0000_0001),
    .CELL01(8'b0000_0001),
    .CELL02(8'b0000_0001),
    .CELL03(8'b0000_1010),

    .CELL04(8'b0000_0001),
    .CELL05(8'b0000_1011),
    .CELL06(8'b0000_0001),
    .CELL07(8'b0000_1111),

    .CELL08(8'b0100_0000),
    .CELL09(8'b0010_0000),
    .CELL10(8'b0001_0000),
    .CELL11(8'b0000_0000),

    .CELL12(8'b0000_0000),
    .CELL13(8'b0000_0000),
    .CELL14(8'b0000_0000),
    .CELL15(8'b0000_0000)
) rom_mem_0 (
    .oe(rstn),
    .addr(prog_cnt),
    .cell_data(instruction_code)
);

instruction_decoder instruction_decoder_0 (
    .clk(clk),
    .instruction_code(instruction_code),

    .rstn(rstn_inter),
    .acumulator_ce(acumulator_ce),
    .reg_file_ce(reg_file_ce),
    .alu_instruction_code(alu_instruction_code)
);

alu alu_0 (
    .clk(clk),
    .alu_instruction_code(alu_instruction_code),
    .acu_data(acu_data),
    .reg_data(reg_data),
);

endmodule