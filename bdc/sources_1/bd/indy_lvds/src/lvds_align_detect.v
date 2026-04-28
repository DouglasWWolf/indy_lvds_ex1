//=============================================================================
//                   ------->  Revision History  <------
//=============================================================================
//
//   Date     Who   Ver  Changes
//=============================================================================
// 15-Apr-26  DWW     1  Initial creation
//=============================================================================

/*
    LVDS alignment detector
*/

module lvds_align_detect # (parameter LANE_COUNT = 64)
(
    input           clk,

    // The input bus
    input [LANE_COUNT*8-1:0] lvds_bus,

    // Alignment error bits, 1 per lane
    output reg [LANE_COUNT-1:0] align_err,

    // When high, clears all align_err bits
    input clear_errors
);

genvar lane;

// We're looking for a pattern that alternates between these two bytes
wire[7:0] pattern[0:1];
assign pattern[0] = 8'hF0;
assign pattern[1] = 8'h55;

// The LVDS lanes, broken out into an array
wire[7:0] data[0:LANE_COUNT-1];

// Break out the input LVDS bus into individual lanes
for (lane=0; lane<LANE_COUNT; lane=lane+1) begin
    assign data[lane] = lvds_bus[8*lane +: 8];
end

// One flag per lane: is this lane aligned yet?
reg[LANE_COUNT-1:0] aligned;

// One flag per lane: which pattern do we expect?
reg[LANE_COUNT-1:0] expected;


//=============================================================================
// Here we check the current "data[lane]" to see whether or not it's the
// expected pattern byte.    If it's not, we assert "align_err[lane]"
//=============================================================================
for (lane=0; lane<LANE_COUNT; lane=lane+1) begin
    always @(posedge clk) begin

        // If we are currently aligned, check to see if
        // the current lane data is the expected pattern byte
        if (aligned[lane]) begin
            if (data[lane] == pattern[expected[lane]])
                expected[lane] <= ~expected[lane];
            else begin
                aligned  [lane] <= 0;
                align_err[lane] <= 1;
            end
        end

        // If we're looking for alignment and found pattern[0]...
        else if (data[lane] == pattern[0]) begin
            aligned [lane] <= 1;
            expected[lane] <= 1;
        end

        // If we're looking for alignment and found pattern[1]...
        else if (data[lane] == pattern[1]) begin
            aligned [lane] <= 1;
            expected[lane] <= 0;
        end

        // Otherwise, we're looking for alignment and found neither
        // pattern byte
        else begin
            align_err[lane] <= 1;
        end

        // If we're supposed to clear alignment errors, do so
        if (clear_errors) align_err[lane] <= 0;

    end
end
//=============================================================================

endmodule