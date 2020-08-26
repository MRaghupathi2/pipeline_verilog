module alu_16(en,op_sel,in1,in2,out,zero_flag,cout);

//input cin;
input en,op_sel;//cin;
input [15:0] in1,in2;

output reg zero_flag,cout;
output [16:0] out;

reg [16:0] out1;

always@(*)
begin
if(en == 1'b0)
     begin       out1 <= 17'd0;
				     cout <= out[16];
	  end
else
    if(op_sel == 1'b0)
	    begin  
		        out1 <= in1 + in2 ;//+ {15'd0,cin};
				  cout <= out[16];			    		 end
	  else
	    begin
		        out1 <= ~(in1 & in2);
				  cout <= 1'b0;
	    end
		 
			
			
if((out1[15:0] == 16'd0 & en == 1'b1)||(in1==in2  && en==1'b1))
        zero_flag <= 1'b1;
else
        zero_flag <= 1'b0;
 end
 
 assign out = out1;
 
 
endmodule