
create_clock -period 10.000 -name clkin -add [get_ports clkin]
create_clock -period 8.000 -name rgmii_rxc -add [get_ports rgmii_rxc]

set_false_path -from [get_clocks CLK125PLLTX] -to [get_clocks BUS_CLK_PLL]
set_false_path -from [get_clocks BUS_CLK_PLL] -to [get_clocks CLK125PLLTX]
set_false_path -from [get_clocks BUS_CLK_PLL] -to [get_clocks rgmii_rxc]
set_false_path -from [get_clocks rgmii_rxc] -to [get_clocks BUS_CLK_PLL]

#NET "Clk100"
set_property PACKAGE_PIN AA4 [get_ports clkin]
set_property IOSTANDARD LVCMOS15 [get_ports clkin]

set_property PACKAGE_PIN G9 [get_ports RESET_N]
set_property IOSTANDARD LVCMOS33 [get_ports RESET_N]
set_property PULLUP TRUE [get_ports RESET_N]

set_property SLEW FAST [get_ports mdio_phy_mdc]
set_property IOSTANDARD LVCMOS33 [get_ports mdio_phy_mdc]
set_property PACKAGE_PIN B25 [get_ports mdio_phy_mdc]

set_property SLEW FAST [get_ports mdio_phy_mdio]
set_property IOSTANDARD LVCMOS33 [get_ports mdio_phy_mdio]
set_property PACKAGE_PIN B26 [get_ports mdio_phy_mdio]

#M20 is routed to Connector C. The Ethernet PHY on th KX2 board has NO reset connection
set_property SLEW FAST [get_ports phy_rst_n]
set_property IOSTANDARD LVCMOS33 [get_ports phy_rst_n]
set_property PACKAGE_PIN M20 [get_ports phy_rst_n]

set_property IOSTANDARD LVCMOS33 [get_ports rgmii_rxc]
set_property PACKAGE_PIN G22 [get_ports rgmii_rxc]

set_property IOSTANDARD LVCMOS33 [get_ports rgmii_rx_ctl]
set_property PACKAGE_PIN F23 [get_ports rgmii_rx_ctl]

set_property IOSTANDARD LVCMOS33 [get_ports "rgmii_rxd[0]"]
set_property PACKAGE_PIN H23 [get_ports "rgmii_rxd[0]"]
set_property IOSTANDARD LVCMOS33 [get_ports "rgmii_rxd[1]"]
set_property PACKAGE_PIN H24 [get_ports "rgmii_rxd[1]"]
set_property IOSTANDARD LVCMOS33 [get_ports "rgmii_rxd[2]"]
set_property PACKAGE_PIN J21 [get_ports "rgmii_rxd[2]"]
set_property IOSTANDARD LVCMOS33 [get_ports "rgmii_rxd[3]"]
set_property PACKAGE_PIN H22 [get_ports "rgmii_rxd[3]"]

set_property SLEW FAST [get_ports rgmii_txc]
set_property IOSTANDARD LVCMOS33 [get_ports rgmii_txc]
set_property PACKAGE_PIN K23 [get_ports rgmii_txc]

set_property SLEW FAST [get_ports rgmii_tx_ctl]
set_property IOSTANDARD LVCMOS33 [get_ports rgmii_tx_ctl]
set_property PACKAGE_PIN J23 [get_ports rgmii_tx_ctl]

set_property SLEW FAST [get_ports "rgmii_txd[0]"]
set_property IOSTANDARD LVCMOS33 [get_ports "rgmii_txd[0]"]
set_property PACKAGE_PIN J24 [get_ports "rgmii_txd[0]"]
set_property SLEW FAST [get_ports "rgmii_txd[1]"]
set_property IOSTANDARD LVCMOS33 [get_ports "rgmii_txd[1]"]
set_property PACKAGE_PIN J25 [get_ports "rgmii_txd[1]"]
set_property SLEW FAST [get_ports "rgmii_txd[2]"]
set_property IOSTANDARD LVCMOS33 [get_ports "rgmii_txd[2]"]
set_property PACKAGE_PIN L22 [get_ports "rgmii_txd[2]"]
set_property SLEW FAST [get_ports "rgmii_txd[3]"]
set_property IOSTANDARD LVCMOS33 [get_ports "rgmii_txd[3]"]
set_property PACKAGE_PIN K22 [get_ports "rgmii_txd[3]"]

# LEDs
#LED 0..3 are onboard LEDs
set_property PACKAGE_PIN U9 [get_ports {LED[0]}]
set_property IOSTANDARD LVCMOS15 [get_ports {LED[0]}]
set_property PACKAGE_PIN V12 [get_ports {LED[1]}]
set_property IOSTANDARD LVCMOS15 [get_ports {LED[1]}]
set_property PACKAGE_PIN V13 [get_ports {LED[2]}]
set_property IOSTANDARD LVCMOS15 [get_ports {LED[2]}]
set_property PACKAGE_PIN W13 [get_ports {LED[3]}]
set_property IOSTANDARD LVCMOS15 [get_ports {LED[3]}]
#LED 4..7 are LEDs on the BDAQ53 base board
set_property PACKAGE_PIN E21 [get_ports {LED[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[4]}]
set_property PACKAGE_PIN E22 [get_ports {LED[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[5]}]
set_property PACKAGE_PIN D21 [get_ports {LED[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[6]}]
set_property PACKAGE_PIN C22 [get_ports {LED[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[7]}]
set_property SLEW SLOW [get_ports LED*]

# SPI configuration flash
set_property CONFIG_MODE SPIx4 [current_design]
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 33 [current_design]

# LEMO Connectors
# Receive
set_property PACKAGE_PIN AC21 [get_ports {RXI[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RXI[0]}]

set_property PACKAGE_PIN AE25 [get_ports {RXI[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {RXI[1]}]

# Transmit
set_property PACKAGE_PIN AB21 [get_ports {TXI[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {TXI[0]}]

set_property PACKAGE_PIN AD25 [get_ports {TXI[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {TXI[1]}]

# GPIO Connector
# GPIO0
set_property PACKAGE_PIN W25 [get_ports {GPIO_IN[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {GPIO_IN[0]}]
# GPIO1
set_property PACKAGE_PIN W26 [get_ports {GPIO_OUT[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {GPIO_OUT[0]}]
# GPIO2
set_property PACKAGE_PIN U26 [get_ports {GPIO_IN[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {GPIO_IN[1]}]
# GPIO3
set_property PACKAGE_PIN V26 [get_ports {GPIO_OUT[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {GPIO_OUT[1]}]

#LVDS
set_property PACKAGE_PIN H17 [get_ports {LVDS_P0}]
set_property PACKAGE_PIN H18 [get_ports {LVDS_N0}]
set_property PACKAGE_PIN G19 [get_ports {LVDS_P1}]
set_property PACKAGE_PIN F20 [get_ports {LVDS_N1}]
set_property PACKAGE_PIN L19 [get_ports {LVDS_P2}]
set_property PACKAGE_PIN L20 [get_ports {LVDS_N2}]
set_property PACKAGE_PIN K20 [get_ports {LVDS_P3}]
set_property PACKAGE_PIN J20 [get_ports {LVDS_N3}]
set_property PACKAGE_PIN M17 [get_ports {LVDS_P4}]
set_property PACKAGE_PIN L18 [get_ports {LVDS_N4}]
set_property PACKAGE_PIN L17 [get_ports {LVDS_P5}]
set_property PACKAGE_PIN K18 [get_ports {LVDS_N5}]
set_property PACKAGE_PIN K16 [get_ports {LVDS_P6}]
set_property PACKAGE_PIN K17 [get_ports {LVDS_N6}]
set_property PACKAGE_PIN J18 [get_ports {LVDS_P7}]
set_property PACKAGE_PIN J19 [get_ports {LVDS_N7}]
set_property PACKAGE_PIN H19 [get_ports {LVDS_P8}]
set_property PACKAGE_PIN G20 [get_ports {LVDS_N8}]
set_property PACKAGE_PIN D19 [get_ports {LVDS_P9}]
set_property PACKAGE_PIN D20 [get_ports {LVDS_N9}]
set_property PACKAGE_PIN G17 [get_ports {LVDS_P10}]
set_property PACKAGE_PIN F18 [get_ports {LVDS_N10}]
set_property PACKAGE_PIN C17 [get_ports {LVDS_P11}]
set_property PACKAGE_PIN C18 [get_ports {LVDS_N11}]
set_property PACKAGE_PIN C14 [get_ports {LVDS_P12}]
set_property PACKAGE_PIN C13 [get_ports {LVDS_N12}]
set_property PACKAGE_PIN D14 [get_ports {LVDS_P13}]
set_property PACKAGE_PIN D13 [get_ports {LVDS_N13}]
set_property PACKAGE_PIN J13 [get_ports {LVDS_P14}]
set_property PACKAGE_PIN H13 [get_ports {LVDS_N14}]
set_property PACKAGE_PIN F14 [get_ports {LVDS_P15}]
set_property PACKAGE_PIN F13 [get_ports {LVDS_N15}]
set_property PACKAGE_PIN E13 [get_ports {LVDS_P16}]
set_property PACKAGE_PIN E12 [get_ports {LVDS_N16}]
set_property PACKAGE_PIN G12 [get_ports {LVDS_P17}]
set_property PACKAGE_PIN F12 [get_ports {LVDS_N17}]
set_property PACKAGE_PIN J11 [get_ports {LVDS_P18}]
set_property PACKAGE_PIN J10 [get_ports {LVDS_N18}]
set_property PACKAGE_PIN H12 [get_ports {LVDS_P19}]
set_property PACKAGE_PIN H11 [get_ports {LVDS_N19}]
set_property PACKAGE_PIN G10 [get_ports {LVDS_P20}]
set_property PACKAGE_PIN G9 [get_ports {LVDS_N20}]
set_property PACKAGE_PIN E11 [get_ports {LVDS_P21}]
set_property PACKAGE_PIN D11 [get_ports {LVDS_N21}]
set_property PACKAGE_PIN A13 [get_ports {LVDS_P22}]
set_property PACKAGE_PIN A12 [get_ports {LVDS_N22}]
set_property PACKAGE_PIN B10 [get_ports {LVDS_P23}]
set_property PACKAGE_PIN A10 [get_ports {LVDS_N23}]

set_property IOSTANDARD LVDS_25 [get_ports LVDS_*]

# LVCMOS
set_property PACKAGE_PIN B12 [get_ports {LVCMOS[0]}]
set_property PACKAGE_PIN B11 [get_ports {LVCMOS[1]}]
set_property PACKAGE_PIN H14 [get_ports {LVCMOS[2]}]
set_property PACKAGE_PIN G14 [get_ports {LVCMOS[3]}]
set_property PACKAGE_PIN C12 [get_ports {LVCMOS[4]}]
set_property PACKAGE_PIN C11 [get_ports {LVCMOS[5]}]
set_property PACKAGE_PIN B14 [get_ports {LVCMOS[6]}]
set_property PACKAGE_PIN A14 [get_ports {LVCMOS[7]}]

set_property IOSTANDARD LVCMOS25 [get_ports {LVCMOS*}]

#CMOS
set_property PACKAGE_PIN V24 [get_ports {CMOS[0]}]
set_property PACKAGE_PIN Y26 [get_ports {CMOS[1]}]
set_property PACKAGE_PIN AA24 [get_ports {CMOS[2]}]
set_property PACKAGE_PIN Y23 [get_ports {CMOS[3]}]
set_property PACKAGE_PIN Y25 [get_ports {CMOS[4]}]
set_property PACKAGE_PIN Y20 [get_ports {CMOS[5]}]
set_property PACKAGE_PIN U21 [get_ports {CMOS[6]}]
set_property PACKAGE_PIN AE26 [get_ports {CMOS[7]}]
set_property PACKAGE_PIN AD26 [get_ports {CMOS[8]}]
set_property PACKAGE_PIN AB25 [get_ports {CMOS[9]}]
set_property PACKAGE_PIN W24 [get_ports {CMOS[10]}]
set_property PACKAGE_PIN W23 [get_ports {CMOS[11]}]
set_property PACKAGE_PIN V22 [get_ports {CMOS[12]}]
set_property PACKAGE_PIN U22 [get_ports {CMOS[13]}]
set_property PACKAGE_PIN AD24 [get_ports {CMOS[14]}]
set_property PACKAGE_PIN AD23 [get_ports {CMOS[15]}]
set_property PACKAGE_PIN U25 [get_ports {CMOS[16]}]
set_property PACKAGE_PIN AE25 [get_ports {CMOS[17]}]
set_property PACKAGE_PIN AD25 [get_ports {CMOS[18]}]
set_property PACKAGE_PIN AA22 [get_ports {CMOS[19]}]
set_property PACKAGE_PIN U24 [get_ports {CMOS[20]}]
set_property PACKAGE_PIN AB21 [get_ports {CMOS[21]}]

set_property IOSTANDARD LVCMOS25 [get_ports {CMOS*}]

# NTC_MUX
set_property PACKAGE_PIN AE23 [get_ports {NTC_MUX[0]}]
set_property PACKAGE_PIN AC22 [get_ports {NTC_MUX[1]}]
set_property PACKAGE_PIN AB22 [get_ports {NTC_MUX[2]}]
set_property IOSTANDARD LVCMOS25 [get_ports {NTC_MUX*}]
set_property SLEW SLOW [get_ports NTC*]

# SPI configuration flash
set_property CONFIG_MODE SPIx4 [current_design]
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 33 [current_design]