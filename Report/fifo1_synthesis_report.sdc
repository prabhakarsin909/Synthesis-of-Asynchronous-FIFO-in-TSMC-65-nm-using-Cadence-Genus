# ####################################################################

#  Created by Genus(TM) Synthesis Solution 21.19-s055_1 on Wed Aug 13 22:13:33 IST 2025

# ####################################################################

set sdc_version 2.0

set_units -capacitance 1000fF
set_units -time 1000ps

# Set the current design
current_design fifo1

create_clock -name "wclk" -period 20.0 -waveform {0.0 10.0} [get_ports wclk]
create_clock -name "rclk" -period 100.0 -waveform {0.0 50.0} [get_ports rclk]
set_clock_transition 0.1 [get_clocks wclk]
set_clock_transition 0.05 [get_clocks rclk]
set_false_path -from [get_clocks wclk] -to [get_clocks rclk]
set_clock_gating_check -setup 0.1 
set_input_delay -clock [get_clocks wclk] -add_delay 2.0 [get_ports rrst_n]
set_input_delay -clock [get_clocks wclk] -add_delay 2.0 [get_ports rclk]
set_input_delay -clock [get_clocks wclk] -add_delay 2.0 [get_ports r_en]
set_input_delay -clock [get_clocks wclk] -add_delay 2.0 [get_ports wrst_n]
set_input_delay -clock [get_clocks wclk] -add_delay 2.0 [get_ports wclk]
set_input_delay -clock [get_clocks wclk] -add_delay 2.0 [get_ports w_en]
set_input_delay -clock [get_clocks wclk] -add_delay 2.0 [get_ports {wdata[0]}]
set_input_delay -clock [get_clocks wclk] -add_delay 2.0 [get_ports {wdata[1]}]
set_input_delay -clock [get_clocks wclk] -add_delay 2.0 [get_ports {wdata[2]}]
set_input_delay -clock [get_clocks wclk] -add_delay 2.0 [get_ports {wdata[3]}]
set_input_delay -clock [get_clocks wclk] -add_delay 2.0 [get_ports {wdata[4]}]
set_input_delay -clock [get_clocks wclk] -add_delay 2.0 [get_ports {wdata[5]}]
set_input_delay -clock [get_clocks wclk] -add_delay 2.0 [get_ports {wdata[6]}]
set_input_delay -clock [get_clocks wclk] -add_delay 2.0 [get_ports {wdata[7]}]
set_output_delay -clock [get_clocks rclk] -add_delay 0.4 [get_ports empty]
set_output_delay -clock [get_clocks rclk] -add_delay 0.4 [get_ports full]
set_output_delay -clock [get_clocks rclk] -add_delay 0.4 [get_ports {rdata[0]}]
set_output_delay -clock [get_clocks rclk] -add_delay 0.4 [get_ports {rdata[1]}]
set_output_delay -clock [get_clocks rclk] -add_delay 0.4 [get_ports {rdata[2]}]
set_output_delay -clock [get_clocks rclk] -add_delay 0.4 [get_ports {rdata[3]}]
set_output_delay -clock [get_clocks rclk] -add_delay 0.4 [get_ports {rdata[4]}]
set_output_delay -clock [get_clocks rclk] -add_delay 0.4 [get_ports {rdata[5]}]
set_output_delay -clock [get_clocks rclk] -add_delay 0.4 [get_ports {rdata[6]}]
set_output_delay -clock [get_clocks rclk] -add_delay 0.4 [get_ports {rdata[7]}]
set_wire_load_mode "segmented"
set_clock_uncertainty -setup 0.25 [get_clocks wclk]
set_clock_uncertainty -hold 0.25 [get_clocks wclk]
set_clock_uncertainty -setup 0.1 [get_clocks rclk]
set_clock_uncertainty -hold 0.1 [get_clocks rclk]
