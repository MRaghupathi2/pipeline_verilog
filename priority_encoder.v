module priority_encoder(en,in,out,stall);

input [7:0] in;
input en;
output [2:0] out;
output stall;

reg [2:0] out;
reg stall;

always@(*)
begin
   if(en == 1'b0)
      begin out <= 3'b000;
		stall <= 1'b0; end
	else
     if(in[0] == 1'b1)
        begin	out <= 3'b000;
			 stall <= 1'b1; end
	  else if(in[1] == 1'b1)
            begin  out <= 3'b001;
				 stall <= 1'b1; end
			 else if(in[2] == 1'b1)
              begin  out <= 3'b010;
					 stall <= 1'b1; end
					 else if(in[3] == 1'b1)
						begin		out <= 3'b011;
								stall <= 1'b1; end
							else if(in[4] == 1'b1)
								begin	out <= 3'b100;
									stall <= 1'b1; end
									else if(in[5] == 1'b1)
										begin 	out <= 3'b101;
											stall <= 1'b1;  end
											else if(in[6] == 1'b1)
												begin	out <= 3'b110;
													stall <= 1'b1;  end
												else if(in[7] == 1'b1)
													begin	out <= 3'b111;
														stall <= 1'b1; end
													else
                                            begin out<=3'b000;
														  stall <= 1'b0; end

end	

endmodule