file mkdir sta_after_synthesis_area/reports
set report_dir sta_after_synthesis_area/reports
read_lib /cadence/FOUNDRY/digital/90nm/dig/lib/slow.lib

read_verilog /home/shrishail25147/Desktop/VDF_Submitted_project/VDF_Project/STA/min_area/netlist.v
set_top_module toll_gate
read_sdc cons.sdc
check_timing > $report_dir/check_timing_area.rpt
report_timing > $report_dir/timing_report_area.rpt
report_timing -retime path_slew_propagation -max_path 50 -nworst 50 -path_type full_clock > $report_dir/pba_area.rpt
report_analysis_coverage > $report_dir/analysis_coverage_area.rpt
report_analysis_summary > $report_dir/analysis_summary_area.rpt
report_clocks > $report_dir/clocks_area.rpt
report_case_analysis > $report_dir/case_analysis_area.rpt
report_constraints -all_violators > $report_dir/allviolations_area.rpt
gui_show

