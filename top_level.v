module top_level(rst,clk,en,R0,R1,R2,R3,R4,R5,R6,R7);


input rst,clk,en;
output [15:0]R0,R1,R2,R3,R4,R5,R6,R7;

wire [15:0] inst_word_fetch,inst_word_dec,inst_word_rr,inst_word_ex;
wire [15:0]g2_16bit_dec,g2_16bit_rr,g2_16bit_ex,g2_16bit_mem,g2_16bit_wb;
wire [15:0]g1_16bit_dec,g1_16bit_rr,g1_16bit_ex,g1_16bit_mem,g1_16bit_wb;
//wire [5:0]f2_6bit_dec,f2_6bit_rr,f2_6bit_ex,f2_6bit_mem,f2_6bit_wb;
wire [7:0]f1_8bit_dec,f1_8bit_rr,f1_8bit_ex,f1_8bit_mem;//f1_8bit_wb;
wire [5:0]opcode_dec,opcode_rr,opcode_ex,opcode_mem,opcode_wb;


//Fetch stage wires

wire [1:0]pc_select_ex;
wire [15:0]pc_fetch,pc_plus_1_fetch,d_R7_wb;
wire LW_stall_dec;

//Decode stage wires
wire [15:0]pc_dec,pc_plus_1_dec;
wire LW_stall_or_branch_or_R7_stall_dec,LM_SM_stall_dec;
wire LW_stall_dec_inv;
assign LW_stall_dec_inv=(~(LW_stall_dec ||LM_SM_stall_dec));

//RR stage wire

wire [2:0]rf_a3_wb;

wire [15:0]pc_rr,pc_plus_1_rr,d3_wb;
wire [15:0]zero_padd_rr,pc_rr_c,pc_plus_imm_rr,data_1_rr,data_2_rr,SE6_or_9_data_rr;
wire priority_out_rr,reg_write_updated_wb;

//EXECUTE STAGE


wire [15:0]pc_ex,pc_plus_1_ex,Data_from_mem_to_ex;
wire [15:0]zero_padd_ex,pc_plus_imm_ex,data_1_ex,data_2_ex,SE6_or_9_data_ex;
wire [15:0]data_2_updated_ex,alu_out_ex,pc_plus_imm_updated_ex,pc_plus_imm_updated_beq_ex;
wire reg_write_updated_ex,cout_ex,zout_ex;

//MEMORY STAGE

wire [15:0]pc_plus_1_mem;
wire [15:0]zero_padd_mem;
wire [15:0]data_2_mem,alu_out_mem,pc_plus_imm_updatedinex_mem;
wire reg_write_updated_mem,cout_mem,zout_mem;
wire [15:0]pc_updated_mem,pc_plus_1_updated_mem,alu_out_updated_mem,data_out_mem;
        
//WB STAGE

wire [15:0]pc_plus_1_wb;
wire [15:0]zero_padd_wb;
wire reg_write_wb;
wire [15:0]pc_wb,alu_out_wb,data_out_wb;

//FETCH STAGE


fetch_stage  A1(rst,clk,LW_stall_dec_inv,pc_select_ex,g2_16bit_wb[13],d_R7_wb,pc_plus_imm_ex,data_2_updated_ex,pc_plus_imm_updated_beq_ex,inst_word_fetch,pc_fetch,pc_plus_1_fetch);


//PIPELINE REGISTERS STAGE -FETCH/DECODE INTERFACE
reg_16bit  r1(inst_word_fetch,rst,(LW_stall_dec_inv),clk,inst_word_dec);
reg_16bit  r2(pc_fetch,rst,(LW_stall_dec_inv),clk,pc_dec);
reg_16bit  r3(pc_plus_1_fetch,rst,(LW_stall_dec_inv),clk,pc_plus_1_dec);

//DECODER STAGE

decode_stage A2(clk,inst_word_dec,inst_word_rr,opcode_rr,opcode_ex,opcode_mem,opcode_wb,g2_16bit_rr[2:0],g2_16bit_ex[2:0],g2_16bit_rr[9],g2_16bit_ex[9],g2_16bit_rr[13],g2_16bit_ex[13],g2_16bit_mem[13],g2_16bit_wb[13],opcode_dec,g1_16bit_dec,g2_16bit_dec,f1_8bit_dec,LW_stall_or_branch_or_R7_stall_dec,LW_stall_dec,LM_SM_stall_dec);

//PIPELINE REGISTERS STAGE- DECODE/RR INTERFACE

reg_16bit r4(pc_plus_1_dec,rst,en,clk,pc_plus_1_rr);
reg_16bit r5(pc_dec,rst,en,clk,pc_rr);
reg_16bit r6(inst_word_dec,rst,en,clk,inst_word_rr);
reg_16bit r7(g1_16bit_dec,rst,en,clk,g1_16bit_rr);
reg_16bit r8(g2_16bit_dec,rst,en,clk,g2_16bit_rr);
reg_8bit r9(f1_8bit_dec,rst,en,clk,f1_8bit_rr);
//reg_6bit r10(f2_6bit_dec,rst,en,clk,f2_6bit_rr);
reg_6bit r11(opcode_dec,rst,en,clk,opcode_rr);

//RR STAGE


register_stage A3(inst_word_rr,pc_rr,rf_a3_wb,g2_16bit_rr[5:3],g2_16bit_rr[8:6],d3_wb,d_R7_wb,
                      g1_16bit_rr[12],g2_16bit_wb[15],reg_write_updated_wb,zero_padd_rr,pc_rr_c,pc_plus_imm_rr,data_1_rr,data_2_rr,SE6_or_9_data_rr,R0,R1,R2,R3,R4,R5,R6,R7);

//PIPELINE REGISTERS STAGE- RR/EXECUTE INTERFACE							 
reg_16bit rr1(pc_plus_1_rr,rst,en,clk,pc_plus_1_ex);
reg_16bit rr2(pc_rr,rst,en,clk,pc_ex);
reg_16bit rr3(inst_word_rr,rst,en,clk,inst_word_ex);
reg_16bit rr4(g1_16bit_rr,rst,en,clk,g1_16bit_ex);
reg_16bit rr5(g2_16bit_rr,rst,en,clk,g2_16bit_ex);
reg_8bit rr6(f1_8bit_rr,rst,en,clk,f1_8bit_ex);
//reg_6bit rr7(f2_6bit_rr,rst,en,clk,f2_6bit_ex);
reg_6bit rr8(opcode_rr,rst,en,clk,opcode_ex);

reg_16bit rr9(zero_padd_rr,rst,en,clk,zero_padd_ex);
reg_16bit rr10(pc_plus_imm_rr,rst,en,clk,pc_plus_imm_ex);
reg_16bit rr11(data_1_rr,rst,en,clk,data_1_ex);
reg_16bit rr12(data_2_rr,rst,en,clk,data_2_ex);
reg_16bit rr13(SE6_or_9_data_rr,rst,en,clk,SE6_or_9_data_ex);

//EXECUTE STAGE

execute_stage  A4(clk,g1_16bit_ex[15],g1_16bit_ex[14],opcode_ex,data_1_ex,data_2_ex,SE6_or_9_data_ex,Data_from_mem_to_ex,d3_wb,pc_plus_1_ex,pc_plus_imm_ex,cout_mem,zout_mem,g1_16bit_ex[10],g1_16bit_ex[9],g1_16bit_ex[7:6],g1_16bit_ex[11],g2_16bit_ex[14],f1_8bit_ex[5:4],f1_8bit_ex[3:2],f1_8bit_ex[1:0],data_2_updated_ex,alu_out_ex,pc_plus_imm_updated_ex,pc_plus_imm_updated_beq_ex,reg_write_updated_ex,cout_ex,zout_ex,pc_select_ex);


//PIPELINE REGISTERS STAGE- EX/MEM INTERFACE							 
reg_16bit ex1(pc_plus_1_ex,rst,en,clk,pc_plus_1_mem);
reg_16bit ex4(g1_16bit_ex,rst,en,clk,g1_16bit_mem);
reg_16bit ex5(g2_16bit_ex,rst,en,clk,g2_16bit_mem);
reg_8bit ex6(f1_8bit_ex,rst,en,clk,f1_8bit_mem);
//reg_6bit ex7(f2_6bit_ex,rst,en,clk,f2_6bit_mem);
reg_6bit ex8(opcode_ex,rst,en,clk,opcode_mem);
reg_16bit ex9(zero_padd_ex,rst,en,clk,zero_padd_mem);



reg_16bit ex10(alu_out_ex,rst,en,clk,alu_out_mem);
reg_16bit ex2(pc_plus_imm_updated_ex,rst,en,clk,pc_plus_imm_updatedinex_mem);
reg_16bit ex12(data_2_updated_ex,rst,en,clk,data_2_mem);


D_Flip_Flop d7(rst,en,cout_ex,clk,cout_mem);
D_Flip_Flop d8(rst,en,zout_ex,clk,zout_mem);
D_Flip_Flop d9(rst,en,reg_write_updated_ex,clk,reg_write_updated_mem);

//MEMORY STAGE

memory_stage A5(g1_16bit_mem[2],g1_16bit_mem[3],g1_16bit_mem[5:4],f1_8bit_mem[7:6],data_2_mem,pc_plus_1_mem,pc_plus_imm_updatedinex_mem,alu_out_mem,zero_padd_mem,
                    pc_updated_mem,pc_plus_1_updated_mem,alu_out_updated_mem,data_out_mem,Data_from_mem_to_ex);
        
//PIPELINE REGISTERS STAGE- MEM/WB INTERFACE							 
reg_16bit mem1(pc_plus_1_updated_mem,rst,en,clk,pc_plus_1_wb);
reg_16bit mem4(g1_16bit_mem,rst,en,clk,g1_16bit_wb);
reg_16bit mem5(g2_16bit_mem,rst,en,clk,g2_16bit_wb);
//reg_8bit mem6(f1_8bit_mem,rst,en,clk,f1_8bit_wb);
//reg_6bit mem7(f2_6bit_mem,rst,en,clk,f2_6bit_wb);
reg_6bit mem8(opcode_mem,rst,en,clk,opcode_wb);
reg_16bit mem9(zero_padd_mem,rst,en,clk,zero_padd_wb);


reg_16bit mem10(pc_updated_mem,rst,en,clk,pc_wb);
reg_16bit mem11(alu_out_updated_mem,rst,en,clk,alu_out_wb);
reg_16bit mem12(data_out_mem,rst,en,clk,data_out_wb);

D_Flip_Flop d10(rst,en,reg_write_updated_mem,clk,reg_write_wb);

write_back_stage A6(g2_16bit_wb[13],g1_16bit_wb[1:0],g2_16bit_wb[2:0],pc_wb,alu_out_wb,pc_plus_1_wb,zero_padd_wb,data_out_wb,reg_write_wb,d3_wb,
                        d_R7_wb,rf_a3_wb,reg_write_updated_wb);
        

endmodule
