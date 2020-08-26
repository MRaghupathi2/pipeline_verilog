module counter(rst,en,clk,out);

input clk,en,rst;

output [15:0] out;
reg [15:0] out1;

always@(posedge clk)
begin
if(rst == 1'b1)
      out1 <= 16'd0;
else
   if(en == 1'b1)
	    out1 <= out1 +  16'd1;
	else
	     out1 <= out1;
end

 assign out = out1;
endmodule