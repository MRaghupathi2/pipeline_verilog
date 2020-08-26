module Mux2x1(sel,d0,d1,q);

input [15:0] d0,d1;
input sel;
output [15:0] q;

wire sel;
wire [15:0] d0,d1;

assign q = (sel==1'b1)? d1:d0;
endmodule