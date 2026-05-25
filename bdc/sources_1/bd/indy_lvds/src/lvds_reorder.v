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

    This module is largely just a wrapper around 8 instantiations of the
    "lvds_bank_reorder" module.   Each of those modules reads in 256 bytes
    from each of 8 LVDS lanes, places those bytes into the correct order, and
    writes the resulting data to a FIFO, 256 bytes per lane.

    This module simply reads those 8 FIFOS and writes them to the "axis_out" output
    stream
*/

module lvds_reorder
(
    (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 clk CLK" *)
    (* X_INTERFACE_PARAMETER = "ASSOCIATED_BUSIF axis_in:axis_out, ASSOCIATED_RESET resetn" *)
    input clk,
    input resetn,

    // The input stream
    input     [511:0] axis_in_tdata,
    input             axis_in_tvalid,

    // The output stream
    output reg[511:0] axis_out_tdata,
    output reg        axis_out_tvalid
);
genvar i;

// There are 8 LVDS bank, and each bank contains 8 LVDS lanes
localparam BANK_COUNT = 8;

// This counts from 0 to 255, which allows us to read 32 records from 
// each of 8 banks
reg[7:0] counter;

// This is '1' when we are actively outputting data
reg fsm_state;

// A full row of data consists of 32 entries from each of 8 banks 
wire[2:0] bank_select = counter[7:5];

// The output FIFO from each LVDS bank
wire[  7:0]          bank_fifo_occupancy[0:BANK_COUNT-1];
wire[511:0]          bank_fifo_tdata[0:BANK_COUNT-1];
wire[BANK_COUNT-1:0] bank_fifo_tvalid;
wire[BANK_COUNT-1:0] bank_fifo_tready = (fsm_state << bank_select);

// This strobes high when a complete row has been pushed into the bank FIFOs
wire[BANK_COUNT-1:0] bank_row_complete_stb;

// When there are at least 32 entries in FIFO 0, there is an entire
// row of data in the FIFO ready to be read out
wire row_ready = (bank_fifo_occupancy[0] >= 32);

//=============================================================================
// This block fetches 32 64-byte records from each LVDS bank (in order)
// and writes them to the output stream.   After it has completed fetching
// records from the last bank, it starts over at bank 0.
//=============================================================================
always @(posedge clk) begin

    axis_out_tvalid <= 0;
    axis_out_tdata  <= 0;

    if (resetn == 0) begin
        counter   <= 0;
        fsm_state <= 0;
    end

    else case(fsm_state) 

        // Here we wait for an entire row of data to be present in the FIFOs.
        // While we are waiting for a row of data to be available to read, 
        // "counter" is always 0.
        0:  if (row_ready) fsm_state <= 1;

        // Here we output data from the FIFOs (32 64-byte records from each
        // bank) until the bank0 FIFO doesn't have a full row of data ready        
        1:  begin
                axis_out_tdata  <= bank_fifo_tdata[bank_select];
                axis_out_tvalid <= 1;
                fsm_state       <= ~(counter == 8'hFF && !row_ready);
                counter         <= counter + 1;
            end

    endcase

end
//=============================================================================




//=============================================================================
// Declare an "lvds_bank_reorder" module for each LVDS bank.  These modules
// read a sequence of 256 bytes from each of 8 LVDS lanes, place them into the
// correct order, and write 256 bytes from each lane into a 64-byte wide FIFO.
//=============================================================================
for (i=0; i<BANK_COUNT; i=i+1) begin
    lvds_bank_reorder u_lvds_bank
    (
        .clk                (clk),
        .resetn             (resetn),
        .in_data            (axis_in_tdata[i*64 +: 64]),
        .in_valid           (axis_in_tvalid),
        .fifo_out_tdata     (bank_fifo_tdata    [i]),
        .fifo_out_tvalid    (bank_fifo_tvalid   [i]),
        .fifo_out_tready    (bank_fifo_tready   [i]),
        .fifo_occupancy     (bank_fifo_occupancy[i])
    );
end
//=============================================================================

endmodule
