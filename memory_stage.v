module memory_stage(mem_write,mem_read,pc_select_mem,for_E_MEM_stage,d2_mem_in,PC_plus_1_in,PC_plus_imm,alu_out_in,zero_pad_in,
                    PC_updated_out,PC_plus_1_out,alu_out,data_out,Data_from_mem_stage_to_be_forwarded);
                     
input [15:0] d2_mem_in,PC_plus_1_in,PC_plus_imm,alu_out_in,zero_pad_in;
input mem_write,mem_read;
input [1:0] pc_select_mem,for_E_MEM_stage;
output [15:0] PC_updated_out,PC_plus_1_out,alu_out,data_out,Data_from_mem_stage_to_be_forwarded;


memory m1(mem_read,mem_write,alu_out_in,d2_mem_in,data_out);
mux4x1 Mux1(pc_select_mem,PC_plus_1_in,PC_plus_imm,d2_mem_in,16'b0,PC_updated_out);
assign PC_plus_1_out = PC_plus_1_in;
assign alu_out = alu_out_in;
mux4x1 FMUX1(for_E_MEM_stage,alu_out_in,PC_plus_1_in,zero_pad_in,16'd0,Data_from_mem_stage_to_be_forwarded);

endmodule