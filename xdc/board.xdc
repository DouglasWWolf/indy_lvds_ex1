
# ---------------------------------------------------------------------------
# Pin definitions
# ---------------------------------------------------------------------------


#===============================================================================
#                            Clocks & system signals
#===============================================================================

#
# Presume the clocks have 300ps of jitter to force place&route to allow more margin on timing
#
set_system_jitter 0.300

#
# 200 Mhz init clock
#
set_property -dict {PACKAGE_PIN G16  IOSTANDARD LVDS}   [get_ports init_clk_clk_n]
set_property -dict {PACKAGE_PIN G17  IOSTANDARD LVDS}   [get_ports init_clk_clk_p]

#create_clock -period 5.000 -name sysclk200                  [get_ports init_clk]
#set_clock_groups -name group_sysclk200 -asynchronous -group [get_clocks sysclk200]



#
# PCIe endpoint refclk
#
set_property -dict {PACKAGE_PIN U29}          [get_ports pcie_refclk_clk_p]
set_property -dict {PACKAGE_PIN U30}          [get_ports pcie_refclk_clk_n]  
create_clock -period 10.000 -name pcie_sysclk [get_ports pcie_refclk_clk_p]
#set_clock_groups -name group_pcie_sysclk -asynchronous -group [get_clocks pcie_sysclk]


#
# LEDs
#
#set_property -dict {PACKAGE_PIN AW26  IOSTANDARD LVCMOS18} [ get_ports LED[0] ]
#set_property -dict {PACKAGE_PIN AW23  IOSTANDARD LVCMOS18} [ get_ports LED[1] ]
#set_property -dict {PACKAGE_PIN AW25  IOSTANDARD LVCMOS18} [ get_ports LED[2] ]
#set_property -dict {PACKAGE_PIN AU23  IOSTANDARD LVCMOS18} [ get_ports LED[3] ]
#set_property -dict {PACKAGE_PIN AU25  IOSTANDARD LVCMOS18} [ get_ports LED[4] ]
#set_property -dict {PACKAGE_PIN AV23  IOSTANDARD LVCMOS18} [ get_ports LED[5] ]
#set_property -dict {PACKAGE_PIN AW24  IOSTANDARD LVCMOS18} [ get_ports LED[6] ]
#set_property -dict {PACKAGE_PIN AV25  IOSTANDARD LVCMOS18} [ get_ports LED[7] ]


#
# Clock inputs for QSFP 0
#
#set_property PACKAGE_PIN AE29 [get_ports qsfp0_clk_clk_p]
#set_property PACKAGE_PIN AE30 [get_ports qsfp0_clk_clk_n]


#
# Clock inputs for QSFP 1
#
#set_property PACKAGE_PIN AB27 [get_ports qsfp1_clk_clk_p]
#set_property PACKAGE_PIN AB28 [get_ports qsfp1_clk_clk_n]

#
# QSFP control and status
#
#set_property -dict {PACKAGE_PIN AW13  IOSTANDARD LVCMOS18} [ get_ports qsfp_present_l[0] ]
#set_property -dict {PACKAGE_PIN AV12  IOSTANDARD LVCMOS18} [ get_ports qsfp_present_l[1] ]

#set_property -dict {PACKAGE_PIN AM12  IOSTANDARD LVCMOS18} [ get_ports qsfp_rst_l[0] ]
#set_property -dict {PACKAGE_PIN AR11  IOSTANDARD LVCMOS18} [ get_ports qsfp_rst_l[1] ]

#set_property -dict {PACKAGE_PIN AN12  IOSTANDARD LVCMOS18} [ get_ports qsfp_lp[0] ]
#set_property -dict {PACKAGE_PIN AM13  IOSTANDARD LVCMOS18} [ get_ports qsfp_lp[1] ]



# 
#  Sensor chip SPI bus
# 
set_property -dict {PACKAGE_PIN B14   IOSTANDARD LVCMOS18  SLEW SLOW  IOB TRUE}  [get_ports CHIP_SPI_CSN ]       ;  # IO Bank 94
set_property -dict {PACKAGE_PIN AV11  IOSTANDARD LVCMOS18                     }  [get_ports CHIP_SPI_MISO]       ;  # IO Bank 65
set_property -dict {PACKAGE_PIN L14   IOSTANDARD LVCMOS18  SLEW SLOW  IOB TRUE}  [get_ports CHIP_SPI_MOSI]       ;  # IO Bank 93
set_property -dict {PACKAGE_PIN A13   IOSTANDARD LVCMOS18  SLEW SLOW  IOB TRUE}  [get_ports CHIP_SPI_CLK ]       ;  # IO Bank 94
                                                                                                                                                           
#
#  High Speed bus for updating sensor chip SMEM
#
#set_property -dict {PACKAGE_PIN C10  IOSTANDARD LVCMOS18  SLEW SLOW  IOB TRUE}  [get_ports CHIP_HSI_DATA[ 0]];  # IO Bank 91     Board signal name: HS0s
#set_property -dict {PACKAGE_PIN F9   IOSTANDARD LVCMOS18  SLEW SLOW  IOB TRUE}  [get_ports CHIP_HSI_DATA[ 1]];  # IO Bank 91     Board signal name: HS1
#set_property -dict {PACKAGE_PIN F8   IOSTANDARD LVCMOS18  SLEW SLOW  IOB TRUE}  [get_ports CHIP_HSI_DATA[ 2]];  # IO Bank 91     Board signal name: HS2
#set_property -dict {PACKAGE_PIN E9   IOSTANDARD LVCMOS18  SLEW SLOW  IOB TRUE}  [get_ports CHIP_HSI_DATA[ 3]];  # IO Bank 91     Board signal name: HS3
#set_property -dict {PACKAGE_PIN C9   IOSTANDARD LVCMOS18  SLEW SLOW  IOB TRUE}  [get_ports CHIP_HSI_DATA[ 4]];  # IO Bank 91     Board signal name: HS4
#set_property -dict {PACKAGE_PIN F7   IOSTANDARD LVCMOS18  SLEW SLOW  IOB TRUE}  [get_ports CHIP_HSI_DATA[ 5]];  # IO Bank 91     Board signal name: HS5
#set_property -dict {PACKAGE_PIN F6   IOSTANDARD LVCMOS18  SLEW SLOW  IOB TRUE}  [get_ports CHIP_HSI_DATA[ 6]];  # IO Bank 91     Board signal name: HS6
#set_property -dict {PACKAGE_PIN F1   IOSTANDARD LVCMOS18  SLEW SLOW  IOB TRUE}  [get_ports CHIP_HSI_DATA[ 7]];  # IO Bank 90     Board signal name: HS7
#set_property -dict {PACKAGE_PIN D7   IOSTANDARD LVCMOS18  SLEW SLOW  IOB TRUE}  [get_ports CHIP_HSI_DATA[ 8]];  # IO Bank 91     Board signal name: HS8
#set_property -dict {PACKAGE_PIN D6   IOSTANDARD LVCMOS18  SLEW SLOW  IOB TRUE}  [get_ports CHIP_HSI_DATA[ 9]];  # IO Bank 90     Board signal name: HS9
#set_property -dict {PACKAGE_PIN F2   IOSTANDARD LVCMOS18  SLEW SLOW  IOB TRUE}  [get_ports CHIP_HSI_DATA[10]];  # IO Bank 90     Board signal name: HS10
#set_property -dict {PACKAGE_PIN F4   IOSTANDARD LVCMOS18  SLEW SLOW  IOB TRUE}  [get_ports CHIP_HSI_DATA[11]];  # IO Bank 90     Board signal name: HS11
#set_property -dict {PACKAGE_PIN E1   IOSTANDARD LVCMOS18  SLEW SLOW  IOB TRUE}  [get_ports CHIP_HSI_DATA[12]];  # IO Bank 90     Board signal name: HS12
#set_property -dict {PACKAGE_PIN E6   IOSTANDARD LVCMOS18  SLEW SLOW  IOB TRUE}  [get_ports CHIP_HSI_DATA[13]];  # IO Bank 91     Board signal name: HS13
#set_property -dict {PACKAGE_PIN E8   IOSTANDARD LVCMOS18  SLEW SLOW  IOB TRUE}  [get_ports CHIP_HSI_DATA[14]];  # IO Bank 91     Board signal name: HS14
#set_property -dict {PACKAGE_PIN D1   IOSTANDARD LVCMOS18  SLEW SLOW  IOB TRUE}  [get_ports CHIP_HSI_DATA[15]];  # IO Bank 90     Board signal name: HS15
#set_property -dict {PACKAGE_PIN E5   IOSTANDARD LVCMOS18  SLEW SLOW  IOB TRUE}  [get_ports CHIP_HSI_DATA[16]];  # IO Bank 90     Board signal name: HS16
#set_property -dict {PACKAGE_PIN D2   IOSTANDARD LVCMOS18  SLEW SLOW  IOB TRUE}  [get_ports CHIP_HSI_DATA[17]];  # IO Bank 90     Board signal name: HS17
#set_property -dict {PACKAGE_PIN E10  IOSTANDARD LVCMOS18  SLEW SLOW  IOB TRUE}  [get_ports CHIP_HSI_DATA[18]];  # IO Bank 91     Board signal name: HS18
#set_property -dict {PACKAGE_PIN E4   IOSTANDARD LVCMOS18  SLEW SLOW  IOB TRUE}  [get_ports CHIP_HSI_DATA[19]];  # IO Bank 90     Board signal name: HS19
#set_property -dict {PACKAGE_PIN D11  IOSTANDARD LVCMOS18  SLEW SLOW  IOB TRUE}  [get_ports CHIP_HSI_DATA[20]];  # IO Bank 91     Board signal name: HS20
#set_property -dict {PACKAGE_PIN E3   IOSTANDARD LVCMOS18  SLEW SLOW  IOB TRUE}  [get_ports CHIP_HSI_DATA[21]];  # IO Bank 90     Board signal name: HS21
#set_property -dict {PACKAGE_PIN B6   IOSTANDARD LVCMOS18  SLEW SLOW  IOB TRUE}  [get_ports CHIP_HSI_DATA[22]];  # IO Bank 90     Board signal name: HS22
#set_property -dict {PACKAGE_PIN B2   IOSTANDARD LVCMOS18  SLEW SLOW  IOB TRUE}  [get_ports CHIP_HSI_DATA[23]];  # IO Bank 90     Board signal name: HS23
#set_property -dict {PACKAGE_PIN D5   IOSTANDARD LVCMOS18  SLEW SLOW  IOB TRUE}  [get_ports CHIP_HSI_DATA[24]];  # IO Bank 90     Board signal name: HS24
#set_property -dict {PACKAGE_PIN D3   IOSTANDARD LVCMOS18  SLEW SLOW  IOB TRUE}  [get_ports CHIP_HSI_DATA[25]];  # IO Bank 90     Board signal name: HS25
#set_property -dict {PACKAGE_PIN D8   IOSTANDARD LVCMOS18  SLEW SLOW  IOB TRUE}  [get_ports CHIP_HSI_DATA[26]];  # IO Bank 91     Board signal name: HS26
#set_property -dict {PACKAGE_PIN C8   IOSTANDARD LVCMOS18  SLEW SLOW  IOB TRUE}  [get_ports CHIP_HSI_DATA[27]];  # IO Bank 91     Board signal name: HS27
#set_property -dict {PACKAGE_PIN C2   IOSTANDARD LVCMOS18  SLEW SLOW  IOB TRUE}  [get_ports CHIP_HSI_DATA[28]];  # IO Bank 90     Board signal name: HS28
#set_property -dict {PACKAGE_PIN C3   IOSTANDARD LVCMOS18  SLEW SLOW  IOB TRUE}  [get_ports CHIP_HSI_DATA[29]];  # IO Bank 90     Board signal name: HS29
#set_property -dict {PACKAGE_PIN B4   IOSTANDARD LVCMOS18  SLEW SLOW  IOB TRUE}  [get_ports CHIP_HSI_DATA[30]];  # IO Bank 90     Board signal name: HS30
#set_property -dict {PACKAGE_PIN A3   IOSTANDARD LVCMOS18  SLEW SLOW  IOB TRUE}  [get_ports CHIP_HSI_DATA[31]];  # IO Bank 90     Board signal name: HS31
set_property -dict {PACKAGE_PIN F3   IOSTANDARD LVCMOS18  SLEW SLOW  }  [get_ports CHIP_HSI_CLK     ];  # IO Bank 90
#set_property -dict {PACKAGE_PIN A6   IOSTANDARD LVCMOS18  SLEW SLOW  IOB TRUE}  [get_ports CHIP_HSI_CMD     ];  # IO Bank 90
#set_property -dict {PACKAGE_PIN B5   IOSTANDARD LVCMOS18  SLEW SLOW  IOB TRUE}  [get_ports CHIP_HSI_VALID   ];  # IO Bank 90


set_property -dict {PACKAGE_PIN AW10  IOSTANDARD LVCMOS18           } [get_ports CHIP_RESET_N];  # IO Bank 65
set_property -dict {PACKAGE_PIN B9    IOSTANDARD LVCMOS18  SLEW SLOW} [get_ports CHIP_VDDIO  ];  # IO Bank 91
set_property -dict {PACKAGE_PIN B10   IOSTANDARD LVCMOS18  SLEW SLOW} [get_ports CHIP_VDDA   ];  # IO Bank 91 
set_property -dict {PACKAGE_PIN B11   IOSTANDARD LVCMOS18  SLEW SLOW} [get_ports CHIP_VDDLVDS];  # IO Bank 91 
set_property -dict {PACKAGE_PIN A18   IOSTANDARD LVCMOS18  SLEW SLOW} [get_ports CHIP_VDD    ];  # IO Bank 71
#set_property -dict {PACKAGE_PIN B30   IOSTANDARD LVCMOS18           } [get_ports CHIP_DETECT_8M];  # IO Bank 71


#
#  UCI ADC bus - contains 3 LTC-1867L ADCs
#
set_property -dict {PACKAGE_PIN C25   IOSTANDARD LVCMOS18  SLEW SLOW} [get_ports UCI_ADC_CSN[0]];  # IO Bank 70
set_property -dict {PACKAGE_PIN R15   IOSTANDARD LVCMOS18  SLEW SLOW} [get_ports UCI_ADC_CSN[1]];  # IO Bank 93
set_property -dict {PACKAGE_PIN K25   IOSTANDARD LVCMOS18  SLEW SLOW} [get_ports UCI_ADC_CSN[2]];  # IO Bank 69
set_property -dict {PACKAGE_PIN J13   IOSTANDARD LVCMOS18           } [get_ports UCI_ADC_MISO  ];  # IO Bank 94
set_property -dict {PACKAGE_PIN C24   IOSTANDARD LVCMOS18  SLEW SLOW} [get_ports UCI_ADC_MOSI  ];  # IO Bank 70
set_property -dict {PACKAGE_PIN J23   IOSTANDARD LVCMOS18  SLEW SLOW} [get_ports UCI_ADC_SCK   ];  # IO Bank 70




#
# FPGA outputs to control the sensor chip GPIO inputs
#
#set_property -dict {PACKAGE_PIN H12    IOSTANDARD LVCMOS18   SLEW SLOW } [get_ports CHIP_GPIO[0]];  # IO Bank 94
#set_property -dict {PACKAGE_PIN H10    IOSTANDARD LVCMOS18   SLEW SLOW } [get_ports CHIP_GPIO[1]];  # IO Bank 94
#set_property -dict {PACKAGE_PIN G11    IOSTANDARD LVCMOS18   SLEW SLOW } [get_ports CHIP_GPIO[2]];  # IO Bank 94
#set_property -dict {PACKAGE_PIN G10    IOSTANDARD LVCMOS18   SLEW SLOW } [get_ports CHIP_GPIO[3]];  # IO Bank 94
#set_property -dict {PACKAGE_PIN G12    IOSTANDARD LVCMOS18   SLEW SLOW } [get_ports CHIP_GPIO[4]];  # IO Bank 94


#
#  This enables a level translator for SPI pins on the sensor-chip (active low)
#
set_property -dict {PACKAGE_PIN A4     IOSTANDARD LVCMOS18   SLEW SLOW } [get_ports LVL_TRSL_OE_N];  # IO Bank 90

set_property -dict {PACKAGE_PIN D12    IOSTANDARD LVCMOS18   SLEW SLOW } [get_ports CHIP_PA_SYNC];  # CHIP_GPIO11 - IO Bank 90



set_property -dict {PACKAGE_PIN C12    IOSTANDARD LVCMOS18   SLEW SLOW  } [get_ports GPIO12              ];  # IO Bank 94
set_property -dict {PACKAGE_PIN B12    IOSTANDARD LVCMOS18   SLEW SLOW  } [get_ports GPIO13              ];  # IO Bank 94
set_property -dict {PACKAGE_PIN A12    IOSTANDARD LVCMOS18   SLEW SLOW  } [get_ports GPIO14              ];  # IO Bank 94
set_property -dict {PACKAGE_PIN D13    IOSTANDARD LVCMOS18   SLEW SLOW  } [get_ports GPIO15              ];  # IO Bank 94
 


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


#set_property -dict {PACKAGE_PIN F28    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_BANKA_clk_p];  # IO Bank 69     Board signal name: CLK512_P
#set_property -dict {PACKAGE_PIN F29    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_BANKA_clk_n];  # IO Bank 69     Board signal name: CLK512_N
#set_property -dict {PACKAGE_PIN D23    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_BANKB_clk_p];  # IO Bank 70     Board signal name: CLK512_P
#set_property -dict {PACKAGE_PIN D22    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_BANKB_clk_n];  # IO Bank 70     Board signal name: CLK512_N
#set_property -dict {PACKAGE_PIN F18    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_BANKC_clk_p];  # IO Bank 71     Board signal name: CLK512_P
#set_property -dict {PACKAGE_PIN F19    IOSTANDARD LVDS   DATA_RATE DDR   DIFF_TERM_ADV TERM_100   EQUALIZATION EQ_LEVEL0} [get_ports LVDS_BANKC_clk_n];  # IO Bank 71     Board signal name: CLK512_N



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


