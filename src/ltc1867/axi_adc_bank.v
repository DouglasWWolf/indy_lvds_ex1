//====================================================================================
//                        ------->  Revision History  <------
//====================================================================================
//
//   Date     Who   Ver  Changes
//====================================================================================
// 10-Mar-26  DWW     1  Initial creation
//====================================================================================

/*
    Provides AXI register access to data from four 8-channel, 16-bit ADCs
*/

module axi_adc_bank # (parameter AW=8, ADC_COUNT = 1)
(
    input clk, resetn,

    input[8 * ADC_COUNT * 16 - 1:0] adc,

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
        ashi_write_state  <= 0;

    // Otherwise, we're not in reset...
    end else case (ashi_write_state)
        
        // If an AXI write-request has occured...
        0:  if (ashi_write) begin
       
                // Assume for the moment that the result will be OKAY
                ashi_wresp <= OKAY;              
            
                // ashi_windex = index of register to be written
                case (ashi_windx)
               

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
             0: ashi_rdata <= (ADC_COUNT >= 1) ? adc[ 0*16 +: 16] : 0;
             1: ashi_rdata <= (ADC_COUNT >= 1) ? adc[ 1*16 +: 16] : 0;
             2: ashi_rdata <= (ADC_COUNT >= 1) ? adc[ 2*16 +: 16] : 0;
             3: ashi_rdata <= (ADC_COUNT >= 1) ? adc[ 3*16 +: 16] : 0;
             4: ashi_rdata <= (ADC_COUNT >= 1) ? adc[ 4*16 +: 16] : 0;
             5: ashi_rdata <= (ADC_COUNT >= 1) ? adc[ 5*16 +: 16] : 0;
             6: ashi_rdata <= (ADC_COUNT >= 1) ? adc[ 6*16 +: 16] : 0;
             7: ashi_rdata <= (ADC_COUNT >= 1) ? adc[ 7*16 +: 16] : 0;

             8: ashi_rdata <= (ADC_COUNT >= 2) ? adc[ 8*16 +: 16] : 0;
             9: ashi_rdata <= (ADC_COUNT >= 2) ? adc[ 9*16 +: 16] : 0; 
            10: ashi_rdata <= (ADC_COUNT >= 2) ? adc[10*16 +: 16] : 0; 
            11: ashi_rdata <= (ADC_COUNT >= 2) ? adc[11*16 +: 16] : 0; 
            12: ashi_rdata <= (ADC_COUNT >= 2) ? adc[12*16 +: 16] : 0; 
            13: ashi_rdata <= (ADC_COUNT >= 2) ? adc[13*16 +: 16] : 0; 
            14: ashi_rdata <= (ADC_COUNT >= 2) ? adc[14*16 +: 16] : 0; 
            15: ashi_rdata <= (ADC_COUNT >= 2) ? adc[15*16 +: 16] : 0; 

            16: ashi_rdata <= (ADC_COUNT >= 3) ? adc[16*16 +: 16] : 0;
            17: ashi_rdata <= (ADC_COUNT >= 3) ? adc[17*16 +: 16] : 0;
            18: ashi_rdata <= (ADC_COUNT >= 3) ? adc[18*16 +: 16] : 0;
            19: ashi_rdata <= (ADC_COUNT >= 3) ? adc[19*16 +: 16] : 0;
            20: ashi_rdata <= (ADC_COUNT >= 3) ? adc[20*16 +: 16] : 0;
            21: ashi_rdata <= (ADC_COUNT >= 3) ? adc[21*16 +: 16] : 0;
            22: ashi_rdata <= (ADC_COUNT >= 3) ? adc[22*16 +: 16] : 0;
            23: ashi_rdata <= (ADC_COUNT >= 3) ? adc[23*16 +: 16] : 0;                          

            24: ashi_rdata <= (ADC_COUNT >= 4) ? adc[24*16 +: 16] : 0;
            25: ashi_rdata <= (ADC_COUNT >= 4) ? adc[25*16 +: 16] : 0;
            26: ashi_rdata <= (ADC_COUNT >= 4) ? adc[26*16 +: 16] : 0;
            27: ashi_rdata <= (ADC_COUNT >= 4) ? adc[27*16 +: 16] : 0;
            28: ashi_rdata <= (ADC_COUNT >= 4) ? adc[28*16 +: 16] : 0;
            29: ashi_rdata <= (ADC_COUNT >= 4) ? adc[29*16 +: 16] : 0;
            30: ashi_rdata <= (ADC_COUNT >= 4) ? adc[30*16 +: 16] : 0;
            31: ashi_rdata <= (ADC_COUNT >= 4) ? adc[31*16 +: 16] : 0;                          


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
