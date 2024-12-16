## Final Project: FPGA Piano
Allows the FPGA to generate audio signals corresponding to musical notes when switches are pressed, which are output through the DAC as analog audio. This is an extension of Lab 5.

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

## Expected Behavior
The 8 switches on the left side of the board each control one note - the leftmost switch represents middle C, the next switch represents D, then E, etc.

Notes continue to play as long as the switch is active. Multiple notes can also be played, but playing 3 or more notes creates a distorted sound.

The 7 segment display shows how many switches are currently active (0 through 8).

## Necessary Hardware
- Nexys A7-100T FPGA Board
- Pmod I2S2 module
- Speakers

## Compiling/Execution Instructions
- Files in this repository should be the only ones necessary to run in Vivado
- In case the project does not open, the source files and constraints are in the srcs folder and can be added manually to a Vivado RTL project

## Project I/O
Inputs
- 50 MHz clock
- NEW: 8 bit logic array where each bit corresponds to a switch on the board

Outputs
- dac_MCLK - output to the DAC
- dac_LRCK - left-right clock
- dac_SCLK - serial clock
- dac_SDIN - serial data input to DAC
- NEW: anode - anode output for 7 segment display
- NEW: seg - segment output for 7 segment display

## Video
[Link to video](https://drive.google.com/file/d/1NB7XC2d79gPRcvojGQ1xbmKFrrjxvC-R/view?usp=sharing)

## Modifications and Difficulties
The starter code for this project was from Lab 5. 

We started by trying to generate one note, which was actually very difficult. We kept the tone and wail modules, but instead of using the clock to modulate between the low and high pitches, we simply set the pitch to the input pitch (the frequency of the note). We only had one instance of the note_proc module, and the input was controlled by the leftmost switch on the board. 

Then we moved on to implementing 13 keys - one octave, flat and sharp notes included. This was later changed to be 8 notes for simplicity. We declared a logic array of the pitches of each of the notes, based on the table here: https://www.seventhstring.com/resources/notefrequencies.html

Next, we generated 8 different note_proc modules, one for each note. Originally, we had all the modules' output set to data_L. After a lot of headaches/issues compiling, we realized that if more than one switch was active, multiple data values were being written to data_L and the board would not know which one to use.

To fix this, we created an array to store 8 16-bit signed data values. Then, we created a variable mixed_audio, which was the sum of all of the data outputs from the note_proc modules. If the switch for that note was active, it would output data, if not, it would be set to 0.

We started to get multiple notes to work, but playing more than one note at a time created a distorted sound. Eventually we realized that the data values were probably reaching the boundaries of a 16 bit signed integer, so we scaled down the output by a factor of 2 by shifting it one bit to the right.

Finally, we implemented the 7 segment display to show how many switches are currently active. We used the leddec.sv file from Lab 1, and had a running count that kept track of how many switches were active. Then, we passed that value into the leddec module as the data value.

## Contributions and Timeline
The work was done together in-person, with the workload being split equally. However, Brandon worked on fixing the distortion caused by playing multiple notes and Melody worked on displaying the number of notes being played on the 7-segment display.

Brandon
- Add source files and reorganize file structure
- Generating multiple instances of notes
- Allowing multiple notes to be played at once
- (Partially) fixing distortion caused by playing multiple notes
- Add to README.md

Melody
- Implementing one note functionality
- Connecting switches to input
- Generating multiple instances of notes
- Displaying number of notes being played on 7-segment display
- Add to README.md

Timeline
- Dec 10: Initial concept and adding base files
- Dec 14: Added one note functionality/connection to switches
- Dec 15: Added 8 notes and multi-note playing functionality
- Dec 16: Added the display to show the number of notes currently being played

## Future Improvements
- Fix distortion caused by playing 3 or more notes
  - This could be caused by weird timing differences, out-of-boundary values for 16 bit signed integers, switch debouncing, or lack of audio scaling for multiple notes
- Add flat/sharp notes
- Use a keypad/keyboard instead of the switches
