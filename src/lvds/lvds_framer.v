//=============================================================================
//                   ------->  Revision History  <------
//=============================================================================
//
//   Date     Who   Ver  Changes
//=============================================================================
// 20-Apr-26  DWW     1  Initial creation
//=============================================================================

/*
    This examines the LVDS input bus, looks for a start of frame
    marker, and outputs the frame
*/

module lvds_framer #
(
    parameter FRAME_HDR = 0x0FAA0FAA,
    parameter LANE_COUNT = 64
)
(
    input      clk,
    input      resetn,

    input      [8*LANE_COUNT-1:0]   lvds_in,
    output     [8*LANE_COUNT-1:0]   lvds_out,
    output reg [LANE_COUNT-1:0]     valid,

    input [5:0] lane_select,
    output[7:0] dbg_lane,
)
genvar lane;

// A frame is 4M bytes
localparam FRAME_BYTES = 32'h40_0000;

// How many data-cycles are there in a full frame?
localparam FRAME_CYCLES = FRAME_BYTES / LANE_COUNT;

// This is the outgoing LVDS bus, carved into individual lanes
reg[7:0] lvds_bus[0:LANE_COUNT-1];

// Select a lane to observer for debugging in an ILA
assign dbg_lane = lvds_bus[lane_select];

// Assemble "lvds_out" from the individual LVDS output lanes
for (lane=0; lane<LANE_COUNT; lane=lane+1) begin
    assign lvds_out[8*lane +: 8] = lvds_bus[lane]
end

// One buffer per lane.  Data from a lane will flow into
// the buffer from lvds_in, and will flow out of the buffer
// to "lvds_bus[lane]"
reg[31:0] buffer[0:LANE_COUNT-1];

// One data-cycle counter per lane
reg[31:0] cycles_left[0:LANE_COUNT-1];


//=============================================================================
// Here the data flows into the buffer
//=============================================================================
for (lane=0; lane<LANE_COUNT; lane=lane+1) begin
    always @(posedge clk) begin
        if (resetn == 0)
            buffer[lane] <= 0;
        else
            buffer[lane] <= {lvds_in[8*lane +: 8], buffer[lane][31:8]};
    end
end
//=============================================================================


//=============================================================================
// Here the data flows out of the buffer
//=============================================================================
for (lane=0; lane<LANE_COUNT; lane=lane+1) begin
    always @(posedge clk) begin

        lvds_bus[lane] <= 0;
        valid   [lane] <= 0;

        if (resetn == 0) begin
            cycles_left[lane] <= 0;
        end

        // If we just encountered a frame header...
        else if (valid[lane] == 0 && buffer[lane] == FRAME_HDR) begin
            lvds_bus   [lane] <= buffer[lane][7:0];
            valid      [lane] <= 1;
            cycles_left[lane] <= FRAME_CYCLES - 1;
        end
        
        // Otherwise, if we're inside of a valid frame
        else if (valid[lane] && cycles_left[lane]) begin
            lvds_bus     [lane] <= buffer[lane][7:0];
            valid        [lane] <= 1;
            cycle_counter[lane] <= cycle_counter[lane] - 1;
        end
    end
end
//=============================================================================


endmodule