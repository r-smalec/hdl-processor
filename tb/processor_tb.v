`timescale 1ps/1ps
`include "../src/processor.v"

module processor_tb;

parameter PERIOD = 4;
parameter HALF_PERIOD = PERIOD / 2;
parameter TWICE_PERIOD = PERIOD * 2;

reg         clk;
reg         rstn_ext;

wire [4:0]  prog_cnt;
wire        rstn_inter;
wire        acumulator_ce;
wire        reg_file_ce;
wire [7:0]  instruction_code;

processor UUT (
    .clk(clk),
    .rstn_ext(rstn_ext),

    .prog_cnt(prog_cnt),
    .rstn_inter(rstn_inter),
    .acumulator_ce(acumulator_ce),
    .reg_file_ce(reg_file_ce),
    .instruction_code(instruction_code)
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
    #1000
    $finish();
end

endmodule