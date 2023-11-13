module counter (
    input               clk,
    input               rstn,
    input               cnt_load,
    input       [4:0]   cnt_val

    output reg  [4:0]   cnt,
    output reg  [4:0]   cnt_store
);

reg first_cmd;

always @ (posedge clk or negedge rstn) begin

    if(!rstn) begin
        cnt <= 5'd0;
        first_cmd <= 1'b0;
    end
    else begin
        if(cnt_load) begin
            cnt <= cnt_val;
            cnt_store <= cnt;
        end           
        else
            if(!first_cmd)
                first_cmd <= 1'b1;
            else
                cnt <= cnt + 1;
    end

end

endmodule