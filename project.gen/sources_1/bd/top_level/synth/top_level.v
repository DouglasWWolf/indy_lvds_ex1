//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2024.2 (lin64) Build 5239630 Fri Nov 08 22:34:34 MST 2024
//Date        : Tue Apr 21 15:52:18 2026
//Host        : wolf-super-server running 64-bit Ubuntu 20.04.6 LTS
//Command     : generate_target top_level.bd
//Design      : top_level
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module adc_bank_imp_1SLD8RV
   (S_AXI_araddr,
    S_AXI_arprot,
    S_AXI_arready,
    S_AXI_arvalid,
    S_AXI_awaddr,
    S_AXI_awprot,
    S_AXI_awready,
    S_AXI_awvalid,
    S_AXI_bready,
    S_AXI_bresp,
    S_AXI_bvalid,
    S_AXI_rdata,
    S_AXI_rready,
    S_AXI_rresp,
    S_AXI_rvalid,
    S_AXI_wdata,
    S_AXI_wready,
    S_AXI_wstrb,
    S_AXI_wvalid,
    UCI_ADC_CSN,
    UCI_ADC_MISO,
    UCI_ADC_MOSI,
    UCI_ADC_SCK,
    clk,
    resetn);
  input [7:0]S_AXI_araddr;
  input [2:0]S_AXI_arprot;
  output S_AXI_arready;
  input S_AXI_arvalid;
  input [7:0]S_AXI_awaddr;
  input [2:0]S_AXI_awprot;
  output S_AXI_awready;
  input S_AXI_awvalid;
  input S_AXI_bready;
  output [1:0]S_AXI_bresp;
  output S_AXI_bvalid;
  output [31:0]S_AXI_rdata;
  input S_AXI_rready;
  output [1:0]S_AXI_rresp;
  output S_AXI_rvalid;
  input [31:0]S_AXI_wdata;
  output S_AXI_wready;
  input [3:0]S_AXI_wstrb;
  input S_AXI_wvalid;
  output [2:0]UCI_ADC_CSN;
  input UCI_ADC_MISO;
  output UCI_ADC_MOSI;
  output UCI_ADC_SCK;
  input clk;
  input resetn;

  wire [7:0]S_AXI_araddr;
  wire [2:0]S_AXI_arprot;
  wire S_AXI_arready;
  wire S_AXI_arvalid;
  wire [7:0]S_AXI_awaddr;
  wire [2:0]S_AXI_awprot;
  wire S_AXI_awready;
  wire S_AXI_awvalid;
  wire S_AXI_bready;
  wire [1:0]S_AXI_bresp;
  wire S_AXI_bvalid;
  wire [31:0]S_AXI_rdata;
  wire S_AXI_rready;
  wire [1:0]S_AXI_rresp;
  wire S_AXI_rvalid;
  wire [31:0]S_AXI_wdata;
  wire S_AXI_wready;
  wire [3:0]S_AXI_wstrb;
  wire S_AXI_wvalid;
  wire [2:0]UCI_ADC_CSN;
  wire UCI_ADC_MISO;
  wire UCI_ADC_MOSI;
  wire UCI_ADC_SCK;
  wire clk;
  wire [383:0]ltc1867l_adc_values;
  wire resetn;

  top_level_axi_adc_bank_0_0 axi_adc_bank
       (.S_AXI_ARADDR(S_AXI_araddr),
        .S_AXI_ARPROT(S_AXI_arprot),
        .S_AXI_ARREADY(S_AXI_arready),
        .S_AXI_ARVALID(S_AXI_arvalid),
        .S_AXI_AWADDR(S_AXI_awaddr),
        .S_AXI_AWPROT(S_AXI_awprot),
        .S_AXI_AWREADY(S_AXI_awready),
        .S_AXI_AWVALID(S_AXI_awvalid),
        .S_AXI_BREADY(S_AXI_bready),
        .S_AXI_BRESP(S_AXI_bresp),
        .S_AXI_BVALID(S_AXI_bvalid),
        .S_AXI_RDATA(S_AXI_rdata),
        .S_AXI_RREADY(S_AXI_rready),
        .S_AXI_RRESP(S_AXI_rresp),
        .S_AXI_RVALID(S_AXI_rvalid),
        .S_AXI_WDATA(S_AXI_wdata),
        .S_AXI_WREADY(S_AXI_wready),
        .S_AXI_WSTRB(S_AXI_wstrb),
        .S_AXI_WVALID(S_AXI_wvalid),
        .adc(ltc1867l_adc_values),
        .clk(clk),
        .resetn(resetn));
  top_level_ltc1867l_0_0 ltc1867l
       (.adc_values(ltc1867l_adc_values),
        .clk(clk),
        .resetn(resetn),
        .slave_select(UCI_ADC_CSN),
        .spi_miso(UCI_ADC_MISO),
        .spi_mosi(UCI_ADC_MOSI),
        .spi_sclk(UCI_ADC_SCK));
endmodule

module chip_spi_imp_HJ3TY6
   (CHIP_SPI_CLK,
    CHIP_SPI_CSN,
    CHIP_SPI_MISO,
    CHIP_SPI_MOSI,
    HSI_CLK,
    S_AXI_araddr,
    S_AXI_arprot,
    S_AXI_arready,
    S_AXI_arvalid,
    S_AXI_awaddr,
    S_AXI_awprot,
    S_AXI_awready,
    S_AXI_awvalid,
    S_AXI_bready,
    S_AXI_bresp,
    S_AXI_bvalid,
    S_AXI_rdata,
    S_AXI_rready,
    S_AXI_rresp,
    S_AXI_rvalid,
    S_AXI_wdata,
    S_AXI_wready,
    S_AXI_wstrb,
    S_AXI_wvalid,
    clk_160,
    resetn_160,
    sys_clk,
    sys_resetn);
  output CHIP_SPI_CLK;
  output CHIP_SPI_CSN;
  input CHIP_SPI_MISO;
  output CHIP_SPI_MOSI;
  output HSI_CLK;
  input [7:0]S_AXI_araddr;
  input [2:0]S_AXI_arprot;
  output S_AXI_arready;
  input S_AXI_arvalid;
  input [7:0]S_AXI_awaddr;
  input [2:0]S_AXI_awprot;
  output S_AXI_awready;
  input S_AXI_awvalid;
  input S_AXI_bready;
  output [1:0]S_AXI_bresp;
  output S_AXI_bvalid;
  output [31:0]S_AXI_rdata;
  input S_AXI_rready;
  output [1:0]S_AXI_rresp;
  output S_AXI_rvalid;
  input [31:0]S_AXI_wdata;
  output S_AXI_wready;
  input [3:0]S_AXI_wstrb;
  input S_AXI_wvalid;
  output clk_160;
  output resetn_160;
  input sys_clk;
  input sys_resetn;

  wire CHIP_SPI_CLK;
  wire CHIP_SPI_CSN;
  wire CHIP_SPI_MISO;
  wire CHIP_SPI_MOSI;
  wire HSI_CLK;
  wire [7:0]S_AXI_araddr;
  wire [2:0]S_AXI_arprot;
  wire S_AXI_arready;
  wire S_AXI_arvalid;
  wire [7:0]S_AXI_awaddr;
  wire [2:0]S_AXI_awprot;
  wire S_AXI_awready;
  wire S_AXI_awvalid;
  wire S_AXI_bready;
  wire [1:0]S_AXI_bresp;
  wire S_AXI_bvalid;
  wire [31:0]S_AXI_rdata;
  wire S_AXI_rready;
  wire [1:0]S_AXI_rresp;
  wire S_AXI_rvalid;
  wire [31:0]S_AXI_wdata;
  wire S_AXI_wready;
  wire [3:0]S_AXI_wstrb;
  wire S_AXI_wvalid;
  wire chip_spi_busy;
  wire [31:0]chip_spi_ctl_spi_addr;
  wire [1:0]chip_spi_ctl_spi_start_stb;
  wire [31:0]chip_spi_ctl_spi_wdata;
  wire [31:0]chip_spi_rdata;
  wire chip_spi_spi_cs_n;
  wire chip_spi_spi_mosi;
  wire chip_spi_spi_pclk;
  wire clk_160;
  wire resetn_160;
  wire sys_clk;
  wire sys_resetn;

  top_level_xpm_cdc_gen_0_1 async_resetn
       (.dest_arst(resetn_160),
        .dest_clk(clk_160),
        .src_arst(sys_resetn));
  top_level_chip_spi_0 chip_spi
       (.addr(chip_spi_ctl_spi_addr),
        .busy(chip_spi_busy),
        .clk(clk_160),
        .rdata(chip_spi_rdata),
        .resetn(resetn_160),
        .spi_cs_n(chip_spi_spi_cs_n),
        .spi_miso(CHIP_SPI_MISO),
        .spi_mosi(chip_spi_spi_mosi),
        .spi_pclk(chip_spi_spi_pclk),
        .start(chip_spi_ctl_spi_start_stb),
        .wdata(chip_spi_ctl_spi_wdata));
  top_level_chip_spi_ctl_0_0 chip_spi_ctl
       (.S_AXI_ARADDR(S_AXI_araddr),
        .S_AXI_ARPROT(S_AXI_arprot),
        .S_AXI_ARREADY(S_AXI_arready),
        .S_AXI_ARVALID(S_AXI_arvalid),
        .S_AXI_AWADDR(S_AXI_awaddr),
        .S_AXI_AWPROT(S_AXI_awprot),
        .S_AXI_AWREADY(S_AXI_awready),
        .S_AXI_AWVALID(S_AXI_awvalid),
        .S_AXI_BREADY(S_AXI_bready),
        .S_AXI_BRESP(S_AXI_bresp),
        .S_AXI_BVALID(S_AXI_bvalid),
        .S_AXI_RDATA(S_AXI_rdata),
        .S_AXI_RREADY(S_AXI_rready),
        .S_AXI_RRESP(S_AXI_rresp),
        .S_AXI_RVALID(S_AXI_rvalid),
        .S_AXI_WDATA(S_AXI_wdata),
        .S_AXI_WREADY(S_AXI_wready),
        .S_AXI_WSTRB(S_AXI_wstrb),
        .S_AXI_WVALID(S_AXI_wvalid),
        .clk(clk_160),
        .resetn(resetn_160),
        .spi_addr(chip_spi_ctl_spi_addr),
        .spi_busy(chip_spi_busy),
        .spi_rdata(chip_spi_rdata),
        .spi_start_stb(chip_spi_ctl_spi_start_stb),
        .spi_wdata(chip_spi_ctl_spi_wdata));
  top_level_chip_spi_extra_flops_0_0 chip_spi_extra_flops
       (.clk(clk_160),
        .pin_spi_csn(CHIP_SPI_CSN),
        .pin_spi_mosi(CHIP_SPI_MOSI),
        .pin_spi_pclk(CHIP_SPI_CLK),
        .resetn(resetn_160),
        .spi_csn(chip_spi_spi_cs_n),
        .spi_mosi(chip_spi_spi_mosi),
        .spi_pclk(chip_spi_spi_pclk));
  top_level_clk_wiz_0_0 clk_160mhz
       (.clk_in1(sys_clk),
        .clk_out1(clk_160));
  top_level_hsi_pclk_0_0 hsi_pclk
       (.clk(clk_160),
        .hsi_pclk(HSI_CLK));
endmodule

module lvds_datapath_imp_QTEW0P
   (LVDS_BANKA_clk_n,
    LVDS_BANKA_clk_p,
    LVDS_BANKB_clk_n,
    LVDS_BANKB_clk_p,
    LVDS_BANKC_clk_n,
    LVDS_BANKC_clk_p,
    LVDS_DN,
    LVDS_DP,
    align_err,
    bitslip_rd,
    cal_mask,
    cal_word,
    cal_word_wstb,
    cal_write_en,
    cfg_reset_hssio,
    clear_errors,
    clk,
    dbg_lvds_lane,
    delay_rd,
    lane_select,
    prbs_err,
    resetn);
  input LVDS_BANKA_clk_n;
  input LVDS_BANKA_clk_p;
  input LVDS_BANKB_clk_n;
  input LVDS_BANKB_clk_p;
  input LVDS_BANKC_clk_n;
  input LVDS_BANKC_clk_p;
  input [63:0]LVDS_DN;
  input [63:0]LVDS_DP;
  output [63:0]align_err;
  output [2:0]bitslip_rd;
  input [63:0]cal_mask;
  input [11:0]cal_word;
  input cal_word_wstb;
  output [2:0]cal_write_en;
  input cfg_reset_hssio;
  input clear_errors;
  input clk;
  output [7:0]dbg_lvds_lane;
  output [8:0]delay_rd;
  input [5:0]lane_select;
  output [63:0]prbs_err;
  input resetn;

  wire LVDS_BANKA_clk_n;
  wire LVDS_BANKA_clk_p;
  wire LVDS_BANKB_clk_n;
  wire LVDS_BANKB_clk_p;
  wire LVDS_BANKC_clk_n;
  wire LVDS_BANKC_clk_p;
  wire [63:0]LVDS_DN;
  wire [63:0]LVDS_DP;
  wire [63:0]align_err;
  wire [2:0]bitslip_rd;
  wire [63:0]cal_mask;
  wire [11:0]cal_word;
  wire cal_word_wstb;
  wire [2:0]cal_write_en;
  wire cfg_reset_hssio;
  wire clear_errors;
  wire clk;
  wire [7:0]dbg_lvds_lane;
  wire [8:0]delay_rd;
  wire [511:0]hssio_lvds_bus;
  wire [5:0]lane_select;
  wire [511:0]lvds_bitslip_lvds_bus;
  wire [63:0]prbs_err;
  wire resetn;

  top_level_hssio_0_0 hssio
       (.LVDS_BANKA_CKIN_N(LVDS_BANKA_clk_n),
        .LVDS_BANKA_CKIN_P(LVDS_BANKA_clk_p),
        .LVDS_BANKB_CKIN_N(LVDS_BANKB_clk_n),
        .LVDS_BANKB_CKIN_P(LVDS_BANKB_clk_p),
        .LVDS_BANKC_CKIN_N(LVDS_BANKC_clk_n),
        .LVDS_BANKC_CKIN_P(LVDS_BANKC_clk_p),
        .LVDS_DN(LVDS_DN),
        .LVDS_DP(LVDS_DP),
        .cal_mask(cal_mask),
        .cal_word(cal_word),
        .cal_word_wstb(cal_word_wstb),
        .cal_write_en(cal_write_en),
        .cfg_reset_hssio(cfg_reset_hssio),
        .clk(clk),
        .delay_rd(delay_rd),
        .lane_select(lane_select),
        .lvds_bus(hssio_lvds_bus),
        .resetn(resetn));
  top_level_lvds_align_detect_0_0 lvds_align_detect
       (.align_err(align_err),
        .clear_errors(clear_errors),
        .clk(clk),
        .lvds_bus(lvds_bitslip_lvds_bus));
  top_level_lvds_bitslip_0_0 lvds_bitslip
       (.bitslip_rd(bitslip_rd),
        .cal_mask(cal_mask),
        .cal_word(cal_word),
        .cal_word_wstb(cal_word_wstb),
        .clk(clk),
        .dbg_lvds_lane(dbg_lvds_lane),
        .input_bus(hssio_lvds_bus),
        .lane_select(lane_select),
        .lvds_bus(lvds_bitslip_lvds_bus),
        .resetn(resetn));
  top_level_lvds_prbs15_check_0_0 lvds_prbs15_check
       (.clear_errors(clear_errors),
        .clk(clk),
        .lvds_bus(lvds_bitslip_lvds_bus),
        .prbs_err(prbs_err));
endmodule

module lvds_imp_JR8VK
   (CHIP_PA_SYNC,
    LVDS_BANKA_clk_n,
    LVDS_BANKA_clk_p,
    LVDS_BANKB_clk_n,
    LVDS_BANKB_clk_p,
    LVDS_BANKC_clk_n,
    LVDS_BANKC_clk_p,
    LVDS_DN,
    LVDS_DP,
    S_AXI_CTL_araddr,
    S_AXI_CTL_arprot,
    S_AXI_CTL_arready,
    S_AXI_CTL_arvalid,
    S_AXI_CTL_awaddr,
    S_AXI_CTL_awprot,
    S_AXI_CTL_awready,
    S_AXI_CTL_awvalid,
    S_AXI_CTL_bready,
    S_AXI_CTL_bresp,
    S_AXI_CTL_bvalid,
    S_AXI_CTL_rdata,
    S_AXI_CTL_rready,
    S_AXI_CTL_rresp,
    S_AXI_CTL_rvalid,
    S_AXI_CTL_wdata,
    S_AXI_CTL_wready,
    S_AXI_CTL_wstrb,
    S_AXI_CTL_wvalid,
    clk,
    resetn);
  input CHIP_PA_SYNC;
  input LVDS_BANKA_clk_n;
  input LVDS_BANKA_clk_p;
  input LVDS_BANKB_clk_n;
  input LVDS_BANKB_clk_p;
  input LVDS_BANKC_clk_n;
  input LVDS_BANKC_clk_p;
  input [63:0]LVDS_DN;
  input [63:0]LVDS_DP;
  input [7:0]S_AXI_CTL_araddr;
  input [2:0]S_AXI_CTL_arprot;
  output S_AXI_CTL_arready;
  input S_AXI_CTL_arvalid;
  input [7:0]S_AXI_CTL_awaddr;
  input [2:0]S_AXI_CTL_awprot;
  output S_AXI_CTL_awready;
  input S_AXI_CTL_awvalid;
  input S_AXI_CTL_bready;
  output [1:0]S_AXI_CTL_bresp;
  output S_AXI_CTL_bvalid;
  output [31:0]S_AXI_CTL_rdata;
  input S_AXI_CTL_rready;
  output [1:0]S_AXI_CTL_rresp;
  output S_AXI_CTL_rvalid;
  input [31:0]S_AXI_CTL_wdata;
  output S_AXI_CTL_wready;
  input [3:0]S_AXI_CTL_wstrb;
  input S_AXI_CTL_wvalid;
  input clk;
  input resetn;

  wire CHIP_PA_SYNC_1;
  wire LVDS_BANKA_clk_n;
  wire LVDS_BANKA_clk_p;
  wire LVDS_BANKB_clk_n;
  wire LVDS_BANKB_clk_p;
  wire LVDS_BANKC_clk_n;
  wire LVDS_BANKC_clk_p;
  wire [63:0]LVDS_DN;
  wire [63:0]LVDS_DP;
  wire [7:0]S_AXI_CTL_araddr;
  wire [2:0]S_AXI_CTL_arprot;
  wire S_AXI_CTL_arready;
  wire S_AXI_CTL_arvalid;
  wire [7:0]S_AXI_CTL_awaddr;
  wire [2:0]S_AXI_CTL_awprot;
  wire S_AXI_CTL_awready;
  wire S_AXI_CTL_awvalid;
  wire S_AXI_CTL_bready;
  wire [1:0]S_AXI_CTL_bresp;
  wire S_AXI_CTL_bvalid;
  wire [31:0]S_AXI_CTL_rdata;
  wire S_AXI_CTL_rready;
  wire [1:0]S_AXI_CTL_rresp;
  wire S_AXI_CTL_rvalid;
  wire [31:0]S_AXI_CTL_wdata;
  wire S_AXI_CTL_wready;
  wire [3:0]S_AXI_CTL_wstrb;
  wire S_AXI_CTL_wvalid;
  wire clk_192mhz_clk_192;
  wire [2:0]hier_0_bitslip_rd;
  wire [8:0]hier_0_delay_rd;
  wire [63:0]lvds_ctl_cal_mask;
  wire [11:0]lvds_ctl_cal_word;
  wire lvds_ctl_cal_word_wstb;
  wire lvds_ctl_clear_errors_stb;
  wire [5:0]lvds_ctl_lane_select;
  wire lvds_ctl_reset_hssio;
  wire [63:0]lvds_datapath_align_err;
  wire [2:0]lvds_datapath_cal_write_en;
  wire [7:0]lvds_datapath_dbg_lvds_lane;
  wire [63:0]lvds_prbs15_check_prbs_err;
  wire resetn;

  assign CHIP_PA_SYNC_1 = CHIP_PA_SYNC;
  assign clk_192mhz_clk_192 = clk;
  top_level_lvds_ctl_0_0 lvds_ctl
       (.S_AXI_ARADDR(S_AXI_CTL_araddr),
        .S_AXI_ARPROT(S_AXI_CTL_arprot),
        .S_AXI_ARREADY(S_AXI_CTL_arready),
        .S_AXI_ARVALID(S_AXI_CTL_arvalid),
        .S_AXI_AWADDR(S_AXI_CTL_awaddr),
        .S_AXI_AWPROT(S_AXI_CTL_awprot),
        .S_AXI_AWREADY(S_AXI_CTL_awready),
        .S_AXI_AWVALID(S_AXI_CTL_awvalid),
        .S_AXI_BREADY(S_AXI_CTL_bready),
        .S_AXI_BRESP(S_AXI_CTL_bresp),
        .S_AXI_BVALID(S_AXI_CTL_bvalid),
        .S_AXI_RDATA(S_AXI_CTL_rdata),
        .S_AXI_RREADY(S_AXI_CTL_rready),
        .S_AXI_RRESP(S_AXI_CTL_rresp),
        .S_AXI_RVALID(S_AXI_CTL_rvalid),
        .S_AXI_WDATA(S_AXI_CTL_wdata),
        .S_AXI_WREADY(S_AXI_CTL_wready),
        .S_AXI_WSTRB(S_AXI_CTL_wstrb),
        .S_AXI_WVALID(S_AXI_CTL_wvalid),
        .align_err(lvds_datapath_align_err),
        .cal_bitslip_rd(hier_0_bitslip_rd),
        .cal_delay_rd(hier_0_delay_rd),
        .cal_mask(lvds_ctl_cal_mask),
        .cal_word(lvds_ctl_cal_word),
        .cal_word_wstb(lvds_ctl_cal_word_wstb),
        .cal_write_en(lvds_datapath_cal_write_en),
        .clear_errors_stb(lvds_ctl_clear_errors_stb),
        .clk(clk_192mhz_clk_192),
        .lane_select(lvds_ctl_lane_select),
        .prbs_err(lvds_prbs15_check_prbs_err),
        .reset_hssio(lvds_ctl_reset_hssio),
        .resetn(resetn));
  lvds_datapath_imp_QTEW0P lvds_datapath
       (.LVDS_BANKA_clk_n(LVDS_BANKA_clk_n),
        .LVDS_BANKA_clk_p(LVDS_BANKA_clk_p),
        .LVDS_BANKB_clk_n(LVDS_BANKB_clk_n),
        .LVDS_BANKB_clk_p(LVDS_BANKB_clk_p),
        .LVDS_BANKC_clk_n(LVDS_BANKC_clk_n),
        .LVDS_BANKC_clk_p(LVDS_BANKC_clk_p),
        .LVDS_DN(LVDS_DN),
        .LVDS_DP(LVDS_DP),
        .align_err(lvds_datapath_align_err),
        .bitslip_rd(hier_0_bitslip_rd),
        .cal_mask(lvds_ctl_cal_mask),
        .cal_word(lvds_ctl_cal_word),
        .cal_word_wstb(lvds_ctl_cal_word_wstb),
        .cal_write_en(lvds_datapath_cal_write_en),
        .cfg_reset_hssio(lvds_ctl_reset_hssio),
        .clear_errors(lvds_ctl_clear_errors_stb),
        .clk(clk_192mhz_clk_192),
        .dbg_lvds_lane(lvds_datapath_dbg_lvds_lane),
        .delay_rd(hier_0_delay_rd),
        .lane_select(lvds_ctl_lane_select),
        .prbs_err(lvds_prbs15_check_prbs_err),
        .resetn(resetn));
  top_level_system_ila_0_0 system_ila
       (.clk(clk_192mhz_clk_192),
        .probe0(CHIP_PA_SYNC_1),
        .probe1(lvds_datapath_dbg_lvds_lane),
        .probe2(lvds_datapath_align_err));
endmodule

module pcie_bridge_imp_1AINXYK
   (M_AXI_B_araddr,
    M_AXI_B_arburst,
    M_AXI_B_arcache,
    M_AXI_B_arid,
    M_AXI_B_arlen,
    M_AXI_B_arlock,
    M_AXI_B_arprot,
    M_AXI_B_arready,
    M_AXI_B_arsize,
    M_AXI_B_arvalid,
    M_AXI_B_awaddr,
    M_AXI_B_awburst,
    M_AXI_B_awcache,
    M_AXI_B_awid,
    M_AXI_B_awlen,
    M_AXI_B_awlock,
    M_AXI_B_awprot,
    M_AXI_B_awready,
    M_AXI_B_awsize,
    M_AXI_B_awvalid,
    M_AXI_B_bid,
    M_AXI_B_bready,
    M_AXI_B_bresp,
    M_AXI_B_bvalid,
    M_AXI_B_rdata,
    M_AXI_B_rid,
    M_AXI_B_rlast,
    M_AXI_B_rready,
    M_AXI_B_rresp,
    M_AXI_B_rvalid,
    M_AXI_B_wdata,
    M_AXI_B_wlast,
    M_AXI_B_wready,
    M_AXI_B_wstrb,
    M_AXI_B_wvalid,
    PCIE_REFCLK_clk_n,
    PCIE_REFCLK_clk_p,
    axi_aclk,
    axi_aresetn,
    pcie_mgt_rxn,
    pcie_mgt_rxp,
    pcie_mgt_txn,
    pcie_mgt_txp);
  output [63:0]M_AXI_B_araddr;
  output [1:0]M_AXI_B_arburst;
  output [3:0]M_AXI_B_arcache;
  output [3:0]M_AXI_B_arid;
  output [7:0]M_AXI_B_arlen;
  output [0:0]M_AXI_B_arlock;
  output [2:0]M_AXI_B_arprot;
  input M_AXI_B_arready;
  output [2:0]M_AXI_B_arsize;
  output M_AXI_B_arvalid;
  output [63:0]M_AXI_B_awaddr;
  output [1:0]M_AXI_B_awburst;
  output [3:0]M_AXI_B_awcache;
  output [3:0]M_AXI_B_awid;
  output [7:0]M_AXI_B_awlen;
  output [0:0]M_AXI_B_awlock;
  output [2:0]M_AXI_B_awprot;
  input M_AXI_B_awready;
  output [2:0]M_AXI_B_awsize;
  output M_AXI_B_awvalid;
  input [3:0]M_AXI_B_bid;
  output M_AXI_B_bready;
  input [1:0]M_AXI_B_bresp;
  input M_AXI_B_bvalid;
  input [511:0]M_AXI_B_rdata;
  input [3:0]M_AXI_B_rid;
  input M_AXI_B_rlast;
  output M_AXI_B_rready;
  input [1:0]M_AXI_B_rresp;
  input M_AXI_B_rvalid;
  output [511:0]M_AXI_B_wdata;
  output M_AXI_B_wlast;
  input M_AXI_B_wready;
  output [63:0]M_AXI_B_wstrb;
  output M_AXI_B_wvalid;
  input [0:0]PCIE_REFCLK_clk_n;
  input [0:0]PCIE_REFCLK_clk_p;
  output axi_aclk;
  output axi_aresetn;
  input [15:0]pcie_mgt_rxn;
  input [15:0]pcie_mgt_rxp;
  output [15:0]pcie_mgt_txn;
  output [15:0]pcie_mgt_txp;

  wire [63:0]M_AXI_B_araddr;
  wire [1:0]M_AXI_B_arburst;
  wire [3:0]M_AXI_B_arcache;
  wire [3:0]M_AXI_B_arid;
  wire [7:0]M_AXI_B_arlen;
  wire \^M_AXI_B_arlock ;
  wire [2:0]M_AXI_B_arprot;
  wire M_AXI_B_arready;
  wire [2:0]M_AXI_B_arsize;
  wire M_AXI_B_arvalid;
  wire [63:0]M_AXI_B_awaddr;
  wire [1:0]M_AXI_B_awburst;
  wire [3:0]M_AXI_B_awcache;
  wire [3:0]M_AXI_B_awid;
  wire [7:0]M_AXI_B_awlen;
  wire \^M_AXI_B_awlock ;
  wire [2:0]M_AXI_B_awprot;
  wire M_AXI_B_awready;
  wire [2:0]M_AXI_B_awsize;
  wire M_AXI_B_awvalid;
  wire [3:0]M_AXI_B_bid;
  wire M_AXI_B_bready;
  wire [1:0]M_AXI_B_bresp;
  wire M_AXI_B_bvalid;
  wire [511:0]M_AXI_B_rdata;
  wire [3:0]M_AXI_B_rid;
  wire M_AXI_B_rlast;
  wire M_AXI_B_rready;
  wire [1:0]M_AXI_B_rresp;
  wire M_AXI_B_rvalid;
  wire [511:0]M_AXI_B_wdata;
  wire M_AXI_B_wlast;
  wire M_AXI_B_wready;
  wire [63:0]M_AXI_B_wstrb;
  wire M_AXI_B_wvalid;
  wire [0:0]PCIE_REFCLK_clk_n;
  wire [0:0]PCIE_REFCLK_clk_p;
  wire [31:0]axi4_lite_plug_M_AXI_ARADDR;
  wire axi4_lite_plug_M_AXI_ARREADY;
  wire axi4_lite_plug_M_AXI_ARVALID;
  wire [31:0]axi4_lite_plug_M_AXI_AWADDR;
  wire axi4_lite_plug_M_AXI_AWREADY;
  wire axi4_lite_plug_M_AXI_AWVALID;
  wire axi4_lite_plug_M_AXI_BREADY;
  wire [1:0]axi4_lite_plug_M_AXI_BRESP;
  wire axi4_lite_plug_M_AXI_BVALID;
  wire [31:0]axi4_lite_plug_M_AXI_RDATA;
  wire axi4_lite_plug_M_AXI_RREADY;
  wire [1:0]axi4_lite_plug_M_AXI_RRESP;
  wire axi4_lite_plug_M_AXI_RVALID;
  wire [31:0]axi4_lite_plug_M_AXI_WDATA;
  wire axi4_lite_plug_M_AXI_WREADY;
  wire [3:0]axi4_lite_plug_M_AXI_WSTRB;
  wire axi4_lite_plug_M_AXI_WVALID;
  wire axi_aclk;
  wire axi_aresetn;
  wire [0:0]clock_buffer_IBUF_DS_ODIV2;
  wire [0:0]clock_buffer_IBUF_OUT;
  wire [0:0]one_dout;
  wire [15:0]pcie_mgt_rxn;
  wire [15:0]pcie_mgt_rxp;
  wire [15:0]pcie_mgt_txn;
  wire [15:0]pcie_mgt_txp;

  assign M_AXI_B_arlock[0] = \^M_AXI_B_arlock ;
  assign M_AXI_B_awlock[0] = \^M_AXI_B_awlock ;
  top_level_axi4_lite_plug_0_0 axi4_lite_plug
       (.M_AXI_ARADDR(axi4_lite_plug_M_AXI_ARADDR),
        .M_AXI_ARREADY(axi4_lite_plug_M_AXI_ARREADY),
        .M_AXI_ARVALID(axi4_lite_plug_M_AXI_ARVALID),
        .M_AXI_AWADDR(axi4_lite_plug_M_AXI_AWADDR),
        .M_AXI_AWREADY(axi4_lite_plug_M_AXI_AWREADY),
        .M_AXI_AWVALID(axi4_lite_plug_M_AXI_AWVALID),
        .M_AXI_BREADY(axi4_lite_plug_M_AXI_BREADY),
        .M_AXI_BRESP(axi4_lite_plug_M_AXI_BRESP),
        .M_AXI_BVALID(axi4_lite_plug_M_AXI_BVALID),
        .M_AXI_RDATA(axi4_lite_plug_M_AXI_RDATA),
        .M_AXI_RREADY(axi4_lite_plug_M_AXI_RREADY),
        .M_AXI_RRESP(axi4_lite_plug_M_AXI_RRESP),
        .M_AXI_RVALID(axi4_lite_plug_M_AXI_RVALID),
        .M_AXI_WDATA(axi4_lite_plug_M_AXI_WDATA),
        .M_AXI_WREADY(axi4_lite_plug_M_AXI_WREADY),
        .M_AXI_WSTRB(axi4_lite_plug_M_AXI_WSTRB),
        .M_AXI_WVALID(axi4_lite_plug_M_AXI_WVALID),
        .clk(axi_aclk));
  top_level_util_ds_buf_0_0 clock_buffer
       (.IBUF_DS_N(PCIE_REFCLK_clk_n),
        .IBUF_DS_ODIV2(clock_buffer_IBUF_DS_ODIV2),
        .IBUF_DS_P(PCIE_REFCLK_clk_p),
        .IBUF_OUT(clock_buffer_IBUF_OUT));
  assign one_dout = 1'h1;
  top_level_xdma_0_0 pcie_bridge_0
       (.axi_aclk(axi_aclk),
        .axi_aresetn(axi_aresetn),
        .m_axib_araddr(M_AXI_B_araddr),
        .m_axib_arburst(M_AXI_B_arburst),
        .m_axib_arcache(M_AXI_B_arcache),
        .m_axib_arid(M_AXI_B_arid),
        .m_axib_arlen(M_AXI_B_arlen),
        .m_axib_arlock(\^M_AXI_B_arlock ),
        .m_axib_arprot(M_AXI_B_arprot),
        .m_axib_arready(M_AXI_B_arready),
        .m_axib_arsize(M_AXI_B_arsize),
        .m_axib_arvalid(M_AXI_B_arvalid),
        .m_axib_awaddr(M_AXI_B_awaddr),
        .m_axib_awburst(M_AXI_B_awburst),
        .m_axib_awcache(M_AXI_B_awcache),
        .m_axib_awid(M_AXI_B_awid),
        .m_axib_awlen(M_AXI_B_awlen),
        .m_axib_awlock(\^M_AXI_B_awlock ),
        .m_axib_awprot(M_AXI_B_awprot),
        .m_axib_awready(M_AXI_B_awready),
        .m_axib_awsize(M_AXI_B_awsize),
        .m_axib_awvalid(M_AXI_B_awvalid),
        .m_axib_bid(M_AXI_B_bid),
        .m_axib_bready(M_AXI_B_bready),
        .m_axib_bresp(M_AXI_B_bresp),
        .m_axib_bvalid(M_AXI_B_bvalid),
        .m_axib_rdata(M_AXI_B_rdata),
        .m_axib_rid(M_AXI_B_rid),
        .m_axib_rlast(M_AXI_B_rlast),
        .m_axib_rready(M_AXI_B_rready),
        .m_axib_rresp(M_AXI_B_rresp),
        .m_axib_rvalid(M_AXI_B_rvalid),
        .m_axib_wdata(M_AXI_B_wdata),
        .m_axib_wlast(M_AXI_B_wlast),
        .m_axib_wready(M_AXI_B_wready),
        .m_axib_wstrb(M_AXI_B_wstrb),
        .m_axib_wvalid(M_AXI_B_wvalid),
        .pci_exp_rxn(pcie_mgt_rxn),
        .pci_exp_rxp(pcie_mgt_rxp),
        .pci_exp_txn(pcie_mgt_txn),
        .pci_exp_txp(pcie_mgt_txp),
        .s_axil_araddr(axi4_lite_plug_M_AXI_ARADDR),
        .s_axil_arprot({1'b0,1'b0,1'b0}),
        .s_axil_arready(axi4_lite_plug_M_AXI_ARREADY),
        .s_axil_arvalid(axi4_lite_plug_M_AXI_ARVALID),
        .s_axil_awaddr(axi4_lite_plug_M_AXI_AWADDR),
        .s_axil_awprot({1'b0,1'b0,1'b0}),
        .s_axil_awready(axi4_lite_plug_M_AXI_AWREADY),
        .s_axil_awvalid(axi4_lite_plug_M_AXI_AWVALID),
        .s_axil_bready(axi4_lite_plug_M_AXI_BREADY),
        .s_axil_bresp(axi4_lite_plug_M_AXI_BRESP),
        .s_axil_bvalid(axi4_lite_plug_M_AXI_BVALID),
        .s_axil_rdata(axi4_lite_plug_M_AXI_RDATA),
        .s_axil_rready(axi4_lite_plug_M_AXI_RREADY),
        .s_axil_rresp(axi4_lite_plug_M_AXI_RRESP),
        .s_axil_rvalid(axi4_lite_plug_M_AXI_RVALID),
        .s_axil_wdata(axi4_lite_plug_M_AXI_WDATA),
        .s_axil_wready(axi4_lite_plug_M_AXI_WREADY),
        .s_axil_wstrb(axi4_lite_plug_M_AXI_WSTRB),
        .s_axil_wvalid(axi4_lite_plug_M_AXI_WVALID),
        .sys_clk(clock_buffer_IBUF_DS_ODIV2),
        .sys_clk_gt(clock_buffer_IBUF_OUT),
        .sys_rst_n(one_dout),
        .usr_irq_req(1'b0));
endmodule

module sys_192mhz_imp_1D7MHLQ
   (LVDS_CLK_clk_n,
    LVDS_CLK_clk_p,
    clk_192,
    init_clk_clk_n,
    init_clk_clk_p,
    resetn_192,
    sys_resetn);
  output [0:0]LVDS_CLK_clk_n;
  output [0:0]LVDS_CLK_clk_p;
  output clk_192;
  input init_clk_clk_n;
  input init_clk_clk_p;
  output resetn_192;
  input sys_resetn;

  wire [0:0]LVDS_CLK_clk_n;
  wire [0:0]LVDS_CLK_clk_p;
  wire clk_192;
  wire clk_768mhz_clk_768;
  wire init_clk_clk_n;
  wire init_clk_clk_p;
  wire resetn_192;
  wire sys_resetn;

  top_level_async_resetn_0 async_resetn
       (.dest_arst(resetn_192),
        .dest_clk(clk_192),
        .src_arst(sys_resetn));
  top_level_clk_wiz_0_1 clk_192mhz
       (.clk_192(clk_192),
        .clk_in1_n(init_clk_clk_n),
        .clk_in1_p(init_clk_clk_p));
  top_level_clk_wiz_0_2 clk_768mhz
       (.clk_768(clk_768mhz_clk_768),
        .clk_in1(clk_192));
  top_level_util_ds_buf_0_1 lvds_clk_buffer
       (.OBUF_DS_N(LVDS_CLK_clk_n),
        .OBUF_DS_P(LVDS_CLK_clk_p),
        .OBUF_IN(clk_768mhz_clk_768));
endmodule

(* CORE_GENERATION_INFO = "top_level,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=top_level,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=32,numReposBlks=26,numNonXlnxBlks=0,numHierBlks=6,maxHierDepth=2,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=14,numPkgbdBlks=0,bdsource=USER,\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"da_axi4_cnt\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"=2,\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"da_bram_cntlr_cnt\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"=2,\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"da_axi4_cnt\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"=1,\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"da_axi4_cnt\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"=1,\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"da_axi4_cnt\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"\"=1,synth_mode=Hierarchical}" *) (* HW_HANDOFF = "top_level.hwdef" *) 
module top_level
   (CHIP_HSI_CLK,
    CHIP_PA_SYNC,
    CHIP_RESET_N,
    CHIP_SPI_CLK,
    CHIP_SPI_CSN,
    CHIP_SPI_MISO,
    CHIP_SPI_MOSI,
    CHIP_VDD,
    CHIP_VDDA,
    CHIP_VDDIO,
    CHIP_VDDLVDS,
    GPIO13,
    GPIO15,
    LVDS_BANKA_clk_n,
    LVDS_BANKA_clk_p,
    LVDS_BANKB_clk_n,
    LVDS_BANKB_clk_p,
    LVDS_BANKC_clk_n,
    LVDS_BANKC_clk_p,
    LVDS_CLK_clk_n,
    LVDS_CLK_clk_p,
    LVDS_DN,
    LVDS_DP,
    LVL_TRSL_OE_N,
    UCI_ADC_CSN,
    UCI_ADC_MISO,
    UCI_ADC_MOSI,
    UCI_ADC_SCK,
    init_clk_clk_n,
    init_clk_clk_p,
    pcie_mgt_rxn,
    pcie_mgt_rxp,
    pcie_mgt_txn,
    pcie_mgt_txp,
    pcie_refclk_clk_n,
    pcie_refclk_clk_p,
    rs0,
    rs256);
  output CHIP_HSI_CLK;
  input CHIP_PA_SYNC;
  output CHIP_RESET_N;
  output CHIP_SPI_CLK;
  output CHIP_SPI_CSN;
  input CHIP_SPI_MISO;
  output CHIP_SPI_MOSI;
  output CHIP_VDD;
  output CHIP_VDDA;
  output CHIP_VDDIO;
  output CHIP_VDDLVDS;
  output [0:0]GPIO13;
  output [0:0]GPIO15;
  input LVDS_BANKA_clk_n;
  input LVDS_BANKA_clk_p;
  input LVDS_BANKB_clk_n;
  input LVDS_BANKB_clk_p;
  input LVDS_BANKC_clk_n;
  input LVDS_BANKC_clk_p;
  (* X_INTERFACE_INFO = "xilinx.com:interface:diff_clock:1.0 LVDS_CLK CLK_N" *) (* X_INTERFACE_MODE = "Master" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME LVDS_CLK, CAN_DEBUG false, FREQ_HZ 100000000" *) output [0:0]LVDS_CLK_clk_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:diff_clock:1.0 LVDS_CLK CLK_P" *) output [0:0]LVDS_CLK_clk_p;
  input [63:0]LVDS_DN;
  input [63:0]LVDS_DP;
  output LVL_TRSL_OE_N;
  output [2:0]UCI_ADC_CSN;
  input UCI_ADC_MISO;
  output UCI_ADC_MOSI;
  output UCI_ADC_SCK;
  (* X_INTERFACE_INFO = "xilinx.com:interface:diff_clock:1.0 init_clk CLK_N" *) (* X_INTERFACE_MODE = "Slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME init_clk, CAN_DEBUG false, FREQ_HZ 200000000" *) input init_clk_clk_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:diff_clock:1.0 init_clk CLK_P" *) input init_clk_clk_p;
  (* X_INTERFACE_INFO = "xilinx.com:interface:pcie_7x_mgt:1.0 pcie_mgt rxn" *) (* X_INTERFACE_MODE = "Master" *) input [15:0]pcie_mgt_rxn;
  (* X_INTERFACE_INFO = "xilinx.com:interface:pcie_7x_mgt:1.0 pcie_mgt rxp" *) input [15:0]pcie_mgt_rxp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:pcie_7x_mgt:1.0 pcie_mgt txn" *) output [15:0]pcie_mgt_txn;
  (* X_INTERFACE_INFO = "xilinx.com:interface:pcie_7x_mgt:1.0 pcie_mgt txp" *) output [15:0]pcie_mgt_txp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:diff_clock:1.0 pcie_refclk CLK_N" *) (* X_INTERFACE_MODE = "Slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME pcie_refclk, CAN_DEBUG false, FREQ_HZ 100000000" *) input [0:0]pcie_refclk_clk_n;
  (* X_INTERFACE_INFO = "xilinx.com:interface:diff_clock:1.0 pcie_refclk CLK_P" *) input [0:0]pcie_refclk_clk_p;
  output rs0;
  output rs256;

  wire CHIP_HSI_CLK;
  wire CHIP_PA_SYNC;
  wire CHIP_RESET_N;
  wire CHIP_SPI_CLK;
  wire CHIP_SPI_CSN;
  wire CHIP_SPI_MISO;
  wire CHIP_SPI_MOSI;
  wire CHIP_VDD;
  wire CHIP_VDDA;
  wire CHIP_VDDIO;
  wire CHIP_VDDLVDS;
  wire [0:0]GPIO15;
  wire LVDS_BANKA_clk_n;
  wire LVDS_BANKA_clk_p;
  wire LVDS_BANKB_clk_n;
  wire LVDS_BANKB_clk_p;
  wire LVDS_BANKC_clk_n;
  wire LVDS_BANKC_clk_p;
  wire [0:0]LVDS_CLK_clk_n;
  wire [0:0]LVDS_CLK_clk_p;
  wire [63:0]LVDS_DN;
  wire [63:0]LVDS_DP;
  wire LVL_TRSL_OE_N;
  wire [7:0]S_AXI_1_ARADDR;
  wire [2:0]S_AXI_1_ARPROT;
  wire S_AXI_1_ARREADY;
  wire S_AXI_1_ARVALID;
  wire [7:0]S_AXI_1_AWADDR;
  wire [2:0]S_AXI_1_AWPROT;
  wire S_AXI_1_AWREADY;
  wire S_AXI_1_AWVALID;
  wire S_AXI_1_BREADY;
  wire [1:0]S_AXI_1_BRESP;
  wire S_AXI_1_BVALID;
  wire [31:0]S_AXI_1_RDATA;
  wire S_AXI_1_RREADY;
  wire [1:0]S_AXI_1_RRESP;
  wire S_AXI_1_RVALID;
  wire [31:0]S_AXI_1_WDATA;
  wire S_AXI_1_WREADY;
  wire [3:0]S_AXI_1_WSTRB;
  wire S_AXI_1_WVALID;
  wire [7:0]S_AXI_2_ARADDR;
  wire [2:0]S_AXI_2_ARPROT;
  wire S_AXI_2_ARREADY;
  wire S_AXI_2_ARVALID;
  wire [7:0]S_AXI_2_AWADDR;
  wire [2:0]S_AXI_2_AWPROT;
  wire S_AXI_2_AWREADY;
  wire S_AXI_2_AWVALID;
  wire S_AXI_2_BREADY;
  wire [1:0]S_AXI_2_BRESP;
  wire S_AXI_2_BVALID;
  wire [31:0]S_AXI_2_RDATA;
  wire S_AXI_2_RREADY;
  wire [1:0]S_AXI_2_RRESP;
  wire S_AXI_2_RVALID;
  wire [31:0]S_AXI_2_WDATA;
  wire S_AXI_2_WREADY;
  wire [3:0]S_AXI_2_WSTRB;
  wire S_AXI_2_WVALID;
  wire [7:0]S_AXI_CTL_1_ARADDR;
  wire [2:0]S_AXI_CTL_1_ARPROT;
  wire S_AXI_CTL_1_ARREADY;
  wire S_AXI_CTL_1_ARVALID;
  wire [7:0]S_AXI_CTL_1_AWADDR;
  wire [2:0]S_AXI_CTL_1_AWPROT;
  wire S_AXI_CTL_1_AWREADY;
  wire S_AXI_CTL_1_AWVALID;
  wire S_AXI_CTL_1_BREADY;
  wire [1:0]S_AXI_CTL_1_BRESP;
  wire S_AXI_CTL_1_BVALID;
  wire [31:0]S_AXI_CTL_1_RDATA;
  wire S_AXI_CTL_1_RREADY;
  wire [1:0]S_AXI_CTL_1_RRESP;
  wire S_AXI_CTL_1_RVALID;
  wire [31:0]S_AXI_CTL_1_WDATA;
  wire S_AXI_CTL_1_WREADY;
  wire [3:0]S_AXI_CTL_1_WSTRB;
  wire S_AXI_CTL_1_WVALID;
  wire [2:0]UCI_ADC_CSN;
  wire UCI_ADC_MISO;
  wire UCI_ADC_MOSI;
  wire UCI_ADC_SCK;
  wire clk_192mhz_clk_192;
  wire init_clk_clk_n;
  wire init_clk_clk_p;
  wire pcie_bridge_0_axi_aclk;
  wire pcie_bridge_0_axi_aresetn;
  wire [63:0]pcie_bridge_M_AXI_B_ARADDR;
  wire [1:0]pcie_bridge_M_AXI_B_ARBURST;
  wire [3:0]pcie_bridge_M_AXI_B_ARCACHE;
  wire [3:0]pcie_bridge_M_AXI_B_ARID;
  wire [7:0]pcie_bridge_M_AXI_B_ARLEN;
  wire [0:0]pcie_bridge_M_AXI_B_ARLOCK;
  wire [2:0]pcie_bridge_M_AXI_B_ARPROT;
  wire pcie_bridge_M_AXI_B_ARREADY;
  wire [2:0]pcie_bridge_M_AXI_B_ARSIZE;
  wire pcie_bridge_M_AXI_B_ARVALID;
  wire [63:0]pcie_bridge_M_AXI_B_AWADDR;
  wire [1:0]pcie_bridge_M_AXI_B_AWBURST;
  wire [3:0]pcie_bridge_M_AXI_B_AWCACHE;
  wire [3:0]pcie_bridge_M_AXI_B_AWID;
  wire [7:0]pcie_bridge_M_AXI_B_AWLEN;
  wire [0:0]pcie_bridge_M_AXI_B_AWLOCK;
  wire [2:0]pcie_bridge_M_AXI_B_AWPROT;
  wire pcie_bridge_M_AXI_B_AWREADY;
  wire [2:0]pcie_bridge_M_AXI_B_AWSIZE;
  wire pcie_bridge_M_AXI_B_AWVALID;
  wire [3:0]pcie_bridge_M_AXI_B_BID;
  wire pcie_bridge_M_AXI_B_BREADY;
  wire [1:0]pcie_bridge_M_AXI_B_BRESP;
  wire pcie_bridge_M_AXI_B_BVALID;
  wire [511:0]pcie_bridge_M_AXI_B_RDATA;
  wire [3:0]pcie_bridge_M_AXI_B_RID;
  wire pcie_bridge_M_AXI_B_RLAST;
  wire pcie_bridge_M_AXI_B_RREADY;
  wire [1:0]pcie_bridge_M_AXI_B_RRESP;
  wire pcie_bridge_M_AXI_B_RVALID;
  wire [511:0]pcie_bridge_M_AXI_B_WDATA;
  wire pcie_bridge_M_AXI_B_WLAST;
  wire pcie_bridge_M_AXI_B_WREADY;
  wire [63:0]pcie_bridge_M_AXI_B_WSTRB;
  wire pcie_bridge_M_AXI_B_WVALID;
  wire [15:0]pcie_mgt_rxn;
  wire [15:0]pcie_mgt_rxp;
  wire [15:0]pcie_mgt_txn;
  wire [15:0]pcie_mgt_txp;
  wire [0:0]pcie_refclk_clk_n;
  wire [0:0]pcie_refclk_clk_p;
  wire rs0;
  wire rs256;
  wire [7:0]smartconnect_M00_AXI_ARADDR;
  wire [2:0]smartconnect_M00_AXI_ARPROT;
  wire smartconnect_M00_AXI_ARREADY;
  wire smartconnect_M00_AXI_ARVALID;
  wire [7:0]smartconnect_M00_AXI_AWADDR;
  wire [2:0]smartconnect_M00_AXI_AWPROT;
  wire smartconnect_M00_AXI_AWREADY;
  wire smartconnect_M00_AXI_AWVALID;
  wire smartconnect_M00_AXI_BREADY;
  wire [1:0]smartconnect_M00_AXI_BRESP;
  wire smartconnect_M00_AXI_BVALID;
  wire [31:0]smartconnect_M00_AXI_RDATA;
  wire smartconnect_M00_AXI_RREADY;
  wire [1:0]smartconnect_M00_AXI_RRESP;
  wire smartconnect_M00_AXI_RVALID;
  wire [31:0]smartconnect_M00_AXI_WDATA;
  wire smartconnect_M00_AXI_WREADY;
  wire [3:0]smartconnect_M00_AXI_WSTRB;
  wire smartconnect_M00_AXI_WVALID;
  wire [7:0]smartconnect_M04_AXI_ARADDR;
  wire [2:0]smartconnect_M04_AXI_ARPROT;
  wire smartconnect_M04_AXI_ARREADY;
  wire smartconnect_M04_AXI_ARVALID;
  wire [7:0]smartconnect_M04_AXI_AWADDR;
  wire [2:0]smartconnect_M04_AXI_AWPROT;
  wire smartconnect_M04_AXI_AWREADY;
  wire smartconnect_M04_AXI_AWVALID;
  wire smartconnect_M04_AXI_BREADY;
  wire [1:0]smartconnect_M04_AXI_BRESP;
  wire smartconnect_M04_AXI_BVALID;
  wire [31:0]smartconnect_M04_AXI_RDATA;
  wire smartconnect_M04_AXI_RREADY;
  wire [1:0]smartconnect_M04_AXI_RRESP;
  wire smartconnect_M04_AXI_RVALID;
  wire [31:0]smartconnect_M04_AXI_WDATA;
  wire smartconnect_M04_AXI_WREADY;
  wire [3:0]smartconnect_M04_AXI_WSTRB;
  wire smartconnect_M04_AXI_WVALID;
  wire source_160mhz_clk_out;
  wire sys_192mhz_resetn_192;

  assign GPIO13[0] = GPIO15;
  adc_bank_imp_1SLD8RV adc_bank
       (.S_AXI_araddr(S_AXI_2_ARADDR),
        .S_AXI_arprot(S_AXI_2_ARPROT),
        .S_AXI_arready(S_AXI_2_ARREADY),
        .S_AXI_arvalid(S_AXI_2_ARVALID),
        .S_AXI_awaddr(S_AXI_2_AWADDR),
        .S_AXI_awprot(S_AXI_2_AWPROT),
        .S_AXI_awready(S_AXI_2_AWREADY),
        .S_AXI_awvalid(S_AXI_2_AWVALID),
        .S_AXI_bready(S_AXI_2_BREADY),
        .S_AXI_bresp(S_AXI_2_BRESP),
        .S_AXI_bvalid(S_AXI_2_BVALID),
        .S_AXI_rdata(S_AXI_2_RDATA),
        .S_AXI_rready(S_AXI_2_RREADY),
        .S_AXI_rresp(S_AXI_2_RRESP),
        .S_AXI_rvalid(S_AXI_2_RVALID),
        .S_AXI_wdata(S_AXI_2_WDATA),
        .S_AXI_wready(S_AXI_2_WREADY),
        .S_AXI_wstrb(S_AXI_2_WSTRB),
        .S_AXI_wvalid(S_AXI_2_WVALID),
        .UCI_ADC_CSN(UCI_ADC_CSN),
        .UCI_ADC_MISO(UCI_ADC_MISO),
        .UCI_ADC_MOSI(UCI_ADC_MOSI),
        .UCI_ADC_SCK(UCI_ADC_SCK),
        .clk(pcie_bridge_0_axi_aclk),
        .resetn(pcie_bridge_0_axi_aresetn));
  chip_spi_imp_HJ3TY6 chip_spi
       (.CHIP_SPI_CLK(CHIP_SPI_CLK),
        .CHIP_SPI_CSN(CHIP_SPI_CSN),
        .CHIP_SPI_MISO(CHIP_SPI_MISO),
        .CHIP_SPI_MOSI(CHIP_SPI_MOSI),
        .HSI_CLK(CHIP_HSI_CLK),
        .S_AXI_araddr(S_AXI_1_ARADDR),
        .S_AXI_arprot(S_AXI_1_ARPROT),
        .S_AXI_arready(S_AXI_1_ARREADY),
        .S_AXI_arvalid(S_AXI_1_ARVALID),
        .S_AXI_awaddr(S_AXI_1_AWADDR),
        .S_AXI_awprot(S_AXI_1_AWPROT),
        .S_AXI_awready(S_AXI_1_AWREADY),
        .S_AXI_awvalid(S_AXI_1_AWVALID),
        .S_AXI_bready(S_AXI_1_BREADY),
        .S_AXI_bresp(S_AXI_1_BRESP),
        .S_AXI_bvalid(S_AXI_1_BVALID),
        .S_AXI_rdata(S_AXI_1_RDATA),
        .S_AXI_rready(S_AXI_1_RREADY),
        .S_AXI_rresp(S_AXI_1_RRESP),
        .S_AXI_rvalid(S_AXI_1_RVALID),
        .S_AXI_wdata(S_AXI_1_WDATA),
        .S_AXI_wready(S_AXI_1_WREADY),
        .S_AXI_wstrb(S_AXI_1_WSTRB),
        .S_AXI_wvalid(S_AXI_1_WVALID),
        .clk_160(source_160mhz_clk_out),
        .sys_clk(pcie_bridge_0_axi_aclk),
        .sys_resetn(pcie_bridge_0_axi_aresetn));
  top_level_framegen_ctl_0_0 framegen_ctl
       (.S_AXI_ARADDR(smartconnect_M04_AXI_ARADDR),
        .S_AXI_ARPROT(smartconnect_M04_AXI_ARPROT),
        .S_AXI_ARREADY(smartconnect_M04_AXI_ARREADY),
        .S_AXI_ARVALID(smartconnect_M04_AXI_ARVALID),
        .S_AXI_AWADDR(smartconnect_M04_AXI_AWADDR),
        .S_AXI_AWPROT(smartconnect_M04_AXI_AWPROT),
        .S_AXI_AWREADY(smartconnect_M04_AXI_AWREADY),
        .S_AXI_AWVALID(smartconnect_M04_AXI_AWVALID),
        .S_AXI_BREADY(smartconnect_M04_AXI_BREADY),
        .S_AXI_BRESP(smartconnect_M04_AXI_BRESP),
        .S_AXI_BVALID(smartconnect_M04_AXI_BVALID),
        .S_AXI_RDATA(smartconnect_M04_AXI_RDATA),
        .S_AXI_RREADY(smartconnect_M04_AXI_RREADY),
        .S_AXI_RRESP(smartconnect_M04_AXI_RRESP),
        .S_AXI_RVALID(smartconnect_M04_AXI_RVALID),
        .S_AXI_WDATA(smartconnect_M04_AXI_WDATA),
        .S_AXI_WREADY(smartconnect_M04_AXI_WREADY),
        .S_AXI_WSTRB(smartconnect_M04_AXI_WSTRB),
        .S_AXI_WVALID(smartconnect_M04_AXI_WVALID),
        .clk(clk_192mhz_clk_192),
        .pa_sync_raw(CHIP_PA_SYNC),
        .resetn(sys_192mhz_resetn_192),
        .rs0(rs0),
        .rs256(rs256));
  assign GPIO15 = 1'h0;
  top_level_indy_power_ctl_0_0 indy_power_ctl
       (.S_AXI_ARADDR(smartconnect_M00_AXI_ARADDR),
        .S_AXI_ARPROT(smartconnect_M00_AXI_ARPROT),
        .S_AXI_ARREADY(smartconnect_M00_AXI_ARREADY),
        .S_AXI_ARVALID(smartconnect_M00_AXI_ARVALID),
        .S_AXI_AWADDR(smartconnect_M00_AXI_AWADDR),
        .S_AXI_AWPROT(smartconnect_M00_AXI_AWPROT),
        .S_AXI_AWREADY(smartconnect_M00_AXI_AWREADY),
        .S_AXI_AWVALID(smartconnect_M00_AXI_AWVALID),
        .S_AXI_BREADY(smartconnect_M00_AXI_BREADY),
        .S_AXI_BRESP(smartconnect_M00_AXI_BRESP),
        .S_AXI_BVALID(smartconnect_M00_AXI_BVALID),
        .S_AXI_RDATA(smartconnect_M00_AXI_RDATA),
        .S_AXI_RREADY(smartconnect_M00_AXI_RREADY),
        .S_AXI_RRESP(smartconnect_M00_AXI_RRESP),
        .S_AXI_RVALID(smartconnect_M00_AXI_RVALID),
        .S_AXI_WDATA(smartconnect_M00_AXI_WDATA),
        .S_AXI_WREADY(smartconnect_M00_AXI_WREADY),
        .S_AXI_WSTRB(smartconnect_M00_AXI_WSTRB),
        .S_AXI_WVALID(smartconnect_M00_AXI_WVALID),
        .chip_reset_n(CHIP_RESET_N),
        .chip_vdd(CHIP_VDD),
        .chip_vdda(CHIP_VDDA),
        .chip_vddio(CHIP_VDDIO),
        .chip_vddlvds(CHIP_VDDLVDS),
        .clk(pcie_bridge_0_axi_aclk),
        .lvl_trsl_oe_n(LVL_TRSL_OE_N),
        .resetn(pcie_bridge_0_axi_aresetn));
  lvds_imp_JR8VK lvds
       (.CHIP_PA_SYNC(CHIP_PA_SYNC),
        .LVDS_BANKA_clk_n(LVDS_BANKA_clk_n),
        .LVDS_BANKA_clk_p(LVDS_BANKA_clk_p),
        .LVDS_BANKB_clk_n(LVDS_BANKB_clk_n),
        .LVDS_BANKB_clk_p(LVDS_BANKB_clk_p),
        .LVDS_BANKC_clk_n(LVDS_BANKC_clk_n),
        .LVDS_BANKC_clk_p(LVDS_BANKC_clk_p),
        .LVDS_DN(LVDS_DN),
        .LVDS_DP(LVDS_DP),
        .S_AXI_CTL_araddr(S_AXI_CTL_1_ARADDR),
        .S_AXI_CTL_arprot(S_AXI_CTL_1_ARPROT),
        .S_AXI_CTL_arready(S_AXI_CTL_1_ARREADY),
        .S_AXI_CTL_arvalid(S_AXI_CTL_1_ARVALID),
        .S_AXI_CTL_awaddr(S_AXI_CTL_1_AWADDR),
        .S_AXI_CTL_awprot(S_AXI_CTL_1_AWPROT),
        .S_AXI_CTL_awready(S_AXI_CTL_1_AWREADY),
        .S_AXI_CTL_awvalid(S_AXI_CTL_1_AWVALID),
        .S_AXI_CTL_bready(S_AXI_CTL_1_BREADY),
        .S_AXI_CTL_bresp(S_AXI_CTL_1_BRESP),
        .S_AXI_CTL_bvalid(S_AXI_CTL_1_BVALID),
        .S_AXI_CTL_rdata(S_AXI_CTL_1_RDATA),
        .S_AXI_CTL_rready(S_AXI_CTL_1_RREADY),
        .S_AXI_CTL_rresp(S_AXI_CTL_1_RRESP),
        .S_AXI_CTL_rvalid(S_AXI_CTL_1_RVALID),
        .S_AXI_CTL_wdata(S_AXI_CTL_1_WDATA),
        .S_AXI_CTL_wready(S_AXI_CTL_1_WREADY),
        .S_AXI_CTL_wstrb(S_AXI_CTL_1_WSTRB),
        .S_AXI_CTL_wvalid(S_AXI_CTL_1_WVALID),
        .clk(clk_192mhz_clk_192),
        .resetn(sys_192mhz_resetn_192));
  pcie_bridge_imp_1AINXYK pcie_bridge
       (.M_AXI_B_araddr(pcie_bridge_M_AXI_B_ARADDR),
        .M_AXI_B_arburst(pcie_bridge_M_AXI_B_ARBURST),
        .M_AXI_B_arcache(pcie_bridge_M_AXI_B_ARCACHE),
        .M_AXI_B_arid(pcie_bridge_M_AXI_B_ARID),
        .M_AXI_B_arlen(pcie_bridge_M_AXI_B_ARLEN),
        .M_AXI_B_arlock(pcie_bridge_M_AXI_B_ARLOCK),
        .M_AXI_B_arprot(pcie_bridge_M_AXI_B_ARPROT),
        .M_AXI_B_arready(pcie_bridge_M_AXI_B_ARREADY),
        .M_AXI_B_arsize(pcie_bridge_M_AXI_B_ARSIZE),
        .M_AXI_B_arvalid(pcie_bridge_M_AXI_B_ARVALID),
        .M_AXI_B_awaddr(pcie_bridge_M_AXI_B_AWADDR),
        .M_AXI_B_awburst(pcie_bridge_M_AXI_B_AWBURST),
        .M_AXI_B_awcache(pcie_bridge_M_AXI_B_AWCACHE),
        .M_AXI_B_awid(pcie_bridge_M_AXI_B_AWID),
        .M_AXI_B_awlen(pcie_bridge_M_AXI_B_AWLEN),
        .M_AXI_B_awlock(pcie_bridge_M_AXI_B_AWLOCK),
        .M_AXI_B_awprot(pcie_bridge_M_AXI_B_AWPROT),
        .M_AXI_B_awready(pcie_bridge_M_AXI_B_AWREADY),
        .M_AXI_B_awsize(pcie_bridge_M_AXI_B_AWSIZE),
        .M_AXI_B_awvalid(pcie_bridge_M_AXI_B_AWVALID),
        .M_AXI_B_bid(pcie_bridge_M_AXI_B_BID),
        .M_AXI_B_bready(pcie_bridge_M_AXI_B_BREADY),
        .M_AXI_B_bresp(pcie_bridge_M_AXI_B_BRESP),
        .M_AXI_B_bvalid(pcie_bridge_M_AXI_B_BVALID),
        .M_AXI_B_rdata(pcie_bridge_M_AXI_B_RDATA),
        .M_AXI_B_rid(pcie_bridge_M_AXI_B_RID),
        .M_AXI_B_rlast(pcie_bridge_M_AXI_B_RLAST),
        .M_AXI_B_rready(pcie_bridge_M_AXI_B_RREADY),
        .M_AXI_B_rresp(pcie_bridge_M_AXI_B_RRESP),
        .M_AXI_B_rvalid(pcie_bridge_M_AXI_B_RVALID),
        .M_AXI_B_wdata(pcie_bridge_M_AXI_B_WDATA),
        .M_AXI_B_wlast(pcie_bridge_M_AXI_B_WLAST),
        .M_AXI_B_wready(pcie_bridge_M_AXI_B_WREADY),
        .M_AXI_B_wstrb(pcie_bridge_M_AXI_B_WSTRB),
        .M_AXI_B_wvalid(pcie_bridge_M_AXI_B_WVALID),
        .PCIE_REFCLK_clk_n(pcie_refclk_clk_n),
        .PCIE_REFCLK_clk_p(pcie_refclk_clk_p),
        .axi_aclk(pcie_bridge_0_axi_aclk),
        .axi_aresetn(pcie_bridge_0_axi_aresetn),
        .pcie_mgt_rxn(pcie_mgt_rxn),
        .pcie_mgt_rxp(pcie_mgt_rxp),
        .pcie_mgt_txn(pcie_mgt_txn),
        .pcie_mgt_txp(pcie_mgt_txp));
  top_level_smartconnect_0_0 smartconnect
       (.M00_AXI_araddr(smartconnect_M00_AXI_ARADDR),
        .M00_AXI_arprot(smartconnect_M00_AXI_ARPROT),
        .M00_AXI_arready(smartconnect_M00_AXI_ARREADY),
        .M00_AXI_arvalid(smartconnect_M00_AXI_ARVALID),
        .M00_AXI_awaddr(smartconnect_M00_AXI_AWADDR),
        .M00_AXI_awprot(smartconnect_M00_AXI_AWPROT),
        .M00_AXI_awready(smartconnect_M00_AXI_AWREADY),
        .M00_AXI_awvalid(smartconnect_M00_AXI_AWVALID),
        .M00_AXI_bready(smartconnect_M00_AXI_BREADY),
        .M00_AXI_bresp(smartconnect_M00_AXI_BRESP),
        .M00_AXI_bvalid(smartconnect_M00_AXI_BVALID),
        .M00_AXI_rdata(smartconnect_M00_AXI_RDATA),
        .M00_AXI_rready(smartconnect_M00_AXI_RREADY),
        .M00_AXI_rresp(smartconnect_M00_AXI_RRESP),
        .M00_AXI_rvalid(smartconnect_M00_AXI_RVALID),
        .M00_AXI_wdata(smartconnect_M00_AXI_WDATA),
        .M00_AXI_wready(smartconnect_M00_AXI_WREADY),
        .M00_AXI_wstrb(smartconnect_M00_AXI_WSTRB),
        .M00_AXI_wvalid(smartconnect_M00_AXI_WVALID),
        .M01_AXI_araddr(S_AXI_2_ARADDR),
        .M01_AXI_arprot(S_AXI_2_ARPROT),
        .M01_AXI_arready(S_AXI_2_ARREADY),
        .M01_AXI_arvalid(S_AXI_2_ARVALID),
        .M01_AXI_awaddr(S_AXI_2_AWADDR),
        .M01_AXI_awprot(S_AXI_2_AWPROT),
        .M01_AXI_awready(S_AXI_2_AWREADY),
        .M01_AXI_awvalid(S_AXI_2_AWVALID),
        .M01_AXI_bready(S_AXI_2_BREADY),
        .M01_AXI_bresp(S_AXI_2_BRESP),
        .M01_AXI_bvalid(S_AXI_2_BVALID),
        .M01_AXI_rdata(S_AXI_2_RDATA),
        .M01_AXI_rready(S_AXI_2_RREADY),
        .M01_AXI_rresp(S_AXI_2_RRESP),
        .M01_AXI_rvalid(S_AXI_2_RVALID),
        .M01_AXI_wdata(S_AXI_2_WDATA),
        .M01_AXI_wready(S_AXI_2_WREADY),
        .M01_AXI_wstrb(S_AXI_2_WSTRB),
        .M01_AXI_wvalid(S_AXI_2_WVALID),
        .M02_AXI_araddr(S_AXI_1_ARADDR),
        .M02_AXI_arprot(S_AXI_1_ARPROT),
        .M02_AXI_arready(S_AXI_1_ARREADY),
        .M02_AXI_arvalid(S_AXI_1_ARVALID),
        .M02_AXI_awaddr(S_AXI_1_AWADDR),
        .M02_AXI_awprot(S_AXI_1_AWPROT),
        .M02_AXI_awready(S_AXI_1_AWREADY),
        .M02_AXI_awvalid(S_AXI_1_AWVALID),
        .M02_AXI_bready(S_AXI_1_BREADY),
        .M02_AXI_bresp(S_AXI_1_BRESP),
        .M02_AXI_bvalid(S_AXI_1_BVALID),
        .M02_AXI_rdata(S_AXI_1_RDATA),
        .M02_AXI_rready(S_AXI_1_RREADY),
        .M02_AXI_rresp(S_AXI_1_RRESP),
        .M02_AXI_rvalid(S_AXI_1_RVALID),
        .M02_AXI_wdata(S_AXI_1_WDATA),
        .M02_AXI_wready(S_AXI_1_WREADY),
        .M02_AXI_wstrb(S_AXI_1_WSTRB),
        .M02_AXI_wvalid(S_AXI_1_WVALID),
        .M03_AXI_araddr(S_AXI_CTL_1_ARADDR),
        .M03_AXI_arprot(S_AXI_CTL_1_ARPROT),
        .M03_AXI_arready(S_AXI_CTL_1_ARREADY),
        .M03_AXI_arvalid(S_AXI_CTL_1_ARVALID),
        .M03_AXI_awaddr(S_AXI_CTL_1_AWADDR),
        .M03_AXI_awprot(S_AXI_CTL_1_AWPROT),
        .M03_AXI_awready(S_AXI_CTL_1_AWREADY),
        .M03_AXI_awvalid(S_AXI_CTL_1_AWVALID),
        .M03_AXI_bready(S_AXI_CTL_1_BREADY),
        .M03_AXI_bresp(S_AXI_CTL_1_BRESP),
        .M03_AXI_bvalid(S_AXI_CTL_1_BVALID),
        .M03_AXI_rdata(S_AXI_CTL_1_RDATA),
        .M03_AXI_rready(S_AXI_CTL_1_RREADY),
        .M03_AXI_rresp(S_AXI_CTL_1_RRESP),
        .M03_AXI_rvalid(S_AXI_CTL_1_RVALID),
        .M03_AXI_wdata(S_AXI_CTL_1_WDATA),
        .M03_AXI_wready(S_AXI_CTL_1_WREADY),
        .M03_AXI_wstrb(S_AXI_CTL_1_WSTRB),
        .M03_AXI_wvalid(S_AXI_CTL_1_WVALID),
        .M04_AXI_araddr(smartconnect_M04_AXI_ARADDR),
        .M04_AXI_arprot(smartconnect_M04_AXI_ARPROT),
        .M04_AXI_arready(smartconnect_M04_AXI_ARREADY),
        .M04_AXI_arvalid(smartconnect_M04_AXI_ARVALID),
        .M04_AXI_awaddr(smartconnect_M04_AXI_AWADDR),
        .M04_AXI_awprot(smartconnect_M04_AXI_AWPROT),
        .M04_AXI_awready(smartconnect_M04_AXI_AWREADY),
        .M04_AXI_awvalid(smartconnect_M04_AXI_AWVALID),
        .M04_AXI_bready(smartconnect_M04_AXI_BREADY),
        .M04_AXI_bresp(smartconnect_M04_AXI_BRESP),
        .M04_AXI_bvalid(smartconnect_M04_AXI_BVALID),
        .M04_AXI_rdata(smartconnect_M04_AXI_RDATA),
        .M04_AXI_rready(smartconnect_M04_AXI_RREADY),
        .M04_AXI_rresp(smartconnect_M04_AXI_RRESP),
        .M04_AXI_rvalid(smartconnect_M04_AXI_RVALID),
        .M04_AXI_wdata(smartconnect_M04_AXI_WDATA),
        .M04_AXI_wready(smartconnect_M04_AXI_WREADY),
        .M04_AXI_wstrb(smartconnect_M04_AXI_WSTRB),
        .M04_AXI_wvalid(smartconnect_M04_AXI_WVALID),
        .S00_AXI_araddr(pcie_bridge_M_AXI_B_ARADDR),
        .S00_AXI_arburst(pcie_bridge_M_AXI_B_ARBURST),
        .S00_AXI_arcache(pcie_bridge_M_AXI_B_ARCACHE),
        .S00_AXI_arid(pcie_bridge_M_AXI_B_ARID),
        .S00_AXI_arlen(pcie_bridge_M_AXI_B_ARLEN),
        .S00_AXI_arlock(pcie_bridge_M_AXI_B_ARLOCK),
        .S00_AXI_arprot(pcie_bridge_M_AXI_B_ARPROT),
        .S00_AXI_arqos({1'b0,1'b0,1'b0,1'b0}),
        .S00_AXI_arready(pcie_bridge_M_AXI_B_ARREADY),
        .S00_AXI_arsize(pcie_bridge_M_AXI_B_ARSIZE),
        .S00_AXI_arvalid(pcie_bridge_M_AXI_B_ARVALID),
        .S00_AXI_awaddr(pcie_bridge_M_AXI_B_AWADDR),
        .S00_AXI_awburst(pcie_bridge_M_AXI_B_AWBURST),
        .S00_AXI_awcache(pcie_bridge_M_AXI_B_AWCACHE),
        .S00_AXI_awid(pcie_bridge_M_AXI_B_AWID),
        .S00_AXI_awlen(pcie_bridge_M_AXI_B_AWLEN),
        .S00_AXI_awlock(pcie_bridge_M_AXI_B_AWLOCK),
        .S00_AXI_awprot(pcie_bridge_M_AXI_B_AWPROT),
        .S00_AXI_awqos({1'b0,1'b0,1'b0,1'b0}),
        .S00_AXI_awready(pcie_bridge_M_AXI_B_AWREADY),
        .S00_AXI_awsize(pcie_bridge_M_AXI_B_AWSIZE),
        .S00_AXI_awvalid(pcie_bridge_M_AXI_B_AWVALID),
        .S00_AXI_bid(pcie_bridge_M_AXI_B_BID),
        .S00_AXI_bready(pcie_bridge_M_AXI_B_BREADY),
        .S00_AXI_bresp(pcie_bridge_M_AXI_B_BRESP),
        .S00_AXI_bvalid(pcie_bridge_M_AXI_B_BVALID),
        .S00_AXI_rdata(pcie_bridge_M_AXI_B_RDATA),
        .S00_AXI_rid(pcie_bridge_M_AXI_B_RID),
        .S00_AXI_rlast(pcie_bridge_M_AXI_B_RLAST),
        .S00_AXI_rready(pcie_bridge_M_AXI_B_RREADY),
        .S00_AXI_rresp(pcie_bridge_M_AXI_B_RRESP),
        .S00_AXI_rvalid(pcie_bridge_M_AXI_B_RVALID),
        .S00_AXI_wdata(pcie_bridge_M_AXI_B_WDATA),
        .S00_AXI_wlast(pcie_bridge_M_AXI_B_WLAST),
        .S00_AXI_wready(pcie_bridge_M_AXI_B_WREADY),
        .S00_AXI_wstrb(pcie_bridge_M_AXI_B_WSTRB),
        .S00_AXI_wvalid(pcie_bridge_M_AXI_B_WVALID),
        .aclk(pcie_bridge_0_axi_aclk),
        .aclk1(source_160mhz_clk_out),
        .aclk2(clk_192mhz_clk_192),
        .aresetn(pcie_bridge_0_axi_aresetn));
  sys_192mhz_imp_1D7MHLQ sys_192mhz
       (.LVDS_CLK_clk_n(LVDS_CLK_clk_n),
        .LVDS_CLK_clk_p(LVDS_CLK_clk_p),
        .clk_192(clk_192mhz_clk_192),
        .init_clk_clk_n(init_clk_clk_n),
        .init_clk_clk_p(init_clk_clk_p),
        .resetn_192(sys_192mhz_resetn_192),
        .sys_resetn(pcie_bridge_0_axi_aresetn));
endmodule
