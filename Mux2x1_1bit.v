module Mux2x1_1bit(sel,d0,d1,q);

input  d0,d1;
input sel;
output  q;

wire sel;
wire  d0,d1;

assign q = (sel==1'b1)? d1:d0;
endmodule