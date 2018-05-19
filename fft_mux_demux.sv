// mux/demux design for 2048 point FFT Core
// design has 3 stage latency
module fft_mux_2048x1 #(
  parameter int DATA_WIDTH = 8
) (
  input  logic clk,
  input  logic [10:0] sel,
  input  logic [DATA_WIDTH-1:0] data_i[2048],
  output logic [DATA_WIDTH-1:0] data_o
);

endmodule

module fft_demux_1x2048 #(
  parameter int DATA_WIDTH = 8
) (
  input  logic clk,
  input  logic [10:0] sel,
  input  logic [DATA_WIDTH-1:0] data_i,
  output logic [DATA_WIDTH-1:0] data_o[2048]
);

endmodule
// 16x1 mux/1x16 demux design
module fft_mux_16x1 #(
  parameter int DATA_WIDTH = 8
) (
  input  logic clk,
  input  logic [3:0] sel,
  input  logic [DATA_WIDTH-1:0] data_i[16],
  output logic [DATA_WIDTH-1:0] data_o
);
  
  always_ff @(posedge clk) begin
    case(sel[3:0])
      4'h0 : data_o <= data_i[00];
      4'h1 : data_o <= data_i[01];
      4'h2 : data_o <= data_i[02];
      4'h3 : data_o <= data_i[03];
      4'h4 : data_o <= data_i[04];
      4'h5 : data_o <= data_i[05];
      4'h6 : data_o <= data_i[06];
      4'h7 : data_o <= data_i[07];
      4'h8 : data_o <= data_i[08];
      4'h9 : data_o <= data_i[09];
      4'hA : data_o <= data_i[10];
      4'hB : data_o <= data_i[11];
      4'hC : data_o <= data_i[12];
      4'hD : data_o <= data_i[13];
      4'hE : data_o <= data_i[14];
      4'hF : data_o <= data_i[15];
    endcase
  end
  
endmodule

module fft_demux_1x16 #(
  parameter int DATA_WIDTH = 8
) (
  input  logic clk,
  input  logic [3:0] sel,
  input  logic [DATA_WIDTH-1:0] data_i,
  output logic [DATA_WIDTH-1:0] data_o[16]
);
  
  always_ff @(posedge clk) begin
    data_o[sel] <= data_i;
  end
  
endmodule
