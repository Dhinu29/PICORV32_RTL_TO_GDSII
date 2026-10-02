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
- after open the Cadence innovus gui go to files and import the window will be open
- add the verilog files
- add the LEF file
- add the IO file
- add the Power nets
  - Power Net  - vdd
  - Ground Net - vss
- creat analysis configuration(MMMMC file)
  - Library sets
    - max_lib/slow.lib
    - min_lib/fast.lib
  - rc_corners
    - max_rc/captableworst
    - min_rc/captablbest
  - op_condition
    - max_lib/slow.lib/power=10/voltage=0.9/temp=125
    - min_lib/fast.lib/power=10/voltage=1.1/temp=-40


