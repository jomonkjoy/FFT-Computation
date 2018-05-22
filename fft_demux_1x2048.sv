// 16x1 mux/1x16 demux design
module fft_bin2dec_1x16 (
  input  logic clk,
  input  logic [3:0]  bin,
  output logic [15:0] dec
);
  
  always_ff @(posedge clk) begin
    unique case(bin[3:0])
      4'h0 : dec <= 16'h0001;
      4'h1 : dec <= 16'h0002;
      4'h2 : dec <= 16'h0004;
      4'h3 : dec <= 16'h0008;
      4'h4 : dec <= 16'h0010;
      4'h5 : dec <= 16'h0020;
      4'h6 : dec <= 16'h0040;
      4'h7 : dec <= 16'h0080;
      4'h8 : dec <= 16'h0100;
      4'h9 : dec <= 16'h0200;
      4'hA : dec <= 16'h0400;
      4'hB : dec <= 16'h0800;
      4'hC : dec <= 16'h1000;
      4'hD : dec <= 16'h2000;
      4'hE : dec <= 16'h4000;
      4'hF : dec <= 16'h8000;
    endcase
  end
  
endmodule
// 8x1 mux/1x8 demux design
module fft_bin2dec_1x8 (
  input  logic clk,
  input  logic [2:0] bin,
  output logic [7:0] dec
);
  
  always_ff @(posedge clk) begin
    unique case(bin[2:0])
      3'h0 : dec <= 8'h01;
      3'h1 : dec <= 8'h02;
      3'h2 : dec <= 8'h04;
      3'h3 : dec <= 8'h08;
      3'h4 : dec <= 8'h10;
      3'h5 : dec <= 8'h20;
      3'h6 : dec <= 8'h40;
      3'h7 : dec <= 8'h80;
    endcase
  end
  
endmodule
