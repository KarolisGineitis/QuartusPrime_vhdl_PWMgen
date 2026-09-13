create_clock -name main_clk -period 20.000 [get_ports {clk_50}]
derive_pll_clocks
derive_clock_uncertainty