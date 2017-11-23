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
    logic [DATA_WIDTH/2-1:0] real;
    logic [DATA_WIDTH/2-1:0] imag;
  } complex_type1;
  
  typedef struct packed {
    logic [DATA_WIDTH-1:0] real;
    logic [DATA_WIDTH-1:0] imag;
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
    mul_y_N.real <= {{DATA_WIDTH{reg_x_N.real[DATA_WIDTH-1]}},reg_x_N.real} + reg_w_N.real*reg_x_M.real;
    mul_y_M.real <= {{DATA_WIDTH{reg_x_N.real[DATA_WIDTH-1]}},reg_x_N.real} - reg_w_N.real*reg_x_M.real;
    mul_y_N.imag <= {{DATA_WIDTH{reg_x_N.imag[DATA_WIDTH-1]}},reg_x_N.imag} + reg_w_N.imag*reg_x_M.imag;
    mul_y_M.imag <= {{DATA_WIDTH{reg_x_N.imag[DATA_WIDTH-1]}},reg_x_N.imag} - reg_w_N.imag*reg_x_M.imag;
  end
  
  assign xor_y_N.real = mul_y_N.real[2*DATA_WIDTH-1:DATA_WIDTH] ^ mul_y_N.real[DATA_WIDTH-1:0];
  assign xor_y_M.real = mul_y_M.real[2*DATA_WIDTH-1:DATA_WIDTH] ^ mul_y_M.real[DATA_WIDTH-1:0];
  assign xor_y_N.imag = mul_y_N.imag[2*DATA_WIDTH-1:DATA_WIDTH] ^ mul_y_N.imag[DATA_WIDTH-1:0];
  assign xor_y_M.imag = mul_y_M.imag[2*DATA_WIDTH-1:DATA_WIDTH] ^ mul_y_M.imag[DATA_WIDTH-1:0];
  
  assign y_N = {xor_y_N.real,xor_y_N.imag};
  assign y_M = {xor_y_M.real,xor_y_M.imag};
  
endmodule
