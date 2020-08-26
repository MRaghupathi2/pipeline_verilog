module D_Flip_Flop(rst,en,data,clk,q);
output reg q;
input en,data,clk,rst;
 
always@(posedge clk or posedge rst)
	begin 
		if(rst == 1'b1)
	      	q <= 1'b0;
		else
		    if(en == 1'b0)
			       q <= q;
			   else
			    	 q <= data; 
		 			 
end
endmodule