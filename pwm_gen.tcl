# Copyright (C) 2025  Altera Corporation. All rights reserved.
# Your use of Altera Corporation's design tools, logic functions 
# and other software and tools, and any partner logic 
# functions, and any output files from any of the foregoing 
# (including device programming or simulation files), and any 
# associated documentation or information are expressly subject 
# to the terms and conditions of the Altera Program License 
# Subscription Agreement, the Altera Quartus Prime License Agreement,
# the Altera IP License Agreement, or other applicable license
# agreement, including, without limitation, that your use is for
# the sole purpose of programming logic devices manufactured by
# Altera and sold by Altera or its authorized distributors.  Please
# refer to the Altera Software License Subscription Agreements 
# on the Quartus Prime software download page.

# Quartus Prime Version 25.1std.0 Build 1129 10/21/2025 Patches 0.02std SC Lite Edition
# File: D:\FPGA_stuff\LC_uzduotis\PWM_Generator\pwm_gen.tcl
# Generated on: Sun Sep 13 10:21:31 2026

package require ::quartus::project

set_location_assignment PIN_60 -to pwm_out
set_location_assignment PIN_88 -to rst_n
set_location_assignment PIN_24 -to clk_50
set_location_assignment PIN_1 -to led_lock
set_location_assignment PIN_73 -to btns[0]
set_location_assignment PIN_114 -to btns[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to clk_50
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to pwm_out
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to led_lock
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to rst_n
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to btns[0]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to btns[1]
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to btns
