//====================================================================================
//                        ------->  Revision History  <------
//====================================================================================
//
//   Date     Who   Ver  Changes
//====================================================================================
// 26-Feb-26  DWW     1  Initial creation
//====================================================================================

/*

    Provides an orderly power-up/power-down for sensor-chip on Indy

*/


module indy_power_ctl #
(
    parameter AW=8,
    parameter FREQ_HZ = 250000000,

    parameter   VDDIO_RISE_MS = 10,
    parameter     VDD_RISE_MS = 10,
    parameter VDDLVDS_RISE_MS = 10,
    parameter    VDDA_RISE_MS = 10,

    parameter   VDDIO_FALL_MS = 200,
    parameter     VDD_FALL_MS = 1000,
    parameter VDDLVDS_FALL_MS = 40,
    parameter    VDDA_FALL_MS = 2500
)
(
    input clk, resetn,

    // The four power supplies for the sensor chip
    output reg chip_vddio, chip_vdd, chip_vddlvds, chip_vdda,

    // The reset pin for the sensor chip
    output reg chip_reset_n,

    // This is an active-low output enable for the level-translator
    // that does voltage translation between the FPGA and sensor-chip
    output reg lvl_trsl_oe_n,

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
localparam REG_CHIP_POWER_CTL    = 0;
localparam REG_CHIP_POWER_STATE  = 1;
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

// The number of clock cycles in 1 millisecond
localparam ONE_MS = FREQ_HZ / 1000;

// Constants for driving the various chip pins
localparam POWER_OFF = 0;
localparam POWER_ON  = 1;
localparam CHIP_RESET_ASSERTED = 0;
localparam CHIP_RESET_DEASSERTED = 1;
localparam LEVELSHIFT_ENABLED  = 0;
localparam LEVELSHIFT_DISABLED = 1;

reg chip_power_ctl;
reg chip_power_state;
reg[4:0] cpsm_state;

reg[31:0] sleep;
always @(posedge clk) begin

    // Count down timer
    if (sleep) sleep <= sleep -1;

    if (resetn == 0) begin
        chip_reset_n     <= CHIP_RESET_ASSERTED;
        chip_vddio       <= POWER_OFF;
        chip_vdd         <= POWER_OFF;
        chip_vddlvds     <= POWER_OFF;
        chip_vdda        <= POWER_OFF;
        chip_power_state <= 0;
        cpsm_state       <= 0;
        sleep            <= 0;
    end

    else case (cpsm_state)

        0:  begin
                if (chip_power_ctl == 1 && chip_power_state == 0) begin
                    chip_reset_n  <= CHIP_RESET_ASSERTED;
                    lvl_trsl_oe_n <= LEVELSHIFT_DISABLED;
                    sleep         <= 0;
                    cpsm_state    <= 10;
                end
                
                if (chip_power_ctl == 0 && chip_power_state == 1) begin
                    chip_reset_n  <= CHIP_RESET_ASSERTED;
                    lvl_trsl_oe_n <= LEVELSHIFT_DISABLED;
                    sleep         <= 100;
                    cpsm_state    <= 20;
                end
            end

        // Here we power up the chip
        10: if (sleep == 0) begin
                chip_vddio <= POWER_ON;
                sleep      <= VDDIO_RISE_MS * ONE_MS;
                cpsm_state <= cpsm_state + 1;
            end

        11: if (sleep == 0) begin
                chip_vdd   <= POWER_ON;
                sleep      <= VDD_RISE_MS * ONE_MS;
                cpsm_state <= cpsm_state + 1;
            end

        12: if (sleep == 0) begin
                chip_vddlvds <= POWER_ON;
                sleep        <= VDDLVDS_RISE_MS * ONE_MS;
                cpsm_state   <= cpsm_state + 1;
            end

        13: if (sleep == 0) begin
                chip_vdda  <= POWER_ON;
                sleep      <= VDDA_RISE_MS * ONE_MS;
                cpsm_state <= cpsm_state + 1;
            end

        14: if (sleep == 0) begin
                lvl_trsl_oe_n    <= LEVELSHIFT_ENABLED;
                chip_reset_n     <= CHIP_RESET_DEASSERTED;
                chip_power_state <= 1;
                cpsm_state       <= 0;
            end


        // This is the power-down sequence
        20: if (sleep == 0) begin
                chip_vdda  <= POWER_OFF;
                sleep      <= VDDA_FALL_MS * ONE_MS;
                cpsm_state <= cpsm_state + 1;
            end

        21: if (sleep == 0) begin
                chip_vddlvds <= POWER_OFF;
                sleep        <= VDDLVDS_FALL_MS * ONE_MS;
                cpsm_state   <= cpsm_state + 1;
            end

        22: if (sleep == 0) begin
                chip_vdd   <= POWER_OFF;
                sleep      <= VDD_FALL_MS * ONE_MS;
                cpsm_state <= cpsm_state + 1;
            end

        23: if (sleep == 0) begin
                chip_vddio <= POWER_OFF;
                sleep      <= VDD_FALL_MS * ONE_MS;
                cpsm_state <= cpsm_state + 1;
            end

        24: if (sleep == 0) begin
                chip_power_state <= 0;
                cpsm_state  <= 0;
            end

    endcase

end



//==========================================================================
// This state machine handles AXI4-Lite write requests
//==========================================================================
always @(posedge clk) begin

    // If we're in reset, initialize important registers
    if (resetn == 0) begin
        ashi_write_state  <= 0;
        chip_power_ctl    <= 0;

    // Otherwise, we're not in reset...
    end else case (ashi_write_state)
        
        // If an AXI write-request has occured...
        0:  if (ashi_write) begin
       
                // Assume for the moment that the result will be OKAY
                ashi_wresp <= OKAY;              
            
                // ashi_windex = index of register to be written
                case (ashi_windx)
                    REG_CHIP_POWER_CTL:  chip_power_ctl <= ashi_wdata;               

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
            REG_CHIP_POWER_CTL:     ashi_rdata <= chip_power_ctl;
            REG_CHIP_POWER_STATE:   ashi_rdata <= chip_power_state;

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
