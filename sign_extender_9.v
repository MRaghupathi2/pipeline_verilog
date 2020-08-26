module sign_extender_9(in,out);

input [8:0] in;
output [15:0] out;

wire [8:0] in;
wire [15:0] out;

assign  out = {in[8],in[8],in[8],in[8],in[8],in[8],in[8],in[8:0]};

endmodule