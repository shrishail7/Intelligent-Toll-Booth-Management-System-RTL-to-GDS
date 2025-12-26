#========================================================
# Constraints File for Toll Managment System Controller (Toll Module)
#========================================================

#----------------------------------------
# Clock Definition
#----------------------------------------
create_clock -name clk -period 5.6 [get_ports "clk"]

# Clock Latency
set_clock_latency 0.01 -source -late [get_clocks "clk"]
set_clock_latency 0.01 -source -early [get_clocks "clk"]

# Clock Transition
set_clock_transition -rise 0.6 [get_clocks "clk"]
set_clock_transition -fall 0.6 [get_clocks "clk"]

# Optional: Uncomment to add uncertainty
# set_clock_uncertainty -setup 0.01 [get_clocks "clk"]
# set_clock_uncertainty -hold 0.01 [get_clocks "clk"]

#----------------------------------------
# Input Delays
#----------------------------------------

set_input_delay -min 0.5 -clock [get_clocks "clk"] [all_inputs]




#========================================================
# End of SDC File
#========================================================

