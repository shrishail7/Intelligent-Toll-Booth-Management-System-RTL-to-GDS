# ####################################################################

#  Created by Genus(TM) Synthesis Solution 19.13-s073_1 on Sun Nov 16 14:56:03 IST 2025

# ####################################################################

set sdc_version 2.0

set_units -capacitance 1000fF
set_units -time 1000ps

# Set the current design
current_design toll_gate

create_clock -name "clk" -period 7.5 -waveform {0.0 3.75} [get_ports clk]
set_clock_transition 0.6 [get_clocks clk]
set_clock_gating_check -setup 0.0 
set_input_delay -clock [get_clocks clk] -add_delay -min 0.5 [get_ports reset]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.5 [get_ports sensor_vehicle_enter]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.5 [get_ports sensor_vehicle_exit]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.5 [get_ports {vehicle_id_in[7]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.5 [get_ports {vehicle_id_in[6]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.5 [get_ports {vehicle_id_in[5]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.5 [get_ports {vehicle_id_in[4]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.5 [get_ports {vehicle_id_in[3]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.5 [get_ports {vehicle_id_in[2]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.5 [get_ports {vehicle_id_in[1]}]
set_input_delay -clock [get_clocks clk] -add_delay -min 0.5 [get_ports {vehicle_id_in[0]}]
set_wire_load_mode "enclosed"
set_clock_latency -source 0.01 [get_clocks clk]
