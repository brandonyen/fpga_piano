module piano (
    input logic clk_50MHz,           // system clock (50 MHz)
    input logic [12:0] switches,
    output logic dac_MCLK,           // outputs to PMODI2L DAC
    output logic dac_LRCK,           // left-right clock
    output logic dac_SCLK,           // serial clock
    output logic dac_SDIN            // serial data input to DAC
);

    localparam logic [13:0] pitches [0:7] = {
        14'd351, // c4
        14'd394, // d4
        14'd442, // e4
        14'd469, // f4
        14'd526, // g4
        14'd591, // a4
        14'd663, // b4
        14'd702 // c5
    };

    // Signals for components and timing
    logic [19:0] tcount;     // 20-bit timing counter
    logic signed [15:0] data_L, data_R;  // 16-bit signed audio data
    logic dac_load_L, dac_load_R;    // DAC load signals
    logic sclk, audio_CLK;  // clocks

    // Timing process (20-bit binary counter to generate timing signals)
    always_ff @(posedge clk_50MHz) begin
        if (tcount[9:0] >= 10'h00F && tcount[9:0] < 10'h02E)
            dac_load_L <= 1'b1;
        else
            dac_load_L <= 1'b0;

        if (tcount[9:0] >= 10'h20F && tcount[9:0] < 10'h22E)
            dac_load_R <= 1'b1;
        else
            dac_load_R <= 1'b0;

        tcount <= tcount + 1;
    end

    // Timing signal assignments
    assign dac_MCLK = ~tcount[1];    // DAC master clock (12.5 MHz)
    assign audio_CLK = tcount[9];    // audio sampling clock (48.8 kHz)
    assign dac_LRCK = audio_CLK;    // left-right clock for DAC
    assign sclk = tcount[4];         // serial clock (1.56 MHz)
    assign dac_SCLK = sclk;         // serial data clock

    // Instantiate DAC interface (dac_if module)
    dac_if dac_inst (
        .SCLK(sclk),
        .L_start(dac_load_L),
        .R_start(dac_load_R),
        .L_data(data_L),
        .R_data(data_R),
        .SDATA(dac_SDIN)
    );
    
    generate
        genvar i;
            for (i = 0; i < 8; i++) begin
                note_proc note_proc_inst (
                        .pitch(pitches[i]),
                        .audio_clk(audio_CLK),
                        .active(switches[i]),
                        .audio_data(note_audio[i])
                );
            end
    endgenerate
    
    logic signed [15:0] note_audio [7:0];
    logic signed [15:0] mixed_audio;
    logic signed [15:0] scaled_audio;

    always_comb begin
        mixed_audio = 16'd0; 
        for (int j = 0; j < 8; j++) begin
            mixed_audio += note_audio[j];
        end
        
        scaled_audio = mixed_audio >>> 1;  // Scale down the audio
        
        if (scaled_audio > 16383) scaled_audio = 16383;
        if (scaled_audio < -16383) scaled_audio = -16383;
    end

    assign data_L = scaled_audio; 

    // Duplicate left data to right channel
    assign data_R = data_L;

endmodule