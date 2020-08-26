module zero_padd_9(in,out);

input [8:0] in;
output [15:0] out;

assign  out = {in[8:0],7'd0};

endmodule