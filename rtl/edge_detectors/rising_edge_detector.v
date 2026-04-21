module rising_edge_detector
  (output reg pulse_out_rise,
   input pulse_in,
   input clk,
   input rstn
) ;

   reg pulse_reg;
   reg valid;

// ANS-1: Using rstn as data signal is ugly
//   always_ff @(posedge clk)
//     pulse_reg <= pulse_in;
//
//   assign pulse_out_rise = rstn ? {pulse_in && ~pulse_reg} : 0;

// ANS-2: Using rstn as data signal is ugly
//   always_ff @(posedge clk or negedge rstn)
//     if (!rstn) pulse_reg <= 1'b0;
//     else       pulse_reg <= pulse_in;
//
//   assign pulse_out_rise = rstn ? (pulse_in & ~pulse_reg) : 0;

// ANS-3: Glitchy
//   always_ff @(posedge clk or negedge rstn)
//     if (!rstn) {pulse_reg, valid} <= 2'b00;
//     else       {pulse_reg, valid} <= {pulse_in, 1'b1};
//
//   assign pulse_out_rise = valid && (pulse_in && ~pulse_reg);

   // ANS-4: Nice
   always_ff @(posedge clk or negedge rstn)
     if (!rstn) begin
	pulse_reg      <= 1'b0;
	valid          <= 1'b0;
	pulse_out_rise <= 1'b0;
     end
     else  begin
	pulse_reg      <= pulse_in;
	valid          <= 1'b1;
	pulse_out_rise <= valid && (pulse_in && ~pulse_reg);
     end

endmodule // rising_edge_detector
