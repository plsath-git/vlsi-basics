module toggle_sync_pulse_cdc
  (output pulse_out,
   input  pulse_in,
   input  src_clk,
   input  src_rstn,
   input  dst_clk,
   input  dst_rstn
);

   reg tgl_r;
   reg sync2_d;
   reg sync2;
   reg sync1;

   always_ff @(posedge src_clk or negedge src_rstn)
     if (!src_rstn)     tgl_r <= 1'b0;
     else if (pulse_in) tgl_r <= ~tgl_r;

   always_ff @(posedge dst_clk or negedge dst_rstn)
     if (!dst_rstn) {sync2_d, sync2, sync1} <= 3'b000;
     else           {sync2_d, sync2, sync1} <=  {sync2, sync1, tgl_r}

   assign pulse_out = sync2_d ^ sync2;

endmodule // toggle_sync_pulse_cdc
