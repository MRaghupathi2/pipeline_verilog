module sign_extender_6(in,out);

input [5:0] in;
output [15:0] out;

wire [5:0] in;
wire [15:0] out;

assign  out = {in[5],in[5],in[5],in[5],in[5],in[5],in[5],in[5],in[5],in[5],in[5:0]};

endmodule