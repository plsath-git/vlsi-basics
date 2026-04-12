module pulse_stretcher_cdc_handshake #(
    parameter int STRETCH_CYCLES = 4
) (
    input  logic src_clk,
    input  logic src_rstn,
    input  logic dst_clk,
    input  logic dst_rstn,
    input  logic pulse_in,
    output logic busy_src,
    output logic pulse_out
);

    localparam int CNTR_WIDTH = (STRETCH_CYCLES > 1) ? $clog2(STRETCH_CYCLES + 1) : 1;

    reg [CNTR_WIDTH-1:0] cntr;
    reg req_src;
    reg ack_src_sync1;
    reg ack_src_sync2;
    reg req_dst_sync1;
    reg req_dst_sync2;
    reg req_dst_sync2_d;
    reg ack_dst;

    wire req_rise_dst;

    //--------------------------------------------------------------------------
    // Destination domain: synchronize request
    //--------------------------------------------------------------------------
    always_ff @(posedge dst_clk or negedge dst_rstn)
        if (!dst_rstn) {req_dst_sync2_d, req_dst_sync2, req_dst_sync1} <= 3'b000;
        else           {req_dst_sync2_d, req_dst_sync2, req_dst_sync1} <= {req_dst_sync2, req_dst_sync1, req_src};

    // New request seen in dst domain
    assign req_rise_dst = req_dst_sync2 & ~req_dst_sync2_d;

    //--------------------------------------------------------------------------
    // Destination domain: acknowledge generation
    //--------------------------------------------------------------------------
    always_ff @(posedge dst_clk or negedge dst_rstn)
        if (!dst_rstn)           ack_dst <= 1'b0;
        else if (req_rise_dst)   ack_dst <= 1'b1; // acknowledge as soon as request arrives
        else if (!req_dst_sync2) ack_dst <= 1'b0; // drop ack after source drops request

    //--------------------------------------------------------------------------
    // Source domain: request generation
    // Holds req until ack comes back from dst
    //--------------------------------------------------------------------------
    always_ff @(posedge src_clk or negedge src_rstn)
        if (!src_rstn) {ack_src_sync2, ack_src_sync1} <= 2'b00;
        else           {ack_src_sync2, ack_src_sync1} <= {ack_src_sync1, ack_dst};

    always_ff @(posedge src_clk or negedge src_rstn)
        if (!src_rstn)                     req_src <= 1'b0;
        else if (!req_src && pulse_in)     req_src <= 1'b1; // latch new request
        else if (req_src && ack_src_sync2) req_src <= 1'b0; // clear once dst has acknowledged

    assign busy_src = req_src | ack_src_sync2;

    //--------------------------------------------------------------------------
    // Destination domain: pulse stretching
    //--------------------------------------------------------------------------
    always_ff @(posedge dst_clk or negedge dst_rstn)
        if (!dst_rstn)         cntr <= '0;
        else if (req_rise_dst) cntr <= STRETCH_CYCLES[CNTR_WIDTH-1:0];
        else if (|cntr)        cntr <= cntr - 1'b1;

    assign pulse_out = |cntr;

endmodule
