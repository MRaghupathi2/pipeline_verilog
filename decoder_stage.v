module decode_stage(clk,inst_word,inst_word_rr,opcode_rr,opcode_ex,opcode_mem,opcode_wb,RD_rr,RD_ex,RD_rr_VALID,RD_ex_VALID,R7_detect_RR,R7_detect_EX,R7_detect_MEM,R7_detect_WB,opcode_dec,control_g1_16bit,control_g2_16bit,control_f1_8bit,LW_stall_or_branch_or_R7_stall,LW_stall,LM_SM_stall);

input clk;
input [15:0]inst_word,inst_word_rr;
input [5:0]opcode_rr,opcode_ex,opcode_mem,opcode_wb;
input [2:0]RD_rr,RD_ex;
input RD_rr_VALID,RD_ex_VALID,R7_detect_RR,R7_detect_EX,R7_detect_MEM,R7_detect_WB;

output [5:0]opcode_dec;
output [15:0]control_g1_16bit,control_g2_16bit;
output [7:0] control_f1_8bit;//control_f2_16bit;

output LW_stall_or_branch_or_R7_stall,LW_stall,LM_SM_stall;

wire nop,extra_signal,branch_stall,nop_or_branch_opcode_select;
wire [5:0]opcode_dec_i,opcode_dec_ii;


wire [7:0]control_signal_forward_1;//control_signal_forward_2;
wire [15:0]control_signal_general_1,control_signal_general_2,control_signal_general_1_LM_SM,control_signal_general_2_LM_SM;
wire [15:0]control_signal_general_2_LM,control_signal_general_2_SM;
wire [15:0]control_g1_a_16bit,control_g2_a_16bit;
wire LM_SM_stall,SM,priority_stall_out;
wire [5:0] opcode;
wire g_LM_SM_SIGNAL,g_SE6_SE9_SELECT,g_ALU_OPERATION_SELECT,g_X1_MODIFY_CARRY,g_X2_MODIFY_ZERO,g_X3_CIN_SELECT,g_PC_DATA_MEM_READ,g_PC_DATA_MEM_WRITE,g_reg_write,g_PC_DATA_MEM_WRITE_U;
wire R7_DEST_DETECT,RS1_VALID,RS2_VALID,RD_VALID,f_E_MEM_STAGE_VALID,f_F_WB_STAGE_VALID,hazard_detect;
wire [1:0] g_RF_A2_SELECT,g_RF_A3_SELECT;
wire [2:0] RS1,RS2,RD,priority_out; 
wire [1:0] g_X4_X5_CARRY_OR_ZERO_SELECT,g_PC_SELECT_NEEDED_FOR_MEM_STAGE,g_PC_WRITE_BACK_MUX;
wire [1:0] f_E_MEM_STAGE,f_F_WB_STAGE,forward_D2_select,forward_ALU_OP1_select,forward_ALU_OP2_select;
wire g_RF_A1_SELECT;
wire for_MUX_ALU_OP1_SELECT_VALID,for_MUX_ALU_OP2_SELECT_VALID,for_MUX_D2_MUX_SELECT_VALID,branch_or_R7_stall;
wire [1:0] f_MUX_ALU_OP1_SELECT,for_MUX_ALU_OP1_SELECT,f_MUX_ALU_OP2_SELECT,for_MUX_ALU_OP2_SELECT,f_MUX_D2_MUX_SELECT,for_MUX_D2_MUX_SELECT;

Decoder id1(inst_word,opcode,g_LM_SM_SIGNAL,g_SE6_SE9_SELECT,g_ALU_OPERATION_SELECT,g_X1_MODIFY_CARRY,g_X2_MODIFY_ZERO,g_X4_X5_CARRY_OR_ZERO_SELECT,g_PC_SELECT_NEEDED_FOR_MEM_STAGE,g_PC_DATA_MEM_READ,g_PC_DATA_MEM_WRITE,g_PC_WRITE_BACK_MUX,g_reg_write,f_MUX_ALU_OP1_SELECT,f_MUX_ALU_OP2_SELECT,f_MUX_D2_MUX_SELECT,R7_DEST_DETECT,RS1_VALID,RS2_VALID,RD_VALID,RS1,RS2,RD); 
Forwarding_logic f1(opcode,opcode_rr,opcode_ex,control_g2_a_16bit[8:6],control_g2_a_16bit[5:3],RD_rr,RD_ex,RS1_VALID,RS2_VALID,RD_rr_VALID,RD_ex_VALID,for_MUX_ALU_OP1_SELECT,for_MUX_ALU_OP2_SELECT,for_MUX_D2_MUX_SELECT,f_E_MEM_STAGE,f_F_WB_STAGE,for_MUX_ALU_OP1_SELECT_VALID,for_MUX_ALU_OP2_SELECT_VALID,for_MUX_D2_MUX_SELECT_VALID,f_E_MEM_STAGE_VALID,f_F_WB_STAGE_VALID,hazard_detect,LW_stall);
branch_stall_unit b1(opcode_rr,opcode_ex,opcode_mem,opcode_wb,R7_detect_RR,R7_detect_EX,R7_detect_MEM,R7_detect_WB,branch_or_R7_stall,branch_stall,extra_signal);
LM_SM_REGISTER_GENERATE_logic l1(1'b0,clk,g_LM_SM_SIGNAL,inst_word,opcode,inst_word_rr,priority_out,priority_stall_out);


Mux2x1_2bit m2(for_MUX_ALU_OP1_SELECT_VALID,f_MUX_ALU_OP1_SELECT,for_MUX_ALU_OP1_SELECT,forward_ALU_OP1_select);
Mux2x1_2bit m3(for_MUX_ALU_OP2_SELECT_VALID,f_MUX_ALU_OP2_SELECT,for_MUX_ALU_OP2_SELECT,forward_ALU_OP2_select);
Mux2x1_2bit m4(for_MUX_D2_MUX_SELECT_VALID,f_MUX_D2_MUX_SELECT,for_MUX_D2_MUX_SELECT,forward_D2_select);

assign nop=~(inst_word[15] || inst_word [14] || inst_word[13] || inst_word[12] ||inst_word[11] || inst_word [10] || inst_word[9] || inst_word[8]||inst_word[7] || inst_word [6] || inst_word[5] || inst_word[4] ||inst_word[3] || inst_word [2] || inst_word[1] || inst_word[0]);

assign LW_stall_or_branch_or_R7_stall=(branch_or_R7_stall || LW_stall || nop);
assign nop_or_branch_opcode_select=(nop || branch_stall);
assign LM_SM_stall=(g_LM_SM_SIGNAL && priority_stall_out);


//assign control_signal_forward_1={forward_ALU_OP1_select[1:0],forward_ALU_OP2_select[1:0],forward_D2_select[1:0]};
//assign control_signal_forward_2={f_E_MEM_STAGE[1:0],f_F_WB_STAGE[1:0],f_E_MEM_STAGE_VALID,f_F_WB_STAGE_VALID};
//assign control_signal_general_1={g_LM_SM_SIGNAL,g_RF_A3_SELECT[1:0],g_SE6_SE9_SELECT,g_ALU_OPERATION_SELECT,g_X1_MODIFY_CARRY,g_X2_MODIFY_ZERO,g_X3_CIN_SELECT,g_X4_X5_CARRY_OR_ZERO_SELECT[1:0],g_PC_SELECT_NEEDED_FOR_MEM_STAGE[1:0],g_PC_DATA_MEM_READ,g_PC_DATA_MEM_WRITE,g_PC_WRITE_BACK_MUX[1:0]};
//assign control_signal_general_2={1'b1,g_reg_write,R7_DEST_DETECT,hazard_detect,RS1_VALID,RS2_VALID,RD_VALID,RS1[2:0],RS2[2:0],RD[2:0]};


assign control_signal_forward_1={f_E_MEM_STAGE[1:0],forward_ALU_OP1_select[1:0],forward_ALU_OP2_select[1:0],forward_D2_select[1:0]};
assign control_signal_general_1={g_LM_SM_SIGNAL,2'b00,g_SE6_SE9_SELECT,g_ALU_OPERATION_SELECT,g_X1_MODIFY_CARRY,g_X2_MODIFY_ZERO,1'b0,g_X4_X5_CARRY_OR_ZERO_SELECT[1:0],g_PC_SELECT_NEEDED_FOR_MEM_STAGE[1:0],g_PC_DATA_MEM_READ,g_PC_DATA_MEM_WRITE,g_PC_WRITE_BACK_MUX[1:0]};
assign control_signal_general_2={1'b1,g_reg_write,R7_DEST_DETECT,hazard_detect,RS1_VALID,RS2_VALID,RD_VALID,RS1[2:0],RS2[2:0],RD[2:0]};


wire R7_DETECT_LM,SM_plus_stall,LW_LM_SM_branch_stall;
assign SM=g_LM_SM_SIGNAL && inst_word[12];
assign R7_DETECT_LM=priority_out[2]&&priority_out[1]&&priority_out[0];
assign SM_plus_stall=SM && LM_SM_stall;

assign LW_LM_SM_branch_stall=LW_stall_or_branch_or_R7_stall || LM_SM_stall;

Mux2x1_1bit m13(SM_plus_stall,g_PC_DATA_MEM_WRITE,1'b1,g_PC_DATA_MEM_WRITE_U);//USED FOR DATA MEM WRITE=1 FOR SM AND 0 FOR LM

assign control_signal_general_1_LM_SM={g_LM_SM_SIGNAL,LM_SM_stall,1'b0,g_SE6_SE9_SELECT,g_ALU_OPERATION_SELECT,g_X1_MODIFY_CARRY,g_X2_MODIFY_ZERO,1'b0,g_X4_X5_CARRY_OR_ZERO_SELECT[1:0],g_PC_SELECT_NEEDED_FOR_MEM_STAGE[1:0],g_PC_DATA_MEM_READ,g_PC_DATA_MEM_WRITE_U,g_PC_WRITE_BACK_MUX[1:0]};
assign control_signal_general_2_LM={1'b1,1'b1,R7_DETECT_LM,hazard_detect,RS1_VALID,RS2_VALID,RD_VALID,RS1[2:0],RS2[2:0],priority_out};
assign control_signal_general_2_SM={1'b1,1'b0,R7_DEST_DETECT,hazard_detect,RS1_VALID,RS2_VALID,RD_VALID,RS1[2:0],priority_out,RD[2:0]};

Mux2x1 m12(SM,control_signal_general_2_LM,control_signal_general_2_SM,control_signal_general_2_LM_SM);


Mux2x1_6bit m1(LW_stall_or_branch_or_R7_stall,opcode,6'b111111,opcode_dec_i);//LW or R7 detect
Mux2x1_6bit m11(nop_or_branch_opcode_select,opcode_dec_i,6'b111011,opcode_dec_ii); ///NOP or branch
Mux2x1_6bit m15(extra_signal,opcode_dec_ii,6'b110111,opcode_dec);   // R7 stall removal when extra signal becomes 1
Mux2x1 m5(LW_stall_or_branch_or_R7_stall,control_g1_a_16bit,16'd0,control_g1_16bit);
Mux2x1 m6(LW_stall_or_branch_or_R7_stall,control_g2_a_16bit,16'd0,control_g2_16bit);
Mux2x1 m7(LM_SM_stall,control_signal_general_1,control_signal_general_1_LM_SM,control_g1_a_16bit);
Mux2x1 m8(LM_SM_stall,control_signal_general_2,control_signal_general_2_LM_SM,control_g2_a_16bit);


Mux2x1_8bit m9(LW_stall_or_branch_or_R7_stall,control_signal_forward_1,8'd0,control_f1_8bit);
//Mux2x1_6bit m10(LW_stall_or_branch_or_R7_stall,control_signal_forward_2,6'd0,control_f2_16bit);

endmodule