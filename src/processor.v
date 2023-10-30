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

assign rstn = rstn_ext && rstn_inter;
assign counter_ce = 1'b1;

reg		load_en; 
reg		store_en; 

wire    [3:0]	instr_code; 
wire    [7:0]   prog_data;
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
wire		    R0_en; 
wire	        R1_en; 
reg     [7:0]   R0;
reg     [7:0]   R1;
reg 	[7:0]	reg_file; 

always @ (posedge clk) begin

    if(store_en && R0_ce && !R1_ce)
        R0 <= ACU;
    else if(store_en && R1_ce && !R0_ce)
        R1 <= ACU;
    else begin
        R0 <= 1'b0;
        R1 <= 1'b0;
    end

    if(load_en)
        ACU <= prog_data;
    else
        ACU <= ACU;
end

always @ (*) begin

    if(R0_en && !R1_en)
        reg_file <= R0;
    else if(R0_en && !R1_en)
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

rom_mem #(
    .CELL00(16'b0000_0000_0000_0000),
    .CELL01(16'b0000_0000_0000_0000),
    .CELL02(16'b0000_0000_0000_0000),
    .CELL03(16'b0000_0000_0000_0000),

    .CELL04(16'b0000_0000_0000_0000),
    .CELL05(16'b0000_0000_0000_0000),
    .CELL06(16'b0000_0000_0000_0000),
    .CELL07(16'b0000_0000_0000_0000),

    .CELL08(16'b0000_0000_0000_0000),
    .CELL09(16'b0000_0000_0000_0000),
    .CELL10(16'b0000_0000_0000_0000),
    .CELL11(16'b0000_0000_0000_0000),

    .CELL12(16'b0000_0000_0000_0000),
    .CELL13(16'b0000_0000_0000_0000),
    .CELL14(16'b0000_0000_0000_0000),
    .CELL15(16'b0000_0000_0000_0000)
) rom_mem_0 (
    .oe(rstn),
    .addr(prog_cnt),

    .cell_data(cell_data)
);

instruction_decoder instruction_decoder_0 (
	.cell_data(cell_data), 

	.rstn(rstn), 
	.load_en(load_en), 
	.store_en(store_en), 
	.R0_ce(R0_ce), 
	.R1_ce(R1_ce), 
	.instr_code(instr_code),
    .prog_data(prog_data)
);

alu alu_0 (
	.instr_code(instr_code), 
	.acumulator(ACU), 
	.reg_file(reg_file), 

    .alu_result(alu_result),
	.flag_z(flag_z), 
	.flag_cy(flag_cy), 
	.flag_ov(flag_ov), 
	.flag_p(flag_p), 
	.flag_s(flag_s) 
);

endmodule