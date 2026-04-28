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
    anything else.   This module handles a single lane. 
   
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

module lvds_lane_framer #
(
    parameter PIPE_LEN     = 0,
    parameter TIMER_BITS   = 0,
    parameter FRAME_CYCLES = 0
)
(
    input   clk,
    input   resetn,
   
    // What frame header bytes are we looking for?
    input   [31:0] frame_header,
    
    // How many bits of the frame header must match?
    input   [ 5:0] match_bits,

    // A free-running timer
    input[TIMER_BITS-1:0] timer,

    // Incoming LVDS data arrives here
    input[7:0] data_in,

    // This is asserted whenever new lanes have detected frame headers
    input new_headers_detected,

    // Outgoing LVDS data is emitted here
    output [7:0] data_out,
    output       valid,
    output reg   header_detected
);
genvar i;
integer n;

// The header is 4 bytes long
localparam HEADER_LEN = 4;

// Data flows into the pipeline from port data_in,
// and flows out of this pipeline on port data_out
reg[7:0] pipeline[0:PIPE_LEN-1];

// This is the most recent 32-bits in the pipeline.  It is an intentional
// design decision to begin "most_recent" with "pipeline[0]" instead of
// "data_in".  By not examining any incoming data until it has been 
// registered, we ease timing closure.
wire[31:0] most_recent = {pipeline[0], pipeline[1], pipeline[2], pipeline[3]};

// The value of timer when the output gate should open/close
reg[TIMER_BITS-1:0] gate_open_time, gate_close_time;

// This is a "1" if the "gate_open_time" has been set
reg open_timer_set;

// Is the output gate open?
assign valid = (open_timer_set) & (timer >= gate_open_time)
                                & (timer <  gate_close_time);

// This strobes high when the gate closes
wire frame_complete_stb = (open_timer_set && timer == gate_close_time);

// Our LVDS output is the last element in the pipeline
assign data_out = (valid) ? pipeline[PIPE_LEN-1] : 0;

//=============================================================================
// This block compares the four most recently rcvd bytes to frame_header, and
// sets "header_match" to 1 if at least "match_bits" bits match.
//=============================================================================
reg [31:0] match_delta;
reg [ 5:0] match_count;
reg        header_match;
always @* begin
    match_delta = most_recent ^ frame_header;
    match_count = 32;
    for (n=0; n<32; n=n+1) match_count = match_count - match_delta[n];
    header_match = (match_count >= match_bits);
end
//=============================================================================


//=============================================================================
// Turn the crank! On every cycle, data flows in from data_in
//=============================================================================
always @(posedge clk) begin
    pipeline[0] <= (resetn) ? data_in : 0;
end
//=============================================================================


//=============================================================================
// Turn the crank!  On every cycle, every item in the pipeline advances one
// position through the pipe.
//=============================================================================
for (i=1; i<PIPE_LEN; i=i+1) begin
    always @(posedge clk) begin
        pipeline[i] <= (resetn) ? pipeline[i-1] : 0;
    end
end
//=============================================================================


//=============================================================================
// Here we perform frame header detection and determine when the output
// gate will open and close
//=============================================================================
always @(posedge clk) begin

    // If we're in reset, or if we have just finished a frame...
    if (resetn == 0 || frame_complete_stb) begin
        open_timer_set  <= 0;
        header_detected <= 0;
    end

    // If we haven't encountered a frame header, and the gate isn't yet open...
    else if (!header_detected & !valid) begin
        
        // If we've just discovered a frame header, set the open timer
        if (header_match) begin
            header_detected <= 1;
            gate_open_time  <= timer + (PIPE_LEN - HEADER_LEN);
            gate_close_time <= timer + (PIPE_LEN - HEADER_LEN) + FRAME_CYCLES;            
            open_timer_set  <= 1;
        end
        
        // Otherwise, if one or more new lanes have detected a header, 
        // this lane will open when those lanes do
        else if (new_headers_detected) begin
            gate_open_time  <= timer + (PIPE_LEN - HEADER_LEN) - 1;
            gate_close_time <= timer + (PIPE_LEN - HEADER_LEN) - 1 + FRAME_CYCLES;                        
            open_timer_set  <= 1;
        end

    end

end
//=============================================================================


endmodule