
//=============================================================================
//                   ------->  Revision History  <------
//=============================================================================
//
//   Date     Who   Ver  Changes
//=============================================================================
// 10-Mar-26  DWW     1  Initial creation
//=============================================================================


/*
    The LTC-1867L is an 8-channel 16-bit ADC made by Analog Devices.

    At the time of this writing, the datasheet for the ADC is here:

    https://www.analog.com/media/en/technical-documentation/data-sheets/ltc1863l-1867l.pdf

    This module can drive up to 4 of these ADCs across a single SPI bus

    The datasheet is clear that (for noise reasons) no SPI pin should change
    while the ADC is acquiring (i.e., sampling) a voltage, nor while the ADC is
    converting the voltage to a digital value.  This module is careful to 
    adhere to that restriction.

    The general procedure for programming the part and obtaining the 
    reading of the most recent measurement is:

    (1) Bring the CS/CONV pin low
    (2) Wait 40 nanoseconds for the ADC's SDO (i.e., MISO) pin to become valid
    (3) Clock 16 bits of data in and out.  The data being clocked out determines
        (among other things) the channel number of the *next* data value that
        will be returned.  The channel number that is clocked out is NOT the
        channel number of the data that is currently being clocked in
    (4) Wait 2 microseconds while signal aquisition (i.e., sampling) occurs
    (5) Bring the CS/CONV pin high
    (6) Wait 4 microseconds while voltage conversion happens

    After those steps have been performed, they can be repeated for the next
    channel and/or the next ADC device.

    This module samples all 8 channels of every attached ADC continously, forever.

    For obvious reasons, only one slave_select bit can ever be active (i.e., low)
    at any given moment.

                               --- Virtual Channels ---

    This module supports multiple 8-channel ADCs and assigns a virtual-channel
    number to each channel of each ADC.   The mapping is quite simple:
        Virtual channels  0 thru  7 = ADC 0, channels 0 thru 7
        Virtual channels  8 thru 15 = ADC 1, channels 0 thru 7
        Virtual channels 16 thru 23 = ADC 2, channels 0 thru 7
        Virtual channels 24 thru 31 = ADC 3, channels 0 thru 7

*/

module ltc1867l # (parameter FREQ_HZ = 250000000, ADC_COUNT = 1, SIMULATE = 0)
(
    input   clk,
    input   resetn,

    // One slave-select for every ADC on the SPI bus
    output reg [ADC_COUNT-1:0] slave_select, 

    // This is the SPI bus that connects us to the ADCs
    output reg spi_sclk,
    output     spi_mosi,
    input      spi_miso,

    // These are the eight 16-bit data-values for each ADC 
    output reg [ADC_COUNT * 8 * 16 - 1:0] adc_values
);
genvar i;

// This is the desired SPI frequency (10 MHz)
localparam SPI_FREQ = 10000000;

// Number of microseconds required for signal acquisition
localparam ACQ_USEC = 2;

// Number of microseconds required for signal conversion
localparam CONV_USEC = 4;

// How many clock-cycles are in one microsecond?
localparam ONE_USEC = FREQ_HZ / 1000000;

// How many nanoseconds is one clock-cycle?
localparam NSEC_PER_CLK = 1000000000 / FREQ_HZ;

// How many clock cycles are there in an SPI sclk cycle?
localparam CLKS_PER_SPI_CLK = FREQ_HZ / SPI_FREQ;

// How many clock cycles are in one-half of an SPI sclk cycle?
localparam SCLK_HALF_CYCLE = (SIMULATE)  ? 2 : CLKS_PER_SPI_CLK / 2;

// How many clock cycles should we delay during signal aquisition?
localparam ACQ_CYCLES = (SIMULATE) ? CLKS_PER_SPI_CLK : ACQ_USEC * ONE_USEC;

// How many clock cycles should we delay during signal conversion?
localparam CONV_CYCLES = (SIMULATE) ? CLKS_PER_SPI_CLK : CONV_USEC * ONE_USEC;

// The channel number of the last virtual channel
localparam LAST_VCHAN = ADC_COUNT * 8 - 1;

// The virtual channel number.  Ranges from 0 to LAST_VCHAN
reg[4:0] vchannel;

// This is the channel number of the *next* ADC value we will read
wire[2:0] next_adc_ch = vchannel[2:0] + 1;

// The ADC number is the upper 2 bits of the virtual channel number
wire[1:0] which_adc = vchannel[4:3];

// When this strobes high, we begin a transaction with the ADC
reg start_stb;

//---------------------------------------------------------------------
// These are bits of the command-word and are defined in the datasheet
//---------------------------------------------------------------------
localparam SD  = 6;
localparam OS  = 5;
localparam S1  = 4;
localparam S0  = 3;
localparam COM = 2;
localparam UNI = 1;
localparam SLP = 0;

wire[6:0] command_word;

assign command_word[ SD] = 1;  // The ADC is in single-ended mode
assign command_word[ OS] = next_adc_ch[0];
assign command_word[ S1] = next_adc_ch[2];
assign command_word[ S0] = next_adc_ch[1];
assign command_word[COM] = 0;  // We're not using channel 7 as "common"
assign command_word[UNI] = 1;  // We want ADC values in straight-binary
assign command_word[SLP] = 0;  // We don't want ADC to enter sleep mode
//---------------------------------------------------------------------


//---------------------------------------------------------------------
// These are the outputs from the conversion state-machine
//---------------------------------------------------------------------
wire      idle;
reg       data_ready;
reg[15:0] adc_value;
//---------------------------------------------------------------------


//---------------------------------------------------------------------
// There is one ADC value per virtual channel.  Here we pack them into
// the output port "adc_values"
//---------------------------------------------------------------------
reg[15:0] adc[0:LAST_VCHAN];
//---------------------------------------------------------------------
for (i=0; i<=LAST_VCHAN; i=i+1) begin
    always @(posedge clk) begin
        if (resetn == 0)
            adc_values[i*16 +: 16] <= 0;
        else
            adc_values[i*16 +: 16] <= adc[i];        
    end
end
//---------------------------------------------------------------------



//=============================================================================
// This very simple state machine will start an ADC conversion on every virtual
// channel, looping through virtual channels forever
//
// After power-up, the first value we read from channel 0 from each ADC will
// be garbage.
//=============================================================================
always @(posedge clk) begin

    // This will strobe high for a single clock-cycle at a time
    start_stb <= 0;

    // Coming out of reset, we start with the 1st virtual channel
    if (resetn == 0) begin
        vchannel <= 0;
    end

    else if (idle) begin
        adc[vchannel] <= adc_value;
        vchannel      <= (vchannel == LAST_VCHAN) ? 0 : vchannel + 1;
        start_stb     <= 1;
    end
end
//=============================================================================




//=============================================================================
// From here down is a state machine that reads the currently available 
// ADC value, and starts the next conversion.  This state machine controls
// the SPI bus and slave-select lines
//
// Inputs: 
//    start_stb    = State machine begins when this strobes high
//    command_word = 7-bit command to clock out to the SPI bus
//    which_adc    = Which ADC are we addressing?  (0 thru ADC_COUNT-1)
//
// Outputs:
//    idle         = Asserted when this state machine is idle
//    adc_value    = The most recently read 16-bit ADC value
//=============================================================================
reg[1:0] csm_state;
localparam CSM_IDLE       = 0;
localparam CSM_CLOCK_BITS = 1;
localparam CSM_WAIT_ACQ   = 2;
localparam CSM_WAIT_CONV  = 3;

reg[ 6:0] mosi_sr;    // Shift register connected to SPI MOSI pin
reg[15:0] csm_sleep;  // A countdown timer
reg[ 4:0] bit_number; // Counts down from 15 to 0
//-----------------------------------------------------------------------------
always @(posedge clk) begin

    // This is a countdown timer
    if (csm_sleep) csm_sleep <= csm_sleep - 1;

    // Define our reset state
    if (resetn == 0) begin
        csm_state    <= CSM_IDLE;
        mosi_sr      <= 0;
        slave_select <= -1;
        spi_sclk     <= 0;
        adc_value    <= 0;
    end

    else case (csm_state)

        // If we're told to start:
        //   Load the command word into the MOSI shift register
        //   Set up the sleep timer for 40 nanoseconds
        //   Drive the appropriate slave-select pin low
        //   The next bit we clock in from SPI will be bit 15 of the ADC value
        //   Go wait for the ADC's SDO (i.e, MISO) pin to be valid
        CSM_IDLE:
            if (start_stb) begin
                mosi_sr      <= command_word;
                csm_sleep    <= 40 / NSEC_PER_CLK;
                slave_select <= ~(1 << which_adc);
                bit_number   <= 15;
                csm_state    <= CSM_CLOCK_BITS;
            end

        // After the sleep timer has expired
        //   If spi_sclk is currently low:
        //       Make spi_sclk high
        //       Clock in a data-bit on spi_miso
        //       Set up the sleep timer
        //   If spi_sclk is currently high:
        //       Make spi_sclk low
        //       Shift out the next bit of the command word 
        //       Either wait for the next sclk cycle, or go wait for signal 
        //       aquisition to complete.
        CSM_CLOCK_BITS:
            if (csm_sleep == 0) begin
                if (spi_sclk == 0) begin
                    spi_sclk  <= 1;
                    adc_value <= (adc_value << 1) | spi_miso;
                    csm_sleep <= SCLK_HALF_CYCLE - 1;
                end else begin
                    spi_sclk  <= 0;
                    mosi_sr   <= (mosi_sr << 1);

                    if (bit_number) begin
                        bit_number <= bit_number - 1;
                        csm_sleep  <= SCLK_HALF_CYCLE - 1; 
                    end else begin
                        csm_sleep  <= ACQ_CYCLES - 1;
                        csm_state  <= CSM_WAIT_ACQ;
                    end
                end
            end

        // Here we wait for ADC signal acquisition to complete.  Once it
        // does, we raise the slave-select to begin the next ADC conversion.
        CSM_WAIT_ACQ:
            if (csm_sleep == 0) begin
                slave_select <= -1;
                csm_sleep    <= CONV_CYCLES - 1;
                csm_state    <= CSM_WAIT_CONV;
            end

        // Here we wait for the ADC conversion to complete
        CSM_WAIT_CONV:
            if (csm_sleep == 0) begin
                csm_state <= CSM_IDLE;
            end
    endcase
end

// Tell the outside world when we're idle
assign idle = (csm_state == CSM_IDLE) & (start_stb == 0);

// The top bit of the MOSI shift-register gets driven to the SPI MOSI pin
assign spi_mosi = mosi_sr[6];
//=============================================================================

endmodule