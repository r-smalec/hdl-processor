`include "instructions.v"

module instruction_decoder (
    input       [15:0]  cell_data,
    
    output reg          rstn,
    output reg          load_en,
    output reg          store_en,
    output reg          R0_ce,
    output reg          R1_ce,
    output reg          R0_en,
    output reg          R1_en,
    output      [3:0]   instr_code,
    output      [7:0]   prog_data
);


assign instr_code = cell_data[11:8];
assign data = cell_data[7:0];

always @ (*) begin
    
    case (cell_data[11:8])
        
        `RST:       begin
            rstn <= 1'b0;
            load_en <= 1'b0;
            store_en <= 1'b0;
            
            R0_ce <= 1'b0;
            R1_ce <= 1'b0;
            R0_en <= 1'b0;
            R1_en <= 1'b0;
        end

        `LD:        begin
            rstn <= 1'b1;
            load_en <= 1'b1;
            store_en <= 1'b0;

            R0_ce <= cell_data[12];
            R1_ce <= cell_data[13];
            R0_en <= 1'b0;
            R1_en <= 1'b0;
        end

        `ST:        begin
            rstn <= 1'b1;
            load_en <= 1'b0;
            store_en <= 1'b1;
            
            R0_ce <= cell_data[12];
            R1_ce <= cell_data[13];
            R0_en <= 1'b0;
            R1_en <= 1'b0;
        end

        default:    begin
            rstn <= 1'b1;
            load_en <= 1'b0;
            store_en <= 1'b0;
            
            R0_ce <= 1'b0;
            R1_ce <= 1'b0;
            R0_en <= cell_data[12];
            R1_en <= cell_data[13];
        end

    endcase
end

endmodule