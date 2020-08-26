module branch_stall_unit(opcode_RR,opcode_EX,opcode_MEM,opcode_WB,R7_detect_RR,R7_detect_EX,R7_detect_MEM,R7_detect_WB,branch_or_R7_stall,branch_stall,extra_signal);
input [5:0] opcode_RR,opcode_EX,opcode_MEM,opcode_WB;
input R7_detect_RR,R7_detect_EX,R7_detect_MEM,R7_detect_WB;
output reg branch_stall,extra_signal;
reg R7_DEST_stall;
output branch_or_R7_stall;  
 
always@(*)
begin
if (opcode_RR[5:2]==4'b1100 || opcode_RR[5:3]==3'b100 || opcode_EX[5:2]==4'b1100 || opcode_EX[5:3]==3'b100 || opcode_MEM[5:2]==4'b1100 || opcode_MEM[5:3]==3'b100)
   branch_stall<=1'b1;
else
   branch_stall<=1'b0;
	

end

always@(*)

begin

if (R7_detect_RR==1'b1 || R7_detect_EX==1'b1 || R7_detect_MEM==1'b1 || R7_detect_WB==1'b1 || (opcode_RR[5:2]==4'b1111 && opcode_EX[5:2]==4'b1111 && opcode_MEM[5:2]==4'b1111 && opcode_WB[5:2]==4'b1111))
    R7_DEST_stall<=1'b1;
else
 	R7_DEST_stall<=1'b0;


end

always@(*)
begin
if ((opcode_RR[5:2]==4'b1111 && opcode_EX[5:2]==4'b1111 && opcode_MEM[5:2]==4'b1111 && opcode_WB[5:2]==4'b1111))
   extra_signal<=1'b1;
else
   extra_signal<=1'b0;
end


assign branch_or_R7_stall=R7_DEST_stall || branch_stall;	
endmodule
