module procedural_ordering_good
  (output reg y_o
   input a_i,
   );

   reg 	 c_r;
   reg 	 tmp;

   // Simulation issue fixed
   // Not synthesis issue. It will reduce to y_o = a_i;
   always_comb begin
      tmp = a_i & c_r;
      c_r = tmp | 1'b1;
      y_o = tmp;
   end

endmodule
