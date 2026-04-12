module toggle_sync_pulse_cdc
  (output pulse_out,
   output busy_src,
   input pulse_in,
   input src_clk,
   input src_rstn,
   input dst_clk,
   input dst_rstn
);

   reg 	 req_dst_sync1;
   reg 	 req_dst_sync2;
   reg 	 req_dst_sync2_d;
   reg 	 ack_dst;
   reg 	 ack_src_sync1;
   reg 	 ack_src_sync2;

   wire req_rise_dst;

    always_ff @(posedge dst_clk or negedge dst_rstn)
        if (!dst_rstn) {req_dst_sync2_d, req_dst_sync2, req_dst_sync1} <= 3'b000;
        else           {req_dst_sync2_d, req_dst_sync2, req_dst_sync1} <= {req_dst_sync2, req_dst_sync1, req_src};

    // New request seen in dst domain
    assign req_rise_dst = req_dst_sync2 & ~req_dst_sync2_d;

    always_ff @(posedge dst_clk or negedge dst_rstn)
        if (!dst_rstn)           ack_dst <= 1'b0;
        else if (req_rise_dst)   ack_dst <= 1'b1; // acknowledge as soon as request arrives
        else if (!req_dst_sync2) ack_dst <= 1'b0; // drop ack after source drops request

   always_ff @(posedge src_clk or negedge src_rstn)
     if (!src_rstn) {ack_src_sync2, ack_src_sync1} <= 2'b00;
     else           {ack_src_sync2, ack_src_sync1} <= {ack_src_sync1, ack_dst};

   always_ff @(posedge src_clk or negedge src_rstn)
        if (!src_rstn)                     req_src <= 1'b0;
        else if (!req_src && pulse_in)     req_src <= 1'b1; // latch new request
        else if (req_src && ack_src_sync2) req_src <= 1'b0; // clear once dst has acknowledged

    assign busy_src = req_src | ack_src_sync2;

endmodule // toggle_sync_pulse_cdc
