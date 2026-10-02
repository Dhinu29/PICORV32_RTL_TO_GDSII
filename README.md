# step by step process

# initial stage
  - enter "csh"
  - source /home/instrall/*.cshrc
  - open cadence tool by the command "genus", "innovus"

# Cadence Xcelium
- first run xcelium before run the xcelium make verilog/systemverilog files and testbench store in a folder
- xrun -64bit -sv -f filelist.f -top alu_tb -access +rwc -elaborate
- xrun -64bit -R
- xrun -64bit -R -gui

# Cadence genus
- source file_name.tcl
- genus -gui

# Cadence innovus
- 

