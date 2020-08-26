module Mux2x1_8bit(sel,d0,d1,q);

input  [7:0]d0,d1;
input sel;
output  [7:0]q;

wire sel;
wire  [7:0]d0,d1;

assign q = (sel==1'b1)? d1:d0;
endmodule