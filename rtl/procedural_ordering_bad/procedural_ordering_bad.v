module procedural_ordering_bad
  (output reg y_o
   input a_i
   );

   reg 	 c_r;

   // Simulation issue
   // Not synthesis issue. It will reduce to y_o = a_i;
   always_comb begin
      y_o = a_i & c_r;
      c_r = y_o | 1'b1;
   end

endmodule
