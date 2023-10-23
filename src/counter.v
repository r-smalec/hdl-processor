module counter (
    input               clk,
    input               rstn,
    input               ce,

    output reg [4:0]    cnt
);

always @ (posedge clk or negedge rstn) begin

    if(!rstn) begin
        cnt <= 5'd0;
    end
    else begin
        if(ce)
            cnt <= cnt + 1;
        else
            cnt <= cnt;
    end

end

endmodule