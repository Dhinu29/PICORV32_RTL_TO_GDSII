############################################################
# 32-bit RISC-V / PCPI
# 45nm ASIC - Industrial Style SDC
############################################################

############################################################
# 1. CLOCK
############################################################

create_clock -name clk \
    -period 10.000 \
    -waveform {0.000 5.000} \
    [get_ports clk]

set_clock_uncertainty -setup 0.20 [get_clocks clk]
set_clock_uncertainty -hold  0.10 [get_clocks clk]

# Clock transition
set_clock_transition 0.10 [get_clocks clk]


############################################################
# 2. RESET
############################################################

# Reset is asynchronous and normally excluded from
# synchronous timing analysis.

set_false_path -from [get_ports rst_n]


############################################################
# 3. PCPI INPUT PORTS
#
# Inputs:
#   pcpi_rd[31:0]
#   pcpi_wr
#   pcpi_wait
#   pcpi_ready
############################################################

set_input_delay -clock clk -max 2.00 \
    [get_ports {pcpi_rd[*] pcpi_wr pcpi_wait pcpi_ready}]

set_input_delay -clock clk -min 0.50 \
    [get_ports {pcpi_rd[*] pcpi_wr pcpi_wait pcpi_ready}]


############################################################
# 4. PCPI OUTPUT PORTS
#
# Outputs:
#   pcpi_valid
#   pcpi_insn[31:0]
#   pcpi_rs1[31:0]
#   pcpi_rs2[31:0]
############################################################

set_output_delay -clock clk -max 2.00 \
    [get_ports {pcpi_valid pcpi_insn[*] pcpi_rs1[*] pcpi_rs2[*]}]

set_output_delay -clock clk -min 0.50 \
    [get_ports {pcpi_valid pcpi_insn[*] pcpi_rs1[*] pcpi_rs2[*]}]


############################################################
# 5. INPUT DRIVE
############################################################

# Replace with the actual 45nm input buffer cell.
# Example only:
#
# set_driving_cell -lib_cell <INPUT_BUFFER_CELL> \
#     [get_ports {pcpi_rd[*] pcpi_wr pcpi_wait pcpi_ready}]

# If driving cell is unavailable:
set_input_transition 0.15 \
    [get_ports {pcpi_rd[*] pcpi_wr pcpi_wait pcpi_ready}]


############################################################
# 6. OUTPUT LOAD
############################################################

# Replace with actual extracted/input capacitance
# from your 45nm IO library.

set_load 0.10 \
    [get_ports {pcpi_valid pcpi_insn[*] pcpi_rs1[*] pcpi_rs2[*]}]


############################################################
# 7. MAX TRANSITION
############################################################

set_max_transition 0.50 [current_design]


############################################################
# 8. MAX FANOUT
############################################################

set_max_fanout 16 [current_design]


############################################################
# 9. INPUT PIN TRANSITION
############################################################

set_input_transition 0.15 \
    [get_ports {pcpi_rd[*] pcpi_wr pcpi_wait pcpi_ready}]


############################################################
# 10. OUTPUT TRANSITION
############################################################

set_max_transition 0.50 \
    [get_ports {pcpi_valid pcpi_insn[*] pcpi_rs1[*] pcpi_rs2[*]}]


############################################################
# 11. CLOCK EXCEPTIONS
############################################################

# Do not time data pins as clocks.

set_clock_groups -name async_external \
    -asynchronous \
    -group [get_clocks clk]


############################################################
# 12. RESET EXCEPTION
############################################################

set_false_path \
    -from [get_ports rst_n] \
    -to [all_registers]


############################################################
# 13. TEST / SCAN
############################################################

# If these ports exist in your top-level RTL:

if {[llength [get_ports test_mode_i -quiet]]} {
    set_false_path -from [get_ports test_mode_i]
}

if {[llength [get_ports scan_en_i -quiet]]} {
    set_false_path -from [get_ports scan_en_i]
}


############################################################
# 14. DFT CLOCK
############################################################

# If JTAG/scan clock exists, define it separately.
#
# create_clock -name scan_clk \
#     -period 50.000 \
#     -waveform {0.000 25.000} \
#     [get_ports scan_clk]


############################################################
# 15. JTAG
############################################################

# Example only if JTAG exists.
#
# set_input_delay -clock scan_clk -max 5.0 \
#     [get_ports {jtag_tms_i jtag_tdi_i}]
#
# set_input_delay -clock scan_clk -min 1.0 \
#     [get_ports {jtag_tms_i jtag_tdi_i}]
#
# set_output_delay -clock scan_clk -max 5.0 \
#     [get_ports jtag_tdo_o]
#
# set_output_delay -clock scan_clk -min 1.0 \
#     [get_ports jtag_tdo_o]


############################################################
# 16. TIMING REPORT CHECKS
############################################################

check_timing

report_clocks

report_constraint -all_violators

report_timing \
    -from [get_ports {pcpi_rd[*] pcpi_wr pcpi_wait pcpi_ready}] \
    -to [all_registers] \
    -max_paths 20

report_timing \
    -from [all_registers] \
    -to [get_ports {pcpi_valid pcpi_insn[*] pcpi_rs1[*] pcpi_rs2[*]}] \
    -max_paths 20
