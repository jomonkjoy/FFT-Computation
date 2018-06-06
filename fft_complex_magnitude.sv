//* magnitude ~= alpha * max(|I|, |Q|) + beta * min(|I|, |Q|) */
module fft_complex_magnitude (
  input  logic                 clk,
  input  logic signed   [15:0] comp_i,
  input  logic signed   [15:0] comp_q,
  output logic unsigned [15:0] comp_m
);
  
  logic unsigned [15:0] abs_i;
  logic unsigned [15:0] abs_q;
  logic unsigned [15:0] max_value;
  logic unsigned [15:0] min_value;
  
  always_ff @(posedge clk) begin
    abs_i <= 'unsigned(comp_i);
    abs_q <= 'unsigned(comp_q);
  end
  
  always_ff @(posedge clk) begin
    if (abs_i < abs_q) begin
      max_value <= abs_q;
      min_value <= abs_i;
    end else begin
      max_value <= abs_i;
      min_value <= abs_q;
    end
  end
  
  always_ff @(posedge clk) begin
    comp_m <= max_value + 2'd2 >> min_value;
  end
  
endmodule
