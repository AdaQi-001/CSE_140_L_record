module tbu
(
   input       clk,
   input       rst,
   input       enable,
   input       selection,
   input [7:0] d_in_0,
   input [7:0] d_in_1,
   output logic  d_o,
   output logic  wr_en);

   logic         d_o_reg;
   logic         wr_en_reg;
   
   logic   [2:0] pstate;
   logic   [2:0] nstate;

   logic         selection_buf;

   always @(posedge clk)    begin
      selection_buf  <= selection;
      wr_en          <= wr_en_reg;
      d_o            <= d_o_reg;
   end
   always @(posedge clk, negedge rst) begin
      if(!rst)
         pstate   <= 3'b000;
      else if(!enable)
         pstate   <= 3'b000;
      else if(selection_buf && !selection)
         pstate   <= 3'b000;
      else
         pstate   <= nstate;
   end

/*  combinational logic drives:
wr_en_reg, d_o_reg, nstate (next state)
from selection, d_in_1[pstate], d_in_0[pstate]
See assignment text for details
*/
   assign wr_en_reg = selection;

   always_comb begin
      if (selection)
         d_o_reg = d_in_1[pstate];
      else
         d_o_reg = 0;
   end


   always_comb begin
      case (pstate)
         3'b000:
            if(!selection) begin
               if(!d_in_0[pstate])
                  nstate = 3'b000;
               else
                  nstate = 3'b001;
            end
            else begin
               if(!d_in_1[pstate])
                  nstate = 3'b000;
               else
                  nstate = 3'b001;
            end

         3'b001:
            if(!selection) begin
               if(!d_in_0[pstate])
                  nstate = 3'b011;
               else
                  nstate = 3'b010;
            end
            else begin
               if(!d_in_1[pstate])
                  nstate = 3'b011;
               else
                  nstate = 3'b010;
            end

         3'b010:
            if(!selection) begin
               if(!d_in_0[pstate])
                  nstate = 3'b100;
               else
                  nstate = 3'b101;
            end
            else begin
               if(!d_in_1[pstate])
                  nstate = 3'b100;
               else
                  nstate = 3'b101;
            end

         3'b011:
            if(!selection) begin
               if(!d_in_0[pstate])
                  nstate = 3'b111;
               else
                  nstate = 3'b110;
            end
            else begin
               if(!d_in_1[pstate])
                  nstate = 3'b111;
               else
                  nstate = 3'b110;
            end

         3'b100:
            if(!selection) begin
               if(!d_in_0[pstate])
                  nstate = 3'b001;
               else
                  nstate = 3'b000;
            end
            else begin
               if(!d_in_1[pstate])
                  nstate = 3'b001;
               else
                  nstate = 3'b000;
            end

         3'b101:
            if(!selection) begin
               if(!d_in_0[pstate])
                  nstate = 3'b010;
               else
                  nstate = 3'b011;
            end
            else begin
               if(!d_in_1[pstate])
                  nstate = 3'b010;
               else
                  nstate = 3'b011;
            end

         3'b110:
            if(!selection) begin
               if(!d_in_0[pstate])
                  nstate = 3'b101;
               else
                  nstate = 3'b100;
            end
            else begin
               if(!d_in_1[pstate])
                  nstate = 3'b101;
               else
                  nstate = 3'b100;
            end

         3'b111:
            if(!selection) begin
               if(!d_in_0[pstate])
                  nstate = 3'b110;
               else
                  nstate = 3'b111;
            end
            else begin
               if(!d_in_1[pstate])
                  nstate = 3'b110;
               else
                  nstate = 3'b111;
            end
      endcase
   end
endmodule
