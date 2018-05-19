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
  
  logic [DATA_WIDTH-1:0] data[8];
  logic [2:0] sel_r;
  
  always_ff @(posedge clk) begin
    sel_r <= sel[10:8];
  end
  
  generate for (genvar i=0; i<8; i++) begin:gen
    fft_mux_256x1 #(
      .DATA_WIDTH(DATA_WIDTH)
    ) fft_mux_256x1_inst0 (
      .clk    (clk),
      .sel    (sel[7:0]),
      .data_i (data_i[256*i+:256]),
      .data_o (data[i])
    );
  end endgenerate
  
  fft_mux_8x1 #(
    .DATA_WIDTH(DATA_WIDTH)
  ) fft_mux_8x1_inst0 (
    .clk    (clk),
    .sel    (sel_r[2:0]),
    .data_i (data),
    .data_o (data_o)
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
  
  logic [DATA_WIDTH-1:0] data[8];
  logic [7:0] sel_r;
  
  always_ff @(posedge clk) begin
    sel_r <= sel[7:0];
  end
  
  generate for (genvar i=0; i<8; i++) begin:gen
    fft_demux_1x256 #(
      .DATA_WIDTH(DATA_WIDTH)
    ) fft_demux_1x256_inst0 (
      .clk    (clk),
      .sel    (sel_r[7:0]),
      .data_i (data[i]),
      .data_o (data_o[256*i+:256])
    );
  end endgenerate
  
  fft_demux_1x8 #(
    .DATA_WIDTH(DATA_WIDTH)
  ) fft_demux_1x8_inst0 (
    .clk    (clk),
    .sel    (sel[10:8]),
    .data_i (data_i),
    .data_o (data)
  );
  
endmodule
// 256x1 mux/1x256 demux design
module fft_mux_256x1 #(
  parameter int DATA_WIDTH = 8
) (
  input  logic clk,
  input  logic [7:0] sel,
  input  logic [DATA_WIDTH-1:0] data_i[256],
  output logic [DATA_WIDTH-1:0] data_o
);
  
  logic [DATA_WIDTH-1:0] data[16];
  logic [3:0] sel_r;
  
  always_ff @(posedge clk) begin
    sel_r <= sel[7:4];
  end
  
  generate for (genvar i=0; i<16; i++) begin:gen
    fft_mux_16x1 #(
      .DATA_WIDTH(DATA_WIDTH)
    ) fft_mux_16x1_inst0 (
      .clk    (clk),
      .sel    (sel[3:0]),
      .data_i (data_i[16*i+:16]),
      .data_o (data[i])
    );
  end endgenerate
  
  fft_mux_16x1 #(
    .DATA_WIDTH(DATA_WIDTH)
  ) fft_mux_16x1_inst1 (
    .clk    (clk),
    .sel    (sel_r[3:0]),
    .data_i (data),
    .data_o (data_o)
  );
  
endmodule

module fft_demux_1x256 #(
  parameter int DATA_WIDTH = 8
) (
  input  logic clk,
  input  logic [7:0] sel,
  input  logic [DATA_WIDTH-1:0] data_i,
  output logic [DATA_WIDTH-1:0] data_o[256]
);
  
  logic [DATA_WIDTH-1:0] data[16];
  logic [3:0] sel_r;
  
  always_ff @(posedge clk) begin
    sel_r <= sel[3:0];
  end
  
  generate for (genvar i=0; i<16; i++) begin:gen
    fft_demux_1x16 #(
      .DATA_WIDTH(DATA_WIDTH)
    ) fft_demux_1x16_inst1 (
      .clk    (clk),
      .sel    (sel_r[3:0]),
      .data_i (data[i]),
      .data_o (data_o[16*i+:16])
    );
  end endgenerate
  
  fft_demux_1x16 #(
    .DATA_WIDTH(DATA_WIDTH)
  ) fft_demux_1x16_inst0 (
    .clk    (clk),
    .sel    (sel[7:4]),
    .data_i (data_i),
    .data_o (data)
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
// 8x1 mux/1x8 demux design
module fft_mux_8x1 #(
  parameter int DATA_WIDTH = 8
) (
  input  logic clk,
  input  logic [2:0] sel,
  input  logic [DATA_WIDTH-1:0] data_i[8],
  output logic [DATA_WIDTH-1:0] data_o
);
  
  always_ff @(posedge clk) begin
    case(sel[2:0])
      3'h0 : data_o <= data_i[00];
      3'h1 : data_o <= data_i[01];
      3'h2 : data_o <= data_i[02];
      3'h3 : data_o <= data_i[03];
      3'h4 : data_o <= data_i[04];
      3'h5 : data_o <= data_i[05];
      3'h6 : data_o <= data_i[06];
      3'h7 : data_o <= data_i[07];
    endcase
  end
  
endmodule

module fft_demux_1x8 #(
  parameter int DATA_WIDTH = 8
) (
  input  logic clk,
  input  logic [2:0] sel,
  input  logic [DATA_WIDTH-1:0] data_i,
  output logic [DATA_WIDTH-1:0] data_o[8]
);
  
  always_ff @(posedge clk) begin
    data_o[sel] <= data_i;
  end
  
endmodule

