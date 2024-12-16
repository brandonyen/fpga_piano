## Final Project: FPGA Piano
Allows the FPGA to generate audio signals corresponding to musical notes when switches are pressed, which are output through the DAC as analog audio
 - dac_if module
   - Takes 16-bit parallel stereo data and converts it to the serial format required by the digital to analog converter
   - Same as Lab 5's dac_if
 - note_proc module
    - Generates a waveform corresponding to a specific pitch
    - The count variable accumulates the pitch value at every clock cycle, determining the waveform frequency
    - audio_data: 16-bit signed output representing the waveform's current amplitude
    - The waveform is split into 4 quadrants, using the upper 2 bits (quad) of the phase (count[15:14]):
      - 00: Positive ramp.
      - 01: Negative ramp.
      - 10: Negative ramp (inverted).
      - 11: Positive ramp (inverted).
    - Depending on the quad value, the audio_data output approximates a triangular waveform
 - piano module
    - Top-level module that integrates all components, manages timing, mixes audio data, and sends it to the DAC
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
