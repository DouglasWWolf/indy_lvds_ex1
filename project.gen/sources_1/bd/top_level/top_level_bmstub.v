// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// -------------------------------------------------------------------------------

`timescale 1 ps / 1 ps

(* BLOCK_STUB = "true" *)
module top_level (
  pcie_refclk_clk_p,
  pcie_refclk_clk_n,
  pcie_mgt_rxn,
  pcie_mgt_rxp,
  pcie_mgt_txn,
  pcie_mgt_txp,
  init_clk_clk_n,
  init_clk_clk_p,
  LVDS_CLK_clk_n,
  LVDS_CLK_clk_p,
  CHIP_SPI_CLK,
  CHIP_SPI_CSN,
  CHIP_SPI_MOSI,
  CHIP_SPI_MISO,
  CHIP_VDDIO,
  CHIP_VDD,
  CHIP_VDDLVDS,
  CHIP_VDDA,
  CHIP_RESET_N,
  UCI_ADC_CSN,
  UCI_ADC_SCK,
  UCI_ADC_MOSI,
  UCI_ADC_MISO,
  LVL_TRSL_OE_N,
  CHIP_HSI_CLK,
  LVDS_DN,
  LVDS_DP,
  LVDS_BANKA_clk_p,
  LVDS_BANKB_clk_n,
  LVDS_BANKC_clk_n,
  LVDS_BANKB_clk_p,
  LVDS_BANKA_clk_n,
  LVDS_BANKC_clk_p,
  CHIP_PA_SYNC,
  GPIO12,
  GPIO13,
  GPIO14,
  GPIO15
);

  (* X_INTERFACE_INFO = "xilinx.com:interface:diff_clock:1.0 pcie_refclk CLK_P" *)
  (* X_INTERFACE_MODE = "slave pcie_refclk" *)
  (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME pcie_refclk, CAN_DEBUG false, FREQ_HZ 100000000" *)
  input [0:0]pcie_refclk_clk_p;
  (* X_INTERFACE_INFO = "xilinx.com:interface:diff_clock:1.0 pcie_refclk CLK_N" *)
  input [0:0]pcie_refclk_clk_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:pcie_7x_mgt:1.0 pcie_mgt rxn" *)
  (* X_INTERFACE_MODE = "master pcie_mgt" *)
  input [15:0]pcie_mgt_rxn;
  (* X_INTERFACE_INFO = "xilinx.com:interface:pcie_7x_mgt:1.0 pcie_mgt rxp" *)
  input [15:0]pcie_mgt_rxp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:pcie_7x_mgt:1.0 pcie_mgt txn" *)
  output [15:0]pcie_mgt_txn;
  (* X_INTERFACE_INFO = "xilinx.com:interface:pcie_7x_mgt:1.0 pcie_mgt txp" *)
  output [15:0]pcie_mgt_txp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:diff_clock:1.0 init_clk CLK_N" *)
  (* X_INTERFACE_MODE = "slave init_clk" *)
  (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME init_clk, CAN_DEBUG false, FREQ_HZ 200000000" *)
  input init_clk_clk_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:diff_clock:1.0 init_clk CLK_P" *)
  input init_clk_clk_p;
  (* X_INTERFACE_INFO = "xilinx.com:interface:diff_clock:1.0 LVDS_CLK CLK_N" *)
  (* X_INTERFACE_MODE = "master LVDS_CLK" *)
  (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME LVDS_CLK, CAN_DEBUG false, FREQ_HZ 100000000" *)
  output [0:0]LVDS_CLK_clk_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:diff_clock:1.0 LVDS_CLK CLK_P" *)
  output [0:0]LVDS_CLK_clk_p;
  (* X_INTERFACE_IGNORE = "true" *)
  output CHIP_SPI_CLK;
  (* X_INTERFACE_IGNORE = "true" *)
  output CHIP_SPI_CSN;
  (* X_INTERFACE_IGNORE = "true" *)
  output CHIP_SPI_MOSI;
  (* X_INTERFACE_IGNORE = "true" *)
  input CHIP_SPI_MISO;
  (* X_INTERFACE_IGNORE = "true" *)
  output CHIP_VDDIO;
  (* X_INTERFACE_IGNORE = "true" *)
  output CHIP_VDD;
  (* X_INTERFACE_IGNORE = "true" *)
  output CHIP_VDDLVDS;
  (* X_INTERFACE_IGNORE = "true" *)
  output CHIP_VDDA;
  (* X_INTERFACE_IGNORE = "true" *)
  output CHIP_RESET_N;
  (* X_INTERFACE_IGNORE = "true" *)
  output [2:0]UCI_ADC_CSN;
  (* X_INTERFACE_IGNORE = "true" *)
  output UCI_ADC_SCK;
  (* X_INTERFACE_IGNORE = "true" *)
  output UCI_ADC_MOSI;
  (* X_INTERFACE_IGNORE = "true" *)
  input UCI_ADC_MISO;
  (* X_INTERFACE_IGNORE = "true" *)
  output LVL_TRSL_OE_N;
  (* X_INTERFACE_IGNORE = "true" *)
  output CHIP_HSI_CLK;
  (* X_INTERFACE_IGNORE = "true" *)
  input [63:0]LVDS_DN;
  (* X_INTERFACE_IGNORE = "true" *)
  input [63:0]LVDS_DP;
  (* X_INTERFACE_IGNORE = "true" *)
  input LVDS_BANKA_clk_p;
  (* X_INTERFACE_IGNORE = "true" *)
  input LVDS_BANKB_clk_n;
  (* X_INTERFACE_IGNORE = "true" *)
  input LVDS_BANKC_clk_n;
  (* X_INTERFACE_IGNORE = "true" *)
  input LVDS_BANKB_clk_p;
  (* X_INTERFACE_IGNORE = "true" *)
  input LVDS_BANKA_clk_n;
  (* X_INTERFACE_IGNORE = "true" *)
  input LVDS_BANKC_clk_p;
  (* X_INTERFACE_IGNORE = "true" *)
  input CHIP_PA_SYNC;
  (* X_INTERFACE_IGNORE = "true" *)
  output [0:0]GPIO12;
  (* X_INTERFACE_IGNORE = "true" *)
  output [0:0]GPIO13;
  (* X_INTERFACE_IGNORE = "true" *)
  output [0:0]GPIO14;
  (* X_INTERFACE_IGNORE = "true" *)
  output [0:0]GPIO15;

  // stub module has no contents

endmodule
