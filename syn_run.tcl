#synthesis  for picorv32

set_attribute lib_search_path {../lib/}                     //Library file path 
set_attribute hdl_search_path {../rtl/}                     //RTL files path
set_attribute library {fsa0m_a_generic_core_tt1p8v25c.lib}  //Specify library
set myFiles [list alu.v]                                    //All Verilog files
set basename alu;                                           //Top module name
set runname synthesys_report;

read_hdl ${myFiles}
elaborate ${basename}
read_sdc ../constraints/constraints_file.sdc               //Constraint file (.sdc)

synthesize -to_mapped
report timing > ${basename}_${runname}_timing.rpt          //Output file
report gates > ${basename}_${runname}_cell.rpt             //Output file 
report power > ${basename}_${runname}_power.rpt            //Output file
report area  > ${basename}_${runname}_area.rpt             //Output file

write_hdl -mapped > ${basename}_${runname}.v               //Generated library mapped netlist
write_sdc > ${basename}_${runname}.sdc                     //Achieved Constraint file
write_sdf -timescale ns -nonegchecks -recrem split -edges check_edge  -setuphold split > delays.sdf  
gui_show                                                    //To show result in GUI mode
+
