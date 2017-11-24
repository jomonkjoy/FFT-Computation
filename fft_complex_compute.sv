////////////////////////////////////////
// Complex Multipllication 
// (a+bi)(c+di) = ac + adi + bci + bdi2 = (ac-bd) + (ad+bc)i
////////////////////////////////////////
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
    logic signed [DATA_WIDTH/2-1:0] r;
    logic signed [DATA_WIDTH/2-1:0] i;
  } complex_type1;
  
  typedef struct packed {
    logic signed [DATA_WIDTH-1:0] r;
    logic signed [DATA_WIDTH-1:0] i;
  } complex_type2;
  
  complex_type1 reg_x_N;
  complex_type1 reg_x_M;
  complex_type1 reg_w_N;
  complex_type1 add_y_N;
  complex_type1 add_y_M;
  
  complex_type2 mul_y_N;
  complex_type2 mul_y_M;
  // pipeline inputs
  always_ff @(posedge clk) begin
    reg_x_N <= x_N;
    reg_x_M <= x_M;
    reg_w_N <= w_N;
  end
  // pipeline complex-multiply outputs
  always_ff @(posedge clk) begin
    mul_y_N.r <= reg_w_N.r*reg_x_M.r;
    mul_y_M.r <= reg_w_N.i*reg_x_M.i;
    mul_y_N.i <= reg_w_N.r*reg_x_M.i;
    mul_y_M.i <= reg_w_N.i*reg_x_M.r;
  end
  // pipeline complex-add outputs
  always_ff @(posedge clk) begin
    add_y_N.r <= reg_x_N.r + mul_y_N.r[DATA_WIDTH-3:DATA_WIDTH/2-2] - mul_y_M.r[DATA_WIDTH-3:DATA_WIDTH/2-2];
    add_y_M.r <= reg_x_N.r - mul_y_N.r[DATA_WIDTH-3:DATA_WIDTH/2-2] + mul_y_M.r[DATA_WIDTH-3:DATA_WIDTH/2-2];
    add_y_N.i <= reg_x_N.i + mul_y_N.i[DATA_WIDTH-3:DATA_WIDTH/2-2] + mul_y_M.i[DATA_WIDTH-3:DATA_WIDTH/2-2];
    add_y_M.i <= reg_x_N.i - mul_y_N.i[DATA_WIDTH-3:DATA_WIDTH/2-2] - mul_y_M.i[DATA_WIDTH-3:DATA_WIDTH/2-2];
  end
  
  assign y_N = {add_y_N.r,add_y_N.i};
  assign y_M = {add_y_M.r,add_y_M.i};
  
endmodule
