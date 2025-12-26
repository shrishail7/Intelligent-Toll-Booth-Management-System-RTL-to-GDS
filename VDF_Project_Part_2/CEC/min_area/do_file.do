set log file logical_equivalence_checking_minarea.log -replace


read library /home/shrishail25147/Desktop/VDF_Project/VDF_Project_Part_2/CEC/min_area/slow.v -verilog -both
read design /home/shrishail25147/Desktop/VDF_Project/VDF_Project_Part_2/CEC/min_area/toll.v -golden
read design /home/shrishail25147/Desktop/VDF_Project/VDF_Project_Part_2/CEC/min_area/netlist.v -verilog -revised


set system mode lec
add compared points -all
compare
report messages -compare -verb
report compare data -noneq
report verification
write compared points -replace lec_compared_points_minarea
write mapped points -replace lec_mapped_points_minarea
set verification information logical_eq_check_minarea
write verification information
exit
