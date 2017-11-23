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
  
  typedef struct packed {
    logic [DATA_WIDTH/2-1:0] r;
    logic [DATA_WIDTH/2-1:0] i;
  } complex_type1;
  
  typedef struct packed {
    logic [DATA_WIDTH-1:0] r;
    logic [DATA_WIDTH-1:0] i;
  } complex_type2;
  
  complex_type1 reg_x_N;
  complex_type1 reg_x_M;
  complex_type1 reg_w_N;
  complex_type1 xor_y_N;
  complex_type1 xor_y_M;
  
  complex_type2 mul_y_N;
  complex_type2 mul_y_M;
  // pipeline inputs
  always_ff @(posedge clk) begin
    reg_x_N <= x_N;
    reg_x_M <= x_M;
    reg_w_N <= w_N;
  end
  // pipeline multiply-add outputs
  always_ff @(posedge clk) begin
    mul_y_N.r <= {{DATA_WIDTH{reg_x_N.r[DATA_WIDTH-1]}},reg_x_N.r} + reg_w_N.r*reg_x_M.r;
    mul_y_M.r <= {{DATA_WIDTH{reg_x_N.r[DATA_WIDTH-1]}},reg_x_N.r} - reg_w_N.r*reg_x_M.r;
    mul_y_N.i <= {{DATA_WIDTH{reg_x_N.i[DATA_WIDTH-1]}},reg_x_N.i} + reg_w_N.i*reg_x_M.i;
    mul_y_M.i <= {{DATA_WIDTH{reg_x_N.i[DATA_WIDTH-1]}},reg_x_N.i} - reg_w_N.i*reg_x_M.i;
  end
  
  assign xor_y_N.r = mul_y_N.r[2*DATA_WIDTH-1:DATA_WIDTH] ^ mul_y_N.r[DATA_WIDTH-1:0];
  assign xor_y_M.r = mul_y_M.r[2*DATA_WIDTH-1:DATA_WIDTH] ^ mul_y_M.r[DATA_WIDTH-1:0];
  assign xor_y_N.i = mul_y_N.i[2*DATA_WIDTH-1:DATA_WIDTH] ^ mul_y_N.i[DATA_WIDTH-1:0];
  assign xor_y_M.i = mul_y_M.i[2*DATA_WIDTH-1:DATA_WIDTH] ^ mul_y_M.i[DATA_WIDTH-1:0];
  
  assign y_N = {xor_y_N.r,xor_y_N.i};
  assign y_M = {xor_y_M.r,xor_y_M.i};
  
endmodule
