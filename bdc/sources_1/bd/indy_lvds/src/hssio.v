module hssio
(

    input   clk,
    input   resetn, 

    // LVDS clock inputs
    input   LVDS_BANKA_CKIN_P, LVDS_BANKA_CKIN_N,
    input   LVDS_BANKB_CKIN_P, LVDS_BANKB_CKIN_N,
    input   LVDS_BANKC_CKIN_P, LVDS_BANKC_CKIN_N,

    // LVDS input pairs
    input[63:0]  LVDS_DN, LVDS_DP,

    // When this is asserted, the HSSIO banks are placed in reset
    input   cfg_reset_hssio,

    `ifdef INCLUDE_RIU
    //-------------------------------------------------------------------------
    // Software interface to all RIUs.   "riu_addr" selects the bank, byte-
    // group, and register number of the pariticular RIU/register being 
    // addressed
    //-------------------------------------------------------------------------
    //  cfg_riu_addr Bits 10:9 = Which bank (0 thru 2)
    //               Bits  8:7 = Byte group (0 thru 3)
    //               Bit     6 = Which nibble
    //               Bits  5:0 = Register number (0 thru 63)
    //-------------------------------------------------------------------------
    input      [10:0] cfg_riu_addr,
    input             cfg_riu_write_stb,
    input      [15:0] cfg_riu_wr_data,
    output reg        cfg_riu_rd_valid,
    output reg [15:0] cfg_riu_rd_data,
    //-------------------------------------------------------------------------
    `endif

    // Interface for writing calibration delays.
    input [63:0] cal_mask,
    input [11:0] cal_word,
    input        cal_word_wstb,
    output[ 2:0] cal_write_en,

    // Information reported about each lane
    input      [ 5:0] lane_select,
    output     [ 8:0] cal_delay_rd,  // rx_cntvalueout[lane]

    // The is the LVDS data output from this module
    output[511:0] lvds_bus

);
genvar i;
genvar lane;

// Bring the the definitions that map an HSSIO-pin to a lane
`include "lvds_lane_map.vh"

// We are controlling three HPIO banks on the FPGA
localparam BANK_COUNT = 3;

// Each HPIO bank contains four byte-groups
localparam BG_PER_BANK = 4;

// There is 1 RIU interface for each bank/byte-group
localparam RIU_COUNT = BANK_COUNT * BG_PER_BANK; 

// There are two nibbles per RIU
localparam NIBBLE_COUNT = RIU_COUNT * 2;

// There are 64 LVDS lanes
localparam LANE_COUNT = 64;

// This is the index of the first byte-group of each bank
localparam BG_A = 0;
localparam BG_B = 4;
localparam BG_C = 8;

// This is the index of the first nibble of each bank
localparam NIB_A =  0;
localparam NIB_B =  8;
localparam NIB_C = 16;

// In a 3-bit field, these are the indexes of the banks
localparam BANK_A = 0;
localparam BANK_B = 1;
localparam BANK_C = 2;

// If we're not including the RIU interface in the port-list, we need
// to define those ports as registers and wires.   The option to omit
// RIU control is here because software never touches the RIU
`ifndef INCLUDE_RIU
    wire [10:0] cfg_riu_addr      = 0;
    wire        cfg_riu_write_stb = 0;
    wire [15:0] cfg_riu_wr_data   = 0;
    reg         cfg_riu_rd_valid;
    reg  [15:0] cfg_riu_rd_data;
`endif

// Break riu_addr into its constituent components
wire[3:0] riu_index    = cfg_riu_addr[10:7];
wire      riu_nibble   = cfg_riu_addr[6];
wire[5:0] riu_register = cfg_riu_addr[5:0];

// Interface to the RIUs.  There is one RIU per byte-group per bank
wire       riu_nibble_sel[0:RIU_COUNT-1];   // To RIU
wire       riu_write_en  [0:RIU_COUNT-1];   // To RIU
wire       riu_rd_valid  [0:RIU_COUNT-1];   // From RIU
wire[15:0] riu_rd_data   [0:RIU_COUNT-1];   // From RIU

// Extract the "delay taps" portion of the calibration word
wire[8:0] cal_delay = cal_word[8:0];

// Each RIU nibble feeds us these two "ready" signals.  Bank C is missing a
// nibble, which is why these wires are 23 bits long instead of 24 bits long.
wire[NIBBLE_COUNT-1:0] vtc_rdy, dly_rdy;

// Bank C doesn't have an 8th nibble, so pretend the non-existent nibble
// is always ready
assign vtc_rdy[NIB_C + 7] = 1;
assign dly_rdy[NIB_C + 7] = 1;

// The HSSIO banks fill these in
wire[BANK_COUNT-1:0] fifo_rd_data_valid;
wire[BANK_COUNT-1:0] rst_seq_done;
wire[BANK_COUNT-1:0] pll0_locked_async, pll0_locked;
wire[BANK_COUNT-1:0] intf_rdy;

// 8-bits of LVDS data from each lane
wire[7:0] data_to_fabric[0:LANE_COUNT-1];

// This is "data_to_fabric", but with lane-inversions corrected
wire[7:0] corrected_lvds[0:LANE_COUNT-1];

// Tell the outside world when every RIU nibble is ready
wire all_vtc_rdy = &vtc_rdy;
wire all_dly_rdy = &dly_rdy;

// Strobe these high to load a new delay_tap into a lane
reg[LANE_COUNT-1:0] rx_load;

// These bits enable/disable VTC for a given lane
reg[LANE_COUNT-1:0] rx_en_vtc;

// From the LVDS banks
wire[LANE_COUNT-1:0] fifo_empty;

// These come from the lvds banks
wire[8:0] rx_cntvalueout[0:LANE_COUNT-1];

// Software selects which lane's information it wants to see
assign cal_delay_rd = rx_cntvalueout[lane_select];

//=============================================================================
// Some lanes are inverted.  Here we correct that
//=============================================================================
localparam [63:0] INVERTED_LANES = 64'hffb8_bf00_58b7_0844;  
for (lane=0; lane<LANE_COUNT; lane=lane+1) begin
    if (INVERTED_LANES[lane])
        assign corrected_lvds[lane] = ~data_to_fabric[lane];
    else
        assign corrected_lvds[lane] =  data_to_fabric[lane];
end
//=============================================================================


//=============================================================================
// Create a reset signal for the HSSIO banks
//=============================================================================
reg reset_hssio;
//-----------------------------------------------------------------------------
always @(posedge clk) begin
    reset_hssio <= (resetn == 0) | cfg_reset_hssio;
end
//=============================================================================



//=============================================================================
// Create a signal that tells us whether pll0 is locked for all three banks
//=============================================================================
reg multi_intf_lock_in;
//-----------------------------------------------------------------------------
always @(posedge clk) begin
    multi_intf_lock_in <= (reset_hssio) ? 0 : &pll0_locked;  
end
//=============================================================================


//=============================================================================
// Set/clear the nibble-select bit for each RIU.  
//=============================================================================
for (i=0; i<RIU_COUNT; i=i+1) begin
    assign riu_nibble_sel[i] = (riu_index == i) & riu_nibble;
end
//=============================================================================


//=============================================================================
// Set/clear the write-enable bit for each RIU. 
//=============================================================================
for (i=0; i<RIU_COUNT; i=i+1) begin
    assign riu_write_en[i] = (riu_index == i) & cfg_riu_write_stb;
end
//=============================================================================


//=============================================================================
// Fetch the "read data is valid" flag and the read-data for the currently 
// selected RIU.
//=============================================================================
always @(posedge clk) begin
    cfg_riu_rd_valid <= riu_rd_valid[riu_index];
    cfg_riu_rd_data  <= riu_rd_data[riu_index];
end
//=============================================================================


//=============================================================================
// This state machine is responsible for programming delay-taps.   The 
// software sets "cal_word" to the desired value, then strobes "cal_word_wstb"
// high as/ a signal to tell us to start.
//
// The programming algorithm is simple:
//
// (1) Disable VTC for selected lanes 
// (2) Wait at least 10 clock-cycles
// (3) Strobe the "rx_load" bit high for the selected lanes
// (4) Wait at least 10 clock-cycles
// (5) Re-enable VTC for all channels
//=============================================================================
reg[1:0] wdsm_state;
reg[3:0] wdsm_sleep;
//-----------------------------------------------------------------------------
always @(posedge clk) begin
    
    // This is a countdown timer for this state machine
    if (wdsm_sleep) wdsm_sleep <= wdsm_sleep - 1;

    // These bits strobe high for a single clock-cycle at a time
    rx_load <= 0;

    if (resetn == 0) begin
        wdsm_state <= 0;
        wdsm_sleep <= 0;
        rx_en_vtc  <= 64'hFFFF_FFFF_FFFF_FFFF;
    end

    else case (wdsm_state)
        
        // If we're told to write the delay taps, disable VTC for
        // the selected lanes
        0:  if (all_dly_rdy & all_vtc_rdy & cal_word_wstb) begin
                rx_en_vtc  <= ~cal_mask;
                wdsm_sleep <= 15;
                wdsm_state <= 1;
            end else
                rx_en_vtc  <= 64'hFFFF_FFFF_FFFF_FFFF;


        // After waiting the appropriate amount of time, load the delay taps
        // for the selected lanes
        1:  if (wdsm_sleep == 0) begin
                rx_load    <= cal_mask;
                wdsm_sleep <= 15;
                wdsm_state <= 2;
            end

        // Wait for delay-tap programming to complete
        2:  if (wdsm_sleep == 0) wdsm_state <= 0;

    endcase

end

// These are the conditions under which its safe to write a delay
wire delay_write_en = (wdsm_state == 0) & all_dly_rdy & all_vtc_rdy;

// Tell the outwise world when it's safe to strobe "cal_word_wstb"
assign cal_write_en = {all_dly_rdy, all_vtc_rdy, delay_write_en};
//=============================================================================



//=============================================================================
// Assemble the output bus "lvds_bus" from the corrected lanes
//=============================================================================
for (lane=0; lane<LANE_COUNT; lane=lane+1) begin
    assign lvds_bus[lane*8 +: 8] = corrected_lvds[lane];
end
//=============================================================================

//=============================================================================
// Sync "pll0_locked_async" into "pll0_locked"
//=============================================================================
xpm_cdc_array_single #
(
    .DEST_SYNC_FF   (3),
    .WIDTH          (BANK_COUNT),
    .SRC_INPUT_REG  (0)
)
i_sync_pll
(
    .src_clk  (),   
    .src_in   (pll0_locked_async),
    .dest_clk (clk), 
    .dest_out (pll0_locked) 
);
//=============================================================================


//=============================================================================
//                              Bank A
//=============================================================================
indy_lvds_bank69 u_lvds_bankA
(

    // The delay (in taps) for each lane
    .rx_cntvaluein_0 (cal_delay),       .rx_cntvalueout_0 (rx_cntvalueout[LANE_A0 ]),
    .rx_cntvaluein_2 (cal_delay),       .rx_cntvalueout_2 (rx_cntvalueout[LANE_A2 ]),
    .rx_cntvaluein_4 (cal_delay),       .rx_cntvalueout_4 (rx_cntvalueout[LANE_A4 ]),
    .rx_cntvaluein_6 (cal_delay),       .rx_cntvalueout_6 (rx_cntvalueout[LANE_A6 ]),
    .rx_cntvaluein_8 (cal_delay),       .rx_cntvalueout_8 (rx_cntvalueout[LANE_A8 ]),
    .rx_cntvaluein_10(cal_delay),       .rx_cntvalueout_10(rx_cntvalueout[LANE_A10]),
    .rx_cntvaluein_13(cal_delay),       .rx_cntvalueout_13(rx_cntvalueout[LANE_A13]),
    .rx_cntvaluein_15(cal_delay),       .rx_cntvalueout_15(rx_cntvalueout[LANE_A15]),
    .rx_cntvaluein_17(cal_delay),       .rx_cntvalueout_17(rx_cntvalueout[LANE_A17]),
    .rx_cntvaluein_19(cal_delay),       .rx_cntvalueout_19(rx_cntvalueout[LANE_A19]),
    .rx_cntvaluein_21(cal_delay),       .rx_cntvalueout_21(rx_cntvalueout[LANE_A21]),
    .rx_cntvaluein_23(cal_delay),       .rx_cntvalueout_23(rx_cntvalueout[LANE_A23]),
    .rx_cntvaluein_28(cal_delay),       .rx_cntvalueout_28(rx_cntvalueout[LANE_A28]),
    .rx_cntvaluein_30(cal_delay),       .rx_cntvalueout_30(rx_cntvalueout[LANE_A30]),
    .rx_cntvaluein_32(cal_delay),       .rx_cntvalueout_32(rx_cntvalueout[LANE_A32]),
    .rx_cntvaluein_34(cal_delay),       .rx_cntvalueout_34(rx_cntvalueout[LANE_A34]),
    .rx_cntvaluein_36(cal_delay),       .rx_cntvalueout_36(rx_cntvalueout[LANE_A36]),
    .rx_cntvaluein_39(cal_delay),       .rx_cntvalueout_39(rx_cntvalueout[LANE_A39]),
    .rx_cntvaluein_41(cal_delay),       .rx_cntvalueout_41(rx_cntvalueout[LANE_A41]),
    .rx_cntvaluein_43(cal_delay),       .rx_cntvalueout_43(rx_cntvalueout[LANE_A43]),
    .rx_cntvaluein_45(cal_delay),       .rx_cntvalueout_45(rx_cntvalueout[LANE_A45]),
    .rx_cntvaluein_47(cal_delay),       .rx_cntvalueout_47(rx_cntvalueout[LANE_A47]),
    .rx_cntvaluein_49(cal_delay),       .rx_cntvalueout_49(rx_cntvalueout[LANE_A49]),
    .rx_cntvaluein_26(0        ),       .rx_cntvalueout_26(),                        


    // "Load new delay" and "enable voltage/temperature compensation"
    .rx_load_0 (rx_load[LANE_A0 ]),     .rx_en_vtc_0 (rx_en_vtc[LANE_A0 ]),         
    .rx_load_2 (rx_load[LANE_A2 ]),     .rx_en_vtc_2 (rx_en_vtc[LANE_A2 ]),         
    .rx_load_4 (rx_load[LANE_A4 ]),     .rx_en_vtc_4 (rx_en_vtc[LANE_A4 ]),         
    .rx_load_6 (rx_load[LANE_A6 ]),     .rx_en_vtc_6 (rx_en_vtc[LANE_A6 ]),         
    .rx_load_8 (rx_load[LANE_A8 ]),     .rx_en_vtc_8 (rx_en_vtc[LANE_A8 ]),         
    .rx_load_10(rx_load[LANE_A10]),     .rx_en_vtc_10(rx_en_vtc[LANE_A10]),         
    .rx_load_13(rx_load[LANE_A13]),     .rx_en_vtc_13(rx_en_vtc[LANE_A13]),         
    .rx_load_15(rx_load[LANE_A15]),     .rx_en_vtc_15(rx_en_vtc[LANE_A15]),         
    .rx_load_17(rx_load[LANE_A17]),     .rx_en_vtc_17(rx_en_vtc[LANE_A17]),         
    .rx_load_19(rx_load[LANE_A19]),     .rx_en_vtc_19(rx_en_vtc[LANE_A19]),         
    .rx_load_21(rx_load[LANE_A21]),     .rx_en_vtc_21(rx_en_vtc[LANE_A21]),         
    .rx_load_23(rx_load[LANE_A23]),     .rx_en_vtc_23(rx_en_vtc[LANE_A23]),         
    .rx_load_28(rx_load[LANE_A28]),     .rx_en_vtc_28(rx_en_vtc[LANE_A28]),         
    .rx_load_30(rx_load[LANE_A30]),     .rx_en_vtc_30(rx_en_vtc[LANE_A30]),         
    .rx_load_32(rx_load[LANE_A32]),     .rx_en_vtc_32(rx_en_vtc[LANE_A32]),         
    .rx_load_34(rx_load[LANE_A34]),     .rx_en_vtc_34(rx_en_vtc[LANE_A34]),         
    .rx_load_36(rx_load[LANE_A36]),     .rx_en_vtc_36(rx_en_vtc[LANE_A36]),         
    .rx_load_39(rx_load[LANE_A39]),     .rx_en_vtc_39(rx_en_vtc[LANE_A39]),         
    .rx_load_41(rx_load[LANE_A41]),     .rx_en_vtc_41(rx_en_vtc[LANE_A41]),         
    .rx_load_43(rx_load[LANE_A43]),     .rx_en_vtc_43(rx_en_vtc[LANE_A43]),         
    .rx_load_45(rx_load[LANE_A45]),     .rx_en_vtc_45(rx_en_vtc[LANE_A45]),         
    .rx_load_47(rx_load[LANE_A47]),     .rx_en_vtc_47(rx_en_vtc[LANE_A47]),         
    .rx_load_49(rx_load[LANE_A49]),     .rx_en_vtc_49(rx_en_vtc[LANE_A49]),         
    .rx_load_26(0),                     .rx_en_vtc_26(0),                           



    // We don't use any of these fields
    .rx_ce_0 (0),                       .rx_inc_0 (0),   
    .rx_ce_2 (0),                       .rx_inc_2 (0),   
    .rx_ce_4 (0),                       .rx_inc_4 (0),   
    .rx_ce_6 (0),                       .rx_inc_6 (0),   
    .rx_ce_8 (0),                       .rx_inc_8 (0),   
    .rx_ce_10(0),                       .rx_inc_10(0),   
    .rx_ce_13(0),                       .rx_inc_13(0),   
    .rx_ce_15(0),                       .rx_inc_15(0),   
    .rx_ce_17(0),                       .rx_inc_17(0),   
    .rx_ce_19(0),                       .rx_inc_19(0),   
    .rx_ce_21(0),                       .rx_inc_21(0),   
    .rx_ce_23(0),                       .rx_inc_23(0),   
    .rx_ce_28(0),                       .rx_inc_28(0),   
    .rx_ce_30(0),                       .rx_inc_30(0),   
    .rx_ce_32(0),                       .rx_inc_32(0),   
    .rx_ce_34(0),                       .rx_inc_34(0),   
    .rx_ce_36(0),                       .rx_inc_36(0),   
    .rx_ce_39(0),                       .rx_inc_39(0),   
    .rx_ce_41(0),                       .rx_inc_41(0),   
    .rx_ce_43(0),                       .rx_inc_43(0),   
    .rx_ce_45(0),                       .rx_inc_45(0),   
    .rx_ce_47(0),                       .rx_inc_47(0),   
    .rx_ce_49(0),                       .rx_inc_49(0),   
    .rx_ce_26(0),                       .rx_inc_26(0),   

    // FIFO clk, read-enable, and empty flag
    .fifo_rd_clk_0 (clk),               .fifo_empty_0 (fifo_empty[LANE_A0 ]),
    .fifo_rd_clk_2 (clk),               .fifo_empty_2 (fifo_empty[LANE_A2 ]),
    .fifo_rd_clk_4 (clk),               .fifo_empty_4 (fifo_empty[LANE_A4 ]),
    .fifo_rd_clk_6 (clk),               .fifo_empty_6 (fifo_empty[LANE_A6 ]),
    .fifo_rd_clk_8 (clk),               .fifo_empty_8 (fifo_empty[LANE_A8 ]),
    .fifo_rd_clk_10(clk),               .fifo_empty_10(fifo_empty[LANE_A10]),
    .fifo_rd_clk_13(clk),               .fifo_empty_13(fifo_empty[LANE_A13]),
    .fifo_rd_clk_15(clk),               .fifo_empty_15(fifo_empty[LANE_A15]),
    .fifo_rd_clk_17(clk),               .fifo_empty_17(fifo_empty[LANE_A17]),
    .fifo_rd_clk_19(clk),               .fifo_empty_19(fifo_empty[LANE_A19]),
    .fifo_rd_clk_21(clk),               .fifo_empty_21(fifo_empty[LANE_A21]),
    .fifo_rd_clk_23(clk),               .fifo_empty_23(fifo_empty[LANE_A23]),
    .fifo_rd_clk_28(clk),               .fifo_empty_28(fifo_empty[LANE_A28]),
    .fifo_rd_clk_30(clk),               .fifo_empty_30(fifo_empty[LANE_A30]),
    .fifo_rd_clk_32(clk),               .fifo_empty_32(fifo_empty[LANE_A32]),
    .fifo_rd_clk_34(clk),               .fifo_empty_34(fifo_empty[LANE_A34]),
    .fifo_rd_clk_36(clk),               .fifo_empty_36(fifo_empty[LANE_A36]),
    .fifo_rd_clk_39(clk),               .fifo_empty_39(fifo_empty[LANE_A39]),
    .fifo_rd_clk_41(clk),               .fifo_empty_41(fifo_empty[LANE_A41]),
    .fifo_rd_clk_43(clk),               .fifo_empty_43(fifo_empty[LANE_A43]),
    .fifo_rd_clk_45(clk),               .fifo_empty_45(fifo_empty[LANE_A45]),
    .fifo_rd_clk_47(clk),               .fifo_empty_47(fifo_empty[LANE_A47]),
    .fifo_rd_clk_49(clk),               .fifo_empty_49(fifo_empty[LANE_A49]),
    .fifo_rd_clk_26(clk),               .fifo_empty_26(                    ),

    //-------------------------------------------------------------------------
    //             Interface to the Register Interface Units
    //-------------------------------------------------------------------------
    .riu_rd_data_bg0    (riu_rd_data [BG_A + 0]),
    .riu_rd_data_bg1    (riu_rd_data [BG_A + 1]),
    .riu_rd_data_bg2    (riu_rd_data [BG_A + 2]),
    .riu_rd_data_bg3    (riu_rd_data [BG_A + 3]),
    //-------------------------------------------------------------------------
    .riu_valid_bg0      (riu_rd_valid[BG_A + 0]),
    .riu_valid_bg1      (riu_rd_valid[BG_A + 1]),
    .riu_valid_bg2      (riu_rd_valid[BG_A + 2]),
    .riu_valid_bg3      (riu_rd_valid[BG_A + 3]),
    //-------------------------------------------------------------------------
    .riu_addr_bg0       (riu_register),
    .riu_addr_bg1       (riu_register),
    .riu_addr_bg2       (riu_register),
    .riu_addr_bg3       (riu_register),
     //-------------------------------------------------------------------------
    .riu_nibble_sel_bg0 (riu_nibble_sel[BG_A + 0]),
    .riu_nibble_sel_bg1 (riu_nibble_sel[BG_A + 1]),
    .riu_nibble_sel_bg2 (riu_nibble_sel[BG_A + 2]),
    .riu_nibble_sel_bg3 (riu_nibble_sel[BG_A + 3]),
    //-------------------------------------------------------------------------
    .riu_wr_data_bg0    (cfg_riu_wr_data),
    .riu_wr_data_bg1    (cfg_riu_wr_data),
    .riu_wr_data_bg2    (cfg_riu_wr_data),
    .riu_wr_data_bg3    (cfg_riu_wr_data),
    //-------------------------------------------------------------------------
    .riu_wr_en_bg0      (riu_write_en[BG_A + 0]),
    .riu_wr_en_bg1      (riu_write_en[BG_A + 1]),
    .riu_wr_en_bg2      (riu_write_en[BG_A + 2]),
    .riu_wr_en_bg3      (riu_write_en[BG_A + 3]),
    //-------------------------------------------------------------------------


    .en_vtc_bsc0(1),   .vtc_rdy_bsc0(vtc_rdy[NIB_A + 0]),   .dly_rdy_bsc0(dly_rdy[NIB_A + 0]),
    .en_vtc_bsc1(1),   .vtc_rdy_bsc1(vtc_rdy[NIB_A + 1]),   .dly_rdy_bsc1(dly_rdy[NIB_A + 1]),
    .en_vtc_bsc2(1),   .vtc_rdy_bsc2(vtc_rdy[NIB_A + 2]),   .dly_rdy_bsc2(dly_rdy[NIB_A + 2]),
    .en_vtc_bsc3(1),   .vtc_rdy_bsc3(vtc_rdy[NIB_A + 3]),   .dly_rdy_bsc3(dly_rdy[NIB_A + 3]),
    .en_vtc_bsc4(1),   .vtc_rdy_bsc4(vtc_rdy[NIB_A + 4]),   .dly_rdy_bsc4(dly_rdy[NIB_A + 4]),
    .en_vtc_bsc5(1),   .vtc_rdy_bsc5(vtc_rdy[NIB_A + 5]),   .dly_rdy_bsc5(dly_rdy[NIB_A + 5]),
    .en_vtc_bsc6(1),   .vtc_rdy_bsc6(vtc_rdy[NIB_A + 6]),   .dly_rdy_bsc6(dly_rdy[NIB_A + 6]),
    .en_vtc_bsc7(1),   .vtc_rdy_bsc7(vtc_rdy[NIB_A + 7]),   .dly_rdy_bsc7(dly_rdy[NIB_A + 7]),


    // LVDS lanes in, data-out
    .D44_P(LVDS_DP[44]), .D44_N(LVDS_DN[44]), .data_to_fabric_D44_N(data_to_fabric[44]),
    .D45_P(LVDS_DP[45]), .D45_N(LVDS_DN[45]), .data_to_fabric_D45_N(data_to_fabric[45]),
    .D54_P(LVDS_DP[54]), .D54_N(LVDS_DN[54]), .data_to_fabric_D54_P(data_to_fabric[54]),
    .D43_P(LVDS_DP[43]), .D43_N(LVDS_DN[43]), .data_to_fabric_D43_N(data_to_fabric[43]),
    .D47_P(LVDS_DP[47]), .D47_N(LVDS_DN[47]), .data_to_fabric_D47_N(data_to_fabric[47]),
    .D37_P(LVDS_DP[37]), .D37_N(LVDS_DN[37]), .data_to_fabric_D37_P(data_to_fabric[37]),
    .D50_P(LVDS_DP[50]), .D50_N(LVDS_DN[50]), .data_to_fabric_D50_P(data_to_fabric[50]),
    .D48_P(LVDS_DP[48]), .D48_N(LVDS_DN[48]), .data_to_fabric_D48_P(data_to_fabric[48]),
    .D32_P(LVDS_DP[32]), .D32_N(LVDS_DN[32]), .data_to_fabric_D32_P(data_to_fabric[32]),
    .D55_P(LVDS_DP[55]), .D55_N(LVDS_DN[55]), .data_to_fabric_D55_N(data_to_fabric[55]),
    .D61_P(LVDS_DP[61]), .D61_N(LVDS_DN[61]), .data_to_fabric_D61_N(data_to_fabric[61]),
    .D49_P(LVDS_DP[49]), .D49_N(LVDS_DN[49]), .data_to_fabric_D49_P(data_to_fabric[49]),
    .D56_P(LVDS_DP[56]), .D56_N(LVDS_DN[56]), .data_to_fabric_D56_N(data_to_fabric[56]),
    .D53_P(LVDS_DP[53]), .D53_N(LVDS_DN[53]), .data_to_fabric_D53_N(data_to_fabric[53]),
    .D51_P(LVDS_DP[51]), .D51_N(LVDS_DN[51]), .data_to_fabric_D51_N(data_to_fabric[51]),
    .D62_P(LVDS_DP[62]), .D62_N(LVDS_DN[62]), .data_to_fabric_D62_N(data_to_fabric[62]),
    .D58_P(LVDS_DP[58]), .D58_N(LVDS_DN[58]), .data_to_fabric_D58_N(data_to_fabric[58]),
    .D57_P(LVDS_DP[57]), .D57_N(LVDS_DN[57]), .data_to_fabric_D57_N(data_to_fabric[57]),
    .D59_P(LVDS_DP[59]), .D59_N(LVDS_DN[59]), .data_to_fabric_D59_N(data_to_fabric[59]),
    .D52_P(LVDS_DP[52]), .D52_N(LVDS_DN[52]), .data_to_fabric_D52_N(data_to_fabric[52]),
    .D60_P(LVDS_DP[60]), .D60_N(LVDS_DN[60]), .data_to_fabric_D60_N(data_to_fabric[60]),
    .D63_P(LVDS_DP[63]), .D63_N(LVDS_DN[63]), .data_to_fabric_D63_N(data_to_fabric[63]),
    .D5_P (LVDS_DP[ 5]), .D5_N (LVDS_DN[ 5]), .data_to_fabric_D5_P (data_to_fabric[ 5]),

    // Other signals
    .clk                (clk),
    .rx_clk             (clk),
    .app_clk            (clk),
    .riu_clk            (clk),
    .rst                (reset_hssio),
    .CLK512_N           (LVDS_BANKA_CKIN_N),
    .CLK512_P           (LVDS_BANKA_CKIN_P),   
    .rst_seq_done       (rst_seq_done     [BANK_A]),
    .pll0_locked        (pll0_locked_async[BANK_A]),
    .intf_rdy           (intf_rdy         [BANK_A]),
    .multi_intf_lock_in (multi_intf_lock_in),
    .fifo_rd_data_valid (fifo_rd_data_valid[BANK_A]),    

    // Unused signals
    .data_to_fabric_CLK512_P(), 
    .shared_pll0_clkoutphy_out(),
    .pll0_clkout0()
);
//=============================================================================



//=============================================================================
//                              Bank B
//=============================================================================
indy_lvds_bank70 u_lvds_bankB
(
    // The delay (in taps) for each lane
    .rx_cntvaluein_0 (cal_delay),           .rx_cntvalueout_0 (rx_cntvalueout[LANE_B0 ]),  
    .rx_cntvaluein_2 (cal_delay),           .rx_cntvalueout_2 (rx_cntvalueout[LANE_B2 ]),  
    .rx_cntvaluein_4 (cal_delay),           .rx_cntvalueout_4 (rx_cntvalueout[LANE_B4 ]),  
    .rx_cntvaluein_6 (cal_delay),           .rx_cntvalueout_6 (rx_cntvalueout[LANE_B6 ]),  
    .rx_cntvaluein_8 (cal_delay),           .rx_cntvalueout_8 (rx_cntvalueout[LANE_B8 ]),  
    .rx_cntvaluein_10(cal_delay),           .rx_cntvalueout_10(rx_cntvalueout[LANE_B10]),  
    .rx_cntvaluein_13(cal_delay),           .rx_cntvalueout_13(rx_cntvalueout[LANE_B13]),  
    .rx_cntvaluein_15(cal_delay),           .rx_cntvalueout_15(rx_cntvalueout[LANE_B15]),  
    .rx_cntvaluein_17(cal_delay),           .rx_cntvalueout_17(rx_cntvalueout[LANE_B17]),  
    .rx_cntvaluein_19(cal_delay),           .rx_cntvalueout_19(rx_cntvalueout[LANE_B19]),  
    .rx_cntvaluein_21(cal_delay),           .rx_cntvalueout_21(rx_cntvalueout[LANE_B21]),  
    .rx_cntvaluein_26(cal_delay),           .rx_cntvalueout_26(rx_cntvalueout[LANE_B26]),  
    .rx_cntvaluein_28(cal_delay),           .rx_cntvalueout_28(rx_cntvalueout[LANE_B28]),  
    .rx_cntvaluein_30(cal_delay),           .rx_cntvalueout_30(rx_cntvalueout[LANE_B30]),  
    .rx_cntvaluein_34(cal_delay),           .rx_cntvalueout_34(rx_cntvalueout[LANE_B34]),  
    .rx_cntvaluein_36(cal_delay),           .rx_cntvalueout_36(rx_cntvalueout[LANE_B36]),  
    .rx_cntvaluein_39(cal_delay),           .rx_cntvalueout_39(rx_cntvalueout[LANE_B39]),  
    .rx_cntvaluein_41(cal_delay),           .rx_cntvalueout_41(rx_cntvalueout[LANE_B41]),  
    .rx_cntvaluein_43(cal_delay),           .rx_cntvalueout_43(rx_cntvalueout[LANE_B43]),  
    .rx_cntvaluein_45(cal_delay),           .rx_cntvalueout_45(rx_cntvalueout[LANE_B45]),  
    .rx_cntvaluein_47(cal_delay),           .rx_cntvalueout_47(rx_cntvalueout[LANE_B47]),  
    .rx_cntvaluein_49(cal_delay),           .rx_cntvalueout_49(rx_cntvalueout[LANE_B49]),  
    .rx_cntvaluein_32(0        ),           .rx_cntvalueout_32(                        ),                          


    // "Load new delay" and "enable voltage/temperature compensation"
    .rx_load_0 (rx_load[LANE_B0 ]),     .rx_en_vtc_0 (rx_en_vtc[LANE_B0 ]),             
    .rx_load_2 (rx_load[LANE_B2 ]),     .rx_en_vtc_2 (rx_en_vtc[LANE_B2 ]),             
    .rx_load_4 (rx_load[LANE_B4 ]),     .rx_en_vtc_4 (rx_en_vtc[LANE_B4 ]),             
    .rx_load_6 (rx_load[LANE_B6 ]),     .rx_en_vtc_6 (rx_en_vtc[LANE_B6 ]),             
    .rx_load_8 (rx_load[LANE_B8 ]),     .rx_en_vtc_8 (rx_en_vtc[LANE_B8 ]),             
    .rx_load_10(rx_load[LANE_B10]),     .rx_en_vtc_10(rx_en_vtc[LANE_B10]),             
    .rx_load_13(rx_load[LANE_B13]),     .rx_en_vtc_13(rx_en_vtc[LANE_B13]),             
    .rx_load_15(rx_load[LANE_B15]),     .rx_en_vtc_15(rx_en_vtc[LANE_B15]),             
    .rx_load_17(rx_load[LANE_B17]),     .rx_en_vtc_17(rx_en_vtc[LANE_B17]),             
    .rx_load_19(rx_load[LANE_B19]),     .rx_en_vtc_19(rx_en_vtc[LANE_B19]),             
    .rx_load_21(rx_load[LANE_B21]),     .rx_en_vtc_21(rx_en_vtc[LANE_B21]),             
    .rx_load_26(rx_load[LANE_B26]),     .rx_en_vtc_26(rx_en_vtc[LANE_B26]),             
    .rx_load_28(rx_load[LANE_B28]),     .rx_en_vtc_28(rx_en_vtc[LANE_B28]),             
    .rx_load_30(rx_load[LANE_B30]),     .rx_en_vtc_30(rx_en_vtc[LANE_B30]),             
    .rx_load_34(rx_load[LANE_B34]),     .rx_en_vtc_34(rx_en_vtc[LANE_B34]),             
    .rx_load_36(rx_load[LANE_B36]),     .rx_en_vtc_36(rx_en_vtc[LANE_B36]),             
    .rx_load_39(rx_load[LANE_B39]),     .rx_en_vtc_39(rx_en_vtc[LANE_B39]),             
    .rx_load_41(rx_load[LANE_B41]),     .rx_en_vtc_41(rx_en_vtc[LANE_B41]),             
    .rx_load_43(rx_load[LANE_B43]),     .rx_en_vtc_43(rx_en_vtc[LANE_B43]),             
    .rx_load_45(rx_load[LANE_B45]),     .rx_en_vtc_45(rx_en_vtc[LANE_B45]),             
    .rx_load_47(rx_load[LANE_B47]),     .rx_en_vtc_47(rx_en_vtc[LANE_B47]),             
    .rx_load_49(rx_load[LANE_B49]),     .rx_en_vtc_49(rx_en_vtc[LANE_B49]),             
    .rx_load_32(0                ),     .rx_en_vtc_32(0),                                               


    // We don't use any of these fields
    .rx_ce_0 (0),                       .rx_inc_0 (0), 
    .rx_ce_2 (0),                       .rx_inc_2 (0), 
    .rx_ce_4 (0),                       .rx_inc_4 (0), 
    .rx_ce_6 (0),                       .rx_inc_6 (0), 
    .rx_ce_8 (0),                       .rx_inc_8 (0), 
    .rx_ce_10(0),                       .rx_inc_10(0), 
    .rx_ce_13(0),                       .rx_inc_13(0), 
    .rx_ce_15(0),                       .rx_inc_15(0), 
    .rx_ce_17(0),                       .rx_inc_17(0), 
    .rx_ce_19(0),                       .rx_inc_19(0), 
    .rx_ce_21(0),                       .rx_inc_21(0), 
    .rx_ce_26(0),                       .rx_inc_26(0), 
    .rx_ce_28(0),                       .rx_inc_28(0), 
    .rx_ce_30(0),                       .rx_inc_30(0), 
    .rx_ce_34(0),                       .rx_inc_34(0), 
    .rx_ce_36(0),                       .rx_inc_36(0), 
    .rx_ce_39(0),                       .rx_inc_39(0), 
    .rx_ce_41(0),                       .rx_inc_41(0), 
    .rx_ce_43(0),                       .rx_inc_43(0), 
    .rx_ce_45(0),                       .rx_inc_45(0), 
    .rx_ce_47(0),                       .rx_inc_47(0), 
    .rx_ce_49(0),                       .rx_inc_49(0), 
    .rx_ce_32(0),                       .rx_inc_32(0), 

    // FIFO clk, read-enable, and empty flag
    .fifo_rd_clk_0 (clk),               .fifo_empty_0 (fifo_empty[LANE_B0 ]),
    .fifo_rd_clk_2 (clk),               .fifo_empty_2 (fifo_empty[LANE_B2 ]),
    .fifo_rd_clk_4 (clk),               .fifo_empty_4 (fifo_empty[LANE_B4 ]),
    .fifo_rd_clk_6 (clk),               .fifo_empty_6 (fifo_empty[LANE_B6 ]),
    .fifo_rd_clk_8 (clk),               .fifo_empty_8 (fifo_empty[LANE_B8 ]),
    .fifo_rd_clk_10(clk),               .fifo_empty_10(fifo_empty[LANE_B10]),
    .fifo_rd_clk_13(clk),               .fifo_empty_13(fifo_empty[LANE_B13]),
    .fifo_rd_clk_15(clk),               .fifo_empty_15(fifo_empty[LANE_B15]),
    .fifo_rd_clk_17(clk),               .fifo_empty_17(fifo_empty[LANE_B17]),
    .fifo_rd_clk_19(clk),               .fifo_empty_19(fifo_empty[LANE_B19]),
    .fifo_rd_clk_21(clk),               .fifo_empty_21(fifo_empty[LANE_B21]),
    .fifo_rd_clk_26(clk),               .fifo_empty_26(fifo_empty[LANE_B26]),
    .fifo_rd_clk_28(clk),               .fifo_empty_28(fifo_empty[LANE_B28]),
    .fifo_rd_clk_30(clk),               .fifo_empty_30(fifo_empty[LANE_B30]),
    .fifo_rd_clk_34(clk),               .fifo_empty_34(fifo_empty[LANE_B34]),
    .fifo_rd_clk_36(clk),               .fifo_empty_36(fifo_empty[LANE_B36]),
    .fifo_rd_clk_39(clk),               .fifo_empty_39(fifo_empty[LANE_B39]),
    .fifo_rd_clk_41(clk),               .fifo_empty_41(fifo_empty[LANE_B41]),
    .fifo_rd_clk_43(clk),               .fifo_empty_43(fifo_empty[LANE_B43]),
    .fifo_rd_clk_45(clk),               .fifo_empty_45(fifo_empty[LANE_B45]),
    .fifo_rd_clk_47(clk),               .fifo_empty_47(fifo_empty[LANE_B47]),
    .fifo_rd_clk_49(clk),               .fifo_empty_49(fifo_empty[LANE_B49]),
    .fifo_rd_clk_32(clk),               .fifo_empty_32(                    ),

    //-------------------------------------------------------------------------
    //             Interface to the Register Interface Units
    //-------------------------------------------------------------------------
    .riu_rd_data_bg0    (riu_rd_data [BG_B + 0]),
    .riu_rd_data_bg1    (riu_rd_data [BG_B + 1]),
    .riu_rd_data_bg2    (riu_rd_data [BG_B + 2]),
    .riu_rd_data_bg3    (riu_rd_data [BG_B + 3]),
    //-------------------------------------------------------------------------
    .riu_valid_bg0      (riu_rd_valid[BG_B + 0]),
    .riu_valid_bg1      (riu_rd_valid[BG_B + 1]),
    .riu_valid_bg2      (riu_rd_valid[BG_B + 2]),
    .riu_valid_bg3      (riu_rd_valid[BG_B + 3]),
    //-------------------------------------------------------------------------
    .riu_addr_bg0       (riu_register),
    .riu_addr_bg1       (riu_register),
    .riu_addr_bg2       (riu_register),
    .riu_addr_bg3       (riu_register),
     //-------------------------------------------------------------------------
    .riu_nibble_sel_bg0 (riu_nibble_sel[BG_B + 0]),
    .riu_nibble_sel_bg1 (riu_nibble_sel[BG_B + 1]),
    .riu_nibble_sel_bg2 (riu_nibble_sel[BG_B + 2]),
    .riu_nibble_sel_bg3 (riu_nibble_sel[BG_B + 3]),
    //-------------------------------------------------------------------------
    .riu_wr_data_bg0    (cfg_riu_wr_data),
    .riu_wr_data_bg1    (cfg_riu_wr_data),
    .riu_wr_data_bg2    (cfg_riu_wr_data),
    .riu_wr_data_bg3    (cfg_riu_wr_data),
    //-------------------------------------------------------------------------
    .riu_wr_en_bg0      (riu_write_en[BG_B + 0]),
    .riu_wr_en_bg1      (riu_write_en[BG_B + 1]),
    .riu_wr_en_bg2      (riu_write_en[BG_B + 2]),
    .riu_wr_en_bg3      (riu_write_en[BG_B + 3]),
    //-------------------------------------------------------------------------

    .en_vtc_bsc0(1),   .vtc_rdy_bsc0(vtc_rdy[NIB_B + 0]),   .dly_rdy_bsc0(dly_rdy[NIB_B + 0]),
    .en_vtc_bsc1(1),   .vtc_rdy_bsc1(vtc_rdy[NIB_B + 1]),   .dly_rdy_bsc1(dly_rdy[NIB_B + 1]),
    .en_vtc_bsc2(1),   .vtc_rdy_bsc2(vtc_rdy[NIB_B + 2]),   .dly_rdy_bsc2(dly_rdy[NIB_B + 2]),
    .en_vtc_bsc3(1),   .vtc_rdy_bsc3(vtc_rdy[NIB_B + 3]),   .dly_rdy_bsc3(dly_rdy[NIB_B + 3]),
    .en_vtc_bsc4(1),   .vtc_rdy_bsc4(vtc_rdy[NIB_B + 4]),   .dly_rdy_bsc4(dly_rdy[NIB_B + 4]),
    .en_vtc_bsc5(1),   .vtc_rdy_bsc5(vtc_rdy[NIB_B + 5]),   .dly_rdy_bsc5(dly_rdy[NIB_B + 5]),
    .en_vtc_bsc6(1),   .vtc_rdy_bsc6(vtc_rdy[NIB_B + 6]),   .dly_rdy_bsc6(dly_rdy[NIB_B + 6]),
    .en_vtc_bsc7(1),   .vtc_rdy_bsc7(vtc_rdy[NIB_B + 7]),   .dly_rdy_bsc7(dly_rdy[NIB_B + 7]),


    // LVDS lanes in, data-out
    .D7_P (LVDS_DP[ 7]), .D7_N (LVDS_DN[ 7]), .data_to_fabric_D7_P (data_to_fabric[ 7]),
    .D2_P (LVDS_DP[ 2]), .D2_N (LVDS_DN[ 2]), .data_to_fabric_D2_N (data_to_fabric[ 2]),
    .D22_P(LVDS_DP[22]), .D22_N(LVDS_DN[22]), .data_to_fabric_D22_P(data_to_fabric[22]),
    .D4_P (LVDS_DP[ 4]), .D4_N (LVDS_DN[ 4]), .data_to_fabric_D4_P (data_to_fabric[ 4]),
    .D0_P (LVDS_DP[ 0]), .D0_N (LVDS_DN[ 0]), .data_to_fabric_D0_P (data_to_fabric[ 0]),
    .D3_P (LVDS_DP[ 3]), .D3_N (LVDS_DN[ 3]), .data_to_fabric_D3_P (data_to_fabric[ 3]),
    .D15_P(LVDS_DP[15]), .D15_N(LVDS_DN[15]), .data_to_fabric_D15_P(data_to_fabric[15]),
    .D1_P (LVDS_DP[ 1]), .D1_N (LVDS_DN[ 1]), .data_to_fabric_D1_P (data_to_fabric[ 1]),
    .D9_P (LVDS_DP[ 9]), .D9_N (LVDS_DN[ 9]), .data_to_fabric_D9_P (data_to_fabric[ 9]),
    .D10_P(LVDS_DP[10]), .D10_N(LVDS_DN[10]), .data_to_fabric_D10_P(data_to_fabric[10]),
    .D8_P (LVDS_DP[ 8]), .D8_N (LVDS_DN[ 8]), .data_to_fabric_D8_P (data_to_fabric[ 8]),
    .D34_P(LVDS_DP[34]), .D34_N(LVDS_DN[34]), .data_to_fabric_D34_P(data_to_fabric[34]),
    .D11_P(LVDS_DP[11]), .D11_N(LVDS_DN[11]), .data_to_fabric_D11_N(data_to_fabric[11]),
    .D6_P (LVDS_DP[ 6]), .D6_N (LVDS_DN[ 6]), .data_to_fabric_D6_N (data_to_fabric[ 6]),
    .D33_P(LVDS_DP[33]), .D33_N(LVDS_DN[33]), .data_to_fabric_D33_P(data_to_fabric[33]),
    .D42_P(LVDS_DP[42]), .D42_N(LVDS_DN[42]), .data_to_fabric_D42_N(data_to_fabric[42]),
    .D36_P(LVDS_DP[36]), .D36_N(LVDS_DN[36]), .data_to_fabric_D36_P(data_to_fabric[36]),
    .D40_P(LVDS_DP[40]), .D40_N(LVDS_DN[40]), .data_to_fabric_D40_N(data_to_fabric[40]),
    .D41_P(LVDS_DP[41]), .D41_N(LVDS_DN[41]), .data_to_fabric_D41_N(data_to_fabric[41]),
    .D35_P(LVDS_DP[35]), .D35_N(LVDS_DN[35]), .data_to_fabric_D35_P(data_to_fabric[35]),
    .D39_P(LVDS_DP[39]), .D39_N(LVDS_DN[39]), .data_to_fabric_D39_P(data_to_fabric[39]),
    .D38_P(LVDS_DP[38]), .D38_N(LVDS_DN[38]), .data_to_fabric_D38_P(data_to_fabric[38]),

    // Other signals
    .clk                (clk),
    .rx_clk             (clk),
    .app_clk            (clk),
    .riu_clk            (clk),
    .rst                (reset_hssio),
    .CLK512_N           (LVDS_BANKB_CKIN_N),
    .CLK512_P           (LVDS_BANKB_CKIN_P),   
    .rst_seq_done       (rst_seq_done     [BANK_B]),
    .pll0_locked        (pll0_locked_async[BANK_B]),
    .intf_rdy           (intf_rdy         [BANK_B]),
    .multi_intf_lock_in (multi_intf_lock_in),
    .fifo_rd_data_valid (fifo_rd_data_valid[BANK_B]),    

    // Unused signals
    .data_to_fabric_CLK512_N(), 
    .shared_pll0_clkoutphy_out(),
    .pll0_clkout0()
);
//=============================================================================



//=============================================================================
//                              Bank C
//=============================================================================
indy_lvds_bank71 u_lvds_bankC
(
    // The delay (in taps) for each lane
    .rx_cntvaluein_0 (cal_delay),        .rx_cntvalueout_0 (rx_cntvalueout[LANE_C0 ]),                          
    .rx_cntvaluein_2 (cal_delay),        .rx_cntvalueout_2 (rx_cntvalueout[LANE_C2 ]),                          
    .rx_cntvaluein_4 (cal_delay),        .rx_cntvalueout_4 (rx_cntvalueout[LANE_C4 ]),                          
    .rx_cntvaluein_6 (cal_delay),        .rx_cntvalueout_6 (rx_cntvalueout[LANE_C6 ]),                          
    .rx_cntvaluein_8 (cal_delay),        .rx_cntvalueout_8 (rx_cntvalueout[LANE_C8 ]),                          
    .rx_cntvaluein_10(cal_delay),        .rx_cntvalueout_10(rx_cntvalueout[LANE_C10]),                          
    .rx_cntvaluein_13(cal_delay),        .rx_cntvalueout_13(rx_cntvalueout[LANE_C13]),                          
    .rx_cntvaluein_15(cal_delay),        .rx_cntvalueout_15(rx_cntvalueout[LANE_C15]),                          
    .rx_cntvaluein_17(cal_delay),        .rx_cntvalueout_17(rx_cntvalueout[LANE_C17]),                          
    .rx_cntvaluein_19(cal_delay),        .rx_cntvalueout_19(rx_cntvalueout[LANE_C19]),                          
    .rx_cntvaluein_23(cal_delay),        .rx_cntvalueout_23(rx_cntvalueout[LANE_C23]),                          
    .rx_cntvaluein_28(cal_delay),        .rx_cntvalueout_28(rx_cntvalueout[LANE_C28]),                          
    .rx_cntvaluein_30(cal_delay),        .rx_cntvalueout_30(rx_cntvalueout[LANE_C30]),                          
    .rx_cntvaluein_32(cal_delay),        .rx_cntvalueout_32(rx_cntvalueout[LANE_C32]),                          
    .rx_cntvaluein_34(cal_delay),        .rx_cntvalueout_34(rx_cntvalueout[LANE_C34]),                          
    .rx_cntvaluein_36(cal_delay),        .rx_cntvalueout_36(rx_cntvalueout[LANE_C36]),                          
    .rx_cntvaluein_39(cal_delay),        .rx_cntvalueout_39(rx_cntvalueout[LANE_C39]),                          
    .rx_cntvaluein_41(cal_delay),        .rx_cntvalueout_41(rx_cntvalueout[LANE_C41]),                          
    .rx_cntvaluein_43(cal_delay),        .rx_cntvalueout_43(rx_cntvalueout[LANE_C43]),                          
    .rx_cntvaluein_26(0        ),        .rx_cntvalueout_26(                        ),                                                  



    // "Load new delay" and "enable voltage/temperature compensation"
    .rx_load_0 (rx_load[LANE_C0 ]),     .rx_en_vtc_0 (rx_en_vtc[LANE_C0 ]),         
    .rx_load_2 (rx_load[LANE_C2 ]),     .rx_en_vtc_2 (rx_en_vtc[LANE_C2 ]),         
    .rx_load_4 (rx_load[LANE_C4 ]),     .rx_en_vtc_4 (rx_en_vtc[LANE_C4 ]),         
    .rx_load_6 (rx_load[LANE_C6 ]),     .rx_en_vtc_6 (rx_en_vtc[LANE_C6 ]),         
    .rx_load_8 (rx_load[LANE_C8 ]),     .rx_en_vtc_8 (rx_en_vtc[LANE_C8 ]),         
    .rx_load_10(rx_load[LANE_C10]),     .rx_en_vtc_10(rx_en_vtc[LANE_C10]),         
    .rx_load_13(rx_load[LANE_C13]),     .rx_en_vtc_13(rx_en_vtc[LANE_C13]),         
    .rx_load_15(rx_load[LANE_C15]),     .rx_en_vtc_15(rx_en_vtc[LANE_C15]),         
    .rx_load_17(rx_load[LANE_C17]),     .rx_en_vtc_17(rx_en_vtc[LANE_C17]),         
    .rx_load_19(rx_load[LANE_C19]),     .rx_en_vtc_19(rx_en_vtc[LANE_C19]),         
    .rx_load_23(rx_load[LANE_C23]),     .rx_en_vtc_23(rx_en_vtc[LANE_C23]),         
    .rx_load_28(rx_load[LANE_C28]),     .rx_en_vtc_28(rx_en_vtc[LANE_C28]),         
    .rx_load_30(rx_load[LANE_C30]),     .rx_en_vtc_30(rx_en_vtc[LANE_C30]),         
    .rx_load_32(rx_load[LANE_C32]),     .rx_en_vtc_32(rx_en_vtc[LANE_C32]),         
    .rx_load_34(rx_load[LANE_C34]),     .rx_en_vtc_34(rx_en_vtc[LANE_C34]),         
    .rx_load_36(rx_load[LANE_C36]),     .rx_en_vtc_36(rx_en_vtc[LANE_C36]),         
    .rx_load_39(rx_load[LANE_C39]),     .rx_en_vtc_39(rx_en_vtc[LANE_C39]),         
    .rx_load_41(rx_load[LANE_C41]),     .rx_en_vtc_41(rx_en_vtc[LANE_C41]),         
    .rx_load_43(rx_load[LANE_C43]),     .rx_en_vtc_43(rx_en_vtc[LANE_C43]),         
    .rx_load_26(0),                     .rx_en_vtc_26(0),                           


    // We don't use any of these fields
    .rx_ce_0 (0),                       .rx_inc_0 (0),
    .rx_ce_2 (0),                       .rx_inc_2 (0),
    .rx_ce_4 (0),                       .rx_inc_4 (0),
    .rx_ce_6 (0),                       .rx_inc_6 (0),
    .rx_ce_8 (0),                       .rx_inc_8 (0),
    .rx_ce_10(0),                       .rx_inc_10(0),
    .rx_ce_13(0),                       .rx_inc_13(0),
    .rx_ce_15(0),                       .rx_inc_15(0),
    .rx_ce_17(0),                       .rx_inc_17(0),
    .rx_ce_19(0),                       .rx_inc_19(0),
    .rx_ce_23(0),                       .rx_inc_23(0),
    .rx_ce_28(0),                       .rx_inc_28(0),
    .rx_ce_30(0),                       .rx_inc_30(0),
    .rx_ce_32(0),                       .rx_inc_32(0),
    .rx_ce_34(0),                       .rx_inc_34(0),
    .rx_ce_36(0),                       .rx_inc_36(0),
    .rx_ce_39(0),                       .rx_inc_39(0),
    .rx_ce_41(0),                       .rx_inc_41(0),
    .rx_ce_43(0),                       .rx_inc_43(0),
    .rx_ce_26(0),                       .rx_inc_26(0),

    // FIFO clk, 0 ad-enable, and empty f0 g
    .fifo_rd_clk_0 (clk),               .fifo_empty_0 (fifo_empty[LANE_C0 ]),
    .fifo_rd_clk_2 (clk),               .fifo_empty_2 (fifo_empty[LANE_C2 ]),
    .fifo_rd_clk_4 (clk),               .fifo_empty_4 (fifo_empty[LANE_C4 ]),
    .fifo_rd_clk_6 (clk),               .fifo_empty_6 (fifo_empty[LANE_C6 ]),
    .fifo_rd_clk_8 (clk),               .fifo_empty_8 (fifo_empty[LANE_C8 ]),
    .fifo_rd_clk_10(clk),               .fifo_empty_10(fifo_empty[LANE_C10]),
    .fifo_rd_clk_13(clk),               .fifo_empty_13(fifo_empty[LANE_C13]),
    .fifo_rd_clk_15(clk),               .fifo_empty_15(fifo_empty[LANE_C15]),
    .fifo_rd_clk_17(clk),               .fifo_empty_17(fifo_empty[LANE_C17]),
    .fifo_rd_clk_19(clk),               .fifo_empty_19(fifo_empty[LANE_C19]),
    .fifo_rd_clk_23(clk),               .fifo_empty_23(fifo_empty[LANE_C23]),
    .fifo_rd_clk_28(clk),               .fifo_empty_28(fifo_empty[LANE_C28]),
    .fifo_rd_clk_30(clk),               .fifo_empty_30(fifo_empty[LANE_C30]),
    .fifo_rd_clk_32(clk),               .fifo_empty_32(fifo_empty[LANE_C32]),
    .fifo_rd_clk_34(clk),               .fifo_empty_34(fifo_empty[LANE_C34]),
    .fifo_rd_clk_36(clk),               .fifo_empty_36(fifo_empty[LANE_C36]),
    .fifo_rd_clk_39(clk),               .fifo_empty_39(fifo_empty[LANE_C39]),
    .fifo_rd_clk_41(clk),               .fifo_empty_41(fifo_empty[LANE_C41]),
    .fifo_rd_clk_43(clk),               .fifo_empty_43(fifo_empty[LANE_C43]),
    .fifo_rd_clk_26(clk),               .fifo_empty_26(                    ),

    //-------------------------------------------------------------------------
    //             Interface to the Register Interface Units
    //-------------------------------------------------------------------------
    .riu_rd_data_bg0    (riu_rd_data [BG_C + 0]),
    .riu_rd_data_bg1    (riu_rd_data [BG_C + 1]),
    .riu_rd_data_bg2    (riu_rd_data [BG_C + 2]),
    .riu_rd_data_bg3    (riu_rd_data [BG_C + 3]),
    //-------------------------------------------------------------------------
    .riu_valid_bg0      (riu_rd_valid[BG_C + 0]),
    .riu_valid_bg1      (riu_rd_valid[BG_C + 1]),
    .riu_valid_bg2      (riu_rd_valid[BG_C + 2]),
    .riu_valid_bg3      (riu_rd_valid[BG_C + 3]),
    //-------------------------------------------------------------------------
    .riu_addr_bg0       (riu_register),
    .riu_addr_bg1       (riu_register),
    .riu_addr_bg2       (riu_register),
    .riu_addr_bg3       (riu_register),
     //-------------------------------------------------------------------------
    .riu_nibble_sel_bg0 (riu_nibble_sel[BG_C + 0]),
    .riu_nibble_sel_bg1 (riu_nibble_sel[BG_C + 1]),
    .riu_nibble_sel_bg2 (riu_nibble_sel[BG_C + 2]),
    .riu_nibble_sel_bg3 (riu_nibble_sel[BG_C + 3]),
    //-------------------------------------------------------------------------
    .riu_wr_data_bg0    (cfg_riu_wr_data),
    .riu_wr_data_bg1    (cfg_riu_wr_data),
    .riu_wr_data_bg2    (cfg_riu_wr_data),
    .riu_wr_data_bg3    (cfg_riu_wr_data),
    //-------------------------------------------------------------------------
    .riu_wr_en_bg0      (riu_write_en[BG_C + 0]),
    .riu_wr_en_bg1      (riu_write_en[BG_C + 1]),
    .riu_wr_en_bg2      (riu_write_en[BG_C + 2]),
    .riu_wr_en_bg3      (riu_write_en[BG_C + 3]),
    //-------------------------------------------------------------------------


    .en_vtc_bsc0(1),   .vtc_rdy_bsc0(vtc_rdy[NIB_C + 0]),   .dly_rdy_bsc0(dly_rdy[NIB_C + 0]),
    .en_vtc_bsc1(1),   .vtc_rdy_bsc1(vtc_rdy[NIB_C + 1]),   .dly_rdy_bsc1(dly_rdy[NIB_C + 1]),
    .en_vtc_bsc2(1),   .vtc_rdy_bsc2(vtc_rdy[NIB_C + 2]),   .dly_rdy_bsc2(dly_rdy[NIB_C + 2]),
    .en_vtc_bsc3(1),   .vtc_rdy_bsc3(vtc_rdy[NIB_C + 3]),   .dly_rdy_bsc3(dly_rdy[NIB_C + 3]),
    .en_vtc_bsc4(1),   .vtc_rdy_bsc4(vtc_rdy[NIB_C + 4]),   .dly_rdy_bsc4(dly_rdy[NIB_C + 4]),
    .en_vtc_bsc5(1),   .vtc_rdy_bsc5(vtc_rdy[NIB_C + 5]),   .dly_rdy_bsc5(dly_rdy[NIB_C + 5]),
    .en_vtc_bsc6(1),   .vtc_rdy_bsc6(vtc_rdy[NIB_C + 6]),   .dly_rdy_bsc6(dly_rdy[NIB_C + 6]),


    // LVDS lanes in, data-out
    .D29_P(LVDS_DP[29]), .D29_N(LVDS_DN[29]), .data_to_fabric_D29_P(data_to_fabric[29]),
    .D19_P(LVDS_DP[19]), .D19_N(LVDS_DN[19]), .data_to_fabric_D19_P(data_to_fabric[19]),
    .D12_P(LVDS_DP[12]), .D12_N(LVDS_DN[12]), .data_to_fabric_D12_P(data_to_fabric[12]),
    .D26_P(LVDS_DP[26]), .D26_N(LVDS_DN[26]), .data_to_fabric_D26_P(data_to_fabric[26]),
    .D27_P(LVDS_DP[27]), .D27_N(LVDS_DN[27]), .data_to_fabric_D27_N(data_to_fabric[27]),
    .D31_P(LVDS_DP[31]), .D31_N(LVDS_DN[31]), .data_to_fabric_D31_P(data_to_fabric[31]),
    .D30_P(LVDS_DP[30]), .D30_N(LVDS_DN[30]), .data_to_fabric_D30_N(data_to_fabric[30]),
    .D23_P(LVDS_DP[23]), .D23_N(LVDS_DN[23]), .data_to_fabric_D23_N(data_to_fabric[23]),
    .D28_P(LVDS_DP[28]), .D28_N(LVDS_DN[28]), .data_to_fabric_D28_N(data_to_fabric[28]),
    .D46_P(LVDS_DP[46]), .D46_N(LVDS_DN[46]), .data_to_fabric_D46_P(data_to_fabric[46]),
    .D13_P(LVDS_DP[13]), .D13_N(LVDS_DN[13]), .data_to_fabric_D13_P(data_to_fabric[13]),
    .D21_P(LVDS_DP[21]), .D21_N(LVDS_DN[21]), .data_to_fabric_D21_N(data_to_fabric[21]),
    .D14_P(LVDS_DP[14]), .D14_N(LVDS_DN[14]), .data_to_fabric_D14_P(data_to_fabric[14]),
    .D25_P(LVDS_DP[25]), .D25_N(LVDS_DN[25]), .data_to_fabric_D25_P(data_to_fabric[25]),
    .D24_P(LVDS_DP[24]), .D24_N(LVDS_DN[24]), .data_to_fabric_D24_P(data_to_fabric[24]),
    .D18_P(LVDS_DP[18]), .D18_N(LVDS_DN[18]), .data_to_fabric_D18_N(data_to_fabric[18]),
    .D17_P(LVDS_DP[17]), .D17_N(LVDS_DN[17]), .data_to_fabric_D17_N(data_to_fabric[17]),
    .D16_P(LVDS_DP[16]), .D16_N(LVDS_DN[16]), .data_to_fabric_D16_N(data_to_fabric[16]),
    .D20_P(LVDS_DP[20]), .D20_N(LVDS_DN[20]), .data_to_fabric_D20_N(data_to_fabric[20]),


    // Other signals
    .clk                (clk),
    .rx_clk             (clk),
    .app_clk            (clk),
    .riu_clk            (clk),
    .rst                (reset_hssio),
    .CLK512_N           (LVDS_BANKC_CKIN_N),
    .CLK512_P           (LVDS_BANKC_CKIN_P),   
    .rst_seq_done       (rst_seq_done     [BANK_C]),
    .pll0_locked        (pll0_locked_async[BANK_C]),
    .intf_rdy           (intf_rdy         [BANK_C]),
    .multi_intf_lock_in (multi_intf_lock_in),
    .fifo_rd_data_valid (fifo_rd_data_valid[BANK_C]),    

    // Unused signals
    .data_to_fabric_CLK512_N(), 
    .shared_pll0_clkoutphy_out(),
    .pll0_clkout0()
);
//=============================================================================

endmodule

