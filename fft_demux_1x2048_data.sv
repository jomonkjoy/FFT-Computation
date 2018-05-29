// 16x1 mux/1x16 demux design
module fft_bin2dec_1x16 #(
  parameter int DATA_WIDTH = 8
) (
  input  logic clk,
  input  logic [3:0] data_sel,
  input  logic data_i_valid,
  input  logic [DATA_WIDTH-1:0] data_i,
  output logic [DATA_WIDTH-1:0] data_o,
  output logic [15:0] data_o_valid
);
  
  always_ff @(posedge clk) begin
    data_o <= data_i;
  end
  
  always_ff @(posedge clk) begin
    unique case(data_sel[3:0])
      4'h0 : data_o_valid <= 16'h0001;
      4'h1 : data_o_valid <= 16'h0002;
      4'h2 : data_o_valid <= 16'h0004;
      4'h3 : data_o_valid <= 16'h0008;
      4'h4 : data_o_valid <= 16'h0010;
      4'h5 : data_o_valid <= 16'h0020;
      4'h6 : data_o_valid <= 16'h0040;
      4'h7 : data_o_valid <= 16'h0080;
      4'h8 : data_o_valid <= 16'h0100;
      4'h9 : data_o_valid <= 16'h0200;
      4'hA : data_o_valid <= 16'h0400;
      4'hB : data_o_valid <= 16'h0800;
      4'hC : data_o_valid <= 16'h1000;
      4'hD : data_o_valid <= 16'h2000;
      4'hE : data_o_valid <= 16'h4000;
      4'hF : data_o_valid <= 16'h8000;
    endcase
  end
  
endmodule
// 8x1 mux/1x8 demux design
module fft_bin2dec_1x8 #(
  parameter int DATA_WIDTH = 8
) (
  input  logic clk,
  input  logic [2:0] data_sel,
  input  logic data_i_valid,
  input  logic [DATA_WIDTH-1:0] data_i,
  output logic [DATA_WIDTH-1:0] data_o,
  output logic [7:0] data_o_valid
);
  
  always_ff @(posedge clk) begin
    data_o <= data_i;
  end
  
  always_ff @(posedge clk) begin
    unique case(data_sel[2:0])
      3'h0 : data_o_valid <= 8'h01;
      3'h1 : data_o_valid <= 8'h02;
      3'h2 : data_o_valid <= 8'h04;
      3'h3 : data_o_valid <= 8'h08;
      3'h4 : data_o_valid <= 8'h10;
      3'h5 : data_o_valid <= 8'h20;
      3'h6 : data_o_valid <= 8'h40;
      3'h7 : data_o_valid <= 8'h80;
    endcase
  end
  
endmodule
