## Final Project: FPGA Piano
 - dac_if module
   - ab the module
 - note_proc module
    - ab the module
 - piano module
    - ab the module
## 1. Create a new RTL project in Vivado Quick Start
 - Chose Verilog for both the target and simulator language 
 - Create four new source files of file type SystemVerilog called dac_if, note_proc, and piano
 - Create a new constraint file of file type XDC called piano
 - Choose Nexys A7-100T board for the project
 - Click 'Finish'
 - Click design sources and copy the VHDL code from dac_if.sv, note_proc.sv, piano.sv
 - Click constraints and copy the code from piano.xdc
## 2. Run synthesis
## 3. Run implementation
## 4. Generate bitstream, open hardware manager, and program device
 - Click 'Generate Bitstream'
 - Click 'Open Hardware Manager' and click 'Open Target' then 'Auto Connect'
 - Click 'Program Device' then xc7a100t_0 to download siren.bit to the Nexys A7-100T board
