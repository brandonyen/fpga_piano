module wail (
    input logic [13:0] pitch,
    input logic [7:0] wspeed,              // speed of wail in pitch units/wclk
    input logic wclk, audio_clk, active,                     // wailing clock (47.6 Hz)
    output logic signed [15:0] audio_data  // output audio sequence (wailing tone)
);

    // Internal signal
    logic [13:0] curr_pitch;               // current wailing pitch

    // Instance of the tone module
    tone tgen (
        .clk(audio_clk),
        .pitch(curr_pitch),
        .data(audio_data)
    );

    // Process to modulate pitch
    always_ff @(posedge wclk) begin
        if (active) begin
            curr_pitch = pitch;
        end else begin
            curr_pitch = 14'd0;
        end
    end

endmodule