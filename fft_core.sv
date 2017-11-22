module fft_N_point_core #(
  parameter DATA_WIDTH = 16,
  parameter N_POINT = 16  
) (
  input  logic clk,
  input  logic [DATA_WIDTH-1:0] x[N_POINT],
  input  logic [DATA_WIDTH-1:0] w[N_POINT/2],
  output logic [DATA_WIDTH-1:0] y[N_POINT]
);

endmdoule

module fft_stage1 #(
  parameter DATA_WIDTH = 16,
  parameter N_POINT = 16
) (
  input  logic clk,
  input  logic [DATA_WIDTH-1:0] x[N_POINT],
  input  logic [DATA_WIDTH-1:0] w[N_POINT/2],
  output logic [DATA_WIDTH-1:0] y[N_POINT]
);

  genvar i;
  generate for (i=0; i<N_POINT/2; i++) begin
    fft_compute #(DATA_WIDTH) fft_compute_inst (
      .clk (clk),
      .x_N (x[2*i]),
      .x_M (x[2*i+1]),
      .w_N (w[i]),
      .y_N (y[2*i])
      .y_M (y[2*i+1])
    );
  end endgenerate
  
endmdoule
