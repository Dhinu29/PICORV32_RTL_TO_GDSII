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
  - delay_corners
    - max_rc/max.lib
    - min_rc/min.lib
  -Constraint model
    - *.sdc file
-  before apply and ok you can save the file next time again open  insted of creating new directly load the file

# FloorPlanning
- after creating the MMMC file the core and die is open  generate
- sanity Checks mainly check for the quality of netlist
  - Library check         > checkDesign -physicalLibrary
  - Netlist Check         > checkDesign -timingLibrary
  - SDC Checks            > checkDesign -netlist
-floorplan => specify floorplan
  - core uilization = 40%
  - aspect ratio =  1 Note: Square
  - aspect ratio <= 1 Note: Vertical rectangular
  - aspect ratio => 1 Note: Horizontl rectangular
  - core to die space select Eg: left=right=top=bottom=10
  - IO pins : incase no IO file in the MMMC file in the floorplan click on the pins and select the pin editor
  - in bottom pin Group select unassign and select the pins  and right side selecct the spread and also choose the metals(M!-M7)
  - also choose the assign Fixed status ,Batch Mode, Fix Overlapping
  ```
  checkPinAssignment
  legalizePin -pin * -moveFixedPin
  setPtnPinStatus -pin * -status FIXED
  saveIOFile pins.io
  ```
 
# Placement
```

place_design

```













 


