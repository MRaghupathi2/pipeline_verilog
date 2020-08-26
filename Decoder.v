module Decoder(instruction_word,opcode,g_LM_SM_SIGNAL,g_SE6_SE9_SELECT,g_ALU_OPERATION_SELECT,g_X1_MODIFY_CARRY,g_X2_MODIFY_ZERO,g_X4_X5_CARRY_OR_ZERO_SELECT,g_PC_SELECT_NEEDED_FOR_MEM_STAGE,g_PC_DATA_MEM_READ,g_PC_DATA_MEM_WRITE,g_PC_WRITE_BACK_MUX,g_reg_write,f_MUX_ALU_OP1_SELECT,f_MUX_ALU_OP2_SELECT,f_MUX_D2_MUX_SELECT,R7_DEST_DETECT,RS1_VALID,RS2_VALID,RD_VALID,RS1,RS2,RD);

input [15:0] instruction_word;
output reg [5:0] opcode;
output reg g_LM_SM_SIGNAL,g_SE6_SE9_SELECT,g_PC_DATA_MEM_READ,g_PC_DATA_MEM_WRITE; 
 reg g_RF_A1_SELECT;
 reg [1:0]g_RF_A2_SELECT;
 reg [1:0]g_RF_A3_SELECT;
output reg g_ALU_OPERATION_SELECT,g_X1_MODIFY_CARRY,g_X2_MODIFY_ZERO;
reg g_X3_CIN_SELECT;
output reg [1:0] g_X4_X5_CARRY_OR_ZERO_SELECT;
output reg g_reg_write;
output reg [1:0]g_PC_WRITE_BACK_MUX;
output reg [1:0]g_PC_SELECT_NEEDED_FOR_MEM_STAGE;
output reg R7_DEST_DETECT;
output reg [2:0]RS1,RS2,RD;
output reg RS1_VALID,RS2_VALID,RD_VALID;


output reg [1:0] f_MUX_ALU_OP1_SELECT;
output reg [1:0] f_MUX_ALU_OP2_SELECT;
output reg [1:0] f_MUX_D2_MUX_SELECT;

always@(*)
begin
case (instruction_word[15:12])

  4'b0000 :   begin
             
					
              if (instruction_word[1:0]==2'b00)   //ADD
				    begin
					 g_LM_SM_SIGNAL<=1'b0;
					 g_RF_A1_SELECT<=1'b0;
					 g_RF_A2_SELECT<=2'b00;
					 g_SE6_SE9_SELECT<=1'b0;
					 g_ALU_OPERATION_SELECT<=1'b0;
					 g_PC_SELECT_NEEDED_FOR_MEM_STAGE<=2'b00;
					 g_PC_DATA_MEM_READ<=1'b0;
					 g_PC_DATA_MEM_WRITE<=1'b0;
					 g_PC_WRITE_BACK_MUX<=2'b00;
					 g_reg_write<=1'b1;
					 g_RF_A3_SELECT<=2'b00;
			       g_X1_MODIFY_CARRY<=1'b1;
					 g_X2_MODIFY_ZERO<=1'b1;
					 g_X3_CIN_SELECT<=1'b1;
					 g_X4_X5_CARRY_OR_ZERO_SELECT<=2'b00;
					 f_MUX_ALU_OP1_SELECT<=2'b00;
					  f_MUX_ALU_OP2_SELECT<=2'b00;
					 f_MUX_D2_MUX_SELECT<=2'b00;
					 opcode<=6'b000000;
					 end
				else if(instruction_word[1:0]==2'b10)   //ADC
					 begin
					 g_LM_SM_SIGNAL<=1'b0;
					 g_RF_A1_SELECT<=1'b0;
					 g_RF_A2_SELECT<=2'b00;
					 g_SE6_SE9_SELECT<=1'b0;
					 g_ALU_OPERATION_SELECT<=1'b0;
					 g_PC_SELECT_NEEDED_FOR_MEM_STAGE<=2'b00;
					 g_PC_DATA_MEM_READ<=1'b0;
					 g_PC_DATA_MEM_WRITE<=1'b0;
					 g_PC_WRITE_BACK_MUX<=2'b00;
					 g_reg_write<=1'b1;
					 g_RF_A3_SELECT<=2'b00;
			       g_X1_MODIFY_CARRY<=1'b1;
					 g_X2_MODIFY_ZERO<=1'b1;
					 g_X3_CIN_SELECT<=1'b1;
					 g_X4_X5_CARRY_OR_ZERO_SELECT<=2'b10;
					 opcode<=6'b000010;
					 f_MUX_ALU_OP1_SELECT<=2'b00;
					  f_MUX_ALU_OP2_SELECT<=2'b00;
					 f_MUX_D2_MUX_SELECT<=2'b00;
					 end
				else if (instruction_word[1:0]==2'b01)                       //ADZ
                  begin  
		      				g_LM_SM_SIGNAL<=1'b0;
								g_RF_A1_SELECT<=1'b0;
								g_RF_A2_SELECT<=2'b00;
								g_SE6_SE9_SELECT<=1'b0;
								g_ALU_OPERATION_SELECT<=1'b0;
								g_PC_SELECT_NEEDED_FOR_MEM_STAGE<=2'b00;
								g_PC_DATA_MEM_READ<=1'b0;
								g_PC_DATA_MEM_WRITE<=1'b0;
								g_PC_WRITE_BACK_MUX<=2'b00;
								g_reg_write<=1'b1;
								g_RF_A3_SELECT<=2'b00;
								g_X1_MODIFY_CARRY<=1'b1;
								g_X2_MODIFY_ZERO<=1'b1;
								g_X3_CIN_SELECT<=1'b1;
								g_X4_X5_CARRY_OR_ZERO_SELECT<=2'b01;
								opcode<=6'b000001;
								f_MUX_ALU_OP1_SELECT<=2'b00;
					          f_MUX_ALU_OP2_SELECT<=2'b00;
					         f_MUX_D2_MUX_SELECT<=2'b00;
						end
				else
				       begin  
		      				g_LM_SM_SIGNAL<=1'b0;
								g_RF_A1_SELECT<=1'b0;
								g_RF_A2_SELECT<=2'b00;
								g_SE6_SE9_SELECT<=1'b0;
								g_ALU_OPERATION_SELECT<=1'b0;
								g_PC_SELECT_NEEDED_FOR_MEM_STAGE<=2'b00;
								g_PC_DATA_MEM_READ<=1'b0;
								g_PC_DATA_MEM_WRITE<=1'b0;
								g_PC_WRITE_BACK_MUX<=2'b00;
								g_reg_write<=1'b1;
								g_RF_A3_SELECT<=2'b00;
								g_X1_MODIFY_CARRY<=1'b0;
								g_X2_MODIFY_ZERO<=1'b0;
								g_X3_CIN_SELECT<=1'b0;
								g_X4_X5_CARRY_OR_ZERO_SELECT<=2'b00;
								opcode<=6'b111111;
								f_MUX_ALU_OP1_SELECT<=2'b00;
					          f_MUX_ALU_OP2_SELECT<=2'b00;
					         f_MUX_D2_MUX_SELECT<=2'b00;
						end
				RS1<=instruction_word[11:9];
				RS2<=instruction_word[8:6];
				 RS1_VALID<=1'b1;
				RS2_VALID<=1'b1;
				RD<=instruction_word[5:3];	
			   RD_VALID<=1'b1;	
						
				 if (instruction_word[5:3]==3'b111)
				   R7_DEST_DETECT<=1'b1;
				 else
               R7_DEST_DETECT<=1'b0;
				end
				
			
				
				
				
 4'b0010: begin
           if (instruction_word[1:0]==2'b00)  //NDU
				    begin
					 g_LM_SM_SIGNAL<=1'b0;
					 g_RF_A1_SELECT<=1'b0;
					 g_RF_A2_SELECT<=2'b00;
					 g_SE6_SE9_SELECT<=1'b0;
					 g_ALU_OPERATION_SELECT<=1'b1;
					 g_PC_SELECT_NEEDED_FOR_MEM_STAGE<=2'b00;
					 g_PC_DATA_MEM_READ<=1'b0;
					 g_PC_DATA_MEM_WRITE<=1'b0;
					 g_PC_WRITE_BACK_MUX<=2'b00;
					 g_reg_write<=1'b1;
					 g_RF_A3_SELECT<=2'b00;
			       g_X1_MODIFY_CARRY<=1'b0;
					 g_X2_MODIFY_ZERO<=1'b1;
					 g_X3_CIN_SELECT<=1'b0;
					 g_X4_X5_CARRY_OR_ZERO_SELECT<=2'b00;
					 opcode<=6'b001000;
					 f_MUX_ALU_OP1_SELECT<=2'b00;
					  f_MUX_ALU_OP2_SELECT<=2'b00;
					 f_MUX_D2_MUX_SELECT<=2'b00;
					 end
				else if(instruction_word[1:0]==2'b10) //NDC
					 begin
					 g_LM_SM_SIGNAL<=1'b0;
					 g_RF_A1_SELECT<=1'b0;
					 g_RF_A2_SELECT<=2'b00;
					 g_SE6_SE9_SELECT<=1'b0;
					 g_ALU_OPERATION_SELECT<=1'b1;
					 g_PC_SELECT_NEEDED_FOR_MEM_STAGE<=2'b00;
					 g_PC_DATA_MEM_READ<=1'b0;
					 g_PC_DATA_MEM_WRITE<=1'b0;
					 g_PC_WRITE_BACK_MUX<=2'b00;
					 g_reg_write<=1'b1;
					 g_RF_A3_SELECT<=2'b00;
			       g_X1_MODIFY_CARRY<=1'b0;
					 g_X2_MODIFY_ZERO<=1'b1;
					 g_X3_CIN_SELECT<=1'b0;
					 g_X4_X5_CARRY_OR_ZERO_SELECT<=2'b10;
					 opcode<=6'b001010;
					 f_MUX_ALU_OP1_SELECT<=2'b00;
					  f_MUX_ALU_OP2_SELECT<=2'b00;
					 f_MUX_D2_MUX_SELECT<=2'b00;
					 end
					 else if(instruction_word[1:0]==2'b01)                 //NDZ
                  begin  
		      				g_LM_SM_SIGNAL<=1'b0;
								g_RF_A1_SELECT<=1'b0;
								g_RF_A2_SELECT<=2'b00;
								g_SE6_SE9_SELECT<=1'b0;
								g_ALU_OPERATION_SELECT<=1'b1;
								g_PC_SELECT_NEEDED_FOR_MEM_STAGE<=2'b00;
								g_PC_DATA_MEM_READ<=1'b0;
								g_PC_DATA_MEM_WRITE<=1'b0;
								g_PC_WRITE_BACK_MUX<=2'b00;
								g_reg_write<=1'b1;
								g_RF_A3_SELECT<=2'b00;
								g_X1_MODIFY_CARRY<=1'b0;
								g_X2_MODIFY_ZERO<=1'b1;
								g_X3_CIN_SELECT<=1'b0;
								g_X4_X5_CARRY_OR_ZERO_SELECT<=2'b01;
								opcode<=6'b001001;
								f_MUX_ALU_OP1_SELECT<=2'b00;
					          f_MUX_ALU_OP2_SELECT<=2'b00;
					         f_MUX_D2_MUX_SELECT<=2'b00;
						end
						
					else
				       begin  
		      				g_LM_SM_SIGNAL<=1'b0;
								g_RF_A1_SELECT<=1'b0;
								g_RF_A2_SELECT<=2'b00;
								g_SE6_SE9_SELECT<=1'b0;
								g_ALU_OPERATION_SELECT<=1'b0;
								g_PC_SELECT_NEEDED_FOR_MEM_STAGE<=2'b00;
								g_PC_DATA_MEM_READ<=1'b0;
								g_PC_DATA_MEM_WRITE<=1'b0;
								g_PC_WRITE_BACK_MUX<=2'b00;
								g_reg_write<=1'b1;
								g_RF_A3_SELECT<=2'b00;
								g_X1_MODIFY_CARRY<=1'b0;
								g_X2_MODIFY_ZERO<=1'b0;
								g_X3_CIN_SELECT<=1'b0;
								g_X4_X5_CARRY_OR_ZERO_SELECT<=2'b00;
								opcode<=6'b111111;
								f_MUX_ALU_OP1_SELECT<=2'b00;
					          f_MUX_ALU_OP2_SELECT<=2'b00;
					         f_MUX_D2_MUX_SELECT<=2'b00;
						end
				RS1<=instruction_word[11:9];
				RS2<=instruction_word[8:6];
				 RS1_VALID<=1'b1;
				RS2_VALID<=1'b1;
				RD<=instruction_word[5:3];	
			   RD_VALID<=1'b1;	
						
				if (instruction_word[5:3]==3'b111)
				   R7_DEST_DETECT<=1'b1;
				else
               R7_DEST_DETECT<=1'b0;
				end
				
				
				
				
								
     
4'b0001:  begin                           //ADI
					 g_LM_SM_SIGNAL<=1'b0;
					 g_RF_A1_SELECT<=1'b0;
					 g_RF_A2_SELECT<=2'b00;//NOT NEEDED//
					 g_SE6_SE9_SELECT<=1'b0;
					 g_ALU_OPERATION_SELECT<=1'b0;
					 g_PC_SELECT_NEEDED_FOR_MEM_STAGE<=2'b00;
					 g_PC_DATA_MEM_READ<=1'b0;
					 g_PC_DATA_MEM_WRITE<=1'b0;
					 g_PC_WRITE_BACK_MUX<=2'b00;
					 g_reg_write<=1'b1;
					 g_RF_A3_SELECT<=2'b01;
			       g_X1_MODIFY_CARRY<=1'b1;
					 g_X2_MODIFY_ZERO<=1'b1;
					 g_X3_CIN_SELECT<=1'b1;
					 g_X4_X5_CARRY_OR_ZERO_SELECT<=2'b00;
					 opcode<=6'b000100;
					 f_MUX_ALU_OP1_SELECT<=2'b00;
					  f_MUX_ALU_OP2_SELECT<=2'b11;
					 f_MUX_D2_MUX_SELECT<=2'b00;
					  RS1<=instruction_word[11:9];
				     RS2<=3'b000;
					  RS1_VALID<=1'b1;
				     RS2_VALID<=1'b0;
				     RD<=instruction_word[8:6];
					  RD_VALID<=1'b1;
					 
			       if (instruction_word[8:6]==3'b111)
				     R7_DEST_DETECT<=1'b1;
				    else
                 R7_DEST_DETECT<=1'b0;
					  end
4'b0011:   begin                            //LHI
					 g_LM_SM_SIGNAL<=1'b0;
					 g_RF_A1_SELECT<=1'b0;//NOT NEEDED
					 g_RF_A2_SELECT<=2'b00;//NOT NEEDED
					 g_SE6_SE9_SELECT<=1'b1;
					 g_ALU_OPERATION_SELECT<=1'b0;//NOT NEEDED
					 g_PC_SELECT_NEEDED_FOR_MEM_STAGE<=2'b00;
					 g_PC_DATA_MEM_READ<=1'b0;
					 g_PC_DATA_MEM_WRITE<=1'b0;
					 g_PC_WRITE_BACK_MUX<=2'b10;
					 g_reg_write<=1'b1;
					 g_RF_A3_SELECT<=2'b10;
			       g_X1_MODIFY_CARRY<=1'b0;
					 g_X2_MODIFY_ZERO<=1'b0;
					 g_X3_CIN_SELECT<=1'b0;
					 g_X4_X5_CARRY_OR_ZERO_SELECT<=2'b00;
					 f_MUX_ALU_OP1_SELECT<=2'b00;//NOT NEEDED
					  f_MUX_ALU_OP2_SELECT<=2'b00;//NOT NEEDED
					 f_MUX_D2_MUX_SELECT<=2'b00;
					 opcode<=6'b001100;
					  RS1<=3'b000;
				     RS2<=3'b000;
					  RS1_VALID<=1'b0;
				     RS2_VALID<=1'b0;
				     RD<=instruction_word[11:9];
					  RD_VALID<=1'b1;
					 
					 
					 if (instruction_word[11:9]==3'b111)
				     R7_DEST_DETECT<=1'b1;
				    else
                 R7_DEST_DETECT<=1'b0;
				 end 
					 
					 
 4'b0100 :                                 //LW
				    begin
					 g_LM_SM_SIGNAL<=1'b0;
					 g_RF_A1_SELECT<=1'b1;
					 g_RF_A2_SELECT<=2'b00;//not needed
					 g_SE6_SE9_SELECT<=1'b0;
					 g_ALU_OPERATION_SELECT<=1'b0;
					 g_PC_SELECT_NEEDED_FOR_MEM_STAGE<=2'b00;
					 g_PC_DATA_MEM_READ<=1'b1;
					 g_PC_DATA_MEM_WRITE<=1'b0;
					 g_PC_WRITE_BACK_MUX<=2'b11;
					 g_reg_write<=1'b1;
					 g_RF_A3_SELECT<=2'b10;
			       g_X1_MODIFY_CARRY<=1'b0;
					 g_X2_MODIFY_ZERO<=1'b0;
					 g_X3_CIN_SELECT<=1'b0;
					 g_X4_X5_CARRY_OR_ZERO_SELECT<=2'b00;
					 f_MUX_ALU_OP1_SELECT<=2'b00;
					  f_MUX_ALU_OP2_SELECT<=2'b11;
					 f_MUX_D2_MUX_SELECT<=2'b00;
					 opcode<=6'b010000;
					  RS1<=instruction_word[8:6];
				     RS2<=3'b000;
					  RS1_VALID<=1'b1;
				     RS2_VALID<=1'b0;
				     RD<=instruction_word[11:9];
					  RD_VALID<=1'b1;
					 
					 
					 if (instruction_word[11:9]==3'b111)
				     R7_DEST_DETECT<=1'b1;
				    else
                 R7_DEST_DETECT<=1'b0;
					 
					 
					 end				 
					 
 4'b0101 : 		 begin                    //SW
					 g_LM_SM_SIGNAL<=1'b0;
					 g_RF_A1_SELECT<=1'b1;
					 g_RF_A2_SELECT<=2'b01;
					 g_SE6_SE9_SELECT<=1'b0;
					 g_ALU_OPERATION_SELECT<=1'b0;
					 g_PC_SELECT_NEEDED_FOR_MEM_STAGE<=2'b00;
					 g_PC_DATA_MEM_READ<=1'b0;
					 g_PC_DATA_MEM_WRITE<=1'b1;
					 g_PC_WRITE_BACK_MUX<=2'b00;//not needed
					 g_reg_write<=1'b0;
					 g_RF_A3_SELECT<=2'b00;//not needed
			       g_X1_MODIFY_CARRY<=1'b0;
					 g_X2_MODIFY_ZERO<=1'b0;
					 g_X3_CIN_SELECT<=1'b0;
					 g_X4_X5_CARRY_OR_ZERO_SELECT<=2'b00;
					 f_MUX_ALU_OP1_SELECT<=2'b00;
					  f_MUX_ALU_OP2_SELECT<=2'b11;
					 f_MUX_D2_MUX_SELECT<=2'b00;
					 opcode<=6'b010100;
                 R7_DEST_DETECT<=1'b0;
					  RS1<=instruction_word[8:6];
				     RS2<=instruction_word[11:9];
					  RS1_VALID<=1'b1;
				     RS2_VALID<=1'b1;
				     RD<=3'b000;
					  RD_VALID<=1'b0;
					  
					  
					end
					  
					

4'b1100 : begin                               //BEQ
					 g_LM_SM_SIGNAL<=1'b0;
					 g_RF_A1_SELECT<=1'b0;
					 g_RF_A2_SELECT<=2'b00;
					 g_SE6_SE9_SELECT<=1'b0;
					 g_ALU_OPERATION_SELECT<=1'b0;//not needed
					 g_PC_SELECT_NEEDED_FOR_MEM_STAGE<=2'b01;
					 g_PC_DATA_MEM_READ<=1'b0;
					 g_PC_DATA_MEM_WRITE<=1'b0;
					 g_PC_WRITE_BACK_MUX<=2'b00;//not needed
					 g_reg_write<=1'b0;
					 g_RF_A3_SELECT<=2'b00;//not needed
			       g_X1_MODIFY_CARRY<=1'b0;
					 g_X2_MODIFY_ZERO<=1'b0;
					 g_X3_CIN_SELECT<=1'b0;
					 g_X4_X5_CARRY_OR_ZERO_SELECT<=2'b00;
					 f_MUX_ALU_OP1_SELECT<=2'b00;
					  f_MUX_ALU_OP2_SELECT<=2'b00;
					 f_MUX_D2_MUX_SELECT<=2'b00;
					 opcode<=6'b110000;
					  R7_DEST_DETECT<=1'b0;
					  RS1<=instruction_word[11:9];
				     RS2<=instruction_word[8:6];
					  RS1_VALID<=1'b1;
				     RS2_VALID<=1'b1;
				     RD<=3'b000;
					  RD_VALID<=1'b0;
					  
					 end

4'b1000 : begin                                //JAL
					 g_LM_SM_SIGNAL<=1'b0;
					 g_RF_A1_SELECT<=1'b0;//not needed
					 g_RF_A2_SELECT<=2'b00;//not needed
					 g_SE6_SE9_SELECT<=1'b1;
					 g_ALU_OPERATION_SELECT<=1'b0;//not needed
					 g_PC_SELECT_NEEDED_FOR_MEM_STAGE<=2'b01;
					 g_PC_DATA_MEM_READ<=1'b0;
					 g_PC_DATA_MEM_WRITE<=1'b0;
					 g_PC_WRITE_BACK_MUX<=2'b01;
					 g_reg_write<=1'b1;
					 g_RF_A3_SELECT<=2'b10;
			       g_X1_MODIFY_CARRY<=1'b0;
					 g_X2_MODIFY_ZERO<=1'b0;
					 g_X3_CIN_SELECT<=1'b0;
					 g_X4_X5_CARRY_OR_ZERO_SELECT<=2'b00;
					 f_MUX_ALU_OP1_SELECT<=2'b00;
					  f_MUX_ALU_OP2_SELECT<=2'b00;
					 f_MUX_D2_MUX_SELECT<=2'b00;
					 opcode<=6'b100000;
					  RS1<=3'b000;
				     RS2<=3'b000;
					  RS1_VALID<=1'b0;
				     RS2_VALID<=1'b0;
				     RD<=instruction_word[11:9];
					  RD_VALID<=1'b1;
					 
					 
					  if (instruction_word[11:9]==3'b111)
				     R7_DEST_DETECT<=1'b1;
				    else
                 R7_DEST_DETECT<=1'b0;
					  
					 

					 end					 

					 
4'b1001 : begin                        //JLR
					 g_LM_SM_SIGNAL<=1'b0;
					 g_RF_A1_SELECT<=1'b0;//not needed
					 g_RF_A2_SELECT<=2'b00;
					 g_SE6_SE9_SELECT<=1'b0;
					 g_ALU_OPERATION_SELECT<=1'b0;//not needed
					 g_PC_SELECT_NEEDED_FOR_MEM_STAGE<=2'b10;
					 g_PC_DATA_MEM_READ<=1'b0;
					 g_PC_DATA_MEM_WRITE<=1'b0;
					 g_PC_WRITE_BACK_MUX<=2'b01;
					 g_reg_write<=1'b1;
					 g_RF_A3_SELECT<=2'b10;
			       g_X1_MODIFY_CARRY<=1'b0;
					 g_X2_MODIFY_ZERO<=1'b0;
					 g_X3_CIN_SELECT<=1'b0;
					 g_X4_X5_CARRY_OR_ZERO_SELECT<=2'b00;
					 f_MUX_ALU_OP1_SELECT<=2'b00;
					  f_MUX_ALU_OP2_SELECT<=2'b00;
					 f_MUX_D2_MUX_SELECT<=2'b00;
					 opcode<=6'b100100;
					 
					  RS1<=3'b000;
				     RS2<=instruction_word[8:6];
					  RS1_VALID<=1'b0;
				     RS2_VALID<=1'b1;
				     RD<=instruction_word[11:9];
					  RD_VALID<=1'b1;
					 
					 
					 
					  if (instruction_word[11:9]==3'b111)
				     R7_DEST_DETECT<=1'b1;
				    else
                 R7_DEST_DETECT<=1'b0;
					 
					 
					 end						 

4'b0110 : begin                 //LM
					 g_LM_SM_SIGNAL<=1'b1;
					 g_RF_A1_SELECT<=1'b0;
					 g_RF_A2_SELECT<=2'b00;//not needed
					 g_SE6_SE9_SELECT<=1'b0;
					 g_ALU_OPERATION_SELECT<=1'b0;
					 g_PC_SELECT_NEEDED_FOR_MEM_STAGE<=2'b00;
					 g_PC_DATA_MEM_READ<=1'b1;
					 g_PC_DATA_MEM_WRITE<=1'b0;
					 g_PC_WRITE_BACK_MUX<=2'b11;
					 g_reg_write<=1'b0;//REG WRITE MADE AS 1 IN TOP LEVEL DECODE STAGE FOR LM
					 g_RF_A3_SELECT<=2'b11;
			       g_X1_MODIFY_CARRY<=1'b0;
					 g_X2_MODIFY_ZERO<=1'b0;
					 g_X3_CIN_SELECT<=1'b0;
					 g_X4_X5_CARRY_OR_ZERO_SELECT<=2'b00;
					 f_MUX_ALU_OP1_SELECT<=2'b00;
					  f_MUX_ALU_OP2_SELECT<=2'b00;//DEFAULT
					 f_MUX_D2_MUX_SELECT<=2'b00;
					 opcode<=6'b011000;
					 R7_DEST_DETECT<=1'b0;//NEED NOT HAVE TO BE CHANGED
					  
					  //LM
					  RS1<=instruction_word[11:9];
				     RS2<=3'b000;
					  RS1_VALID<=1'b1;//VALID
				     RS2_VALID<=1'b0;
				     RD<=3'b000;//DEFAULT AND UPDATED BY LM/SM SIGNAL MUX
					  RD_VALID<=1'b1;//VALID
					 
					 
					 end	

4'b0111 : begin               //SM
					 g_LM_SM_SIGNAL<=1'b1;
					 g_RF_A1_SELECT<=1'b0;
					 g_RF_A2_SELECT<=2'b00;
					 g_SE6_SE9_SELECT<=1'b0;
					 g_ALU_OPERATION_SELECT<=1'b0;
					 g_PC_SELECT_NEEDED_FOR_MEM_STAGE<=2'b00;
					 g_PC_DATA_MEM_READ<=1'b0;
					 g_PC_DATA_MEM_WRITE<=1'b0;//MADE AS 1 IN TOP LEVEL DECODE STAGE FOR SM
					 g_PC_WRITE_BACK_MUX<=2'b00;//not needed
					 g_reg_write<=1'b0;
					 g_RF_A3_SELECT<=2'b00;//not needed
			       g_X1_MODIFY_CARRY<=1'b0;
					 g_X2_MODIFY_ZERO<=1'b0;
					 g_X3_CIN_SELECT<=1'b0;
					 g_X4_X5_CARRY_OR_ZERO_SELECT<=2'b00;
					 f_MUX_ALU_OP1_SELECT<=2'b00;
					  f_MUX_ALU_OP2_SELECT<=2'b00;//DEFAULT
					 f_MUX_D2_MUX_SELECT<=2'b00;
					 opcode<=6'b011100;
					 R7_DEST_DETECT<=1'b0;
					 
					  RS1<=instruction_word[11:9];
				     RS2<=3'b000;//DEFAULT AND UPDATED BY LM/SM SIGNAL MUX
					  RS1_VALID<=1'b1;//VALID
				     RS2_VALID<=1'b1;//VALID
				     RD<=3'b000;
					  RD_VALID<=1'b0;
					 
					 
					 end
default :begin 
             g_LM_SM_SIGNAL<=1'b0;
					 g_RF_A1_SELECT<=1'b0;
					 g_RF_A2_SELECT<=2'b00;
					 g_SE6_SE9_SELECT<=1'b0;
					 g_ALU_OPERATION_SELECT<=1'b0;
					 g_PC_SELECT_NEEDED_FOR_MEM_STAGE<=2'b00;
					 g_PC_DATA_MEM_READ<=1'b0;
					 g_PC_DATA_MEM_WRITE<=1'b0;
					 g_PC_WRITE_BACK_MUX<=2'b00;//not needed
					 g_reg_write<=1'b0;
					 g_RF_A3_SELECT<=2'b00;//not needed
			       g_X1_MODIFY_CARRY<=1'b0;
					 g_X2_MODIFY_ZERO<=1'b0;
					 g_X3_CIN_SELECT<=1'b0;
					 g_X4_X5_CARRY_OR_ZERO_SELECT<=2'b00;
					 f_MUX_ALU_OP1_SELECT<=2'b00;
					  f_MUX_ALU_OP2_SELECT<=2'b00;
					 f_MUX_D2_MUX_SELECT<=2'b00;
					 opcode<=6'b111111;
					 R7_DEST_DETECT<=1'b0;
					 
					  //DEFAULT
					  RS1<=3'b000;
				     RS2<=3'b000;
					  RS1_VALID<=1'b0;
				     RS2_VALID<=1'b0;
				     RD<=3'b000;
					  RD_VALID<=1'b0;
					 
					 
					 
					 end
					 
endcase		 
end					 

endmodule