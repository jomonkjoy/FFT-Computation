module fft_complex_compute #(
  parameter DATA_WIDTH = 32
) (
  input  logic clk,
  input  logic [DATA_WIDTH-1:0] x_N,
  input  logic [DATA_WIDTH-1:0] x_M,
  input  logic [DATA_WIDTH-1:0] w_N,
  output logic [DATA_WIDTH-1:0] y_N,
  output logic [DATA_WIDTH-1:0] y_M
);

  logic [1*DATA_WIDTH-1:0] reg_x_N;
  logic [1*DATA_WIDTH-1:0] reg_x_M;
  logic [1*DATA_WIDTH-1:0] reg_w_N;
  
  logic [2*DATA_WIDTH-1:0] mul_y_N;
  logic [2*DATA_WIDTH-1:0] mul_y_M;
  // pipeline inputs
  always_ff @(posedge clk) begin
    reg_x_N <= x_N;
    reg_x_M <= x_M;
    reg_w_N <= w_N;
  end
  // pipeline multiply-add outputs
  always_ff @(posedge clk) begin
    mul_y_N <= {{DATA_WIDTH{reg_x_N[DATA_WIDTH-1]}},reg_x_N} + reg_w_N*reg_x_M;
    mul_y_M <= {{DATA_WIDTH{reg_x_N[DATA_WIDTH-1]}},reg_x_N} - reg_w_N*reg_x_M;
  end
  
  assign y_N = mul_y_N[2*DATA_WIDTH-1:DATA_WIDTH] ^ mul_y_N[DATA_WIDTH-1:0];
  assign y_M = mul_y_M[2*DATA_WIDTH-1:DATA_WIDTH] ^ mul_y_M[DATA_WIDTH-1:0];
  
endmodule
