//====================================================================================
//                        ------->  Revision History  <------
//====================================================================================
//
//   Date     Who   Ver  Changes
//====================================================================================
// 12-May-26  DWW     1  Initial creation
//====================================================================================

/*
    This module manages the 8 LVDS lanes that are associated with a sensor-chip
    "Bank1M".
        
    256 bytes flow in from each lane and are re-ordered by storing them into an SDP
    RAM.  The read-side of the SDP RAM for each lane is 8-bytes wide.

    From the SDP RAM of each lane, we read 32 words (each word is 8-bytes wide) and 
    write them into the FIFO as four 64-byte records, like this:

        Lane 0: read 32 8-byte words from SDP RAM and write four 64-byte records to the FIFO
        Lane 1: read 32 8-byte words from SDP RAM and write four 64-byte records to the FIFO
        Lane 2: read 32 8-byte words from SDP RAM and write four 64-byte records to the FIFO
        Lane 3: read 32 8-byte words from SDP RAM and write four 64-byte records to the FIFO
        Lane 4: read 32 8-byte words from SDP RAM and write four 64-byte records to the FIFO
        Lane 5: read 32 8-byte words from SDP RAM and write four 64-byte records to the FIFO
        Lane 6: read 32 8-byte words from SDP RAM and write four 64-byte records to the FIFO
        Lane 7: read 32 8-byte words from SDP RAM and write four 64-byte records to the FIFO

*/

module lvds_bank_reorder # (parameter LANE_COUNT = 8)
(
    input clk,
    input resetn,

    // Input stream is 8 LVDS lanes wide
    input[LANE_COUNT*8-1:0] in_data,
    input                   in_valid,

    // Output stream, fed by a FIFO
    output[511:0]           fifo_out_tdata,
    output                  fifo_out_tvalid,
    input                   fifo_out_tready,

    // Tells how many 64-byte records are in the output FIFO
    output reg[7:0]         fifo_occupancy
); 

genvar i;

// A counter that counts from 0 to 4095, then rolls over to 0.  
// Since a row is 256 bytes, this can count through 16 full rows
reg[11:0] wr_counter;

// Here we map the bottom 8 bits of "wr_counter" into a RAM address.
// The top 4 bits (i.e., "wr_counter[11:8]") tell us which 256 byte "chunk"
// of RAM we're writing to.
//
// The bottom 8 bits of wr_counter are "out of order" because that is the
// order that the sensor-chip sends cell data
wire[11:0] addra = {wr_counter[11:8], wr_counter[4:0], wr_counter[7:5]};

// A row for a given LVDS lane is 256 bytes of data.  We can think of that as:
//        (1) 256 bytes
// --or-- (2)  32 8-byte words
// --or-- (3)   4 64-byte records
reg[3:0] rows_in, rows_out;

// Output from the SDP RAM, one per LVDS lane
wire[63:0] doutb[0:LANE_COUNT-1];

// The input to our FIFO
wire[511:0] fifo_in_tdata;
reg         fifo_in_tvalid;
wire        fifo_in_tready;

// A 64-byte buffer, arranged as eight 8-byte words.  
// Writing values to tdata[] writes to fifo_in_tdata
reg[63:0] tdata[0:7];
for (i=0; i<8; i=i+1) begin
    assign fifo_in_tdata[i*64 +: 64] = tdata[i];
end

//=============================================================================
// Here we keep track of how many words of data are in the output FIFO
//=============================================================================
wire fifo_data_in  = fifo_in_tvalid  & fifo_in_tready;
wire fifo_data_out = fifo_out_tvalid & fifo_out_tready;
//----------------------------------------------------------------------------
always @(posedge clk) begin
    if (resetn == 0)
        fifo_occupancy <= 0;
    else
        fifo_occupancy <= fifo_occupancy + fifo_data_in - fifo_data_out;
end
//=============================================================================


//=============================================================================
// We count arriving bytes.  "addra" (the RAM address where the input byte will
// be stored) is derived from this wr_counter
//=============================================================================
always @(posedge clk) begin

    if (resetn == 0) begin
        rows_in    <= 0;
        wr_counter <= 0;
    end

    else if (in_valid)  begin
        rows_in    <= rows_in + (wr_counter[7:0] == 8'hFF);
        wr_counter <= wr_counter + 1;
    end
end
//=============================================================================

//=============================================================================
// This simple state machine reads every address on port B of the SDP RAM.
//=============================================================================
reg        rasm_state;
reg [11:0] ar_counter;
wire[ 8:0] addrb = {ar_counter[11:8], ar_counter[4:0]};
//-----------------------------------------------------------------------------
always @(posedge clk) begin

    if (resetn == 0) begin
        rows_out   <= 0;
        ar_counter <= 0;
        rasm_state <= 0;
    end

    else case (rasm_state)

        // While we're waiting for a new row of data to arrive, we are always
        // in state 0, and the lower 8 bits of ar_counter are 8'b0000_0000
        0:  if (rows_in != rows_out) begin
                ar_counter <= ar_counter + 1;
                rasm_state <= 1;
            end

        // For a row of data across all 8 lanes, the lower 8 bits of ar_counter
        // are always 8'b1111_1111 on the last word of the last lane.  Each
        // word is 8-bytes wide.
        1:  begin
                if (ar_counter[7:0] == 8'hFF) begin
                    rows_out   <= rows_out + 1;
                    rasm_state <= 0;
                end
                ar_counter <= ar_counter + 1;
            end

    endcase

end
//=============================================================================


//=============================================================================
// Here we determine when "doutb" is presenting valid data from the SDP RAM
//=============================================================================
reg doutb_valid;
//-----------------------------------------------------------------------------
always @(posedge clk) begin
    doutb_valid <= (rows_in != rows_out) & (resetn == 1);
end
//=============================================================================


//=============================================================================
// Here we read data from the SDP RAMs and write it to the FIFO.   We read
// 32 words from doutb[0], then 32 words from doutb[1], then 32 words from 
// doutb[3], etc.
//
// We strobe fifo_in_tvalid high on every 8th word, writing 64-bytes at a time
// into the output FIFO
//=============================================================================
reg [7:0] rd_counter;
wire[2:0] tdata_idx = rd_counter[2:0];
wire[2:0] lane_idx  = rd_counter[7:5];
//-----------------------------------------------------------------------------
always @(posedge clk) begin

    fifo_in_tvalid <= 0;

    if (resetn == 0)
        rd_counter <= 0;

    else if (doutb_valid) begin
        tdata[tdata_idx] <= doutb[lane_idx];
        fifo_in_tvalid   <= (tdata_idx == 3'b111);
        rd_counter       <= rd_counter + 1;
    end
end
//=============================================================================



//=============================================================================
// These are each a wrapper around a single RAMB36E2 (on Ultrascale+) or a 
// single RAMB36E5 (on Versal), each being used as a simple dual-port RAM.
//
// On the write-side, each BRAM is organized as 1 byte wide x 4096 deep
// On the read-side,  each BRAM is organized as 8 bytes wide x 512 deep
//=============================================================================

for (i=0; i<LANE_COUNT; i=i+1) begin
    xpm_memory_sdpram #
    (
       .MEMORY_SIZE(32 * 1024),         // 32Kbit, 4KB
       .ADDR_WIDTH_A(12),               // 12 bits, addra = 0 thru 4095
       .WRITE_DATA_WIDTH_A(8),          // We write 8 bits (1 byte)  at a time
       .BYTE_WRITE_WIDTH_A(8),          // We write 1 byte at a time
       .ADDR_WIDTH_B(9),                // 9 bits, addrb = 0 thru 511
       .READ_DATA_WIDTH_B(64),          // We read 64 bits (8 bytes) at a time

       .IGNORE_INIT_SYNTH(1),           // DECIMAL
       .MEMORY_INIT_FILE("none"),       // String
       .MEMORY_INIT_PARAM("0"),         // String
       .MEMORY_PRIMITIVE("auto"),       // String
       .MESSAGE_CONTROL(0),             // DECIMAL
       .RAM_DECOMP("auto"),             // String
       .READ_LATENCY_B(1),              // DECIMAL
       .READ_RESET_VALUE_B("0"),        // String
       .RST_MODE_A("SYNC"),             // String
       .RST_MODE_B("SYNC"),             // String
       .USE_EMBEDDED_CONSTRAINT(0),     // DECIMAL
       .USE_MEM_INIT(0),                // DECIMAL
       .WRITE_PROTECT(1)                // DECIMAL
    )
    i_sdp_ram
    (
        .clka   (clk),                  // Clock, Port A
        .ena    (1),                    // Enable, Port A
        .addra  (addra),                // Address, Port A               
        .dina   (in_data[i*8 +: 8]),    // Data-in, Port A         
        .wea    (in_valid),             // Write-Enable, Port A

        .clkb   (clk),                  // Clock, Port B
        .enb    (1),                    // Enable, Port B
        .addrb  (addrb),                // Address, Port B
        .doutb  (doutb[i]),             // Data-out, Port B
        .regceb (1),                    // Clock enable for last register on Port B path
        .rstb   (~resetn),              // Reset for last register on Port B path    

        .sleep(0),
        .dbiterrb(),      
        .sbiterrb(),  
        .injectdbiterra(), 
        .injectsbiterra()           
    );
end
//=============================================================================


//=============================================================================
// This holds our output data stream
//=============================================================================
xpm_fifo_axis #
(
   .TDATA_WIDTH     (512),
   .FIFO_DEPTH      (256),  /* This is much deeper than we will ever fill */
   .FIFO_MEMORY_TYPE("auto"),
   .PACKET_FIFO     ("false"),
   .USE_ADV_FEATURES("0000"),
   .CDC_SYNC_STAGES (2),
   .CLOCKING_MODE   ("common_clock")
)
i_bank_fifo
(
    // Clock and reset
   .s_aclk   (clk   ),
   .m_aclk   (clk   ),
   .s_aresetn(resetn),

    // The input bus of the FIFO
   .s_axis_tdata (fifo_in_tdata),
   .s_axis_tvalid(fifo_in_tvalid),
   .s_axis_tready(fifo_in_tready),

    // The output bus of the FIFO
   .m_axis_tdata (fifo_out_tdata),
   .m_axis_tvalid(fifo_out_tvalid),
   .m_axis_tready(fifo_out_tready),

    // Unused input stream signals
   .s_axis_tkeep(),
   .s_axis_tlast(),
   .s_axis_tdest(),
   .s_axis_tid  (),
   .s_axis_tstrb(),
   .s_axis_tuser(),

    // Unused output stream signals
   .m_axis_tdest(),
   .m_axis_tid  (),
   .m_axis_tstrb(),
   .m_axis_tuser(),
   .m_axis_tkeep(),
   .m_axis_tlast(),

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