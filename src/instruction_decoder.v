`include "instructions.v"

module instruction_decoder (
    input               clk,
    input   [7:0]       instruction_code,
    
    output  reg         rstn,
    output  reg         acumulator_ce,
    output  reg         reg_file_ce,
    output  reg [3:0]   alu_instruction_code
);


always @ (*) begin
    alu_instruction_code <= instruction_code[3:0];
    
    case (instruction_code[3:0])
        
        `RST:       begin
            rstn <= 1'b0;
            acumulator_ce <= 1'b0;
            reg_file_ce <= 1'b0;
        end

        `LD:        begin
            rstn <= 1'b1;
            acumulator_ce <= 1'b1;
            reg_file_ce <= 1'b0;
        end

        `ST:         begin
            rstn <= 1'b1;
            acumulator_ce <= 1'b0;
            reg_file_ce <= 1'b1;
        end

        default:    begin
            rstn <= 1'b1;
            acumulator_ce <= 1'b0;
            reg_file_ce <= 1'b0;
        end

    endcase
end

endmodule