// OFDM Single carrier to multiple sub-carrier spectral efficeincy & reduce delay-spread/ ISI
// 1MHz -> [100 sub carriers of 10KHz]
// OFDMA rxUE and SCFDMA txUE
// OFDM 64QAM Modulation -> IFFT(freq2time) -> CyclePrefix[GuardPeriod]
// 20MHz LTE spectrum Fmax = 9MHz
// Nquist sampling rate >= 18M samples per sec
// 20MHz LTE (3.8MHz * 8 = 30.7MHz sampling frequency)
// FFT Size = 2048 samples per symbol in OFDMA
// Removal of CyclePrrfix -> FFT(time2freq) -> OFDM 64QAM DeModulation
module ofdm_modulation (
  input  logic               clk,
  input  logic               reset,
  input  logic        [5:0]  qam_symbol,
  input  logic               qam_symbol_valid,
  output logic signed [15:0] qam_inphase_o,
  output logic signed [15:0] qam_quadrat_o,
  output logic               qam_mod_valid
);
  
  always_ff @(posedge clk) begin
    unique case(qam_symbol[3:0])
      4'h0 : qam_inphase <= QAM_I[00];
      4'h1 : qam_inphase <= QAM_I[01];
      4'h2 : qam_inphase <= QAM_I[02];
      4'h3 : qam_inphase <= QAM_I[03];
      4'h4 : qam_inphase <= QAM_I[04];
      4'h5 : qam_inphase <= QAM_I[05];
      4'h6 : qam_inphase <= QAM_I[06];
      4'h7 : qam_inphase <= QAM_I[07];
      4'h8 : qam_inphase <= QAM_I[08];
      4'h9 : qam_inphase <= QAM_I[09];
      4'hA : qam_inphase <= QAM_I[10];
      4'hB : qam_inphase <= QAM_I[11];
      4'hC : qam_inphase <= QAM_I[12];
      4'hD : qam_inphase <= QAM_I[13];
      4'hE : qam_inphase <= QAM_I[14];
      4'hF : qam_inphase <= QAM_I[15];
    endcase
  end
  
  always_ff @(posedge clk) begin
    unique case(qam_symbol[5:4])
      2'b00 : qam_inphase_o <= {1'b0,qam_inphase};
      2'b01 : qam_inphase_o <= {1'b0,qam_inphase};
      2'b10 : qam_inphase_o <= {1'b1,qam_inphase};
      2'b11 : qam_inphase_o <= {1'b1,qam_inphase};
    endcase
  end
  
  always_ff @(posedge clk) begin
    unique case(qam_symbol[3:0])
      4'h0 : qam_quadrat <= QAM_Q[00];
      4'h1 : qam_quadrat <= QAM_Q[01];
      4'h2 : qam_quadrat <= QAM_Q[02];
      4'h3 : qam_quadrat <= QAM_Q[03];
      4'h4 : qam_quadrat <= QAM_Q[04];
      4'h5 : qam_quadrat <= QAM_Q[05];
      4'h6 : qam_quadrat <= QAM_Q[06];
      4'h7 : qam_quadrat <= QAM_Q[07];
      4'h8 : qam_quadrat <= QAM_Q[08];
      4'h9 : qam_quadrat <= QAM_Q[09];
      4'hA : qam_quadrat <= QAM_Q[10];
      4'hB : qam_quadrat <= QAM_Q[11];
      4'hC : qam_quadrat <= QAM_Q[12];
      4'hD : qam_quadrat <= QAM_Q[13];
      4'hE : qam_quadrat <= QAM_Q[14];
      4'hF : qam_quadrat <= QAM_Q[15];
    endcase
  end
  
  always_ff @(posedge clk) begin
    unique case(qam_symbol[5:4])
      2'b00 : qam_quadrat_o <= {1'b0,qam_quadrat};
      2'b01 : qam_quadrat_o <= {1'b0,qam_quadrat};
      2'b10 : qam_quadrat_o <= {1'b1,qam_quadrat};
      2'b11 : qam_quadrat_o <= {1'b1,qam_quadrat};
    endcase
  end
  
endmodule
