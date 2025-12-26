# 1. Here we are setting all the necessary files (All the inputs)
# 2. Sanity Check before floorplaning
# 3. Floor Planing
# 4. Power Planing
# 5. Global Routing
# 6. Sanity Check for Scan Chain of DFT
# 7. Generating Reports for Before_Physical_Design
# 8. Placement
# 9. Clock Tree Synthesis
# 10. CTS optimization
# 11. Global and Detailed Routing
# 12. Generating GDS

#creating directories for report
file mkdir placement_reports/report
file mkdir placement_reports/timing
file mkdir placement_reports/area
file mkdir placement_reports/gates
file mkdir placement_reports/power
file mkdir placement_reports/GDS
file mkdir placement_reports/netlist
file mkdir placement_reports/incremental_placement_report
file mkdir cts_reports/timing
file mkdir cts_reports/area
file mkdir optimised_cts_reports/timing
file mkdir optimised_cts_reports/area
file mkdir ctsrepairreports/area
file mkdir ctsrepairreports/timing
file mkdir post_route_reports/timing
file mkdir post_route_reports/area


set report_dir placement_reports

set init_gnd_net VSS
set init_io_file pin_location.io
set init_lef_file gsclib090_translated_ref.lef
set init_mmmc_file Default.view
set init_pwr_net VDD
set init_top_cell toll_gate
set init_verilog rtl_netlist_min_area.v

init_design

setDesignMode -process 90 -flowEffort standard

#/* Sanity check before Floorplanning*/
checkDesign -physicalLibrary; #Sanity check of physical library -lef file
checkDesign -timingLibrary; #Sanity check of timing library 
checkDesign -netlist; #Sanity check of dft netlist
check_timing; #Sanity check of timing reports of min and max path

#/*Floorplanning*/
getIoFlowFlag
setIoFlowFlag 0
#floorplanning die siting according to Innovus LRM
floorPlan -site gsclib090site -r 1 0.8 4.06 4.06 4.06 4.06 



#/*Power Planning to be done by voltus tool*/
# Adding Rings
addRing -skip_via_on_wire_shape Noshape -skip_via_on_pin Standardcell -center 1 -stacked_via_top_layer Metal9 -type core_rings -jog_distance 0.435 -threshold 0.435 -nets {VSS VDD} -follow core -stacked_via_bottom_layer Metal1 -layer {bottom Metal8 top Metal8 right Metal9 left Metal9} -width 1.25 -spacing 0.4

# Adding Stripes
addStripe -skip_via_on_wire_shape Noshape -block_ring_top_layer_limit Metal9 -max_same_layer_jog_length 0.88 -padcore_ring_bottom_layer_limit Metal7 -number_of_sets 10 -skip_via_on_pin Standardcell -stacked_via_top_layer Metal9 -padcore_ring_top_layer_limit Metal9 -spacing 0.4 -merge_stripes_value 0.435 -layer Metal8 -block_ring_bottom_layer_limit Metal7 -width 0.44 -nets {VDD VSS} -stacked_via_bottom_layer Metal1

set delaycal_use_default_delay_limit 1000 
setDelayCalMode -reportOutBound true



#/*Global Routing*/
globalNetConnect VDD -type pgpin -pin VDD -override -verbose -netlistOverride
globalNetConnect VSS -type pgpin -pin VSS -override -verbose -netlistOverride
sroute -nets {VDD VSS} -allowLayerChange 1 -layerChangeRange {Metal1 Metal9}

#/*Sanity check of Scan chain dft*/
specifyScanChain scan1 -start DFT_sdi_1 -stop DFT_sdo_1
specifyScanChain scan2 -start DFT_sdi_2 -stop DFT_sdo_2

#All these reports are for 'Before Physical Design'
report_timing -early -view {view1} -max_paths 100 > $report_dir/hold_analysis_before_placement.txt
report_timing -late  -max_paths 100 > $report_dir/setup_analysis_before_placement.txt
report_timing > $report_dir/timing_report.rpt
report_timing -retime path_slew_propagation -max_path 50 -nworst 50 -path_type full_clock > $report_dir/pba.rpt
report_power -rail_analysis_format VS -outfile $report_dir/power.rpt
report_area -detail > $report_dir/area.rpt
reportGateCount -level 5 -limit 100 > $report_dir/gate_count.rpt
#report gates -level 5 -limit 100 > $report_dir/gates.rpt

 #/*Placement*/
setPlaceMode -fp false
placeDesign
#/*RC Extration .spef file generated required in power analysis of voltus tool*/
extractRC
rcOut -spef rtl_module.spef
#/*physical design ideal clock sdf file required for timing signoff check from prime time tool*/
write_sdf -ideal_clock_network $report_dir/report/physical_design_rtl_moduleoptimum.sdf

#Reports generation after Placement
verify_drc > $report_dir/report/placement_DRC_vio.rpt
verifyConnectivity > $report_dir/report/post_detailedRoute_verifyConnectivity.rpt
reportRoute > $report_dir/report/postDetailRoute_reportRoute.rpt
reportWire > $report_dir/report/postDetailRoute_reportWire.rpt
summaryReport -outdir $report_dir/report/summaryReport
report_timing -early -view {view1} -max_paths 100 > $report_dir/timing/timing_post_PnR_early.txt
report_timing -late  -max_paths 100 > $report_dir/timing/timing_post_PnR_late.txt
report_area -detail > $report_dir/area/area.rpt
reportGateCount -level 5 -limit 100 -outfile $report_dir/gates/gate_count.rpt
report_power -rail_analysis_format VS -outfile $report_dir/power/power.rpt

#CTS
set_ccopt_mode -cts_buffer_cells {CLKBUFX3 CLKBUFX2  CLKBUFX8 CLKBUFX12 CLKBUFX16 CLKBUFX20 CLKINVX3 CLKINVX2 CLKINVX8 CLKINVX12 CLKINVX16} -cts_opt_priority all
create_ccopt_clock_tree_spec -file ccopt_new.spec -keep_all_sdc_clocks -views {view1}

source ccopt_new.spec 

# ccopt_design is a super command. Capable of doing complete CTS
ccopt_design -check_prerequisites
ccopt_design

#Reports generation after CTS
report_timing -early -view {view1} -max_paths 100 > cts_reports/timing/timing_post_PnR_early.txt
report_timing -late  -max_paths 100 > cts_reports/timing/timing_post_PnR_late.txt
report_area -detail > cts_reports/area/area_post_pnr2.rpt
report_power -rail_analysis_format VS -outfile cts_reports/ctsafteranalysis.rpt

#Optimising design after CTS is done for setup and hold violation
optDesign -postCTS;   #for setup violation
optDesign -postCTS -hold; #for hold violation

#Reports generation after CTS Optimization
report_timing -early -view {view1} -max_paths 100 > optimised_cts_reports/timing/timing_post_PnR_early.txt
report_timing -late  -max_paths 100 > optimised_cts_reports/timing/timing_post_PnR_late.txt
report_area -detail > optimised_cts_reports/area/area_post_pnr3.rpt
report_power -rail_analysis_format VS -outfile optimised_cts_reports/ctsafteranalysispostoptimization.rpt


# Repair clock tree rules violations post CTS and doing exact timing analysis, CTS is done enable skew fixing  true and enable timing update true .repair is done by rebuffering
ccopt_pro -enable_drv_fixing true -enable_drv_fixing_by_rebuffering true -enable_refine_place true -enable_routing_eco true -enable_skew_fixing true -enable_skew_fixing_by_rebuffering true -enable_timing_update true

#Reports generation after repair of clock tree rules violation post cts
report_timing -early -view {view1} -max_paths 100 > ctsrepairreports/timing/timing_post_PnR_early.txt
report_timing -late  -max_paths 100 > ctsrepairreports/timing/timing_post_PnR_late.txt
report_area -detail > ctsrepairreports/area/area_post_pnr3.rpt

#Routing
setNanoRouteMode -quiet -timingEngine {}
setNanoRouteMode -quiet -routeWithSiPostRouteFix 0
setNanoRouteMode -quiet -drouteStartIteration default
setNanoRouteMode -quiet -routeTopRoutingLayer default
setNanoRouteMode -quiet -routeBottomRoutingLayer default
setNanoRouteMode -quiet -drouteEndIteration default
setNanoRouteMode -quiet -routeWithTimingDriven false
setNanoRouteMode -quiet -routeWithSiDriven false
routeDesign -globalDetail

#Reports generation post global and detail routing
report_timing -early -view {view1} -max_paths 100 > post_route_reports/timing/timing_post_PnR_early.txt
report_timing -late  -max_paths 100 > post_route_reports/timing/timing_post_PnR_late.txt
report_area -detail > post_route_reports/area/area_post_pnr4.rpt
report_power -rail_analysis_format VS -outfile post_route_reports/routeafteranalysis.rpt


#/*Generating GDS*/
streamOut Toll_gate.gds -mapFile streamOut.map -libName DesignLib -units 2000 -mode ALL

#/*Saving the Design */
saveNetlist rtl_module_post_route_netlist.v
defOut -floorplan -netlist -routing rtl_module.def
saveDesign new_uptoGDS.enc
