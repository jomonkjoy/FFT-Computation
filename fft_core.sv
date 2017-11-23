module fft_N_point_core #(
  parameter DATA_WIDTH = 16,
  parameter N_POINT = 16  
) (
  input  logic clk,
  input  logic [DATA_WIDTH-1:0] x[N_POINT],
  output logic [DATA_WIDTH-1:0] y[N_POINT]
);

  logic [DATA_WIDTH-1:0] x_1[N_POINT];
  logic [DATA_WIDTH-1:0] x_2[N_POINT];
  logic [DATA_WIDTH-1:0] x_3[N_POINT];
  
  logic [DATA_WIDTH-1:0] w_1[N_POINT/2] = '{default:{DATA_WIDTH{1'b0}}};
  logic [DATA_WIDTH-1:0] w_2[N_POINT/2] = '{default:{DATA_WIDTH{1'b0}}};
  logic [DATA_WIDTH-1:0] w_3[N_POINT/2] = '{default:{DATA_WIDTH{1'b0}}};
  logic [DATA_WIDTH-1:0] w_4[N_POINT/2] = '{default:{DATA_WIDTH{1'b0}}};
  
  fft_stage1 #(DATA_WIDTH,N_POINT) fft_stage1 (.clk(clk), .x(x  ), .w(w_1), .y(x_1));
  fft_stage2 #(DATA_WIDTH,N_POINT) fft_stage2 (.clk(clk), .x(x_1), .w(w_2), .y(x_2));
  fft_stage3 #(DATA_WIDTH,N_POINT) fft_stage3 (.clk(clk), .x(x_2), .w(w_3), .y(x_3));
  fft_stage4 #(DATA_WIDTH,N_POINT) fft_stage4 (.clk(clk), .x(x_3), .w(w_4), .y(y  ));
  
endmodule

module fft_stage4 #(
  parameter DATA_WIDTH = 16,
  parameter N_POINT = 16
) (
  input  logic clk,
  input  logic [DATA_WIDTH-1:0] x[N_POINT],
  input  logic [DATA_WIDTH-1:0] w[N_POINT/2],
  output logic [DATA_WIDTH-1:0] y[N_POINT]
);

  genvar i;
  generate for (i=0; i<N_POINT/2; i++) begin : gen
    fft_compute #(DATA_WIDTH) fft_compute_inst (
      .clk (clk),
      .x_N (x[i]),
      .x_M (x[i+8]),
      .w_N (w[i]),
      .y_N (y[i])
      .y_M (y[i+8])
    );
  end endgenerate
  
endmodule

module fft_stage3 #(
  parameter DATA_WIDTH = 16,
  parameter N_POINT = 16
) (
  input  logic clk,
  input  logic [DATA_WIDTH-1:0] x[N_POINT],
  input  logic [DATA_WIDTH-1:0] w[N_POINT/2],
  output logic [DATA_WIDTH-1:0] y[N_POINT]
);

  genvar i;
  generate for (i=0; i<N_POINT/4; i++) begin : gen
    fft_compute #(DATA_WIDTH) fft_compute_inst0 (
      .clk (clk),
      .x_N (x[i]),
      .x_M (x[i+4]),
      .w_N (w[i]),
      .y_N (y[i])
      .y_M (y[i+4])
    );
    fft_compute #(DATA_WIDTH) fft_compute_inst1 (
      .clk (clk),
      .x_N (x[i+8]),
      .x_M (x[i+12]),
      .w_N (w[i+4]),
      .y_N (y[i+8])
      .y_M (y[i+12])
    );
  end endgenerate
  
endmodule

module fft_stage2 #(
  parameter DATA_WIDTH = 16,
  parameter N_POINT = 16
) (
  input  logic clk,
  input  logic [DATA_WIDTH-1:0] x[N_POINT],
  input  logic [DATA_WIDTH-1:0] w[N_POINT/2],
  output logic [DATA_WIDTH-1:0] y[N_POINT]
);

  genvar i;
  generate for (i=0; i<N_POINT/2; i++) begin : gen
    if (i%2 == 0) begin
      fft_compute #(DATA_WIDTH) fft_compute_inst0 (
        .clk (clk),
        .x_N (x[2*i]),
        .x_M (x[2*i+2]),
        .w_N (w[i]),
        .y_N (y[2*i])
        .y_M (y[2*i+2])
      );
    end else begin
      fft_compute #(DATA_WIDTH) fft_compute_inst1 (
        .clk (clk),
        .x_N (x[2*i-1]),
        .x_M (x[2*i+1]),
        .w_N (w[i]),
        .y_N (y[2*i-1])
        .y_M (y[2*i+1])
      );
    end
  end endgenerate
  
endmodule

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
  generate for (i=0; i<N_POINT/2; i++) begin : gen
    fft_compute #(DATA_WIDTH) fft_compute_inst (
      .clk (clk),
      .x_N (x[2*i]),
      .x_M (x[2*i+1]),
      .w_N (w[i]),
      .y_N (y[2*i])
      .y_M (y[2*i+1])
    );
  end endgenerate
  
endmodule
