module pulse_stretcher_shiftreg #(
			  parameter STRETCH_CYCLES=4
			  )
   (output pulse_out,
    input pulse_in,
    input clk,
    input rstn
    );

   reg [STRETCH_CYCLES-1:0] sh_reg;

   assign pulse_out = |sh_reg;

   always_ff @(posedge clk or negedge rstn)
     if (!rstn) sh_reg <= {STRETCH_CYCLES{1'b0}};
     else       sh_reg <= {sh_reg[STRETCH_CYCLES-2:0],pulse_in};

endmodule // pulse_stretcher_shiftreg
