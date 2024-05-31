module ACS		                        // add-compare-select
(
   input       path_0_valid,
   input       path_1_valid,
   input [1:0] path_0_bmc,	            // branch metric computation
   input [1:0] path_1_bmc,				
   input [7:0] path_0_pmc,				// path metric computation
   input [7:0] path_1_pmc,

   output logic        selection,
   output logic        valid_o,
   output      [7:0] path_cost);  

   wire  [7:0] path_cost_0;			   // branch metric + path metric
   wire  [7:0] path_cost_1;

/* Fill in the guts per ACS instructions
*/
   logic[7:0] total_cost;
   assign path_cost_0 = path_0_pmc + path_0_bmc;
   assign path_cost_1 = path_1_pmc + path_1_bmc;

   always_comb begin
      // valid_o = 0 if neither path valid only
      if (!path_0_valid && !path_1_valid) begin
         valid_o = 0;
         selection = 0;
         total_cost = 8'b00000000;
      end
      else if (!path_0_valid && path_1_valid) begin
         valid_o = 1;
         selection = 1;
         total_cost = path_cost_1;
      end
      else if (path_0_valid && !path_1_valid) begin
         valid_o = 1;
         selection = 0;
         total_cost = path_cost_0;
      end
      else begin
         if (path_cost_0 > path_cost_1) begin
            valid_o = 1;
            selection = 1;
            total_cost = path_cost_1;
         end
         else begin
            valid_o = 1;
            selection = 0;
            total_cost = path_cost_0;
         end
      end
   end
   assign path_cost = total_cost;

endmodule
