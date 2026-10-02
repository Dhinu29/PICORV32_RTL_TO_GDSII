#===========================================================
# CTS / CCOpt Script - Cadence Innovus
#===========================================================

#-----------------------------------------------------------
# RC Extraction
#-----------------------------------------------------------
extractRC
rcOut -spef leon.spef -rc_corner rc_worst


#-----------------------------------------------------------
# Non Default Rule (NDR)
# 2W2S routing rule
#-----------------------------------------------------------
add_ndr \
    -width {
        Metal1 0.12
        Metal2 0.14
        Metal3 0.14
        Metal4 0.14
        Metal5 0.14
        Metal6 0.14
        Metal7 0.14
        Metal8 0.14
        Metal9 0.14
    } \
    -spacing {
        Metal1 0.12
        Metal2 0.14
        Metal3 0.14
        Metal4 0.14
        Metal5 0.14
        Metal6 0.14
        Metal7 0.14
        Metal8 0.14
        Metal9 0.14
    } \
    -name 2w2s


#-----------------------------------------------------------
# Clock Route Type
#-----------------------------------------------------------
create_route_type \
    -name clkroute \
    -non_default_rule 2w2s \
    -bottom_preferred_layer Metal5 \
    -top_preferred_layer Metal6


#-----------------------------------------------------------
# CCOpt Route Type Properties
#-----------------------------------------------------------
set_ccopt_property route_type clkroute -net_type trunk
set_ccopt_property route_type clkroute -net_type leaf


#-----------------------------------------------------------
# Clock Buffer / Inverter / Clock Gating Cells
#-----------------------------------------------------------
set_ccopt_property buffer_cells {CLKBUFX8 CLKBUFX12}

set_ccopt_property inverter_cells {CLKINVX8 CLKINVX12}

set_ccopt_property clock_gating_cells {TLATNTSCA*}


#-----------------------------------------------------------
# Generate CCOpt Clock Tree Specification
#-----------------------------------------------------------
create_ccopt_clock_tree_spec -file ccopt.spec

source ccopt.spec


#-----------------------------------------------------------
# Clock Tree Synthesis
#-----------------------------------------------------------
ccopt_design -cts


#-----------------------------------------------------------
# Save CTS Database
#-----------------------------------------------------------
saveDesign DBS/cts.enc


#-----------------------------------------------------------
# Post-CTS Timing Analysis
#-----------------------------------------------------------
timeDesign -postCTS


#-----------------------------------------------------------
# Post-CTS Optimization
#-----------------------------------------------------------
optDesign -postCTS

saveDesign DBS/postcts.enc


#-----------------------------------------------------------
# Routing
#-----------------------------------------------------------
routeDesign

saveDesign DBS/route.enc


#-----------------------------------------------------------
# Post-Route RC Extraction
#-----------------------------------------------------------
setExtractRCMode -engine postRoute
setExtractRCMode -effortLevel medium


#-----------------------------------------------------------
# Post-Route Timing Analysis
#-----------------------------------------------------------
timeDesign -postRoute

timeDesign -postRoute -hold


#-----------------------------------------------------------
# Post-Route Optimization
#-----------------------------------------------------------
optDesign -postRoute -setup -hold


#-----------------------------------------------------------
# Final Database
#-----------------------------------------------------------
saveDesign DBS/postroute.enc
