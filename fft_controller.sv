module fft_controller #(
  parameter ADDR_WIDTH = 32,
  parameter DATA_WIDTH = 32
) (
  input  logic clk,
  input  logic reset,
  input  logic fft_clk,
  
  input  logic cpu_if_read,
  input  logic cpu_if_write,
  input  logic [ADDR_WIDTH-1:0] cpu_if_address,
  input  logic [DATA_WIDTH-1:0] cpu_if_write_data,
  output logic [DATA_WIDTH-1:0] cpu_if_read_data,
  output logic cpu_if_access_complete,
  
  output logic error
);
  
  localparam NO_STAGES = 4;
  localparam N_POINT_FFT = 2**NO_STAGES;
  
  logic [DATA_WIDTH/2-1:0] x_N [N_POINT_FFT];
  logic [DATA_WIDTH/2-1:0] w_N [NO_STAGES][N_POINT_FFT/2];
  logic [DATA_WIDTH/2-1:0] y_N [N_POINT_FFT];
  
  logic wr_full,rd_empty;
  logic rd_full,rd_empty;
  logic fft_if_read;
  logic fft_if_write;
  logic [DATA_WIDTH/2-1:0][N_POINT_FFT-1:0] fft_if_write_data;
  logic [DATA_WIDTH/2-1:0][N_POINT_FFT-1:0] fft_if_read_data;
  
  logic [9:0] fft_data_valid;
  
  always_ff @(posedge clkk) begin
    if (reset) begin
      fft_data_valid <= 10'd0;
    end else begin
      fft_data_valid <= {fft_data_valid[8:0],fft_if_read};
    end
  end
  
  assign fft_if_write = fft_data_valid[9];
  assign error = rd_full;
  
  genvar i;
  generate for (i=0; i<N_POINT_FFT; i++) begin
    assign x_N[i] = fft_if_read_data[i];
    assign fft_if_write_data[i] = y_N[i];
  end endgenerate
  
  fft_n_point_core #(NO_STAGES,DATA_WIDTH/2) fft_core_inst (
    .clk (clk),
    .x_N (x_N),
    .w_N (w_N),
    .y_N (y_N)
  );
  
  fifo_wr_channel fifo_wr_channel (
    .rst    (reset),
    .wr_clk (clk),
    .rd_clk (fft_clk),
    .din    (cpu_if_write_data),
    .wr_en  (cpu_if_write),
    .rd_en  (fft_if_read),
    .dout   (fft_if_read_data),
    .full   (wr_full),
    .empty  (wr_empty)
  );
  
  fifo_rd_channel fifo_rd_channel (
    .rst    (reset),
    .wr_clk (fft_clk),
    .rd_clk (clk),
    .din    (fft_if_write_data),
    .wr_en  (fft_if_write),
    .rd_en  (cpu_if_read),
    .dout   (cpu_if_read_data),
    .full   (rd_full),
    .empty  (rd_empty)
  );
  
endmodule
