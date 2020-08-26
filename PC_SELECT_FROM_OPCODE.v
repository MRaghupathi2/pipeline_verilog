module PC_SELECT_FROM_OPCODE(opcode,pc_select_ex);


input [5:0]opcode;
output reg [1:0]pc_select_ex;

always@(*)

begin

if (opcode[5:2]==4'b1100)
   pc_select_ex<=2'b11;
else if (opcode[5:2]==4'b1000)
  pc_select_ex<=2'b01;
else if (opcode[5:2]==4'b1001)
  pc_select_ex<=2'b10;
else
  pc_select_ex<=2'b00;

end



endmodule
