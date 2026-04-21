module falling_edge_detector
  (output reg pulse_out_fall,
   input pulse_in,
   input clk,
   input rstn
) ;

   reg pulse_reg;
   reg valid;

   always_ff @(posedge clk or negedge rstn)
     if (!rstn) begin
	pulse_reg      <= 1'b0;
	valid          <= 1'b0;
	pulse_out_fall <= 1'b0;
     end
     else  begin
	pulse_reg      <= ~pulse_in;
	valid          <= 1'b1;
	pulse_out_fall <= valid && (pulse_in && ~pulse_reg);
     end

endmodule // falling_edge_detector
