module pulse_stretcher_cntr #(
			  parameter STRETCH_CYCLES=4
			  )
   (output pulse_out,
    input pulse_in,
    input clk,
    input rstn
    );

   // ln(4)/ln(2) = 2
   localparam int CNTR_WIDTH = (STRETCH_CYCLES > 1) ? $clog2(STRETCH_CYCLES+1) : 1;

   logic [CNTR_WIDTH-1:0] cntr;

   assign pulse_out = |cntr;

//   always_ff @(posedge clk or negedge rstn)
//     if (!rstn) pulse_out <= 1'b0;
//     else       pulse_out <= |cntr;

   always_ff @(posedge clk or negedge rstn)
     if (!rstn)         cntr <= {CNTR_WIDTH{1'b0}};
     else if (pulse_in) cntr <= STRETCH_CYCLES;
     else if (|cntr)    cntr <= cntr - 1;

//   // Stretch by ignoring subsequent pulse_in
//   always_ff @(posedge clk or negedge rstn)
//     if (!rstn)         cntr <= {CNTR_WIDTH{1'b0}};
//     else if (~|cntr & pulse_in) cntr <= STRETCH_CYCLES;
//     else if (|cntr)    cntr <= cntr - 1;

endmodule // pulse_stretcher_shiftreg
