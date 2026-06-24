//====================================================================================
//                        ------->  Revision History  <------
//====================================================================================
//
//   Date     Who   Ver  Changes
//====================================================================================
// 16-Feb-26  DWW     1  Initial Creation
//====================================================================================

/*

    Provides AXI registers for control and status of the ABM manager

*/


module chip_spi_ctl # (parameter AW=8)
(
    input clk, resetn,

    // These are used to read and write registers/SMEM on the sensor chip
    output  [ 1:0] spi_start_stb,
    output  [31:0] spi_addr,
    output  [31:0] spi_wdata,
    input   [31:0] spi_rdata,
    input          spi_busy,

    //================== This is an AXI4-Lite slave interface ==================
        
    // "Specify write address"              -- Master --    -- Slave --
    (* keep = "true" *) input[AW-1:0]                           S_AXI_AWADDR,   
    (* keep = "true" *) input                                   S_AXI_AWVALID,  
    (* keep = "true" *) input[   2:0]                           S_AXI_AWPROT,
    (* keep = "true" *) output                                                  S_AXI_AWREADY,


    // "Write Data"                         -- Master --    -- Slave --
    (* keep = "true" *) input[31:0]                             S_AXI_WDATA,      
    (* keep = "true" *) input                                   S_AXI_WVALID,
    (* keep = "true" *) input[ 3:0]                             S_AXI_WSTRB,
    (* keep = "true" *) output                                                  S_AXI_WREADY,

    // "Send Write Response"                -- Master --    -- Slave --
    (* keep = "true" *) output[1:0]                                             S_AXI_BRESP,
    (* keep = "true" *) output                                                  S_AXI_BVALID,
    (* keep = "true" *) input                                   S_AXI_BREADY,

    // "Specify read address"               -- Master --    -- Slave --
    (* keep = "true" *) input[AW-1:0]                           S_AXI_ARADDR,     
    (* keep = "true" *) input[   2:0]                           S_AXI_ARPROT,     
    (* keep = "true" *) input                                   S_AXI_ARVALID,
    (* keep = "true" *) output                                                  S_AXI_ARREADY,

    // "Read data back to master"           -- Master --    -- Slave --
    (* keep = "true" *) output[31:0]                                            S_AXI_RDATA,
    (* keep = "true" *) output                                                  S_AXI_RVALID,
    (* keep = "true" *) output[ 1:0]                                            S_AXI_RRESP,
    (* keep = "true" *) input                                   S_AXI_RREADY
    //==========================================================================
);  

//=========================  AXI Register Map  =============================

/*
    @register Sensor-chip register address
*/

localparam REG_CHIPIO_ADDR    =  0;

/*
    @register Sensor-chip register data
*/
localparam REG_CHIPIO_DATA    =  1;

/*
    @register Sensor-chip read/write command and status
*/
localparam  REG_CHIPIO_CMD    =  2;
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

//==========================================================================
// These are how we communicate with the chip_spi interface
//==========================================================================
reg [31:0] chipio_raddr;
reg [31:0] chipio_waddr;
reg [31:0] chipio_wdata;
reg        chipio_write_stb;
reg        chipio_read_stb;
wire[31:0] chipio_rdata;
wire       chipio_read_busy;
wire       chipio_write_busy;
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

// This is the address that will used to read/write data to/from the chip
reg[31:0] chipio_addr;

// Bit 0 = Perform chip-read, Bit 1 = Perform chip-write, Bit 2 = auto-inc address
reg[2:0] chipio_cmd;

//=============================================================================
// This function swaps big-endian to little-endian or vice-versa
//=============================================================================
function [31:0] byte_swap (input [31:0] value);
    byte_swap = {value[7:0], value[15:8], value[23:16], value[31:24]};
endfunction
//=============================================================================


//==========================================================================
// This state machine handles AXI4-Lite write requests
//==========================================================================
always @(posedge clk) begin

    // These strobes high for a single cycle at a time
    chipio_write_stb <= 0;
    chipio_read_stb  <= 0;
    
    // If we're in reset, initialize important registers
    if (resetn == 0) begin
        ashi_write_state  <= 0;
    end
    
    // Otherwise, we're not in reset...
    else case (ashi_write_state)
        
        // If an AXI write-request has occured...
        0:  if (ashi_write) begin
       
                // Assume for the moment that the result will be OKAY
                ashi_wresp <= OKAY;              
            
                // ashi_windex = index of register to be written
                case (ashi_windx)
             

                    REG_CHIPIO_DATA:
                        begin
                            chipio_wdata <= byte_swap(ashi_wdata);
                        end

                    REG_CHIPIO_ADDR:
                        begin
                            chipio_addr <= ashi_wdata;
                        end

                    REG_CHIPIO_CMD:
                        begin
                            chipio_cmd <= ashi_wdata;
    
                            if (ashi_wdata[0]) begin
                                chipio_raddr     <= chipio_addr;
                                chipio_read_stb  <= 1;
                            end else if (ashi_wdata[1]) begin
                                chipio_waddr     <= chipio_addr;
                                chipio_write_stb <= 1;
                            end

                            if (ashi_wdata[2]) chipio_addr <= chipio_addr + 4;
                        end

                    // Writes to any other register are a decode-error
                    default: ashi_wresp <= DECERR;
                endcase
            end

        // Dummy state that is never reached
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
    end

    // If we're not in reset...
    else case (ashi_read_state)
        
        // If a read-request has occured...
        0:  if (ashi_read) begin
   
                // Assume for the moment that the result will be OKAY
                ashi_rresp <= OKAY;              
        
                // ashi_rindex = index of register to be read
                case (ashi_rindx)
            
                    // User is reading back the address of the chip-register             
                    REG_CHIPIO_ADDR:
                        ashi_rdata <= chipio_addr;

                    // Report the data read or the data written
                    REG_CHIPIO_DATA:
                        ashi_rdata <= (chipio_cmd[1]) ? byte_swap(chipio_wdata) : byte_swap(chipio_rdata);

                    // Report 0 when the read or write is complete
                    REG_CHIPIO_CMD:
                        if (chipio_read_busy | chipio_write_busy)
                            ashi_rdata <= chipio_cmd;
                        else
                            ashi_rdata <= 0;

                    // Reads of any other register are a decode-error
                    default: ashi_rresp <= DECERR;
                endcase
            end

        // A dummy state that is never reached
        1:  ashi_read_state <= 0;
    endcase
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

//==========================================================================
// This is an interface to the chip_spi module
//==========================================================================
chip_spi_if i_chip_spi_if
(
    .clk            (clk),
    .resetn         (resetn),

    // Client-side interface for write-transactions
    .io_waddr       (chipio_waddr),
    .io_wdata       (chipio_wdata),
    .io_write_stb   (chipio_write_stb),
    .io_write_busy  (chipio_write_busy),

    // Client-side interface for read transactions
    .io_raddr       (chipio_raddr),
    .io_read_stb    (chipio_read_stb),
    .io_rdata       (chipio_rdata),
    .io_read_busy   (chipio_read_busy),

    // Interface to the chip_spi module
    .spi_addr       (spi_addr),
    .spi_wdata      (spi_wdata),
    .spi_start_stb  (spi_start_stb),
    .spi_busy       (spi_busy),
    .spi_rdata      (spi_rdata)
);
//==========================================================================



endmodule
