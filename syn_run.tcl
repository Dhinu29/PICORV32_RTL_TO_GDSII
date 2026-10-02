```tcl
#==============================================================================
# PicoRV32 - Cadence Genus Synthesis Script
# Target      : 45nm
# Flow        : RTL -> Generic -> Mapped Netlist
# Tool        : Cadence Genus
#==============================================================================

#------------------------------------------------------------------------------
# 0. Basic configuration
#------------------------------------------------------------------------------

set TOP            picorv32
set DESIGN_NAME    picorv32
set RUN_NAME       picorv32_syn

set RTL_DIR        ../rtl
set LIB_DIR        ../lib
set CONSTRAINT_DIR ../constraints
set REPORT_DIR     ../reports
set NETLIST_DIR    ../netlist
set SDF_DIR        ../sdf

# Create output directories if required
file mkdir $REPORT_DIR
file mkdir $NETLIST_DIR
file mkdir $SDF_DIR


#==============================================================================
# 1. Library setup
#==============================================================================

# Technology library search path
set_db / .library $LIB_DIR

# RTL search path
set_db / .hdl_search_path [list $RTL_DIR]

# Standard-cell timing library
# IMPORTANT:
# Replace this with the actual .lib supplied by your 45nm PDK.
set_db / .library \
    [list $LIB_DIR/fsa0m_a_generic_core_tt1p8v25c.lib]


#==============================================================================
# 2. RTL source files
#==============================================================================

# PicoRV32 RTL
set RTL_FILES [list \
    $RTL_DIR/picorv32.v \
]

# If your PicoRV32 implementation contains additional RTL files,
# add them here:
#
# set RTL_FILES [list \
#     $RTL_DIR/picorv32.v \
#     $RTL_DIR/picorv32_regs.v \
#     $RTL_DIR/picorv32_alu.v \
# ]


#==============================================================================
# 3. Read RTL
#==============================================================================

puts "============================================================"
puts "Reading PicoRV32 RTL"
puts "============================================================"

read_hdl -language sv $RTL_FILES


#==============================================================================
# 4. Elaborate
#==============================================================================

puts "============================================================"
puts "Elaborating design"
puts "============================================================"

elaborate $TOP

# Current design
current_design $TOP


#==============================================================================
# 5. Basic design checks
#==============================================================================

puts "============================================================"
puts "Checking design"
puts "============================================================"

check_design > $REPORT_DIR/${RUN_NAME}_check_design.rpt

# Show design hierarchy
report_hierarchy > $REPORT_DIR/${RUN_NAME}_hierarchy.rpt

# Show ports
report_ports > $REPORT_DIR/${RUN_NAME}_ports.rpt


#==============================================================================
# 6. Read timing constraints
#==============================================================================

puts "============================================================"
puts "Reading SDC constraints"
puts "============================================================"

read_sdc $CONSTRAINT_DIR/constraints_file.sdc


#==============================================================================
# 7. Constraint verification
#==============================================================================

puts "============================================================"
puts "Checking timing constraints"
puts "============================================================"

report_clocks \
    > $REPORT_DIR/${RUN_NAME}_clocks.rpt

report_timing \
    -lint \
    > $REPORT_DIR/${RUN_NAME}_constraint_check.rpt


#==============================================================================
# 8. Generic synthesis
#==============================================================================

puts "============================================================"
puts "Starting generic synthesis"
puts "============================================================"

syn_generic


#------------------------------------------------------------------------------
# Generic synthesis reports
#------------------------------------------------------------------------------

report_area \
    > $REPORT_DIR/${RUN_NAME}_generic_area.rpt

report_power \
    > $REPORT_DIR/${RUN_NAME}_generic_power.rpt

report_timing \
    > $REPORT_DIR/${RUN_NAME}_generic_timing.rpt


#==============================================================================
# 9. Technology mapping
#==============================================================================

puts "============================================================"
puts "Starting technology mapping"
puts "============================================================"

syn_map


#------------------------------------------------------------------------------
# Mapped synthesis reports
#------------------------------------------------------------------------------

report_area \
    > $REPORT_DIR/${RUN_NAME}_mapped_area.rpt

report_power \
    > $REPORT_DIR/${RUN_NAME}_mapped_power.rpt

report_timing \
    > $REPORT_DIR/${RUN_NAME}_mapped_timing.rpt

report_gates \
    > $REPORT_DIR/${RUN_NAME}_mapped_gates.rpt


#==============================================================================
# 10. Optimization
#==============================================================================

puts "============================================================"
puts "Starting post-mapping optimization"
puts "============================================================"

syn_opt


#==============================================================================
# 11. Final QoR reports
#==============================================================================

puts "============================================================"
puts "Generating final QoR reports"
puts "============================================================"

report_area \
    > $REPORT_DIR/${RUN_NAME}_final_area.rpt

report_power \
    > $REPORT_DIR/${RUN_NAME}_final_power.rpt

report_timing \
    > $REPORT_DIR/${RUN_NAME}_final_timing.rpt

report_gates \
    > $REPORT_DIR/${RUN_NAME}_final_gates.rpt

report_clocks \
    > $REPORT_DIR/${RUN_NAME}_final_clocks.rpt


#==============================================================================
# 12. Timing analysis
#==============================================================================

# Worst setup paths
report_timing \
    -max_paths 20 \
    -path_type full \
    > $REPORT_DIR/${RUN_NAME}_setup_paths.rpt


# Worst hold paths
report_timing \
    -hold \
    -max_paths 20 \
    -path_type full \
    > $REPORT_DIR/${RUN_NAME}_hold_paths.rpt


#==============================================================================
# 13. Design rule checks
#==============================================================================

report_constraint \
    -all_violators \
    > $REPORT_DIR/${RUN_NAME}_constraint_violations.rpt


#==============================================================================
# 14. High-fanout / transition checks
#==============================================================================

report_constraint \
    -max_transition \
    > $REPORT_DIR/${RUN_NAME}_transition.rpt

report_constraint \
    -max_fanout \
    > $REPORT_DIR/${RUN_NAME}_fanout.rpt


#==============================================================================
# 15. Final design check
#==============================================================================

check_design \
    > $REPORT_DIR/${RUN_NAME}_final_check_design.rpt


#==============================================================================
# 16. Write synthesized netlist
#==============================================================================

puts "============================================================"
puts "Writing mapped netlist"
puts "============================================================"

write_hdl > $NETLIST_DIR/${RUN_NAME}.v


#==============================================================================
# 17. Write SDC
#==============================================================================

puts "============================================================"
puts "Writing final SDC"
puts "============================================================"

write_sdc > $NETLIST_DIR/${RUN_NAME}.sdc


#==============================================================================
# 18. Write SDF
#==============================================================================

puts "============================================================"
puts "Writing SDF"
puts "============================================================"

write_sdf \
    -timescale ns \
    > $SDF_DIR/${RUN_NAME}.sdf


#==============================================================================
# 19. Save Genus database
#==============================================================================

puts "============================================================"
puts "Saving Genus database"
puts "============================================================"

write_db \
    -common \
    $NETLIST_DIR/${RUN_NAME}.db


#==============================================================================
# 20. Final summary
#==============================================================================

puts "============================================================"
puts "PicoRV32 SYNTHESIS COMPLETE"
puts "============================================================"

puts "Top module      : $TOP"
puts "Netlist         : $NETLIST_DIR/${RUN_NAME}.v"
puts "SDC             : $NETLIST_DIR/${RUN_NAME}.sdc"
puts "SDF             : $SDF_DIR/${RUN_NAME}.sdf"
puts "Reports         : $REPORT_DIR/"
puts "============================================================"

# Optional GUI
# gui_show
```
