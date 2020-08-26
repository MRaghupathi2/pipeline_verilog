module Mux2x1_6bit(sel,d0,d1,q);

input  [5:0]d0,d1;
input sel;
output [5:0] q;

wire sel;
wire  [5:0]d0,d1;

assign q = (sel==1'b1)? d1:d0;
endmodule