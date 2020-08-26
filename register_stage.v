module register_stage(inst_word_out_in,PC_in,rf_a3,rf_a2,rf_a1,d_in3_wb,d_R7_in,
                      SE6_9_select,R7_write_in,reg_write_in,ZERO_PADD,PC_out,PC_plus_IMM,d_out1,d_out2,SE6_or_9,R0,R1,R2,R3,R4,R5,R6,R7);

output [15:0] ZERO_PADD,PC_out,PC_plus_IMM,d_out1,d_out2;
input R7_write_in,reg_write_in,SE6_9_select;
input [15:0]  PC_in,inst_word_out_in,d_in3_wb,d_R7_in;
input [2:0] rf_a3,rf_a2,rf_a1;

//wire [2:0] rf_a2,rf_a1;
wire [15:0] SE6,SE9;
output [15:0]SE6_or_9;
output [15:0]R0,R1,R2,R3,R4,R5,R6,R7;

//mux4x1 Mux1(rf_a2_select,inst_word_out_in[8:6],inst_word_out_in[11:9],priority_out_in,3'b0,rf_a2);
//Mux2x1 Mux2(rf_a1_select,inst_word_out_in[11:9],inst_word_out_in[8:6],rf_a1);
sign_extender_6 SE_6(inst_word_out_in[5:0],SE6);
sign_extender_9 SE_9(inst_word_out_in[8:0],SE9);
zero_padd_9 zero_padd(inst_word_out_in[8:0],ZERO_PADD);
Mux2x1 Mux3(SE6_9_select,SE6,SE9,SE6_or_9);
pc_plus_imm adder1(PC_in,SE6_or_9,PC_plus_IMM);
reg_file RF(rf_a1,rf_a2,rf_a3,reg_write_in,R7_write_in,d_out1,d_out2,d_in3_wb,d_R7_in,R0,R1,R2,R3,R4,R5,R6,R7);
assign PC_out = PC_in ;

endmodule