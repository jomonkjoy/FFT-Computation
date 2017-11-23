module fft_n_point_core #(
  parameter NO_STAGES = 4,
  parameter DATA_WIDTH = 16,
  parameter N_POINT_FFT = 2**NO_STAGES
) (
  input  logic clk,
  input  logic [DATA_WIDTH-1:0] x_N[N_POINT_FFT],
  input  logic [DATA_WIDTH-1:0] w_N[NO_STAGES][N_POINT_FFT/2],
  output logic [DATA_WIDTH-1:0] y_N[N_POINT_FFT]
);
  
  logic [DATA_WIDTH-1:0] x_i[NO_STAGES+1][N_POINT_FFT];
  
  assign x_i[0] = x_N;
  genvar i;
  generate for (i=1; i<=NO_STAGES; i++) begin : gen
    fft_n_point_stage #(i,DATA_WIDTH,N_POINT_FFT) fft_stage_inst (
      .clk (clk),
      .x_N (x_i[i-1]),
      .w_N (w_N[i-1]),
      .y_N (x_i[i])
    );
  end endgenerate
  assign y_N = x_i[NO_STAGES];
  
endmodule

module fft_n_point_stage #(
  parameter STAGE = 1,
  parameter DATA_WIDTH = 16,
  parameter N_POINT_FFT = 16
) (
  input  logic clk,
  input  logic [DATA_WIDTH-1:0] x_N[N_POINT_FFT],
  input  logic [DATA_WIDTH-1:0] w_N[N_POINT_FFT/2],
  output logic [DATA_WIDTH-1:0] y_N[N_POINT_FFT]
);

  localparam N_POINT_DFT = 2**STAGE;
  genvar i;
  generate for (i=0; i<N_POINT_FFT/N_POINT_DFT; i++) begin : gen
    fft_n_point_compute #(DATA_WIDTH,N_POINT_DFT) dft_n_point_inst (
      .clk (clk),
      .x_N (x_N[N_POINT_DFT*i   : N_POINT_DFT*i  +N_POINT_DFT  -1]),
      .w_N (w_N[N_POINT_DFT/2*i : N_POINT_DFT/2*i+N_POINT_DFT/2-1]),
      .y_N (y_N[N_POINT_DFT*i   : N_POINT_DFT*i  +N_POINT_DFT  -1])
    );
  end endgenerate
  
endmodule

module fft_n_point_compute #(
  parameter DATA_WIDTH = 16,
  parameter N_POINT_FFT = 16
) (
  input  logic clk,
  input  logic [DATA_WIDTH-1:0] x_N[N_POINT_FFT],
  input  logic [DATA_WIDTH-1:0] w_N[N_POINT_FFT/2],
  output logic [DATA_WIDTH-1:0] y_N[N_POINT_FFT]
);

  genvar i;
  generate for (i=0; i<N_POINT_FFT/2; i++) begin : gen
    fft_compute #(DATA_WIDTH) fft_compute_inst (
      .clk (clk),
      .x_N (x_N[i]),
      .x_M (x_N[i+N_POINT_FFT/2]),
      .w_N (w_N[i]),
      .y_N (y_N[i]),
      .y_M (y_N[i+N_POINT_FFT/2])
    );
  end endgenerate
  
endmodule
