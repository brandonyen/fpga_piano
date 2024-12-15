module note_proc (
    input logic [13:0] pitch,
    input logic audio_clk, active,  
    output logic signed [15:0] audio_data 
);

    logic [13:0] curr_pitch;   
    logic [15:0] count;                    // current phase of waveform
    logic [1:0] quad;                      // current quadrant of phase
    logic signed [15:0] index;             // index into current quadrant

    // Process to modulate pitch
    always_ff @(posedge audio_clk) begin
        if (active) begin
            curr_pitch = pitch;
        end else begin
            curr_pitch = 14'd0;
        end
        
        count = count + curr_pitch;
    end
    
    assign quad = count[15:14];
    assign index = {2'b00, count[13:0]};
    
    always_comb begin
        if (active) begin
            case (quad)
                2'b00: audio_data = index;                     // 1st quadrant
                2'b01: audio_data = 16383 - index;    // 2nd quadrant
                2'b10: audio_data = -index;                    // 3rd quadrant
                2'b11: audio_data = index - 16383;  // 4th quadrant
            endcase
        end else begin
            audio_data = 14'd0;
        end
    end

endmodule