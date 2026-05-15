//====================================================================================
//                        ------->  Revision History  <------
//====================================================================================
//
//   Date     Who   Ver  Changes
//====================================================================================
// 12-May-26  DWW     1  Initial creation
//====================================================================================

/*
    Reads the LVDS input stream (in which the data is in the order that
    is output by the sensor-chip), and reorders it into cell order on the output 
    stream.

    This module is largely just a wrapper around 64 instantiations of the
    "lvds_lane_reorder" module.   Each of those modules reads in 256 bytes
    from its LVDS lane, places those bytes into the correct order, and 
    exposes that reordered buffer to this module

    This module simply reads those  256 byte "reordered" buffers from each 
    lane and and writes them to the "axis_out" output stream as four 64-byte
    chunks
*/


module lvds_reorder # (parameter LANE_COUNT = 64)
(

    (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 clk CLK" *)
    (* X_INTERFACE_PARAMETER = "ASSOCIATED_BUSIF axis_in:axis_out, ASSOCIATED_RESET resetn" *)
    input clk,
    input resetn,

    // The input stream
    input[LANE_COUNT*8-1:0] axis_in_tdata,
    input                   axis_in_tvalid,

    // The output stream
    output reg[511:0] axis_out_tdata,
    output reg        axis_out_tvalid
);
genvar i;

// These are from the "lvds_lane_reorder" modules, one per LVDS lane
wire[     256*8-1:0] reordered[0:LANE_COUNT-1];
wire[LANE_COUNT-1:0] reordered_valid_stb;

// A counter wide enough to count from 0 to LANE_COUNT*4 - 1. This
// will enable us to read 4 data-cycles from each lane.
reg[$clog2(LANE_COUNT)+1:0] counter;

// Extract the LVDS lane number from the counter
wire[5:0] lane_select = counter[$clog2(LANE_COUNT)+1:2];

//=============================================================================
// This block fetches four 64-byte data records from each LVDS lane (in order)
// and writes them to the output stream.   After it has completed fetching
// records from the last lane, it starts over at lane 0
//=============================================================================
always @(posedge clk) begin
    
    axis_out_tvalid <= 0;
    axis_out_tdata  <= 0;
    
    if (resetn == 0)
        counter <= 0;

    else if (reordered_valid_stb[0] || counter) begin
        case(counter[1:0])
            0:  axis_out_tdata <= reordered[lane_select][0*512 +: 512];
            1:  axis_out_tdata <= reordered[lane_select][1*512 +: 512];
            2:  axis_out_tdata <= reordered[lane_select][2*512 +: 512];
            3:  axis_out_tdata <= reordered[lane_select][3*512 +: 512];                
        endcase
        axis_out_tvalid <= 1;
        counter         <= counter + 1;
    end

end
//=============================================================================



//=============================================================================
// Declare an "lvds_lane_reorder" module for each LVDS lane.  These modules
// read a sequence of 256 bytes from an LVDS lane and place those bytes
// into a 256 byte buffer in the correct order.  
//=============================================================================
for (i=0; i<LANE_COUNT; i=i+1) begin
    lvds_lane_reorder u_lane
    (
        .clk                (clk),
        .resetn             (resetn),
        .in_data            (axis_in_tdata[i*8 +: 8]),
        .in_valid           (axis_in_tvalid),
        .reordered          (reordered[i]),
        .reordered_valid_stb(reordered_valid_stb[i])
    );
end
//=============================================================================

endmodule
