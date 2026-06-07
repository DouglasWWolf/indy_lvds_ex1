//====================================================================================
//                        ------->  Revision History  <------
//====================================================================================
//
//   Date     Who   Ver  Changes
//====================================================================================
// 09-Jan-24  DWW     1  Initial creation
//====================================================================================


module sensor_emu_ctl_axi # (parameter AW=8)
(
    input clk, resetn,
  

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
    input                                   S_AXI_RREADY,
    //==========================================================================



    //==========================================================================
    //          These ports are probably mapped to AXI registers
    //==========================================================================

    // Tells everything downstream whether to operate in "sensor emulation mode"
    output o_SIM_SELECT,

    // These reset the FIFOs
    output o_FIFO_CTL_f0_reset,
    output o_FIFO_CTL_f1_reset,
    output o_FIFO_CTL_wstrobe,

    // Upper 32 bits of data for a FIFO
    output [31:0] o_UPPER32,
    
    // Loads a word into FIFO 0
    output [31:0] o_LOAD_F0,
    output        o_LOAD_F0_wstrobe,
    
    // Loads a word into FIFO 1
    output [31:0] o_LOAD_F1,
    output        o_LOAD_F1_wstrobe,

    // Activates one of the FIFOs
    output [1:0]  o_START,
    output        o_START_wstrobe,

    // Forces a hard-stop
    output        o_HARD_STOP_wstrobe,

    // Module revision number
    input [31:0]  i_MODULE_REV,

    // The cell-pattern width, in bytes
    input [3:0]   i_PATTERN_WIDTH,

    // FIFO status 
    input         i_FIFO_STAT_f0_ready,
    input         i_FIFO_STAT_f1_ready,

    // The number of entries in each FIFO
    input [31:0]  i_F0_COUNT,
    input [31:0]  i_F1_COUNT,

    // Which FIFO is active (if any)
    input [1:0]   i_ACTIVE_FIFO
    //==========================================================================

);  

// The number of AXI register we have
localparam REGISTER_COUNT = 13;

// 32-bit AXI accessible registers
reg [31:0] axi_reg[0:REGISTER_COUNT-1];
    
// These bits are a "1" when an AXI read or write to a register occurs
reg [REGISTER_COUNT-1:0] rstrobe, wstrobe;

//<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
//<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
//                Between these two markers is module-specific code
//<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
//<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

//=========================  AXI Register Map  =============================


/*
    @register Sensor emulation - specifies the width of the programmable pattern in bits
    @rtype    ro
*/
localparam REG_PATTERN_WIDTH    = 0;  

/*
    @register Sensor emulation - reports the "ready" status of the pattern FIFOs
    @rtype ro
    @field fifo_0 1 0 RO 0 Is FIFO_0 ready for new data? 1 = yes, 0 = no
    @field fifo_1 1 1 RO 0 Is FIFO_1 ready for new data? 1 = yes, 0 = no    
*/
localparam REG_FIFO_STAT        = 1;  

/*
    @register Sensor emulation - How many patterns are loaded into FIFO_0?
    @rtype ro
*/
localparam REG_F0_COUNT         = 2;  

/*
    @register Sensor emulation - How many patterns are loaded into FIFO_1?
    @rtype ro
*/
localparam REG_F1_COUNT         = 3;  


/*
    @register Sensor emulation - which FIFO is currently active?
    @rdesc The two bits can both be off, but they can never both be on
    @rtype ro
    @field fifo_0 1 0 RO 0 1 = FIFO_0 is outputting data
    @field fifo_1 1 1 RO 0 1 = FIFO_1 is outputting data
*/
localparam REG_ACTIVE_FIFO      = 4;
    
// This is an alias for the first control register
localparam CTL_REG_FIRST            = 5;    
        
/*
    @register Sensor emulation - Is the system in sensor emulation mode?
    @rdesc  0 = LVDS data and pa_sync come from the senor chip
    @rdesc  1 = LVDS data and pa_sync come from the sensor emulator
*/
localparam REG_SIM_SELECT       = 5;


/*
    @register Sensor emulation - FIFO control : Resets (i.e., clears) the pattern FIFOs
    @rdesc    >> It is not possible to reset an active FIFO <<
    @field f0_reset 1 0 RO 0 1 = Hold FIFO_0 in reset (i.e., empty it)
    @field f1_reset 1 1 RO 0 1 = Hold FIFO_1 in reset (i.e., empty it)
*/
localparam REG_FIFO_CTL         = 6;   


localparam REG_UPPER32          = 7; 

/*
    @register Sensor emulation - Writing a value this register writes it to FIFO_0
    @rdesc    Before writing a value, FIFO_STAT_fifo_0 must be 1
*/
localparam REG_LOAD_F0          = 8; 

/*
    @register Sensor emulation - Writing a value this register writes it to FIFO_1
    @rdesc    Before writing a value, FIFO_STAT_fifo_1 must be 1
*/
localparam REG_LOAD_F1          = 9;  

/*
    @register Sensor emulation - Starts or stops frame generation
    @rdesc
    @rdesc > 0 : If a FIFO is currently active, frame generation continues until
    @rdesc >     the last frame for that FIFO has been generated, then frame generation
    @rdesc >     halts.
    @rdesc >
    @rdesc > 1 : If FIFO_1 is currently active, frame generation continues until
    @rdesc >     the last frame for that FIFO has been generated, then frame generation
    @rdesc >     continues from FIFO_0.   If FIFO_1 is not currently active, then frame
    @rdesc >     generation commences immediately from FIFO_0.
    @rdesc >
    @rdesc > 2 : If FIFO_0 is currently active, frame generation continues until
    @rdesc >     the last frame for that FIFO has been generated, then frame generation
    @rdesc >     continues from FIFO_1.   If FIFO_0 is not currently active, then frame
    @rdesc >     generation commences immediately from FIFO_1
    @rdesc >
    @rdesc > Any other value : nothing happens
    @rdesc
    @rdesc It is not possible to start frame generation from an empty FIFO

*/
localparam REG_START            = 10;            


/*
    @register Sensor emulation - Writing any value to this register causes frame generation
    @rdesc                       to halt immediately after the current frame (if any) has 
    @rdesc                       been transmitted.
*/
localparam REG_HARD_STOP        = 11; 
//==========================================================================


//-------------------------------------------------------
// Map output ports to registers
//-------------------------------------------------------
assign o_SIM_SELECT         = axi_reg[REG_SIM_SELECT];
assign o_FIFO_CTL_f0_reset  = axi_reg[REG_FIFO_CTL  ][0];
assign o_FIFO_CTL_f1_reset  = axi_reg[REG_FIFO_CTL  ][1];
assign o_FIFO_CTL_wstrobe   = wstrobe[REG_FIFO_CTL  ];
assign o_UPPER32            = axi_reg[REG_UPPER32   ];
assign o_LOAD_F0            = axi_reg[REG_LOAD_F0   ];
assign o_LOAD_F0_wstrobe    = wstrobe[REG_LOAD_F0   ];
assign o_LOAD_F1            = axi_reg[REG_LOAD_F1   ];
assign o_LOAD_F1_wstrobe    = wstrobe[REG_LOAD_F1   ];
assign o_START              = axi_reg[REG_START     ];
assign o_START_wstrobe      = wstrobe[REG_START     ];
assign o_HARD_STOP_wstrobe  = wstrobe[REG_HARD_STOP ];
//-------------------------------------------------------


//-----------------------------------------------------------------
// Map registers to input ports
//-----------------------------------------------------------------
always @* axi_reg[REG_FIFO_STAT    ][0] = i_FIFO_STAT_f0_ready;
always @* axi_reg[REG_FIFO_STAT    ][1] = i_FIFO_STAT_f1_ready;
always @* axi_reg[REG_F0_COUNT     ]    = i_F0_COUNT;
always @* axi_reg[REG_F1_COUNT     ]    = i_F1_COUNT;
always @* axi_reg[REG_ACTIVE_FIFO  ]    = i_ACTIVE_FIFO;
always @* axi_reg[REG_PATTERN_WIDTH]    = i_PATTERN_WIDTH;
//-----------------------------------------------------------------


//<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
//<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
//                         End of module-specific code
//<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
//<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>


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
reg[3:0] ashi_write_state, ashi_read_state;

// The AXI4 slave state machines are idle when in state 0 and their "start" signals are low
assign ashi_widle = (ashi_write == 0) && (ashi_write_state == 0);
assign ashi_ridle = (ashi_read  == 0) && (ashi_read_state  == 0);
   
// These are the valid values for ashi_rresp and ashi_wresp
localparam OKAY   = 0;
localparam SLVERR = 2;
localparam DECERR = 3;

 
integer i;
    
//==========================================================================
// This state machine handles AXI4-Lite write requests
//==========================================================================
always @(posedge clk) begin

    // These bits strobe high for only a single cycle
    wstrobe <= 0;

    // If we're in reset, initialize important registers
    if (resetn == 0) begin
        ashi_write_state <= 0;
    end
    
    // If we're not in reset, and a write-request has occured...        
    else case (ashi_write_state)
        
        0:  if (ashi_write) begin
                  
                for (i = CTL_REG_FIRST; i < REGISTER_COUNT; i=i+1) begin
                    if (ashi_windx == i) begin
                        axi_reg[i] <= ashi_wdata;
                        wstrobe[i] <= 1;
                    end
                end

                // The value of ashi_wresp depends on whether the user just 
                // wrote to a valid register    
                if (ashi_windx >= CTL_REG_FIRST && ashi_windx < REGISTER_COUNT)
                    ashi_wresp <= OKAY;
                else
                    ashi_wresp <= SLVERR;
            end

    endcase
end
//==========================================================================





//==========================================================================
// World's simplest state machine for handling AXI4-Lite read requests
//==========================================================================
always @(posedge clk) begin

    // These bits strobe high for only a single cycle
    rstrobe <= 0;

    // If we're in reset, initialize important registers
    if (resetn == 0) begin
        ashi_read_state <= 0;
    end        
    
    // If we're not in reset, and a read-request has occured...        
    else if (ashi_read) begin
       
        // Assume for the moment that the result will be OKAY
        ashi_rresp <= OKAY;              
            
        // Examine the register index to determine what the user is trying to read
        if (ashi_rindx < REGISTER_COUNT) begin
            ashi_rdata          <= axi_reg[ashi_rindx];
            rstrobe[ashi_rindx] <= 1;
        end

        // Reads of any other register are a decode-error
        else ashi_rresp <= DECERR;

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
