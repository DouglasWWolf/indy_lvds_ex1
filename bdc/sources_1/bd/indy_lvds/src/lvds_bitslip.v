//=============================================================================
//                   ------->  Revision History  <------
//=============================================================================
//
//   Date     Who   Ver  Changes
//=============================================================================
// 15-Apr-26  DWW     1  Initial creation
//=============================================================================

/*
    Bit-slips the LVDS bus.   

    The idea behind bitslip is that incoming bits may not be properly divided
    into 8-bit bytes.  Consider data that arrives in a continuous pattern like
    this:

    ...10011110 10100101 10011110 10100101 10011110 10100101 
       <------> <------> <------> <------> <------> <------>  
         Byte5    Byte4    Byte3    Byte2    Byte1    Byte0    

    Bit slipping the original stream of bits by 1 bit would yield:

    ....1001111 01010010 11001111 01010010 11001111 01010010 
       <------> <------> <------> <------> <------> <------>  
         Byte5    Byte4    Byte3    Byte2    Byte1    Byte0    

    Bit slipping the original stream of bits by 2 bits would yield:

    .....100111 10101001 01100111 10101001 01100111 10101001 
       <------> <------> <------> <------> <------> <------>  
         Byte5    Byte4    Byte3    Byte2    Byte1    Byte0    

    Bit slipping the original stream of bits by 3 bits would yield:

    ......10011 11010100 10110011 11010100 10110011 11010100 
       <------> <------> <------> <------> <------> <------>  
         Byte5    Byte4    Byte3    Byte2    Byte1    Byte0    

         (etc)

*/

module lvds_bitslip # (parameter LANE_COUNT = 64)
(
    input           clk,
    input           resetn,

    // The input bus
    input [LANE_COUNT*8-1:0] input_bus,
    
    // The bit-slipped output bus
    output[LANE_COUNT*8-1:0] lvds_bus,

    input [ 5:0]   lane_select,
    input [63:0]   cal_mask,
    input [11:0]   cal_word,
    input          cal_word_wstb,

    // Read back the selected lane's bitslip value
    output[ 2:0]   bitslip_rd,

    // The output stream from the selected LVDS lane
    output[7:0] dbg_lvds_lane
);

genvar lane;

// The new bitslip value is in the top 3 bits of the calibration word
wire[2:0] new_bitslip = cal_word[11:9];

// There is one bitslip-setting per lane
reg[2:0] bitslip [0:LANE_COUNT-1];

// There is one shift register per lane
reg[15:0] shiftreg[0:LANE_COUNT-1];

// One input and output value per lane
wire[7:0] input_lane [0:LANE_COUNT-1];
reg [7:0] output_lane[0:LANE_COUNT-1];

// Report the selected lane's bitslip value
assign bitslip_rd = bitslip[lane_select];

// This allows us to see the selected output lane in an ILA
assign dbg_lvds_lane = output_lane[lane_select];

//-----------------------------------------------------------------------------
// Divide the input bus into lanes
//-----------------------------------------------------------------------------
for (lane=0; lane<LANE_COUNT; lane=lane+1) begin
    assign input_lane[lane] = input_bus[lane*8 +: 8];
end
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
// Assemble the output LVDS bus from the output lanes
//-----------------------------------------------------------------------------
for (lane=0; lane<LANE_COUNT; lane=lane+1) begin
    assign lvds_bus[8*lane +: 8] = output_lane[lane];
end
//-----------------------------------------------------------------------------


//=============================================================================
// Update the per-lane bitslip values when cal_word_wstb fires
//=============================================================================
for (lane=0; lane<LANE_COUNT; lane=lane+1) begin
    always @(posedge clk) begin
        if (resetn == 0)
            bitslip[lane] <= 0;
        else if (cal_word_wstb & cal_mask[lane])
            bitslip[lane] <= new_bitslip;
    end
end
//=============================================================================



//=============================================================================
// Perform the bitslip for each lane
//
// New data enters a shift-register from the left, and leaves from the right
//
// If the bitslip is 0, the output byte is shiftreg[7:0]
// If the bitslip is 1, the output byte is shiftreg[8:1]
// If the bitslip is 2, the output byte is shiftreg[9:2] (etc)
//=============================================================================
for (lane=0; lane<LANE_COUNT; lane=lane+1) begin
    always @(posedge clk) begin
        if (resetn == 0) begin
            shiftreg   [lane] <= 0;
            output_lane[lane] <= 0;
        end

        else begin
            output_lane[lane] <= shiftreg[lane][bitslip[lane] +: 8];
            shiftreg   [lane] <= {input_lane[lane], shiftreg[lane][15:8]};
        end
    end
end
//=============================================================================



endmodule