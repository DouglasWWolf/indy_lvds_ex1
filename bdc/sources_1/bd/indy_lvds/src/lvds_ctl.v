//=============================================================================
//                   ------->  Revision History  <------
//=============================================================================
//
//   Date     Who   Ver  Changes
//=============================================================================
// 15-Apr-26  DWW     1  Initial creation
//=============================================================================

/*
    Provides AXI register access to HSSIO and LVDS related modules
*/


module lvds_ctl # (parameter AW=8)
(
    (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 clk CLK" *)
    (* X_INTERFACE_PARAMETER = "ASSOCIATED_BUSIF S_AXI:missing_hdr, ASSOCIATED_RESET resetn" *)
    input clk,
    input resetn,

    // Control and status for writing delay values
    output reg [63:0] cal_mask,
    output reg [11:0] cal_word,
    output reg        cal_word_wstb,
    input      [ 2:0] cal_write_en,

    // Select lane for the inputs below
    output reg [ 5:0] lane_select,
    input      [ 8:0] cal_delay_rd,
    input      [ 2:0] cal_bitslip_rd,

    // Assert this to reset the HSSIO banks
    output reg        reset_hssio,

    // Errors, 1 bit per lane
    input      [63:0] align_err,
    input      [63:0] prbs_err,

    // When this is asserted, LVDS alignment errors and PRBS errors are cleared
    output reg        clear_errors_stb,

    // The 32-bit frame header that the sensor-chip should send us
    output reg [31:0] frame_header,
    
    // The number of bits of the frame header that have to match
    output reg [ 5:0] hdr_match_bits,

    // The number of frames that had framing errors
    input [31:0] framing_errors,

    // The number of clock-cycles of skew between the LVDS lanes
    input [ 7:0] max_lane_skew,

    // This AXI stream describes lanes that were missing frame headers
    input [31:0] missing_hdr_tdata,  /* Frame number */
    input [63:0] missing_hdr_tuser,  /* Bitmap of which lanes were missing frame headers */
    input        missing_hdr_tvalid,
    output reg   missing_hdr_tready,

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

//=========================  AXI Register Map  =============================

/*
    @register Calibration write-enable
    @rdesc    This must be non-zero before writing to LVDS_CAL_WORD
    @rtype    ro

*/
localparam REG_CAL_WEN         = 0;

/*
    @register Writing to this register writes the specified calibration word to each
    @rdesc    LVDS lane selected in register LVDS_CAL_MASK.  Do not write to this register
    @rdesc    unless LVDS_CAL_WEN is non-zero
    @rdesc
    @rdesc    Reading from this register returns the calibration word for the lane
    @rdesc    selected by LVDS_LANE_SELECT
    @rdesc
    @rdesc    Valid calibration words are 0 thru 4095 (i.e., 0x0000 thru 0xFFF)
    @rdesc    
    @rdesc    > For informational purposes only:  Bits 11:9 are a bitslip value (0 thru 7)
    @rdesc    >                                   Bits  8:0 are a delay tap (0 thru 0x1FF)
*/
localparam REG_CAL_WORD = 1;


/*
    @register Selects the LVDS lane that will be read when reading LVDS_CAL_WORD
    @rdesc    Valid values are 0 thru 63
*/
localparam REG_LANE_SELECT = 2;

/*
    @register Writing a 1 to this register places the FPGA's "High Speed Serial I/O" logic
    @rdesc    in reset.    Writing a 0 takes the HSSIO logic out of reset.
*/
localparam REG_RESET_HSSIO = 3;

/*
    @register Writing a 1 clears the error bits in LVDS_ALIGN_ERR and LVDS_PRBS_ERR
    @rtype    wo
*/
localparam REG_CLEAR_ERRORS = 4;

/*
    @register The four-byte frame-header pattern that the sensor-chip generates.   
    @rdesc    The value of this register must match the value in sensor-chip register SRDWR_HEADER_PATTERN.
    @rdesc    Default value is 0x0FAA0FAA

*/
localparam REG_FRAME_HEADER = 5;

/*
    @register Defines the number of bits of LVDS_FRAME_HDR that must match the data in the LVDS
    @rdesc    lane in order for LVDS lane data to be recognized as a frame-header. 
    @rdesc    Valid values are 1 thru 32.  Default value is 32.
*/
localparam REG_HDR_MATCH_BITS = 6;

/*
    @register Count of the number of LVDS frames in which at least one LVDS lane was
    @rdesc    missing a frame header.
    @rdesc    This value is cleared by a full system reset
    @rtype    ro
*/
localparam REG_FRAMING_ERRS = 7;

/*
    @register The maximum lane-to-lane skew measured during frame-header detection.
    @rdesc    This value is cleared by a full system reset.
    @rtype    ro
*/
localparam REG_MAX_LANE_SKEW = 8;

/*
    @register The status of the "missing header" registers LVDS_MISS_HDR_FRAME and
    @rdesc    LVDS_MISS_HDR_LANES.  Reading this register (when it returns a 1)
    @rdesc    causes valid data to be latched into the above mentioned registers
    @rtype    ro
*/
localparam REG_REG_MISS_HDR_STATUS = 9;

/*
    @register If the last read of LVDS_MISS_HDR_STATUS returned a 1, this register
    @rdesc    contains the frame number of the frame that had missing frame headers
    @rtype    ro
*/
localparam REG_MISS_HDR_FRAME = 10;

/*
    @register If the last read of LVDS_MISS_HDR_STATUS returned a 1, this register
    @rdesc    contains a bitmap of which LVDS lanes were missing headers.
    @rname    REG_MISS_HDR_LANES
    @rtype    ro
    @rsize    64
*/
localparam REG_MISS_HDR_LANES_H = 11;
localparam REG_MISS_HDR_LANES_L = 12;

/*
    @register Determines which LVDS lanes the next write to LVDS_CAL_WORD will affect.
    @rsize    64
    @rname    REG_CAL_MASK
*/
localparam REG_CAL_MASK_H    = 16;
localparam REG_CAL_MASK_L    = 17;


/*
    @register A bitmap of which LVDS lanes detected a failure of the LVDS alignment pattern
    @rdesc    This is cleared by writing a 1 to register LVDS_CLEAR_ERRORS.
    @rtype    ro
    @rsize    64
    @rname    REG_ALIGN_ERR
*/
localparam REG_ALIGN_ERR_H   = 18;
localparam REG_ALIGN_ERR_L   = 19;

/*
    @register A bitmap of which LVDS lanes detected a failure of PRBS checking
    @rdesc    This is cleared by writing a 1 to register LVDS_CLEAR_ERRORS.
    @rtype    ro
    @rsize    64
    @rname    REG_PRBS_ERR
*/
localparam REG_PRBS_ERR_H    = 20;
localparam REG_PRBS_ERR_L    = 21;

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

// Bitmap of which lanes were missing a frame header
reg[63:0] missing_hdr_lanes;

// Frame number that "missing_hdr_lanes" applies to
reg[31:0] missing_hdr_frame;

//==========================================================================
// This state machine handles AXI4-Lite write requests
//==========================================================================
always @(posedge clk) begin

    // These strobe high for a single cycle at a time
    cal_word_wstb    <= 0;
    clear_errors_stb <= 0;

    // If we're in reset, initialize important registers
    if (resetn == 0) begin
        ashi_write_state <= 0;
        cal_mask         <= 0;
        cal_word         <= 0; 
        reset_hssio      <= 0;
        lane_select      <= 0;
        frame_header     <= 32'h0F_AA_0F_AA;
        hdr_match_bits   <= 32;
    end
    
    // Otherwise, we're not in reset...
    else case (ashi_write_state)
        
        // If an AXI write-request has occured...
        0:  if (ashi_write) begin
       
                // Assume for the moment that the result will be OKAY
                ashi_wresp <= OKAY;              
            
                // ashi_windex = index of register to be written
                case (ashi_windx)

                    REG_CAL_MASK_H    : cal_mask[63:32]  <= ashi_wdata;
                    REG_CAL_MASK_L    : cal_mask[31:00]  <= ashi_wdata;
                    REG_LANE_SELECT   : lane_select      <= ashi_wdata;
                    REG_RESET_HSSIO   : reset_hssio      <= ashi_wdata;
                    REG_CLEAR_ERRORS  : clear_errors_stb <= ashi_wdata;
                    REG_FRAME_HEADER  : frame_header     <= ashi_wdata;
                    REG_HDR_MATCH_BITS: hdr_match_bits   <= ashi_wdata;
                    REG_CAL_WORD:    
                        begin
                            cal_word      <= ashi_wdata;
                            cal_word_wstb <= 1;
                        end
                

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

    // This strobes high for a single cycle at a time
    missing_hdr_tready <= 0;

    // If we're in reset, initialize important registers
    if (resetn == 0) begin
        ashi_read_state <= 0;
    end
    
    // If we're not in reset, and a read-request has occured...        
    else if (ashi_read) begin
   
        // Assume for the moment that the result will be OKAY
        ashi_rresp <= OKAY;              
        
        // ashi_rindex = index of register to be read
        case (ashi_rindx)
            
            // Allow a read from any valid register                
            REG_CAL_WEN         : ashi_rdata <= cal_write_en;
            REG_CAL_WORD        : ashi_rdata <= {cal_bitslip_rd, cal_delay_rd};
            REG_LANE_SELECT     : ashi_rdata <= lane_select;
            REG_RESET_HSSIO     : ashi_rdata <= reset_hssio;
            REG_CLEAR_ERRORS    : ashi_rdata <= 0;
            REG_CAL_MASK_H      : ashi_rdata <= cal_mask [63:32];
            REG_CAL_MASK_L      : ashi_rdata <= cal_mask [31:00];
            REG_ALIGN_ERR_H     : ashi_rdata <= align_err[63:32];
            REG_ALIGN_ERR_L     : ashi_rdata <= align_err[31:00];
            REG_PRBS_ERR_H      : ashi_rdata <= prbs_err [63:32];
            REG_PRBS_ERR_L      : ashi_rdata <= prbs_err [31:00];     
            REG_FRAME_HEADER    : ashi_rdata <= frame_header;       
            REG_HDR_MATCH_BITS  : ashi_rdata <= hdr_match_bits;
            REG_FRAMING_ERRS    : ashi_rdata <= framing_errors;
            REG_MAX_LANE_SKEW   : ashi_rdata <= max_lane_skew;
            REG_MISS_HDR_FRAME  : ashi_rdata <= missing_hdr_frame;
            REG_MISS_HDR_LANES_H: ashi_rdata <= missing_hdr_lanes[63:32];
            REG_MISS_HDR_LANES_L: ashi_rdata <= missing_hdr_lanes[31:00];

            // When the user reads the MISS_HDR_STAT register and there is
            // data waiting on the "missing_hdr" AXI stream, we fetch the data
            // from the AXI stream into registers
            REG_REG_MISS_HDR_STATUS : if (missing_hdr_tvalid) begin
                                    missing_hdr_frame  <= missing_hdr_tdata;
                                    missing_hdr_lanes  <= missing_hdr_tuser;
                                    missing_hdr_tready <= 1;
                                    ashi_rdata         <= 1;
                                end else begin
                                    missing_hdr_frame  <= 0;
                                    missing_hdr_lanes  <= 0;
                                    missing_hdr_tready <= 0;
                                    ashi_rdata         <= 0;
                                end



            // Reads of any other register are a decode-error
            default: ashi_rresp <= DECERR;

        endcase
    end
end
//==========================================================================



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
