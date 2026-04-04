module combo_loop_bad
  (output y_o,
   input a_i
   );

   wire  c_w;

   // Combinational loop with an inverter and OR gate.
   assign c_w = ~y_o;
   assign y_o = a_i | c_w;

endmodule
