module combo_loop_good
  (output y_o,
   input rstn,
   input clk,
   input a_i
   );

   reg c_r;

   // Breaking the combinational loop with an inverter and OR gate.
   assign y_o = a_i | c_r;

   always_ff @(posedge clk or negedge rstn) begin
      if (!rstn) c_r <= 1'b0;
      else       c_r <= ~y_o;
   end

endmodule
