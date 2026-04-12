module pulse_stretcher_edge_cntr #(
			      parameter STRETCH_CYCLES=4
			      )
   (output pulse_out,
    input pulse_in,
    input clk,
    input rstn
    );

   localparam int CNTR_WIDTH = (STRETCH_CYCLES > 1) ? $clog2(STRETCH_CYCLES+1) : 1;

   reg [CNTR_WIDTH-1:0] cntr;
   reg 			pulse_inn_d;

   wire pulse_edge;

   assign pulse_out = |cntr;

   always_ff @(posedge clk or negedge rstn)
     if (!rstn)           cntr <= {CNTR_WIDTH{1'b0}};
     else if (pulse_edge) cntr <= STRETCH_CYCLES;
     else if (|cntr)      cntr <= cntr - 1;

     assign pulse_edge = pulse_in & ~pulse_inn_d;

     always_ff @(posedge clk or negedge rstn)
       if (!rstn) pulse_inn_d <= 1'b0;
       else       pulse_inn_d <= pulse_in;

endmodule // pulse_stretcher_edge_cntr
