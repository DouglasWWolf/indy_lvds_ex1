// This divides the input clock by 2 
module hsi_pclk
(
    input clk,
    output reg hsi_pclk
);

always @(posedge clk) begin
    if (hsi_pclk)
        hsi_pclk <= 0;
    else
        hsi_pclk <= 1;
end

endmodule
