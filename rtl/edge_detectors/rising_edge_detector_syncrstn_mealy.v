module rising_edge_detector_syncrstn_mealy
  (input      rstn,
   input      clk,
   input      pulse_in,
   output reg pulse_out_rise
) ;

   typedef enum reg
		{S0 = 1'b0,
		 S1 = 1'b1
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
      pulse_out_rise = valid && 1'b0;
      case (crnt_state)
	S0: if (pulse_in) begin
	   next_state     = S1;
	   pulse_out_rise = valid && 1'b1;
	end
	else begin
	  next_state     = S0;
	  pulse_out_rise = valid && 1'b0;
	end
	S1: if (pulse_in) begin
	   next_state     = S1;
	   pulse_out_rise = valid && 1'b0;
	end
	else begin
	  next_state     = S0;
	  pulse_out_rise = valid && 1'b0;
	end
      endcase // case (crnt_state)
   end

endmodule // rising_edge_detector_syncrstn_mealy
