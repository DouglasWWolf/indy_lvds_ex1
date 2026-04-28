//====================================================================================
//                        ------->  Revision History  <------
//====================================================================================
//
//   Date     Who   Ver  Changes
//====================================================================================
// 25-Apr-26  DWW     1  Initial creation
//====================================================================================

/*
    The goal of this module is to emit a frame of data (defined by a frame-
    header and a known number of clock-cycles that follow), without emitting
    anything else.   This module is not much more than an aggregator for 64
    copies of the "lvds_lane_framer" module.

    Each lane is independent: The normal case for for some lanes to begin 
    emitting frame-data before other frames.   The lanes will be synchronized
    by a downstream module.
    
    This module:

       (1) Copies each lane of incoming data into a register pipeline
       
       (2) Monitors that pipeline, looking for a 4-byte "frame header" sequence
       
       (3) When it finds a frame header, calculates the right time to "open 
           and close the output gate". (i.e., to assert/deassert "valid")
       
       (4) Any lanes that don't find a frame-header will open on the same 
           clock-cycle as the lane(s) that most recently found a frame-header

    When looking for a frame-header, not all 32-bits of the data stream are
    required to match the frame-header sequence.  The number of bits that
    must match in order to be considered a valid frame header are defined by
    the "match_bits" input port 
    

*/

module lvds_framer #
(
    parameter LANE_COUNT   = 64,
    parameter PIPE_LEN     = 12,
    parameter FRAME_BYTES  = 32'h40_0000
)
(
    input clk,
    input resetn,

    // What frame header bytes are we looking for?
    input   [31:0] frame_header,
    
    // How many bits of the frame header must match?
    input   [ 5:0] match_bits,

    // LVDS data flows in here
    input   [8*LANE_COUNT-1:0] lvds_in,
    
    // Framed LVDS data flows out here
    output  [8*LANE_COUNT-1:0] lvds_out,
    output  [  LANE_COUNT-1:0] valid,

    // This stream reports lanes that did not detect a header.  Software uses
    // this to create a report so we can characterize how often this happens.
    output  [63:0] missing_hdr_tdata,
    output  [31:0] missing_hdr_tuser,
    output         missing_hdr_tvalid,
    input          missing_hdr_tready,

    // We count the number of frames that exhibit missing frame headers
    output reg[31:0] framing_errors
);

genvar lane; 
integer i;

// Spread across our LVDS lanes, how many cycles are in a full frame?
localparam FRAME_CYCLES = FRAME_BYTES / LANE_COUNT;

// This must be big enough that we never have to worry about it rolling over
// in the course of a 24 hour run.  At 192 Mhz, a 48 bit timer rolls over
// every 16 days or so
localparam TIMER_BITS = 48;

// A free-running timer
reg[TIMER_BITS-1:0] timer;

// One bit for each lane, tells us if the lane has detected a frame header
wire[LANE_COUNT-1:0] header_detected;

// A bitmap of which lanes had to be forced open
wire[LANE_COUNT-1:0] forced = valid & ~header_detected;

// This is asserted if at least one lane didn't find a frame header
wire framing_error = |forced;

// A count of how many lanes have their "header_detected" bit on
reg[5:0] header_detected_cnt, prior_header_detected_cnt;

// Keep track of whether all lanes are valid
wire all_lanes_valid = &valid;

// Keep track of whether all lanes were valid on the previous clock-cycle
reg  prior_all_lanes_valid;

// A high going edge here happens once per frame
wire new_frame_stb = all_lanes_valid & !prior_all_lanes_valid;

// We count frames so we can report a frame number in the error stream
reg[31:0] frame_number;

//=============================================================================
// Here we keep track of how many lanes have detected headers
//=============================================================================
always @* begin
    header_detected_cnt = 0;
    for (i=0; i<LANE_COUNT; i=i+1) begin
        header_detected_cnt = header_detected_cnt + header_detected[i];
    end
end

// Keep track of when new headers are detected
wire new_headers_detected = header_detected_cnt > prior_header_detected_cnt;
//=============================================================================


//=============================================================================
// Logic that needs to happen on every clock cycle
//=============================================================================
always @(posedge clk) begin

    if (resetn == 0) begin
        prior_header_detected_cnt <= 0;
        prior_all_lanes_valid     <= 0;
        timer                     <= 0;
        framing_errors            <= 0;
        frame_number              <= 1;
    end

    else begin

        // Always need to know "header_detected_cnt" for two consecutive cycles
        prior_header_detected_cnt <= header_detected_cnt;

        // Always need to know "all_lanes_valid" for two consecutive cycles
        prior_all_lanes_valid <= all_lanes_valid;

        // Advance the free-running timer
        timer <= timer +1;

        // Once for each new frame, increment frame_number and track
        // the number of frames that had framing errors
        if (new_frame_stb) begin
            frame_number   <= frame_number + 1;
            framing_errors <= framing_errors + framing_error;
        end

    end
end
//=============================================================================



//=============================================================================
// One lvds_lane_framer per lane.
//=============================================================================
for (lane=0; lane<LANE_COUNT; lane=lane+1) begin

    lvds_lane_framer #
    (
        .TIMER_BITS          (TIMER_BITS),
        .PIPE_LEN            (PIPE_LEN),
        .FRAME_CYCLES        (FRAME_CYCLES)
    )
    u_lane_framer
    (
        .clk                 (clk),                     // In
        .resetn              (resetn),                  // In
        .frame_header        (frame_header),            // In
        .match_bits          (match_bits),              // In
        .timer               (timer),                   // In
        .new_headers_detected(new_headers_detected),    // In
        .data_in             (lvds_in [8*lane +: 8]),   // In
        .data_out            (lvds_out[8*lane +: 8]),   // Out
        .valid               (valid[lane]),             // Out
        .header_detected     (header_detected[lane])    // Out
    );
end
//=============================================================================


//=============================================================================
// This FIFO records "missing frame header" errors.   TDATA holds a 32-bit 
// frame number and TUSER holds a 64-bit bitmap of which lanes failed to 
// detect a frame header
//=============================================================================
xpm_fifo_axis #
(
    .CLOCKING_MODE      ("common_clock"),
    .PACKET_FIFO        ("false"),
    .FIFO_DEPTH         (32),
    .TDATA_WIDTH        (32),
    .TUSER_WIDTH        (LANE_COUNT),
    .FIFO_MEMORY_TYPE   ("auto"),
    .USE_ADV_FEATURES   ("0000")
)
missing_hdr_err_fifo
(
    // Clock and reset
   .s_aclk          (clk   ),
   .m_aclk          (clk   ),
   .s_aresetn       (resetn),

    // The input bus to the FIFO
   .s_axis_tdata    (frame_number),
   .s_axis_tuser    (forced),
   .s_axis_tvalid   (new_frame_stb & framing_error),
   .s_axis_tready   (),

    // The output bus of the FIFO
   .m_axis_tdata    (missing_hdr_tdata ),
   .m_axis_tuser    (missing_hdr_tuser ),
   .m_axis_tvalid   (missing_hdr_tvalid),
   .m_axis_tready   (missing_hdr_tready),

    // Unused input stream signals
   .s_axis_tkeep(),
   .s_axis_tlast(),
   .s_axis_tdest(),
   .s_axis_tid  (),
   .s_axis_tstrb(),

    // Unused output stream signals
   .m_axis_tkeep(),
   .m_axis_tlast(),
   .m_axis_tdest(),
   .m_axis_tid  (),
   .m_axis_tstrb(),

    // Other unused signals
   .almost_empty_axis(),
   .almost_full_axis(),
   .dbiterr_axis(),
   .prog_empty_axis(),
   .prog_full_axis(),
   .rd_data_count_axis(),
   .sbiterr_axis(),
   .wr_data_count_axis(),
   .injectdbiterr_axis(),
   .injectsbiterr_axis()
);
//=============================================================================



endmodule
