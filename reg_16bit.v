module reg_16bit(in,rst,en,clk,out);

output [15:0] out;
input en,clk,rst;
input [15:0] in;


 D_Flip_Flop D0 (rst,en,in[0],clk,out[0]);
 D_Flip_Flop D1(rst,en,in[1],clk,out[1]);
 D_Flip_Flop D2(rst,en,in[2],clk,out[2]);
 D_Flip_Flop D3 (rst,en,in[3],clk,out[3]);
 D_Flip_Flop D4(rst,en,in[4],clk,out[4]);
 D_Flip_Flop D5(rst,en,in[5],clk,out[5]);
 D_Flip_Flop D6(rst,en,in[6],clk,out[6]);
 D_Flip_Flop D7(rst,en,in[7],clk,out[7]);
 D_Flip_Flop D8(rst,en,in[8],clk,out[8]);
 D_Flip_Flop D9(rst,en,in[9],clk,out[9]);
 D_Flip_Flop D10(rst,en,in[10],clk,out[10]);
 D_Flip_Flop D11(rst,en,in[11],clk,out[11]);
 D_Flip_Flop D12(rst,en,in[12],clk,out[12]);
 D_Flip_Flop D13(rst,en,in[13],clk,out[13]);
 D_Flip_Flop D14(rst,en,in[14],clk,out[14]);
 D_Flip_Flop D15(rst,en,in[15],clk,out[15]);

endmodule