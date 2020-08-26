module execute_stage(clk,g_LM_SM_SIGNAL,LM_stall,opcode_ex,Data_1_ex_in,Data_2_ex_in,SE6_9_ex,Data_from_mem,Data_from_wb,PC_plus_1,PC_plus_Imm,cout_prev,zout_prev,X1,X2,X4_X5,ALU_CTRL,reg_write_ex_in,forward_control_OP1,forward_control_OP2,forward_control_D2_MUX,Data_2_ex_updated,alu_out,PC_plus_Imm_updated,PC_plus_Imm_updated_BEQ,reg_write_ex_updated,cout_n,zout_n,pc_select_ex);

input [15:0]Data_1_ex_in,Data_2_ex_in,SE6_9_ex,Data_from_mem,Data_from_wb,PC_plus_1,PC_plus_Imm;
input [5:0] opcode_ex;
input g_LM_SM_SIGNAL,LM_stall;
input X1,X2,ALU_CTRL,reg_write_ex_in,cout_prev,zout_prev;
input [1:0] X4_X5,forward_control_OP1,forward_control_OP2,forward_control_D2_MUX;
input clk;
//input X3;
//wire cin;

output [15:0] Data_2_ex_updated,alu_out,PC_plus_Imm_updated_BEQ,PC_plus_Imm_updated;
output reg_write_ex_updated,cout_n,zout_n;
output [1:0] pc_select_ex;
wire en_alu,cout,zout,beq_select,JAL_select,zero_flag_select,reg_write_select;
wire [15:0] OP1,OP2,OP2_a,COUNTER_OP;
wire LM_SM_not;
assign LM_SM_not=(~(LM_stall));

assign en_alu= ~(opcode_ex[5] && opcode_ex[4] && opcode_ex[3] && opcode_ex[2]);
assign beq_select=(opcode_ex[5]&& opcode_ex[4] && (~opcode_ex[3]) && (~opcode_ex[2])); 
assign JAL_select=(opcode_ex[5] && (~opcode_ex[4]) && (~opcode_ex[3]) && (~opcode_ex[2]));

mux4x1 m1(forward_control_OP1,Data_1_ex_in,Data_from_mem,Data_from_wb,16'd0,OP1);
mux4x1 m2(forward_control_OP2,Data_2_ex_in,Data_from_mem,Data_from_wb,SE6_9_ex,OP2_a);
mux4x1 m3(forward_control_D2_MUX,Data_2_ex_in,Data_from_mem,Data_from_wb,16'd0,Data_2_ex_updated);

counter c1(LM_SM_not,g_LM_SM_SIGNAL,clk,COUNTER_OP);

Mux2x1 m12(g_LM_SM_SIGNAL,OP2_a,COUNTER_OP,OP2);


alu_16 a1(en_alu,ALU_CTRL,OP1,OP2,alu_out,zout,cout);

//D_Flip_Flop c1(rst,X1,cout,clk,cout_n);
//D_Flip_Flop z1(rst,X2,zout,clk,zout_n);

Mux2x1_1bit m4(X1,cout_prev,cout,cout_n);
Mux2x1_1bit m5(X2,zout_prev,zout,zout_n);
 
//Mux2x1_1bit m7(X3,1'b0,cout_prev,cin);

Mux2x1_1bit  m8(beq_select,1'b0,zout,zero_flag_select);
Mux2x1 m9(zero_flag_select,PC_plus_1,PC_plus_Imm,PC_plus_Imm_updated_BEQ);
Mux2x1 m19(JAL_select,PC_plus_Imm_updated_BEQ,PC_plus_Imm,PC_plus_Imm_updated);

mux4x1_1bit m10(X4_X5,1'b1,zout_prev,cout_prev,1'b0,reg_write_select);
Mux2x1_1bit m11(reg_write_select,1'b0,reg_write_ex_in,reg_write_ex_updated);

PC_SELECT_FROM_OPCODE P1(opcode_ex,pc_select_ex);

endmodule
