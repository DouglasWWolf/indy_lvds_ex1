//====================================================================================
//                        ------->  Revision History  <------
//====================================================================================
//
//   Date     Who   Ver  Changes
//====================================================================================
// 08-Apr-26  DWW     1  Initial creation
//====================================================================================

/*
     Provides status and control registers for analyzing the sensor-chip's
     "pa_sync" by building a histogram its period
*/


module count_ctl # (parameter AW=12)
(
    input clk, resetn,

    input pa_sync_raw,

    //================== This is an AXI4-Lite slave interface ==================
        
    // "Specify write address"              -- Master --    -- Slave --
    input[AW-1:0]                           S_AXI_AWADDR,   
    input                                   S_AXI_AWVALID,  
    input[   2:0]                           S_AXI_AWPROT,
    output                                                  S_AXI_AWREADY,


    // "Write Data"                         -- Master --    -- Slave --
    input[31:0]                             S_AXI_WDATA,      
    input                                   S_AXI_WVALID,
    input[ 3:0]                             S_AXI_WSTRB,
    output                                                  S_AXI_WREADY,

    // "Send Write Response"                -- Master --    -- Slave --
    output[1:0]                                             S_AXI_BRESP,
    output                                                  S_AXI_BVALID,
    input                                   S_AXI_BREADY,

    // "Specify read address"               -- Master --    -- Slave --
    input[AW-1:0]                           S_AXI_ARADDR,     
    input[   2:0]                           S_AXI_ARPROT,     
    input                                   S_AXI_ARVALID,
    output                                                  S_AXI_ARREADY,

    // "Read data back to master"           -- Master --    -- Slave --
    output[31:0]                                            S_AXI_RDATA,
    output                                                  S_AXI_RVALID,
    output[ 1:0]                                            S_AXI_RRESP,
    input                                   S_AXI_RREADY
    //==========================================================================
);  
genvar i;

// pa_sync_raw synchronized to our clock
wire pa_sync;

// When this is asserted, our histogram values are reset to 0
reg reset_histogram;

// One counter for each possible value of pa_sync_timer 
reg[31:0] histogram[0:255];

// This is how many ticks we've observed so far
reg[31:0] tick_count;

// We keep building our histogram until tick_count == tick_limit
reg[31:0] tick_limit;

// We're running so lock as we haven't counted our last tick yet
wire running = (tick_count < tick_limit) & (reset_histogram == 0);

//==========================================================================
// Perform edge detection on pa_sync
//==========================================================================
reg prior_pa_sync;
always @(posedge clk) prior_pa_sync <= pa_sync;
wire rising_edge = (prior_pa_sync == 0) & (pa_sync == 1);
//==========================================================================



//==========================================================================
// When we're running, pa_sync_timer increments every time we see the
// rising edge of pa_sync.  When we're not running, we adjust our timer
// such that the rising edge of pa_sync occured on count 0x80
//==========================================================================
reg [7:0] pa_sync_timer;
always @(posedge clk) begin
    if (rising_edge & reset_histogram)
        pa_sync_timer <= 129;
    else
        pa_sync_timer <= pa_sync_timer + 1;
end
//==========================================================================


//==========================================================================
// Here we count rising edges of pa_sync
//==========================================================================
always @(posedge clk) begin
    if (reset_histogram)
        tick_count <= 0;
    else if (rising_edge && tick_count < tick_limit)
        tick_count <= tick_count + 1;
end
//==========================================================================


//==========================================================================
// Create a histogram of what the value of pa_sync_timer was every time
// we see the rising edge of pa_sync
//==========================================================================
for (i=0; i<256; i=i+1) begin
    always @(posedge clk) begin
        if (reset_histogram)
            histogram[i] <= 0;
        else if (running && rising_edge && pa_sync_timer == i)
            histogram[i] <= histogram[i] + 1;
    end
end
//==========================================================================


//=============================================================================
// Synchronize "pa_sync_raw" into "pa_sync"
//=============================================================================
xpm_cdc_single #
(
    .DEST_SYNC_FF  (3),
    .INIT_SYNC_FF  (0),
    .SIM_ASSERT_CHK(0),
    .SRC_INPUT_REG (0)
)
sync_pa_sync
(
    .src_clk (            ),
    .src_in  (pa_sync_raw ),
    .dest_clk(clk         ),
    .dest_out(pa_sync     )
);
//=============================================================================



//=========================  AXI Register Map  =============================
localparam REG_RESET      = 0;
localparam REG_TICK_LIMIT = 1;
localparam REG_TICK_COUNT = 2;
//==========================================================================


//==========================================================================
// We'll communicate with the AXI4-Lite Slave core with these signals.
//==========================================================================
// AXI Slave Handler Interface for write requests
wire[  31:0]  ashi_windx;     // Input   Write register-index
wire[AW-1:0]  ashi_waddr;     // Input:  Write-address
wire[  31:0]  ashi_wdata;     // Input:  Write-data
wire          ashi_write;     // Input:  1 = Handle a write request
reg [   1:0]  ashi_wresp;     // Output: Write-response (OKAY, DECERR, SLVERR)
wire          ashi_widle;     // Output: 1 = Write state machine is idle

// AXI Slave Handler Interface for read requests
wire[  31:0]  ashi_rindx;     // Input   Read register-index
wire[AW-1:0]  ashi_raddr;     // Input:  Read-address
wire          ashi_read;      // Input:  1 = Handle a read request
reg [  31:0]  ashi_rdata;     // Output: Read data
reg [   1:0]  ashi_rresp;     // Output: Read-response (OKAY, DECERR, SLVERR);
wire          ashi_ridle;     // Output: 1 = Read state machine is idle
//==========================================================================

// The state of the state-machines that handle AXI4-Lite read and AXI4-Lite write
reg ashi_write_state, ashi_read_state;

// The AXI4 slave state machines are idle when in state 0 and their "start" signals are low
assign ashi_widle = (ashi_write == 0) && (ashi_write_state == 0);
assign ashi_ridle = (ashi_read  == 0) && (ashi_read_state  == 0);
   
// These are the valid values for ashi_rresp and ashi_wresp
localparam OKAY   = 0;
localparam SLVERR = 2;
localparam DECERR = 3;


//==========================================================================
// This state machine handles AXI4-Lite write requests
//==========================================================================
always @(posedge clk) begin

    // If we're in reset, initialize important registers
    if (resetn == 0) begin
        ashi_write_state <= 0;
        reset_histogram  <= 0;
        tick_limit       <= 0;
    end
    
    // Otherwise, we're not in reset...
    else case (ashi_write_state)
        
        // If an AXI write-request has occured...
        0:  if (ashi_write) begin
       
                // Assume for the moment that the result will be OKAY
                ashi_wresp <= OKAY;              
            
                // ashi_windex = index of register to be written
                case (ashi_windx)
               
                    REG_RESET:      reset_histogram <= ashi_wdata[0];
                    REG_TICK_LIMIT: tick_limit  <= ashi_wdata;

                    // Writes to any other register are a decode-error
                    default: ashi_wresp <= DECERR;
                endcase
            end

        // Dummy state, doesn't do anything
        1: ashi_write_state <= 0;

    endcase
end
//==========================================================================



//==========================================================================
// World's simplest state machine for handling AXI4-Lite read requests
//==========================================================================
always @(posedge clk) begin

    // If we're in reset, initialize important registers
    if (resetn == 0) begin
        ashi_read_state <= 0;
    
    // If we're not in reset, and a read-request has occured...        
    end else if (ashi_read) begin
   
        // Assume for the moment that the result will be OKAY
        ashi_rresp <= OKAY;              
        
        // ashi_rindx = index of register to be read
        if (ashi_rindx >= 256 && ashi_rindx <= 511) begin
            ashi_rdata <= histogram[ashi_rindx - 256];
        end

        else case (ashi_rindx)
            
            // Allow a read from any valid register                
            REG_RESET:          ashi_rdata <= reset_histogram;
            REG_TICK_LIMIT:     ashi_rdata <= tick_limit;
            REG_TICK_COUNT:     ashi_rdata <= tick_count;
            
            // Reads of any other register are a decode-error
            default: ashi_rresp <= DECERR;

        endcase
    end
end
//==========================================================================


//=============================================================================



//==========================================================================
// This connects us to an AXI4-Lite slave core
//==========================================================================
axi4_lite_slave#(.AW(AW)) i_axi4lite_slave
(
    .clk            (clk),
    .resetn         (resetn),
    
    // AXI AW channel
    .AXI_AWADDR     (S_AXI_AWADDR),
    .AXI_AWPROT     (S_AXI_AWPROT),
    .AXI_AWVALID    (S_AXI_AWVALID),   
    .AXI_AWREADY    (S_AXI_AWREADY),
    
    // AXI W channel
    .AXI_WDATA      (S_AXI_WDATA),
    .AXI_WVALID     (S_AXI_WVALID),
    .AXI_WSTRB      (S_AXI_WSTRB),
    .AXI_WREADY     (S_AXI_WREADY),

    // AXI B channel
    .AXI_BRESP      (S_AXI_BRESP),
    .AXI_BVALID     (S_AXI_BVALID),
    .AXI_BREADY     (S_AXI_BREADY),

    // AXI AR channel
    .AXI_ARADDR     (S_AXI_ARADDR), 
    .AXI_ARPROT     (S_AXI_ARPROT),
    .AXI_ARVALID    (S_AXI_ARVALID),
    .AXI_ARREADY    (S_AXI_ARREADY),

    // AXI R channel
    .AXI_RDATA      (S_AXI_RDATA),
    .AXI_RVALID     (S_AXI_RVALID),
    .AXI_RRESP      (S_AXI_RRESP),
    .AXI_RREADY     (S_AXI_RREADY),

    // ASHI write-request registers
    .ASHI_WADDR     (ashi_waddr),
    .ASHI_WINDX     (ashi_windx),
    .ASHI_WDATA     (ashi_wdata),
    .ASHI_WRITE     (ashi_write),
    .ASHI_WRESP     (ashi_wresp),
    .ASHI_WIDLE     (ashi_widle),

    // ASHI read registers
    .ASHI_RADDR     (ashi_raddr),
    .ASHI_RINDX     (ashi_rindx),
    .ASHI_RDATA     (ashi_rdata),
    .ASHI_READ      (ashi_read ),
    .ASHI_RRESP     (ashi_rresp),
    .ASHI_RIDLE     (ashi_ridle)
);
//==========================================================================


endmodule
