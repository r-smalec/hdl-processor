`timescale 1ns / 1ps
//`include "../src/processor.v"

module processor_tb;

parameter PERIOD = 4;
parameter HALF_PERIOD = PERIOD / 2;
parameter TWICE_PERIOD = PERIOD * 2;

reg		        clk; 
reg		        rstn_ext;

wire			rstn_inter_dbg; 
wire	[4:0]	prog_cnt_dbg; 
wire			cnt_load_dbg; 
wire	[4:0]	cnt_val_dbg; 
wire			load_en_dbg; 
wire			store_en_dbg; 
wire			R0_ce_dbg; 
wire			R1_ce_dbg; 
wire			R0_oe_dbg; 
wire			R1_oe_dbg; 
wire	[7:0]	R0_dbg; 
wire	[7:0]	R1_dbg; 
wire	[7:0]	reg_file_dbg; 
wire	[7:0]	ACU_dbg; 
wire	[7:0]	alu_result_dbg; 
wire	[5:0]	instr_code_dbg; 
wire	[7:0]	prog_mem_data_dbg; 

processor UUT (
	.clk								(clk), 
	.rstn_ext							(rstn_ext), 
	
	.rstn_inter_dbg						(rstn_inter_dbg), 
	.prog_cnt_dbg						(prog_cnt_dbg), 
	.cnt_load_dbg						(cnt_load_dbg), 
	.cnt_val_dbg						(cnt_val_dbg), 
	.load_en_dbg						(load_en_dbg), 
	.store_en_dbg						(store_en_dbg), 
	.R0_ce_dbg							(R0_ce_dbg), 
	.R1_ce_dbg							(R1_ce_dbg), 
	.R0_oe_dbg							(R0_oe_dbg), 
	.R1_oe_dbg							(R1_oe_dbg), 
	.R0_dbg								(R0_dbg), 
	.R1_dbg								(R1_dbg), 
	.reg_file_dbg						(reg_file_dbg), 
	.ACU_dbg							(ACU_dbg), 
	.alu_result_dbg						(alu_result_dbg), 
	.instr_code_dbg						(instr_code_dbg), 
	.prog_mem_data_dbg					(prog_mem_data_dbg) 
);

initial begin
    clk = 1'b1;
    forever begin
        #HALF_PERIOD clk = ~clk;
    end
end

initial begin
    rstn_ext = 1'b0;
    #TWICE_PERIOD
    rstn_ext = 1'b1;
    #100
    $finish();
end

endmodule
