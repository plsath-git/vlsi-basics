module procedural_ordering_good
  (input a_i,
   output reg y_o
   );

   reg 	 c_r;

   // Simulation issue fixed
   // Not synthesis issue. It will reduce to y_o = a_i;
   always_comb begin
      c_r = 1'b1;
      y_o = a_i;
   end

endmodule
