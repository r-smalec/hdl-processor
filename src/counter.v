module counter (
    input               clk,
    input               rstn,
    input               ce,

    output reg [4:0]    cnt
);

reg first_cmd;

always @ (posedge clk or negedge rstn) begin

    if(!rstn) begin
        cnt <= 5'd0;
        first_cmd <= 1'b0;
    end
    else begin
        if(ce)
            if(!first_cmd)
                first_cmd <= 1'b1;
            else
                cnt <= cnt + 1;
        else
            cnt <= cnt;
    end

end

endmodule