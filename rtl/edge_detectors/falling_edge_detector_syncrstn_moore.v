module falling_edge_detector_syncrstn_moore
  (input  rstn,
   input  clk,
   input  pulse_in,
   output pulse_out_rise
) ;

   typedef enum reg [2:0]
		{S0 = 3'b000,
		 S1 = 3'b001,
		 S2 = 3'b010
		 } state_t;

   state_t crnt_state;
   state_t next_state;

   reg valid;

   always_ff @(posedge clk)
     if (!rstn) begin
	crnt_state <= S0;
	valid      <= 1'b0;
     end
     else       begin
	crnt_state <= next_state;
	valid      <= 1'b1;
     end

   always @(*) begin
      next_state = crnt_state;
      case (crnt_state)
	S0: next_state = pulse_in ? S0 : S1;
	S1: next_state = pulse_in ? S0 : S2;
	S2: next_state = pulse_in ? S0 : S2;
      endcase // case (crnt_state)
   end

   // Works, but this is not pure Moore machine!
   // always_ff @(posedge clk)
   //   if (!rstn) pulse_out_rise <= 1'b0;
   //   else       pulse_out_rise <= valid && (next_state == S1);

   // If edge close to rstn de-assertion is not desirable, go to Mealy machine
   assign pulse_out_rise = valid && (crnt_state == S1);

endmodule // falling_edge_detector_syncrstn_moore
