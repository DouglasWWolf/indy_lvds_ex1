//====================================================================================
//                        ------->  Revision History  <------
//====================================================================================
//
//   Date     Who   Ver  Changes
//====================================================================================
// 22-May-26  DWW     1  Initial creation
//====================================================================================

/*
    This module serves as a switch for determining whether external logic sees
    LVDS lanes from the LVDS logic or from the sensor emulator.

    It also determines whether pa_sync_out is driven from the sensor-chip's pa_sync
    output pin, or whether it's driven from the sensor emulator's pa_sync output
    signal

*/

module lvds_switch # (parameter LANE_COUNT = 64)
(
    input clk,

    // If this is a 1, "lvds_out" and "pa_sync_out" come from the emulator
    input  sim_select,

    // LVDS input buses
    input[LANE_COUNT*8-1:0] sensor_lvds, emulator_lvds,

    // LVDS output bus
    output[LANE_COUNT*8-1:0] lvds_out,

    // This is asynchronous to clk!
    input    async_pa_sync,
    
    // This comes from the sensor-chip emulator
    input    emulator_pa_sync,

    // This is sychronous to "clk"
    output   pa_sync_out

);

// Mux for the LVDS output
assign lvds_out = (sim_select) ? emulator_lvds : sensor_lvds;

// This is a synchronized version of "async_pa_sync"
wire sensor_pa_sync;

// Mux the pa_sync_out signal
assign pa_sync_out = (sim_select) ? emulator_pa_sync : async_pa_sync;


//=============================================================================
// Synchronize "async_pa_sync" into "sensor_pa_sync"
//=============================================================================
xpm_cdc_single #
(
   .DEST_SYNC_FF    (2), 
   .SRC_INPUT_REG   (0)
)
i_sync_pa_sync
(
   .dest_out (sensor_pa_sync),
   .dest_clk (clk), 
   .src_clk  (), 
   .src_in   (async_pa_sync)
);
//=============================================================================


endmodule