//====================================================================================
//                        ------->  Revision History  <------
//====================================================================================
//
//   Date     Who   Ver  Changes
//====================================================================================
// 25-Apr-26  DWW     1  Initial creation
//====================================================================================

/*

    A block that synchronizes 64 individual input streams into a unified, 
    64-byte wide output stream.

    Presume for a moment there were only 4 lanes.   That incoming data might 
    look like this: (* = "valid" is not asserted on the incoming stream)

            0x0F   *     *     *
            0xAA  0x0F   *    0x0F
            0x0F  0xAA  0x0F  0xAA
            0xAA  0x0F  0xAA  0x0F
            0x01  0xAA  0x0F  0xAA
            0x02  0x01  0xAA  0x01 
            0x03  0x02  0x01  0x02
            0x04  0x03  0x02  0x03
              .   0x04  0x03  0x04
              .    .    0x04   .
              .    .     .     .


   We want all the incoming lanes synchronized at the output, so they look like:

             *     *     *     *
             *     *     *     *
            0x0F  0x0F  0x0F  0x0F
            0xAA  0xAA  0xAA  0xAA
            0x0F  0x0F  0x0F  0x0F
            0xAA  0xAA  0xAA  0xAA
            0x01  0x01  0x01  0x01
            0x02  0x02  0x02  0x02
            0x03  0x03  0x03  0x03
            0x04  0x04  0x04  0x04
             .     .     .     .
             .     .     .     .
             .     .     .     .
   
*/

module lvds_lane_sync # (parameter LANE_COUNT = 64)
(
    input clk,
    input resetn,

    input[8*LANE_COUNT-1:0] lvds_in,
    input[  LANE_COUNT-1:0] in_valid,

    output[8*LANE_COUNT-1:0] axis_out_tdata,
    output                   axis_out_tvalid,

    output                   overflow
);
genvar lane;

// One ready signal per lane, from lvds_lane_fifo
wire[LANE_COUNT-1:0] in_ready;

// One valid signal per lane, from lvds_lane_fifo
wire[LANE_COUNT-1:0] out_valid;

// This strobes high on any cycle where any lane was too full to accept
// incoming data
assign overflow = |(in_valid & ~in_ready);

// We won't output data until every lane is ready to output data
wire out_ready = &out_valid;

// Our output stream isn't valid until every lane is ready to output data
assign axis_out_tvalid = &out_valid;

//=============================================================================
// One FIFO per lane.   We don't allow data to flow out of per-lane 
// FIFOs until all lanes have data to send
//=============================================================================
for (lane=0; lane<LANE_COUNT; lane=lane+1) begin
    lvds_lane_fifo #
    (
        .WIDTH(8), .DEPTH(8)
    )
    u_lvds_fifo
    (
        .clk        (clk),                              // In
        .resetn     (resetn),                           // In

        .data_in    (lvds_in       [8*lane +: 8]),      // In
        .data_out   (axis_out_tdata[8*lane +: 8]),      // Out

        .in_valid   (in_valid[lane]),                   // In
        .in_ready   (in_ready[lane]),                   // Out

        .out_valid  (out_valid[lane]),                  // Out
        .out_ready  (out_ready)                         // In
    );
end
//=============================================================================

endmodule