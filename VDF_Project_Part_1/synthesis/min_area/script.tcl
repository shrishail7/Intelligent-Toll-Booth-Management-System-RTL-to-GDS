


read_lib /home/shrishail25147/Desktop/VDF_Submitted_project/VDF_Project/synthesis/min_area/slow.lib

read_hdl /home/shrishail25147/Desktop/VDF_Submitted_project/VDF_Project/synthesis/min_area/toll.v





elaborate 


read_sdc cons.sdc
synthesize -to_mapped -effort medium


write_sdf -timescale ns -nonegchecks -recrem split -edges check_edge > syn_report_toll_minarea/delays_toll_minarea.sdf
check_timing_intent > syn_report_toll_minarea/timing_intent_toll_minarea.rep


write_hdl > syn_report_toll_minarea/netlist.v
write_sdc > syn_report_toll_minarea/dc_file_for_physical_design_toll_minarea.sdc
write_script > syn_report_toll_minarea/synthesis_script_sdc_toll_minarea.g


report timing > syn_report_toll_minarea/synthesis_timing_report_toll_minarea.rep
report power > syn_report_toll_minarea/synthesis_power_report_toll_minarea.rep
report gates > syn_report_toll_minarea/synthesis_cell_report_toll_minarea.rep
report area > syn_report_toll_minarea/synthesis_area_report_toll_minarea.rep


gui_show



