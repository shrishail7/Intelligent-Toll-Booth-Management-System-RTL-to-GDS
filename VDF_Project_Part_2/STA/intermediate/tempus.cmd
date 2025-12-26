#######################################################
#                                                     
#  Tempus Timing Signoff Solution Command Logging File                     
#  Created on Sat Oct 11 19:29:19 2025                
#                                                     
#######################################################

#@(#)CDS: Tempus Timing Signoff Solution v20.10-p003_1 (64bit) 04/29/2020 15:56 (Linux 2.6.32-431.11.2.el6.x86_64)
#@(#)CDS: NanoRoute 20.10-p003_1 NR200413-0234/20_10-UB (database version 18.20.505) {superthreading v1.69}
#@(#)CDS: AAE 20.10-p005 (64bit) 04/29/2020 (Linux 2.6.32-431.11.2.el6.x86_64)
#@(#)CDS: CTE 20.10-p005_1 () Apr 14 2020 09:14:28 ( )
#@(#)CDS: SYNTECH 20.10-b004_1 () Mar 12 2020 22:18:21 ( )
#@(#)CDS: CPE v20.10-p006

read_lib /cadence/FOUNDRY/digital/90nm/dig/lib/slow.lib
read_verilog /home/prerana25172/Desktop/cmos65/VDF_Project/STA/intermediate/netlist.v
set_top_module toll_gate
read_sdc cons.sdc
check_timing > $report_dir/check_timing_area.rpt
report_timing > $report_dir/timing_report_area.rpt
report_timing -retime path_slew_propagation -max_path 50 -nworst 50 -path_type full_clock > $report_dir/pba_area.rpt
report_analysis_coverage > $report_dir/analysis_coverage_area.rpt
report_analysis_summary > $report_dir/analysis_summary_area.rpt
report_clocks > $report_dir/clocks_area.rpt
report_case_analysis > $report_dir/case_analysis_area.rpt
report_constraints -all_violators > sta_after_synthesis_area/reports/allviolations_area.rpt
