`timescale 1ns / 1ps
// `include "instructions.v"
// `include "counter.v"
// `include "rom_mem.v"
// `include "instruction_decoder.v"
// `include "alu.v"

module processor (
    input           clk,
    input           rstn_ext,

    output          rstn_inter_dbg,
    output [4:0]    prog_cnt_dbg,
    output          cnt_load_dbg,
    output [4:0]    cnt_val_dbg,
    output          load_en_dbg, 
    output          store_en_dbg,
    output     	    R0_ce_dbg, 
    output          R1_ce_dbg,
    output 	        R0_oe_dbg, 
    output          R1_oe_dbg,
    output [7:0]    R0_dbg,
    output [7:0]    R1_dbg,
    output [7:0]	reg_file_dbg,
    output [7:0]    ACU_dbg,
    output [7:0]    alu_result_dbg,
    output [5:0]    instr_code_dbg,
    output [7:0]    prog_mem_data_dbg
);

wire            rstn;
wire            rstn_inter;

wire    [4:0]   prog_cnt;
reg             cnt_load;
reg     [4:0]   cnt_val;
wire    [4:0]   cnt_store;

wire    [15:0]  cell_data;
wire    [5:0]	instr_code;
wire    [7:0]   prog_mem_data;
wire    [7:0]   alu_result;

wire		    load_en; 
wire		    store_en; 

wire            jmpf;
wire            jmpb;

//////// Flags ////////
wire            flag_z;     // Zero flag
wire            flag_cy;    // Carry flag
wire            flag_ov;    // Overflow flag
wire            flag_p;     // Parity flag
wire            flag_s;     // Sign flag

//////// Acumulator ////////
reg	    [7:0]	ACU;

//////// Register file ////////
wire		    R0_ce; 
wire	        R1_ce;
wire		    R0_oe; 
wire	        R1_oe;
reg     [7:0]   R0;
reg     [7:0]   R1;
reg 	[7:0]	reg_file; 

//////// Debug signals ////////
assign  rstn_inter_dbg = rstn_inter;
assign  prog_cnt_dbg = prog_cnt;
assign  cnt_load_dbg = cnt_load;
assign  cnt_val_dbg = cnt_val;
assign  load_en_dbg = load_en; 
assign  store_en_dbg = store_en;
assign  R0_ce_dbg = R0_ce;
assign  R1_ce_dbg = R1_ce;
assign  R0_oe_dbg = R0_oe;
assign  R1_oe_dbg = R1_oe;
assign  R0_dbg = R0;
assign  R1_dbg = R1;
assign  reg_file_dbg = reg_file;
assign  ACU_dbg = ACU;
assign  alu_result_dbg = alu_result;
assign  instr_code_dbg = instr_code;
assign  prog_mem_data_dbg = prog_mem_data;

//////// Reset ////////
assign  rstn = rstn_ext && rstn_inter;

//////// Store to file registers ////////
always @ (posedge clk) begin

    if(store_en && R0_ce && !R1_ce)
        R0 <= ACU;
    else if(store_en && R1_ce && !R0_ce)
        R1 <= ACU;
    else begin
        R0 <= R0;
        R1 <= R1;
    end
end

//////// Load to acumulator ////////
always @ (posedge clk) begin

    if(load_en)
        ACU <= prog_mem_data;
    else
        ACU <= alu_result;
end

//////// Register file mux ////////
always @ (*) begin

    if(R0_oe && !R1_oe)
        reg_file <= R0;
    else if(R0_oe && !R1_oe)
        reg_file <= R1;
    else
        reg_file <= reg_file;
end

//////// Jump's program counter modification ////////
always @ (*) begin

    if(jmpf) begin
        cnt_load <= 1'b1;
        cnt_val <= prog_cnt + prog_mem_data;
    end
    else if(jmpb) begin
        cnt_load <= 1'b1;
        cnt_val <= prog_cnt - prog_mem_data;
    end
    else begin
        cnt_load <= 1'b0;
        cnt_val <= cnt_val;
    end
end

//////// Program counter ////////
counter program_counter_0(
    .clk(clk),
    .rstn(rstn),
    .cnt_load(cnt_load),
    .cnt_val(cnt_val),
    
    .cnt_store(cnt_store),
    .cnt(prog_cnt)
);

//////// Program ROM memory ////////
// instruction's bits:
//  15, 14,     13, ... 8,      7,  ... 0
//  R1  R0      instr code        data
rom_mem #(
	.CELL00(16'b0000_1010_0000_0010), // LD 2
	.CELL01(16'b0100_1011_0000_0000), // ST R0
	.CELL02(16'b0100_0101_0000_0101), // ADD R0 5
	.CELL03(16'b0100_1011_0000_0000), // ST R0
	.CELL04(16'b0000_1100_0000_0100), // JMPF LABEL1
	.CELL05(16'b0011_1100_0000_0000), // NOP
	.CELL06(16'b0011_1100_0000_0000), // NOP
	.CELL08(16'b0011_1100_0000_0000), // NOP
	.CELL09(16'b0011_1100_0000_0000), // NOP
	.CELL10(16'b0011_1100_0000_0000), // NOP
	.CELL11(16'b0011_1100_0000_0000), // NOP
	.CELL12(16'b0011_1100_0000_0000), // NOP
	.CELL13(16'b0011_1100_0000_0000), // NOP
	.CELL14(16'b0011_1100_0000_0000), // NOP
	.CELL15(16'b0011_1100_0000_0000), // NOP
	.CELL16(16'b0011_1100_0000_0000)  // NOP
) program_memory_0 (
    .oe(rstn),
    .addr(prog_cnt),

    .cell_data(cell_data)
);

//////// Instruction decoder ////////
instruction_decoder instruction_decoder_0 (
	.cell_data(cell_data), 

	.rstn(rstn_inter), 
	.load_en(load_en), 
	.store_en(store_en),

	.R0_ce(R0_ce), 
	.R1_ce(R1_ce),
    .R0_oe(R0_oe),
    .R1_oe(R1_oe),

    .jmpf(jmpf),
    .jmpb(jmpb),

	.instr_code(instr_code),
    .prog_mem_data(prog_mem_data)
);

//////// Arithmetic logic unit ////////
alu alu_0 (
	.instr_code(instr_code), 
	.in_data(prog_mem_data), 
	.reg_file(reg_file), 

    .alu_result(alu_result),
	.flag_z(flag_z), 
	.flag_cy(flag_cy), 
	.flag_ov(flag_ov), 
	.flag_p(flag_p), 
	.flag_s(flag_s) 
);

endmodule