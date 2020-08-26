module fetch_stage(rst,clk,en_pc_in,pc_select_ex,r7_detect_wb_in,R7_data_in,PC_plus_IMM_ex_data_in,JLR_ex_data_in,BEQ_ex_data_in,inst_word_out,pc_out,pc_plus_1_out);

output [15:0] inst_word_out,pc_out,pc_plus_1_out;
input en_pc_in,r7_detect_wb_in,clk,rst;
input [15:0]  R7_data_in,PC_plus_IMM_ex_data_in,JLR_ex_data_in,BEQ_ex_data_in;
input [1:0] pc_select_ex;

wire [15:0] A,B,C,D;

inst_memory IM(en_pc_in,A,inst_word_out);
assign pc_out = A;
pcadder pc_add(A,B);
assign pc_plus_1_out = B;
reg_16bit R1(D,rst,en_pc_in,clk,A);
mux4x1 Mux1(pc_select_ex,B,PC_plus_IMM_ex_data_in,JLR_ex_data_in,BEQ_ex_data_in,C);
Mux2x1 Mux2(r7_detect_wb_in,C,R7_data_in,D);

endmodule