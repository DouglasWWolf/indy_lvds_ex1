//=============================================================================
//                   ------->  Revision History  <------
//=============================================================================
//
//   Date     Who   Ver  Changes
//=============================================================================
// 15-Apr-26  DWW     1  Initial creation
//=============================================================================

/*
    This module checks the incoming LVDS lanes to see if they
    conform to an 8-bit wide PRBS-15 byte sequence
*/

module lvds_prbs15_check # (parameter LANE_COUNT = 64)
(
    input                       clk,
    input [LANE_COUNT*8-1:0]    lvds_bus,
    input                       clear_errors,
    output reg[LANE_COUNT-1:0]  prbs_err
);

genvar lane;

// The individual LVDS lanes
wire[7:0] data[0:LANE_COUNT-1];

// Linear feedback shift-register, one per lane
reg[14:0] lfsr[0:LANE_COUNT-1];

//-----------------------------------------------------------------------------
// Carve the incoming lvds_bus into individual lanes
//-----------------------------------------------------------------------------
for (lane=0; lane<LANE_COUNT; lane=lane+1) begin
    assign data[lane] = lvds_bus[8*lane +: 8];
end
//-----------------------------------------------------------------------------


//=============================================================================
// If you feed this a byte in the PRBS15 sequence, it predicts what the next
// byte will be.   This is a pipeline, so the first time you feed it a byte,
// the predicted next value will be wrong.   You must feed it two correct bytes
// in a row for the prediction of the next byte to be correct
//
// data[lane]      : the current input value
// lfsr[lane][7:0] : predicts the next input value
//=============================================================================
for (lane=0; lane<LANE_COUNT; lane=lane+1) begin
    always @(posedge clk) begin
        prbs_err[lane] <= clear_errors ? 0 : data[lane] != lfsr[lane][7:0];

        lfsr[lane] <= {
                        data[lane][   7],                      // 1 bit
                        data[lane][ 7:1] ^ data[lane][6:0],    // 7 bits
                        data[lane][   0] ^ lfsr[lane][ 14],    // 1 bit
                        lfsr[lane][13:8]                       // 6 bits
                      };
    end
end
//=============================================================================

endmodule