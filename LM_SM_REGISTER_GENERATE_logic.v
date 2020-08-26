module LM_SM_REGISTER_GENERATE_logic(rst,clk,LM_SM_signal,inst_word,opcode_dec,inst_word_rr,priority_out,stall_out);

input LM_SM_signal,rst,clk;
input [15:0] inst_word,inst_word_rr;
input [5:0] opcode_dec;
output stall_out;
output [2:0]priority_out;

wire [7:0]mux_in0,priority_in,decoder_out,exor_in1,exor_in2;
reg select_decoder_out;

priority_encoder p1(LM_SM_signal,priority_in,priority_out,stall_out);
one_hot_decoder  oh1(priority_out,stall_out,decoder_out);


reg_8bit   r1 (decoder_out,rst,LM_SM_signal,clk,exor_in2);
reg_8bit   r2 (priority_in,rst,LM_SM_signal,clk,exor_in1);


assign mux_in0=exor_in1^exor_in2;

always@(*)
begin
if ((inst_word==inst_word_rr) && (opcode_dec[5:2]==4'b0111 ||opcode_dec[5:2]==4'b0110))
select_decoder_out<=1'b0;
else
select_decoder_out<=1'b1;
end

Mux2x1_8bit m1(select_decoder_out,mux_in0,inst_word[7:0],priority_in);


endmodule