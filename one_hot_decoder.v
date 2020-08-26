module one_hot_decoder(in,stall,out);

input [2:0] in;
output [7:0] out;
input stall;

reg [7:0] out;

always @(*)
begin
if (stall==1'b0)
    out<=8'b00000000;
else
     if(in == 3'b000)
           out <= 8'b00000001;
	  else if(in == 3'b001)
            out <= 8'b00000010;
			 else if(in == 3'b010)
              out <= 8'b00000100;
					 else if(in == 3'b011)
						out <= 8'b00001000;
							else if(in == 3'b100)
								out <= 8'b00010000;
									else if(in == 3'b101)
										out <= 8'b00100000;
											else if(in == 3'b110)
												out <= 8'b01000000;
												else 
													out <= 8'b10000000;
end	
endmodule