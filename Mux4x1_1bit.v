module mux4x1_1bit(sel,d0,d1,d2,d3,q);

input  d0,d1,d2,d3;
input [1:0] sel;
output reg  q;

wire [1:0] sel;
wire d0,d1,d2,d3;

always @(sel,d0,d1,d2,d3)
begin
   if( sel == 2'b00)
      q = d0;
    else if( sel == 2'b01)
         q = d1;
    else if( sel == 2'b10)
      q = d2;
    else
      q = d3;
end

endmodule