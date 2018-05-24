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
  
  localparam int QAM_MAX = 1024;
  
  logic unsigned [14:0] qam_inphase;
  logic unsigned [14:0] qam_quadrat;
  
  assign qam_inphase = unsigned'(qam_inphase_i);
  assign qam_quadrat = unsigned'(qam_quadrat_i);
  
  always_ff @(posedge clk) begin
    unique case(qam_type[1:0])
      2'b00 : begin // BPSK
        qam_symbol[0] <= ~qam_inphase_i[15];
        qam_symbol[1] <= 1'b0;
        qam_symbol[2] <= 1'b0;
        qam_symbol[3] <= 1'b0;
        qam_symbol[4] <= 1'b0;
        qam_symbol[5] <= 1'b0;
      end
      2'b01 : begin // QPSK
        qam_symbol[0] <= ~qam_inphase_i[15];
        qam_symbol[1] <= ~qam_quadrat_i[15];
        qam_symbol[2] <= 1'b0;
        qam_symbol[3] <= 1'b0;
        qam_symbol[4] <= 1'b0;
        qam_symbol[5] <= 1'b0;
      end
      2'b10 : begin // 16QAM
        qam_symbol[0] <= ~qam_inphase_i[15];
        qam_symbol[1] <=  qam_inphase < (QAM_MAX*2/3);
        qam_symbol[2] <= ~qam_quadrat_i[15];
        qam_symbol[3] <=  qam_quadrat < (QAM_MAX*2/3);
        qam_symbol[4] <= 1'b0;
        qam_symbol[5] <= 1'b0;
      end
      2'b11 : begin // 64QAM
        qam_symbol[0] <= ~qam_inphase_i[15];
        qam_symbol[1] <=  qam_inphase < (QAM_MAX*4/7);
        qam_symbol[2] <=  qam_inphase > (QAM_MAX*2/7) && qam_inphase < (QAM_MAX*6/7);
        qam_symbol[3] <= ~qam_quadrat_i[15];
        qam_symbol[4] <=  qam_quadrat < (QAM_MAX*4/7);
        qam_symbol[5] <=  qam_quadrat > (QAM_MAX*2/7) && qam_quadrat < (QAM_MAX*6/7);
      end
    endcase
  end
  
endmodule
