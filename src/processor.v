// `include "instructions.v"
// `include "counter.v"
// `include "rom_mem.v"
// `include "instruction_decoder.v"
// `include "alu.v"

module processor (
    input           clk,
    input           rstn_ext,

    output [4:0]    prog_cnt_dbg,
    output          rstn_inter_dbg,
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
    output [3:0]    instr_code_dbg,
    output [7:0]    prog_mem_data_dbg
);

wire            rstn;
wire            counter_ce;

wire            rstn_inter;
wire		    load_en; 
wire		    store_en; 

wire    [4:0]   prog_cnt;
wire    [15:0]  cell_data;
wire    [5:0]	instr_code;
wire    [7:0]   prog_mem_data;
wire    [7:0]   alu_result;

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

assign  rstn_inter_dbg = rstn_inter;
assign  prog_cnt_dbg = prog_cnt;
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

assign  rstn = rstn_ext && rstn_inter;
assign  counter_ce = 1'b1;

always @ (posedge clk) begin

    if(store_en && R0_ce && !R1_ce)
        R0 <= ACU;
    else if(store_en && R1_ce && !R0_ce)
        R1 <= ACU;
    else begin
        R0 <= R0;
        R1 <= R1;
    end

    if(load_en)
        ACU <= prog_mem_data;
    else
        ACU <= alu_result;
end

always @ (*) begin

    if(R0_oe && !R1_oe)
        reg_file <= R0;
    else if(R0_oe && !R1_oe)
        reg_file <= R1;
    else
        reg_file <= reg_file;
end

counter counter_0(
    .clk(clk),
    .rstn(rstn),
    .ce(counter_ce),
    
    .cnt(prog_cnt)
);

// instruction's bits:
//  15, 14,     13, ... 8,      7,  ... 0
//  R1  R0      instr code        data

rom_mem #(
	.CELL00(16'b0000_1010_0000_0010), // LD 2
	.CELL01(16'b0100_1011_0000_0000), // ST R0
	.CELL02(16'b0100_0100_0000_0101), // SUB R0 5
	.CELL03(16'b0100_1011_0000_0000), // ST R0
	.CELL04(16'b0011_1100_0000_0000), // NOP
	.CELL05(16'b0011_1100_0000_0000), // NOP
	.CELL06(16'b0011_1100_0000_0000), // NOP
	.CELL07(16'b0011_1100_0000_0000), // NOP
	.CELL08(16'b0011_1100_0000_0000), // NOP
	.CELL09(16'b0011_1100_0000_0000), // NOP
	.CELL10(16'b0011_1100_0000_0000), // NOP
	.CELL11(16'b0011_1100_0000_0000), // NOP
	.CELL12(16'b0011_1100_0000_0000), // NOP
	.CELL13(16'b0011_1100_0000_0000), // NOP
	.CELL14(16'b0011_1100_0000_0000), // NOP
	.CELL15(16'b0011_1100_0000_0000)  // NOP
) rom_mem_0 (
    .oe(rstn),
    .addr(prog_cnt),

    .cell_data(cell_data)
);

instruction_decoder instruction_decoder_0 (
	.cell_data(cell_data), 

	.rstn(rstn_inter), 
	.load_en(load_en), 
	.store_en(store_en), 
	.R0_ce(R0_ce), 
	.R1_ce(R1_ce),
    .R0_oe(R0_oe),
    .R1_oe(R1_oe),
	.instr_code(instr_code),
    .prog_mem_data(prog_mem_data)
);

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