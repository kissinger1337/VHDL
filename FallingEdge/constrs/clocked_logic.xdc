create_clock  -period 40.00 -name {i_Clk} [get_ports {i_Clk}]

set_property IOSTANDARD LVCMOS33 [get_ports i_Clk]
set_property IOSTANDARD LVCMOS33 [get_ports i_Switch_1]
set_property IOSTANDARD LVCMOS33 [get_ports o_LED_1]
set_property PACKAGE_PIN W5 [get_ports i_Clk]
set_property PACKAGE_PIN T18 [get_ports i_Switch_1]
set_property PACKAGE_PIN V14 [get_ports o_LED_1]
