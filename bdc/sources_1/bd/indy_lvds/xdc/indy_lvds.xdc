
# ---------------------------------------------------------------------------
# Pin definitions for indy_lvds BDC
# ---------------------------------------------------------------------------



#
# LVDS  clock output to the sensor-chip. 768 MHz
#
set_property -dict {PACKAGE_PIN F22  IOSTANDARD LVDS  DATA_RATE DDR  LVDS_PRE_EMPHASIS FALSE } [get_ports LVDS_CLK_clk_n];  # IO Bank 70     Board signal name: CLK512_N
set_property -dict {PACKAGE_PIN G22  IOSTANDARD LVDS  DATA_RATE DDR  LVDS_PRE_EMPHASIS FALSE } [get_ports LVDS_CLK_clk_p];  # IO Bank 70     Board signal name: CLK512_P


#
# LVDS clock inputs, one per HSSIO bank
#
set_property -dict {PACKAGE_PIN F28    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_BANKA_clk_p];  # IO Bank 69     Board signal name: CLK512_P
set_property -dict {PACKAGE_PIN F29    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_BANKA_clk_n];  # IO Bank 69     Board signal name: CLK512_N

set_property -dict {PACKAGE_PIN D23    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_BANKB_clk_p];  # IO Bank 70     Board signal name: CLK512_P
set_property -dict {PACKAGE_PIN D22    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_BANKB_clk_n];  # IO Bank 70     Board signal name: CLK512_N

set_property -dict {PACKAGE_PIN F18    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_BANKC_clk_p];  # IO Bank 71     Board signal name: CLK512_P
set_property -dict {PACKAGE_PIN F19    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_BANKC_clk_n];  # IO Bank 71     Board signal name: CLK512_N


#
#  LVDS Lanes, negative side
#
set_property -dict {PACKAGE_PIN K24    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DN[ 0]         ];  # IO Bank 70     Board signal name: D0_N
set_property -dict {PACKAGE_PIN J21    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DN[ 1]         ];  # IO Bank 70     Board signal name: D1_N
set_property -dict {PACKAGE_PIN M19    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DN[ 2]         ];  # IO Bank 70     Board signal name: D2_N
set_property -dict {PACKAGE_PIN K21    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DN[ 3]         ];  # IO Bank 70     Board signal name: D3_N
set_property -dict {PACKAGE_PIN L22    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DN[ 4]         ];  # IO Bank 70     Board signal name: D4_N
set_property -dict {PACKAGE_PIN A29    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DN[ 5]         ];  # IO Bank 69     Board signal name: D5_N
set_property -dict {PACKAGE_PIN E25    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DN[ 6]         ];  # IO Bank 70     Board signal name: D6_N
set_property -dict {PACKAGE_PIN M22    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DN[ 7]         ];  # IO Bank 70     Board signal name: D7_N
set_property -dict {PACKAGE_PIN F21    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DN[ 8]         ];  # IO Bank 70     Board signal name: D8_N
set_property -dict {PACKAGE_PIN G24    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DN[ 9]         ];  # IO Bank 70     Board signal name: D9_N
set_property -dict {PACKAGE_PIN G20    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DN[10]         ];  # IO Bank 70     Board signal name: D10_N
set_property -dict {PACKAGE_PIN E23    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DN[11]         ];  # IO Bank 70     Board signal name: D11_N
set_property -dict {PACKAGE_PIN K18    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DN[12]         ];  # IO Bank 71     Board signal name: D12_N
set_property -dict {PACKAGE_PIN G19    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DN[13]         ];  # IO Bank 71     Board signal name: D13_N
set_property -dict {PACKAGE_PIN E18    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DN[14]         ];  # IO Bank 71     Board signal name: D14_N
set_property -dict {PACKAGE_PIN H22    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DN[15]         ];  # IO Bank 70     Board signal name: D15_N
set_property -dict {PACKAGE_PIN C15    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DN[16]         ];  # IO Bank 71     Board signal name: D16_N
set_property -dict {PACKAGE_PIN C18    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DN[17]         ];  # IO Bank 71     Board signal name: D17_N
set_property -dict {PACKAGE_PIN D16    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DN[18]         ];  # IO Bank 71     Board signal name: D18_N
set_property -dict {PACKAGE_PIN K19    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DN[19]         ];  # IO Bank 71     Board signal name: D19_N
set_property -dict {PACKAGE_PIN B19    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DN[20]         ];  # IO Bank 71     Board signal name: D20_N
set_property -dict {PACKAGE_PIN F17    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DN[21]         ];  # IO Bank 71     Board signal name: D21_N
set_property -dict {PACKAGE_PIN L24    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DN[22]         ];  # IO Bank 70     Board signal name: D22_N
set_property -dict {PACKAGE_PIN H18    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DN[23]         ];  # IO Bank 71     Board signal name: D23_N
set_property -dict {PACKAGE_PIN D17    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DN[24]         ];  # IO Bank 71     Board signal name: D24_N
set_property -dict {PACKAGE_PIN E15    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DN[25]         ];  # IO Bank 71     Board signal name: D25_N
set_property -dict {PACKAGE_PIN L16    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DN[26]         ];  # IO Bank 71     Board signal name: D26_N
set_property -dict {PACKAGE_PIN K16    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DN[27]         ];  # IO Bank 71     Board signal name: D27_N
set_property -dict {PACKAGE_PIN H14    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DN[28]         ];  # IO Bank 71     Board signal name: D28_N
set_property -dict {PACKAGE_PIN M15    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DN[29]         ];  # IO Bank 71     Board signal name: D29_N
set_property -dict {PACKAGE_PIN J15    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DN[30]         ];  # IO Bank 71     Board signal name: D30_N
set_property -dict {PACKAGE_PIN K14    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DN[31]         ];  # IO Bank 71     Board signal name: D31_N
set_property -dict {PACKAGE_PIN H28    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DN[32]         ];  # IO Bank 69     Board signal name: D32_N
set_property -dict {PACKAGE_PIN D21    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DN[33]         ];  # IO Bank 70     Board signal name: D33_N
set_property -dict {PACKAGE_PIN F24    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DN[34]         ];  # IO Bank 70     Board signal name: D34_N
set_property -dict {PACKAGE_PIN A22    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DN[35]         ];  # IO Bank 70     Board signal name: D35_N
set_property -dict {PACKAGE_PIN C23    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DN[36]         ];  # IO Bank 70     Board signal name: D36_N
set_property -dict {PACKAGE_PIN G26    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DN[37]         ];  # IO Bank 69     Board signal name: D37_N
set_property -dict {PACKAGE_PIN A24    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DN[38]         ];  # IO Bank 70     Board signal name: D38_N
set_property -dict {PACKAGE_PIN B25    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DN[39]         ];  # IO Bank 70     Board signal name: D39_N
set_property -dict {PACKAGE_PIN C20    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DN[40]         ];  # IO Bank 70     Board signal name: D40_N
set_property -dict {PACKAGE_PIN B21    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DN[41]         ];  # IO Bank 70     Board signal name: D41_N
set_property -dict {PACKAGE_PIN E20    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DN[42]         ];  # IO Bank 70     Board signal name: D42_N
set_property -dict {PACKAGE_PIN J25    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DN[43]         ];  # IO Bank 69     Board signal name: D43_N
set_property -dict {PACKAGE_PIN M25    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DN[44]         ];  # IO Bank 69     Board signal name: D44_N
set_property -dict {PACKAGE_PIN J27    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DN[45]         ];  # IO Bank 69     Board signal name: D45_N
set_property -dict {PACKAGE_PIN F14    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DN[46]         ];  # IO Bank 71     Board signal name: D46_N
set_property -dict {PACKAGE_PIN K26    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DN[47]         ];  # IO Bank 69     Board signal name: D47_N
set_property -dict {PACKAGE_PIN H30    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DN[48]         ];  # IO Bank 69     Board signal name: D48_N
set_property -dict {PACKAGE_PIN G30    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DN[49]         ];  # IO Bank 69     Board signal name: D49_N
set_property -dict {PACKAGE_PIN J31    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DN[50]         ];  # IO Bank 69     Board signal name: D50_N
set_property -dict {PACKAGE_PIN E30    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DN[51]         ];  # IO Bank 69     Board signal name: D51_N
set_property -dict {PACKAGE_PIN B31    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DN[52]         ];  # IO Bank 69     Board signal name: D52_N
set_property -dict {PACKAGE_PIN E31    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DN[53]         ];  # IO Bank 69     Board signal name: D53_N
set_property -dict {PACKAGE_PIN L27    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DN[54]         ];  # IO Bank 69     Board signal name: D54_N
set_property -dict {PACKAGE_PIN G31    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DN[55]         ];  # IO Bank 69     Board signal name: D55_N
set_property -dict {PACKAGE_PIN E28    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DN[56]         ];  # IO Bank 69     Board signal name: D56_N
set_property -dict {PACKAGE_PIN C29    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DN[57]         ];  # IO Bank 69     Board signal name: D57_N
set_property -dict {PACKAGE_PIN D27    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DN[58]         ];  # IO Bank 69     Board signal name: D58_N
set_property -dict {PACKAGE_PIN C27    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DN[59]         ];  # IO Bank 69     Board signal name: D59_N
set_property -dict {PACKAGE_PIN B27    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DN[60]         ];  # IO Bank 69     Board signal name: D60_N
set_property -dict {PACKAGE_PIN G27    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DN[61]         ];  # IO Bank 69     Board signal name: D61_N
set_property -dict {PACKAGE_PIN E26    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DN[62]         ];  # IO Bank 69     Board signal name: D62_N
set_property -dict {PACKAGE_PIN B26    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DN[63]         ];  # IO Bank 69     Board signal name: D63_N



#
#  LVDS Lanes, positive side
#
set_property -dict {PACKAGE_PIN K23    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DP[ 0]         ];  # IO Bank 70     Board signal name: D0_P
set_property -dict {PACKAGE_PIN J20    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DP[ 1]         ];  # IO Bank 70     Board signal name: D1_P
set_property -dict {PACKAGE_PIN M20    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DP[ 2]         ];  # IO Bank 70     Board signal name: D2_P
set_property -dict {PACKAGE_PIN K20    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DP[ 3]         ];  # IO Bank 70     Board signal name: D3_P
set_property -dict {PACKAGE_PIN L21    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DP[ 4]         ];  # IO Bank 70     Board signal name: D4_P
set_property -dict {PACKAGE_PIN A28    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DP[ 5]         ];  # IO Bank 69     Board signal name: D5_P
set_property -dict {PACKAGE_PIN D25    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DP[ 6]         ];  # IO Bank 70     Board signal name: D6_P
set_property -dict {PACKAGE_PIN M21    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DP[ 7]         ];  # IO Bank 70     Board signal name: D7_P
set_property -dict {PACKAGE_PIN G21    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DP[ 8]         ];  # IO Bank 70     Board signal name: D8_P
set_property -dict {PACKAGE_PIN H24    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DP[ 9]         ];  # IO Bank 70     Board signal name: D9_P
set_property -dict {PACKAGE_PIN H20    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DP[10]         ];  # IO Bank 70     Board signal name: D10_P
set_property -dict {PACKAGE_PIN E24    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DP[11]         ];  # IO Bank 70     Board signal name: D11_P
set_property -dict {PACKAGE_PIN L18    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DP[12]         ];  # IO Bank 71     Board signal name: D12_P
set_property -dict {PACKAGE_PIN H19    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DP[13]         ];  # IO Bank 71     Board signal name: D13_P
set_property -dict {PACKAGE_PIN E19    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DP[14]         ];  # IO Bank 71     Board signal name: D14_P
set_property -dict {PACKAGE_PIN J22    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DP[15]         ];  # IO Bank 70     Board signal name: D15_P
set_property -dict {PACKAGE_PIN C14    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DP[16]         ];  # IO Bank 71     Board signal name: D16_P
set_property -dict {PACKAGE_PIN C17    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DP[17]         ];  # IO Bank 71     Board signal name: D17_P
set_property -dict {PACKAGE_PIN D15    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DP[18]         ];  # IO Bank 71     Board signal name: D18_P
set_property -dict {PACKAGE_PIN L19    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DP[19]         ];  # IO Bank 71     Board signal name: D19_P
set_property -dict {PACKAGE_PIN A19    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DP[20]         ];  # IO Bank 71     Board signal name: D20_P
set_property -dict {PACKAGE_PIN F16    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DP[21]         ];  # IO Bank 71     Board signal name: D21_P
set_property -dict {PACKAGE_PIN L23    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DP[22]         ];  # IO Bank 70     Board signal name: D22_P
set_property -dict {PACKAGE_PIN H17    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DP[23]         ];  # IO Bank 71     Board signal name: D23_P
set_property -dict {PACKAGE_PIN D18    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DP[24]         ];  # IO Bank 71     Board signal name: D24_P
set_property -dict {PACKAGE_PIN E16    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DP[25]         ];  # IO Bank 71     Board signal name: D25_P
set_property -dict {PACKAGE_PIN L17    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DP[26]         ];  # IO Bank 71     Board signal name: D26_P
set_property -dict {PACKAGE_PIN J16    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DP[27]         ];  # IO Bank 71     Board signal name: D27_P
set_property -dict {PACKAGE_PIN G14    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DP[28]         ];  # IO Bank 71     Board signal name: D28_P
set_property -dict {PACKAGE_PIN M16    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DP[29]         ];  # IO Bank 71     Board signal name: D29_P
set_property -dict {PACKAGE_PIN H15    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DP[30]         ];  # IO Bank 71     Board signal name: D30_P
set_property -dict {PACKAGE_PIN K15    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DP[31]         ];  # IO Bank 71     Board signal name: D31_P
set_property -dict {PACKAGE_PIN J28    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DP[32]         ];  # IO Bank 69     Board signal name: D32_P
set_property -dict {PACKAGE_PIN E21    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DP[33]         ];  # IO Bank 70     Board signal name: D33_P
set_property -dict {PACKAGE_PIN F23    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DP[34]         ];  # IO Bank 70     Board signal name: D34_P
set_property -dict {PACKAGE_PIN B22    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DP[35]         ];  # IO Bank 70     Board signal name: D35_P
set_property -dict {PACKAGE_PIN C22    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DP[36]         ];  # IO Bank 70     Board signal name: D36_P
set_property -dict {PACKAGE_PIN G25    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DP[37]         ];  # IO Bank 69     Board signal name: D37_P
set_property -dict {PACKAGE_PIN A23    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DP[38]         ];  # IO Bank 70     Board signal name: D38_P
set_property -dict {PACKAGE_PIN B24    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DP[39]         ];  # IO Bank 70     Board signal name: D39_P
set_property -dict {PACKAGE_PIN B20    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DP[40]         ];  # IO Bank 70     Board signal name: D40_P
set_property -dict {PACKAGE_PIN A21    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DP[41]         ];  # IO Bank 70     Board signal name: D41_P
set_property -dict {PACKAGE_PIN D20    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DP[42]         ];  # IO Bank 70     Board signal name: D42_P
set_property -dict {PACKAGE_PIN H25    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DP[43]         ];  # IO Bank 69     Board signal name: D43_P
set_property -dict {PACKAGE_PIN M26    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DP[44]         ];  # IO Bank 69     Board signal name: D44_P
set_property -dict {PACKAGE_PIN H27    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DP[45]         ];  # IO Bank 69     Board signal name: D45_P
set_property -dict {PACKAGE_PIN G15    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DP[46]         ];  # IO Bank 71     Board signal name: D46_P
set_property -dict {PACKAGE_PIN J26    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DP[47]         ];  # IO Bank 69     Board signal name: D47_P
set_property -dict {PACKAGE_PIN H29    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DP[48]         ];  # IO Bank 69     Board signal name: D48_P
set_property -dict {PACKAGE_PIN G29    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DP[49]         ];  # IO Bank 69     Board signal name: D49_P
set_property -dict {PACKAGE_PIN J30    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DP[50]         ];  # IO Bank 69     Board signal name: D50_P
set_property -dict {PACKAGE_PIN D30    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DP[51]         ];  # IO Bank 69     Board signal name: D51_P
set_property -dict {PACKAGE_PIN A31    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DP[52]         ];  # IO Bank 69     Board signal name: D52_P
set_property -dict {PACKAGE_PIN D31    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DP[53]         ];  # IO Bank 69     Board signal name: D53_P
set_property -dict {PACKAGE_PIN L26    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DP[54]         ];  # IO Bank 69     Board signal name: D54_P
set_property -dict {PACKAGE_PIN F31    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DP[55]         ];  # IO Bank 69     Board signal name: D55_P
set_property -dict {PACKAGE_PIN E29    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DP[56]         ];  # IO Bank 69     Board signal name: D56_P
set_property -dict {PACKAGE_PIN B29    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DP[57]         ];  # IO Bank 69     Board signal name: D57_P
set_property -dict {PACKAGE_PIN D28    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DP[58]         ];  # IO Bank 69     Board signal name: D58_P
set_property -dict {PACKAGE_PIN C28    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DP[59]         ];  # IO Bank 69     Board signal name: D59_P
set_property -dict {PACKAGE_PIN A27    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DP[60]         ];  # IO Bank 69     Board signal name: D60_P
set_property -dict {PACKAGE_PIN F27    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DP[61]         ];  # IO Bank 69     Board signal name: D61_P
set_property -dict {PACKAGE_PIN D26    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DP[62]         ];  # IO Bank 69     Board signal name: D62_P
set_property -dict {PACKAGE_PIN A26    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_DP[63]         ];  # IO Bank 69     Board signal name: D63_P


