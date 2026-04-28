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
    (* X_INTERFACE_PARAMETER = "ASSOCIATED_BUSIF S_AXI, ASSOCIATED_RESET resetn" *)
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

localparam REG_CAL_WEN        = 0;
localparam REG_CAL_WORD       = 1;
localparam REG_LANE_SELECT    = 2;
localparam REG_RESET_HSSIO    = 3;
localparam REG_CLEAR_ERRORS   = 4;
localparam REG_FRAME_HEADER   = 5;
localparam REG_HDR_MATCH_BITS = 6;
localparam REG_FRAMING_ERRS   = 7;

localparam REG_CAL_MASK_H    = 16;
localparam REG_CAL_MASK_L    = 17;
localparam REG_ALIGN_ERR_H   = 18;
localparam REG_ALIGN_ERR_L   = 19;
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

    // If we're in reset, initialize important registers
    if (resetn == 0) begin
        ashi_read_state <= 0;
    
    // If we're not in reset, and a read-request has occured...        
    end else if (ashi_read) begin
   
        // Assume for the moment that the result will be OKAY
        ashi_rresp <= OKAY;              
        
        // ashi_rindex = index of register to be read
        case (ashi_rindx)
            
            // Allow a read from any valid register                
            REG_CAL_WEN       : ashi_rdata <= cal_write_en;
            REG_CAL_WORD      : ashi_rdata <= {cal_bitslip_rd, cal_delay_rd};
            REG_LANE_SELECT   : ashi_rdata <= lane_select;
            REG_RESET_HSSIO   : ashi_rdata <= reset_hssio;
            REG_CLEAR_ERRORS  : ashi_rdata <= 0;
            REG_CAL_MASK_H    : ashi_rdata <= cal_mask [63:32];
            REG_CAL_MASK_L    : ashi_rdata <= cal_mask [31:00];
            REG_ALIGN_ERR_H   : ashi_rdata <= align_err[63:32];
            REG_ALIGN_ERR_L   : ashi_rdata <= align_err[31:00];
            REG_PRBS_ERR_H    : ashi_rdata <= prbs_err [63:32];
            REG_PRBS_ERR_L    : ashi_rdata <= prbs_err [31:00];     
            REG_FRAME_HEADER  : ashi_rdata <= frame_header;       
            REG_HDR_MATCH_BITS: ashi_rdata <= hdr_match_bits;
            REG_FRAMING_ERRS  : ashi_rdata <= framing_errors;

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
