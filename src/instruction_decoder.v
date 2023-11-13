`include "instructions.v"

module instruction_decoder (
    input       [15:0]  cell_data,
    
    output reg          rstn,
    output reg          load_en,
    output reg          store_en,

    output reg          R0_ce,
    output reg          R1_ce,
    output reg          R0_oe,
    output reg          R1_oe,

    output reg          jmpf,
    output reg          jmpb,

    output      [5:0]   instr_code,
    output      [7:0]   prog_mem_data
);


assign instr_code = cell_data[13:8];
assign prog_mem_data = cell_data[7:0];

always @ (*) begin
    
    case (cell_data[13:8])
        
        `RST:       begin
            rstn <= 1'b0;
            load_en <= 1'b0;
            store_en <= 1'b0;
            
            R0_ce <= 1'b0;
            R1_ce <= 1'b0;
            R0_oe <= 1'b0;
            R1_oe <= 1'b0;

            jmpf <= 1'b0;
            jmpb <= 1'b0;
        end

        `LD:        begin
            rstn <= 1'b1;
            load_en <= 1'b1;
            store_en <= 1'b0;

            // load to register (R0 or R1) from acumulator
            R0_ce <= cell_data[14];
            R1_ce <= cell_data[15];
            R0_oe <= 1'b0;
            R1_oe <= 1'b0;
            
            jmpf <= 1'b0;
            jmpb <= 1'b0;
        end

        `ST:        begin
            rstn <= 1'b1;
            load_en <= 1'b0;
            store_en <= 1'b1;

            // load to register (R0 or R1) from instruction data
            R0_ce <= cell_data[14];
            R1_ce <= cell_data[15];
            R0_oe <= 1'b0;
            R1_oe <= 1'b0;
            
            jmpf <= 1'b0;
            jmpb <= 1'b0;
        end

        `JMPF:      begin
            rstn <= 1'b1;
            load_en <= 1'b0;
            store_en <= 1'b0;
            
            R0_ce <= 1'b0;
            R1_ce <= 1'b0;
            R0_oe <= 1'b0;
            R1_oe <= 1'b0;

            jmpf <= 1'b1;
            jmpb <= 1'b0;
        end

        `JMPB:      begin
            rstn <= 1'b1;
            load_en <= 1'b0;
            store_en <= 1'b0;
            
            R0_ce <= 1'b0;
            R1_ce <= 1'b0;
            R0_oe <= 1'b0;
            R1_oe <= 1'b0;

            jmpf <= 1'b0;
            jmpb <= 1'b1;
        end

        default:    begin
            rstn <= 1'b1;
            load_en <= 1'b0;
            store_en <= 1'b0;

            // take data from register (R0 or R1) and data from acumulator to computation in alu
            R0_ce <= 1'b0;
            R1_ce <= 1'b0;
            R0_oe <= cell_data[14];
            R1_oe <= cell_data[15];
            
            jmpf <= 1'b0;
            jmpb <= 1'b0;
        end

    endcase
end

endmodule