// 64QAM DeModulation
module ofdm_demodulation (
  input  logic               clk,
  input  logic               reset,
  input  logic        [1:0]  qam_type,
  output logic        [5:0]  qam_symbol,
  output logic               qam_symbol_valid,
  input  logic signed [15:0] qam_inphase_i,
  input  logic signed [15:0] qam_quadrat_i,
  input  logic               qam_mod_valid
);
  
  always_ff @(posedge clk) begin
    unique case(qam_type[1:0])
      2'b00 : begin // BPSK
        qam_symbol[0] <= 1'b0;
        qam_symbol[0] <= 1'b0;
        qam_symbol[0] <= 1'b0;
        qam_symbol[0] <= 1'b0;
        qam_symbol[0] <= 1'b0;
        qam_symbol[0] <= 1'b0;
      end
      2'b01 : begin // QPSK
        qam_symbol[0] <= 1'b0;
        qam_symbol[0] <= 1'b0;
        qam_symbol[0] <= 1'b0;
        qam_symbol[0] <= 1'b0;
        qam_symbol[0] <= 1'b0;
        qam_symbol[0] <= 1'b0;
      end
      2'b10 : begin // 16QAM
        qam_symbol[0] <= 1'b0;
        qam_symbol[0] <= 1'b0;
        qam_symbol[0] <= 1'b0;
        qam_symbol[0] <= 1'b0;
        qam_symbol[0] <= 1'b0;
        qam_symbol[0] <= 1'b0;
      end
      2'b11 : begin // 64QAM
        qam_symbol[0] <= 1'b0;
        qam_symbol[0] <= 1'b0;
        qam_symbol[0] <= 1'b0;
        qam_symbol[0] <= 1'b0;
        qam_symbol[0] <= 1'b0;
        qam_symbol[0] <= 1'b0;
      end
    endcase
  end
  
endmodule
