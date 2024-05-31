// test bench
module viterbi_tx_rx_tb();
   bit clk;
   bit rst;
   bit encoder_i;		   // original data
   bit enc_i_hist[2048];   // history thereof
   bit enable_encoder_i;
   wire decoder_o;		   // decoded data, should match original
   bit dec_o_hist[2048];   // history thereof
   bit disp;			   // end of test flag
   int good, bad; 		   // scoreboard

// this module contains conv. encode, channel, and Vit decode
   viterbi_tx_rx vtr(
      .clk,
      .rst,
      .encoder_i,		    // original data
      .enable_encoder_i,
      .decoder_o    );		// decoded data

   always begin
      #50  clk   = 'b1;
      #50  clk   = 'b0;
   end
   int i, j, k, l;

   always @(posedge clk) begin
	 enc_i_hist[i] <= encoder_i;
	 i <= i+1;				// counters for data in and out
	 l <= l+1;
   end

   initial begin   
	 #410500;//#410400;
	 forever @(posedge clk) begin
	   dec_o_hist[k] <= decoder_o;
	   k<=k+1;
     end
   end

   initial begin
      #1000      rst       =  1'b1;
                 enable_encoder_i  =  1'b1;
      repeat(2) begin
      #100       encoder_i=  1'b1; 
      #100       encoder_i=  1'b0;   
      #200       encoder_i=  1'b1;  
      #200       encoder_i=  1'b0;  
      #300       encoder_i=  1'b1;  
      #300       encoder_i=  1'b0;  
      #400       encoder_i=  1'b1;  
      #400       encoder_i=  1'b0;  
      #500		 encoder_i=  1'b1;  
      #500       encoder_i=  1'b0;
      #100       encoder_i=  1'b1; 
      #100       encoder_i=  1'b0;   
      #100       encoder_i=  1'b1; 
      #100       encoder_i=  1'b0;   
      #100       encoder_i=  1'b1; 
      #100       encoder_i=  1'b0;   
      #100       encoder_i=  1'b1; 
      #100       encoder_i=  1'b0;   
      end
      #1000  	 encoder_i=  1'b1;
      #1000		 encoder_i=  1'b0;
	  repeat(20)
      #100		 encoder_i=  $random>>3;
      #100   	 encoder_i=  1'b0;
      #1000      encoder_i=  1'b1;
      #1000  	 encoder_i=  1'b0;
      #100		 encoder_i=  1'b1;
      #10000     encoder_i=  1'b0;
      #100	     encoder_i=  1'b1;
      #10000     encoder_i=  1'b0;
      #100	     encoder_i=  1'b1;
      #10000	 encoder_i=  1'b0;
      #1000000  $display("word_count = %d",vtr.word_ct);                    	    
      for(j=0; j<256; j=j+1) 		// checker & scoreboard
        if(enc_i_hist[j]==dec_o_hist[j]) begin 
          $displayb("yaa! in = %b, out = %b, w_ct = %d, err = %b",enc_i_hist[j],dec_o_hist[j],j,vtr.err_inj);
          good++;
		end
		else begin
          $displayb("boo! in = %b, out = %b, w_ct = %d, err = %b, %t, BAD!",enc_i_hist[j],dec_o_hist[j],j,vtr.err_inj,$time);
          bad++;
		end
	  $display("good = %d, bad = %d,   %d bad_bits",good,bad,vtr.bad_bit_ct);
	  disp = 1;
      $stop;
   end

endmodule
