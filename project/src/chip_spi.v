/*

===============================================================================
                   ------->  Revision History  <------
===============================================================================

   Date    Who  Ver  Changes
===============================================================================
18-Feb-26  DWW    1  Initial creation
===============================================================================


The SPI clock is synchronous to a free-running clock that is obtained
by dividing "clk" by 16.   The HSI clock is derived by dividing clk / 2, 
and the sensor chip dictates that the SPI clock run no faster than 
HSI_CLK / 8... hence the SPI clock is clk / 16.   Because the maximum frequency
of the SPI clock is 10 MHz, that means the maximum clock rate this module can
be driven at is 160 MHz.


This module reads and writes 32-bit words in the sensor-chip via the SPI
interface.

This assumes that all data sent during SPI transactions is sent MSB first and
further assumes that the chip clocks in data on rising edges.

A single register or SMEM read/write consists of two 40-bit transactions, each
of those consisting of an 8-bit command word and a 32-bit data-value.

The 32-bit data in the first transaction is the upper 27-bits of the register
or SMEM address.   These 32-bits must be in LITTLE-ENDIAN order.

The 32-bit data sent in the 2nd transaction of a write must be in LITTLE-ENDIAN 
order!

The 32-bit data received in the 2nd transaction of read will always be in 
little endian-order.

*/

module chip_spi 
(

    input clk, resetn,

    // This is a free-running psuedo-clock that never stops, synchronous to
    // "spi_pclk".  This is output solely because it's convenient to feed into
    // an ILA during debugging.  It is not driven out to the sensor chip.
    output reg free_pclk,

    //----------------
    // User interface    
    //----------------
    input     [ 1:0] start,
    input     [31:0] addr,
    input     [31:0] wdata,  /* This must be in little endian! */
    output reg[31:0] rdata,  /* This will be in little endian! */
    output           busy,

    //----------------
    //  SPI interface    
    //----------------
    output     spi_pclk,
    output reg spi_mosi,
    input      spi_miso,
    output reg spi_cs_n
);


// Chip select is active low
localparam ASSERT_CHIP_SELECT  = 0;
localparam RELEASE_CHIP_SELECT = 1;

// The two-bit "start" field will strobe high with one of these values
localparam START_READ  = 1;
localparam START_WRITE = 2;
localparam START_SIM   = 3;

// When sending SPI commands to the chip, these are the opcodes
localparam[0:0] OP_READ  = 0;
localparam[0:0] OP_WRITE = 1;

// This tells the chip that we will be sending 32-bits of data
localparam[0:0] CHIP_SPI_MODE32 = 1'b1;

// This is the SPI register that determines the upper 27 bits of the address
// in the chip's address space
localparam[0:0] MAP_SELECT_ON  = 1'b1;
localparam[0:0] MAP_SELECT_OFF = 1'b0;


// The number of spi_pclk cycles from:
//
// (1) Chip-select assertion to the first rising edge of spi_pclk
// (2) The last falling edge of spi_pclk to chip-select release
localparam PORCH_CYCLES = 1;

// Bits are numbered in MSB-to-LSB in the usual manner - 79 down to 0
// After bit 40 has been sent, we will suspend the spi_pclk to provide
// a gap between transactions.  
localparam TRANSACTION_BOUNDARY = 40;

// Between transactions, we will insert this many idle free_pclk cycles
localparam TRANSACTION_SUSPEND = 2;

// During a read of SMEM, we will stretch the spi_pclk cycle between the 
// command-byte and the 32 "data" cycles.
localparam READ_DATA_BOUNDARY = 32;

//=============================================================================
// This function swaps big-endian to little-endian or vice-versa
//=============================================================================
function [31:0] little_endian (input [31:0] value);
    little_endian = {value[7:0], value[15:8], value[23:16], value[31:24]};
endfunction
//=============================================================================


//=============================================================================
// Create "free_pclk" by dividing clk by 16, and keep track of its edges
//=============================================================================
reg[3:0] div_counter;
reg      rising_edge, falling_edge;
//-----------------------------------------------------------------------------
always @(posedge clk) begin
    
    falling_edge <= 0;
    rising_edge  <= 0;

    if (div_counter)
        div_counter <= div_counter - 1;
    else if (free_pclk) begin
        free_pclk    <= 0;
        falling_edge <= 1;
        div_counter  <= 15;
    end else begin
        free_pclk    <= 1;
        rising_edge  <= 1;
        div_counter  <= 15;
    end
end
//=============================================================================




// These are the address, write-data, and operation (read or write) for this
// transaction
reg[31:0] user_addr;
reg[31:0] user_wdata;
reg       user_op;

// A read/write into the chip's address space requres two 40-bit transactions.
// The 1st transaction tells the chip what the upper 27 bits of the address
// will be, while the 2nd transactions provides the lower 5 bits of the address
// and the 32 bits of data.
wire[79:0] transaction =
{
    // First 40-bit transaction
    OP_WRITE,                               //  1 bit
    CHIP_SPI_MODE32,                        //  1 bit
    MAP_SELECT_ON,                          //  1 bit
    5'b0,                                   //  5 bits
    little_endian({5'b0, user_addr[31:5]}), // 32 bits

    // Second 40-bit transactions
    user_op,          //  1 bit
    CHIP_SPI_MODE32,  //  1 bit
    MAP_SELECT_OFF,   //  1 bit
    user_addr[4:0],   //  5 bits
    user_wdata        // 32 bits
};

//=============================================================================
// This is the main state machine.  It drives the spi_pclk from free_pclk, and
// is clocks data out on falling edges and clocks data in on rising edges.
//
// It includes a mechanism that stretches the clock before reading the first
// bit of SMEM data.   This is to give the chip time to fetch the required
// data from SMEM before we start clocking it in.
//=============================================================================

// A shift register
reg[79:0] shift_reg;

// Keeps track of the bit number that is currently written to spi_mosi
reg[6:0] bit_number;

// Both of these count down the falling edges of free_pclk
reg[2:0] sleep, suspend_counter;

// This counts down the rising edges of free_pclk
reg[1:0] stretch_counter;

// Keep track of whether spi_pclk is current stretched or suspended
wire spi_pclk_suspended = (suspend_counter != 0);
wire spi_pclk_stretched = (stretch_counter != 0);

// When this is asserted, free_pclk is driven out to spi_pclk
wire spi_pclk_en;

// This is a count-down timer for simulating SPI transactions
reg[7:0] sim_delay;

// Are we reading from the sensor-chip's SMEM area?
reg is_smem_read;

// The state of the main finite-state-machine
reg[2:0] fsm_state;
localparam FSM_IDLE               = 0;
localparam FSM_ASSERT_CHIP_SELECT = 1;
localparam FSM_FRONT_PORCH        = 2;
localparam FSM_TRANSACT           = 3;
localparam FSM_BACK_PORCH         = 4;
localparam FSM_SIM_DELAY          = 5;
//--------------------------------------------------------------------------
always @(posedge clk) begin

    // This is a countdown timer that counts falling edges of free_pclk
    if (sleep && falling_edge)
        sleep <= sleep - 1;

    // While this is non-zero, the spi_pclk is suspended (i.e., is 0)
    if (suspend_counter && falling_edge)
        suspend_counter <= suspend_counter - 1;

    // While this is non-zero, the spi_pclk is stretched (i.e., is 1)
    if (stretch_counter && rising_edge)
        stretch_counter <= stretch_counter - 1;

    // If we're in reset, initialize important signals
    if (resetn == 0) begin
        fsm_state       <= 0;
        stretch_counter <= 0;
        suspend_counter <= 0;
        spi_cs_n        <= RELEASE_CHIP_SELECT;
    end

    else case(fsm_state)
    
        // Wait for someone to tell us to start
        FSM_IDLE:
            case (start)
                START_WRITE:
                    begin
                        user_addr    <= addr;
                        user_wdata   <= wdata;
                        user_op      <= OP_WRITE;
                        is_smem_read <= 0;
                        fsm_state    <= FSM_ASSERT_CHIP_SELECT;
                    end

                START_READ:
                    begin
                        user_addr    <= addr;                            
                        user_wdata   <= 0;
                        user_op      <= OP_READ;
                        is_smem_read <= (addr >= 32'h8000 && addr <= 32'h107FFF);
                        fsm_state    <= FSM_ASSERT_CHIP_SELECT; 
                    end
                
                START_SIM:
                    begin
                        sim_delay <= 4;
                        fsm_state <= FSM_SIM_DELAY;
                    end                   
            endcase

        // Wait for a falling edge, then assert chip-select, then,
        // wait for a couple more falling edges
        FSM_ASSERT_CHIP_SELECT:
            if (falling_edge) begin
                spi_cs_n   <= ASSERT_CHIP_SELECT;
                sleep      <= PORCH_CYCLES;
                fsm_state  <= FSM_FRONT_PORCH;
            end

        FSM_FRONT_PORCH:
            if (sleep == 0) begin
                spi_mosi   <= transaction[79];
                shift_reg  <= (transaction << 1);
                bit_number <= 79;
                fsm_state  <= FSM_TRANSACT;
            end
        
        FSM_TRANSACT:

            // If this is the rising edge of the 8th bit (on the 2nd transaction)
            // then we need to ensure that spi_pclk remains high for an extra
            // free_pclk cycle. 
            if (is_smem_read && rising_edge
                             && bit_number == READ_DATA_BOUNDARY
                             && !spi_pclk_stretched)
                begin
                    stretch_counter <= 1;
                end

            // On falling edges we clock out a new bit to spi_mosi
            else if (falling_edge & !spi_pclk_stretched & !spi_pclk_suspended) begin
                if (bit_number == TRANSACTION_BOUNDARY)
                    suspend_counter <= TRANSACTION_SUSPEND;

                if (bit_number) begin
                    spi_mosi   <= shift_reg[79];
                    shift_reg  <= (shift_reg << 1);
                    bit_number <= bit_number - 1;
                end else begin
                    spi_mosi  <= 0;
                    sleep     <= PORCH_CYCLES + 2;
                    fsm_state <= FSM_BACK_PORCH;
                end
            end

        // During the back porch, we wait for two free_pclk
        // cycles after chip-select has been released because
        // we want to ensure that there are time gaps between
        // consecutive chip regster/SMEM reads/writes.
        FSM_BACK_PORCH:
            begin
                if (sleep == 2) spi_cs_n  <= RELEASE_CHIP_SELECT;
                if (sleep == 0) fsm_state <= FSM_IDLE;
            end

        // A "simulation delay" operation just wastes a few clock cycles.
        // This causes the SPI to appear to be completing transactions
        // very quickly.  This is convenient for debugging with an ILA when
        // you want to fit a lot of SPI transactions onto the debugging
        // screen.
        FSM_SIM_DELAY:
            if (sim_delay)
                sim_delay <= sim_delay - 1;
            else
                fsm_state <= FSM_IDLE;

    endcase

end

// spi_pclk is enabled during state FSM_TRANSACT while we're not suspended
assign spi_pclk_en = (fsm_state == FSM_TRANSACT) & !spi_pclk_suspended;

// spi_pclk is driven from the free-running "free_pclk".  
assign spi_pclk = (free_pclk & spi_pclk_en) | spi_pclk_stretched;

// We're busy as soon as we receive a transaction request
assign busy = start || (fsm_state != FSM_IDLE);
//=============================================================================


//=============================================================================
// We clock in data on the rising edge of spi_pclk
//=============================================================================
always @(posedge clk) begin
    if (spi_pclk & rising_edge) begin
        rdata <= {rdata[30:0], spi_miso};
    end
end
//=============================================================================


endmodule
