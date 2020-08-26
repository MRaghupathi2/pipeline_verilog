module reg_6bit(in,rst,en,clk,out);

output [5:0] out;
input en,clk,rst;
input [5:0] in;


 D_Flip_Flop D0 (rst,en,in[0],clk,out[0]);
 D_Flip_Flop D1(rst,en,in[1],clk,out[1]);
 D_Flip_Flop D2(rst,en,in[2],clk,out[2]);
 D_Flip_Flop D3 (rst,en,in[3],clk,out[3]);
 D_Flip_Flop D4(rst,en,in[4],clk,out[4]);
 D_Flip_Flop D5(rst,en,in[5],clk,out[5]);
 

endmodule