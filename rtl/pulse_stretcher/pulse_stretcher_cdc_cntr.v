module pulse_stretcher_cdc_cntr #(
			      parameter STRETCH_CYCLES=4
			      )
  (output pulse_out,
   input pulse_in,
   input src_clk,
   input src_rstn,
   input dst_clk,
   input dst_rstn
   );

   localparam int CNTR_WIDTH = (STRETCH_CYCLES > 1) ? $clog2(STRETCH_CYCLES+1) : 1;

   reg 		  pulse_in_tgl;
   reg 		  sync2_d;
   reg 		  sync2;
   reg 		  sync1;
   reg [CNTR_WIDTH-1:0] cntr;

   wire 	  pulse_edge;

   always_ff @(posedge src_clk or negedge src_rstn)
     if (!src_rstn) pulse_in_tgl <= 1'b0;
     else           pulse_in_tgl <= ~pulse_in; // falling edge

   always_ff @(posedge dst_clk or negedge dst_rstn)
     if (!dst_rstn) {sync2_d, sync2, sync1} <= 3'b000;
     else           {sync2_d, sync2, sync1} <= {sync2, sync1, pulse_in_tgl};

// Both are same
// assign pulse_edge = sync2_d ^ sync2;
   assign pulse_edge = ~sync2_d & sync2;

   always_ff @(posedge dst_clk or negedge dst_rstn)
     if (!dst_rstn)       cntr <= {CNTR_WIDTH{1'b0}};
     else if (pulse_edge) cntr <= STRETCH_CYCLES;
     else if (|cntr)      cntr <= cntr - 1;

   assign pulse_out = |cntr;

endmodule // pulse_stretcher_cdc_cntr
