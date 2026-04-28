//=============================================================================
//                   ------->  Revision History  <------
//=============================================================================
//
//   Date     Who   Ver  Changes
//=============================================================================
// 28-Mar-26  DWW     1  Initial creation
//=============================================================================

/*
    This provides extra flip-flops between the output of the SPI bus
    and the physical pins of the FPGA. 
*/

module chip_spi_extra_flops # (parameter EXTRA_FLOPS = 2)
(
    input        clk,
    input        resetn,

    input        spi_pclk,
    input        spi_mosi,
    input        spi_csn,

    output       pin_spi_pclk,
    output       pin_spi_mosi,
    output       pin_spi_csn

);
genvar i;

// This is the number of input signal bits we have
localparam SIGNAL_COUNT = 3;

// This is the last index in the chain
localparam LAST_INDEX = EXTRA_FLOPS - 1;

// This is the chain of flip-flops, one chain per signal bit
(* dont_touch = "true" *) reg[SIGNAL_COUNT-1:0] flop[0:LAST_INDEX];

//=============================================================================
// Build a word consisting of all the input signals
//=============================================================================
wire[SIGNAL_COUNT-1:0] input_word = 
{
    spi_pclk,
    spi_mosi,
    spi_csn
};
//=============================================================================


//=============================================================================
// The last flop in the chain is our output signals
//=============================================================================
assign
{
    pin_spi_pclk,
    pin_spi_mosi,
    pin_spi_csn

} = flop[LAST_INDEX];
//=============================================================================



//=============================================================================
// Feed our input pins to the first flop in the chain
//=============================================================================
always @(posedge clk) begin
    flop[0] <= (resetn == 1) ? input_word : 0;
end
//=============================================================================


//=============================================================================
// If there are two or more extra flops, copy each flop to the next one
//=============================================================================
if (EXTRA_FLOPS > 1) begin
    for (i=1; i<EXTRA_FLOPS; i=i+1) begin
        always @(posedge clk) begin
            flop[i] <= (resetn == 1) ? flop[i-1] : 0;
        end
    end
end
//=============================================================================


endmodule