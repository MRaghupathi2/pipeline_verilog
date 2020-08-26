module Forward_logic_unit(INS_WORD_CURRENT,INS_WORD_PREV,INS_WORD_PREV_PREV,OPCODE_CURRENT,OPCODE_PREV,OPCODE_PREV_PREV,for_MUX_ALU_OP1_SELECT,for_MUX_ALU_OP2_SELECT,for_MUX_D2_MUX_SELECT,f_E_MEM_STAGE,f_F_WB_STAGE,hazard_detect,stall);

input [15:0]INS_WORD_CURRENT;
input [15:0]INS_WORD_PREV;
input [15:0]INS_WORD_PREV_PREV;
input [5:0]OPCODE_CURRENT;
input [5:0]OPCODE_PREV;
input [5:0]OPCODE_PREV_PREV;
output  reg hazard_detect;
output  reg stall;
output reg [1:0] for_MUX_ALU_OP1_SELECT,for_MUX_ALU_OP2_SELECT,for_MUX_D2_MUX_SELECT;
output reg [1:0] f_E_MEM_STAGE,f_F_WB_STAGE;

always@(*)
begin

if (INS_WORD_CURRENT[15:12]==4'b0000 || INS_WORD_CURRENT[15:12]==4'b0010 || INS_WORD_CURRENT[15:12]==4'b1100)  //CURRENT -R-TYPE OR BEQ

   if (INS_WORD_PREV[15:12]==4'b0000 || INS_WORD_PREV[15:12]==4'b0010)//PREV-R-TYPE
           if (INS_WORD_CURRENT[11:9]==INS_WORD_PREV[5:3])//SOURCE OPERAND_1_MATCH
			  begin
			    for_MUX_ALU_OP1_SELECT<=2'b01;//FROM MEM STAGE
				 for_MUX_ALU_OP2_SELECT<=2'b00;
				 for_MUX_D2_MUX_SELECT<=2'b00;
				 f_F_WB_STAGE<=2'b00;//NOT NEEDED
				 f_E_MEM_STAGE<=2'b00;//ALU OUTPUT OF MEM_STAGE_SELECTED
				 stall<=1'b0;
				 hazard_detect<=1'b1;
			  end
				else if (INS_WORD_CURRENT[8:6]==INS_WORD_PREV[5:3])//SOURCE OPERAND_2_MATCH
			  begin
			    for_MUX_ALU_OP1_SELECT<=2'b00;
				 for_MUX_ALU_OP2_SELECT<=2'b01;//FROM MEM STAGE
				 for_MUX_D2_MUX_SELECT<=2'b00;
				 f_F_WB_STAGE<=2'b00;//NOT NEEDED
				 f_E_MEM_STAGE<=2'b00;//ALU OUTPUT OF MEM_STAGE_FORWARDED 
				 stall<=1'b0; 
				  hazard_detect<=1'b1;
				end
             else                         //DEFAULT ALL 0
             begin
				 for_MUX_ALU_OP1_SELECT<=2'b00;//DEFAULT
				 for_MUX_ALU_OP2_SELECT<=2'b00;//DEFAULT
				 for_MUX_D2_MUX_SELECT<=2'b00;//DEFAULT
				 f_F_WB_STAGE<=2'b00;//DEFAULT
				 f_E_MEM_STAGE<=2'b00;//DEFAULT 
             stall<=1'b0;
				  hazard_detect<=1'b0;
			    end
	else if(INS_WORD_PREV[15:12]==4'b0001) // PREV-ADI
			    if (INS_WORD_CURRENT[11:9]==INS_WORD_PREV[8:6])//SOURCE OPERAND_1_MATCH
			    begin
				 for_MUX_ALU_OP1_SELECT<=2'b01;//FROM MEM STAGE
				 for_MUX_ALU_OP2_SELECT<=2'b00;
				 for_MUX_D2_MUX_SELECT<=2'b00;
				 f_F_WB_STAGE<=2'b00;//NOT NEEDED
				 f_E_MEM_STAGE<=2'b00;//ALU OUTPUT OF MEM_STAGE_FORWARDED
				 stall<=1'b0;
				  hazard_detect<=1'b1;
				 end
				 else if (INS_WORD_CURRENT[8:6]==INS_WORD_PREV[8:6])//SOURCE OPERAND_2_MATCH
			    begin
				 for_MUX_ALU_OP1_SELECT<=2'b00;
				 for_MUX_ALU_OP2_SELECT<=2'b01;//FROM MEM STAGE
				 for_MUX_D2_MUX_SELECT<=2'b00;
				 f_F_WB_STAGE<=2'b00;//NOT NEEDED
				 f_E_MEM_STAGE<=2'b00;//ALU OUTPUT OF MEM_STAGE_FORWARDED  
             stall<=1'b0;
				  hazard_detect<=1'b1;
				 end
				 else                         //DEFAULT ALL 0
             begin
				 for_MUX_ALU_OP1_SELECT<=2'b00;//DEFAULT
				 for_MUX_ALU_OP2_SELECT<=2'b00;//DEFAULT
				 for_MUX_D2_MUX_SELECT<=2'b00;//DEFAULT
				 f_F_WB_STAGE<=2'b00;//DEFAULT
				 f_E_MEM_STAGE<=2'b00;//DEFAULT
			    stall<=1'b0;	 
				  hazard_detect<=1'b0;
				end
	else if (INS_WORD_PREV[15:12]==4'b0011) // PREV-LHI   
				if (INS_WORD_CURRENT[11:9]==INS_WORD_PREV[11:9])//SOURCE OPERAND_1_MATCH
			    begin
				 for_MUX_ALU_OP1_SELECT<=2'b01;//FROM MEM STAGE
				 for_MUX_ALU_OP2_SELECT<=2'b00;
				 for_MUX_D2_MUX_SELECT<=2'b00;
				 f_F_WB_STAGE<=2'b00;//NOT NEEDED
				 f_E_MEM_STAGE<=2'b10;//0 PAD OF MEM_STAGE_FORWARDED
				 stall<=1'b0;
				  hazard_detect<=1'b1;
				 end
				 else if (INS_WORD_CURRENT[8:6]==INS_WORD_PREV[11:9])//SOURCE OPERAND_2_MATCH
			    begin
				 for_MUX_ALU_OP1_SELECT<=2'b00;
				 for_MUX_ALU_OP2_SELECT<=2'b01;//FROM MEM STAGE
				 for_MUX_D2_MUX_SELECT<=2'b00;
				 f_F_WB_STAGE<=2'b00;//NOT NEEDED
				 f_E_MEM_STAGE<=2'b10;//ALU OUTPUT OF MEM_STAGE_SELECTED  
             stall<=1'b0;
				  hazard_detect<=1'b1;
				 end
				 else                         //DEFAULT ALL 0
				 begin
				 for_MUX_ALU_OP1_SELECT<=2'b00;//DEFAULT
				 for_MUX_ALU_OP2_SELECT<=2'b00;//DEFAULT
				 for_MUX_D2_MUX_SELECT<=2'b00;//DEFAULT
				 f_F_WB_STAGE<=2'b00;//DEFAULT
				 f_E_MEM_STAGE<=2'b00;//DEFAULT
			    stall<=1'b0;	 
				  hazard_detect<=1'b0;
				 end
	else if (INS_WORD_PREV[15:12]==4'b1000 || INS_WORD_PREV[15:12]==4'b1001) // PREV-JAL OR JLR
			    
				 if (INS_WORD_CURRENT[11:9]==INS_WORD_PREV[11:9])//SOURCE OPERAND_1_MATCH
			    begin
				 for_MUX_ALU_OP1_SELECT<=2'b01;//FROM MEM STAGE
				 for_MUX_ALU_OP2_SELECT<=2'b00;
				 for_MUX_D2_MUX_SELECT<=2'b00;
				 f_F_WB_STAGE<=2'b00;//NOT NEEDED
				 f_E_MEM_STAGE<=2'b01;//PC+1 OF MEM_STAGE_FORWARDED
				 stall<=1'b0;
				  hazard_detect<=1'b1;
				 end
				 else if (INS_WORD_CURRENT[8:6]==INS_WORD_PREV[11:9])//SOURCE OPERAND_2_MATCH
			    begin
				 for_MUX_ALU_OP1_SELECT<=2'b00;
				 for_MUX_ALU_OP2_SELECT<=2'b01;//FROM MEM STAGE
				 for_MUX_D2_MUX_SELECT<=2'b00;
				 f_F_WB_STAGE<=2'b00;//NOT NEEDED
				 f_E_MEM_STAGE<=2'b01;//ALU OUTPUT OF MEM_STAGE_SELECTED  
             stall<=1'b0;
				  hazard_detect<=1'b1;
				 end
				 else                         //DEFAULT ALL 0
             begin
				 for_MUX_ALU_OP1_SELECT<=2'b00;//DEFAULT
				 for_MUX_ALU_OP2_SELECT<=2'b00;//DEFAULT
				 for_MUX_D2_MUX_SELECT<=2'b00;//DEFAULT
				 f_F_WB_STAGE<=2'b00;//DEFAULT
				 f_E_MEM_STAGE<=2'b00;//DEFAULT
			    stall<=1'b0;
				  hazard_detect<=1'b0;
	           end
	else if (INS_WORD_PREV[15:12]==4'b0100 ) // PREV-LW
			    if (INS_WORD_CURRENT[11:9]==INS_WORD_PREV[11:9]||INS_WORD_CURRENT[8:6]==INS_WORD_PREV[11:9])//SOURCE OPERAND_1_2_MATCH
			    begin
				 for_MUX_ALU_OP1_SELECT<=2'b00;//DEFAULT
				 for_MUX_ALU_OP2_SELECT<=2'b00;//DEFAULT
				 for_MUX_D2_MUX_SELECT<=2'b00;//DEFAULT
				 f_F_WB_STAGE<=2'b00;//DEFAULT
				 f_E_MEM_STAGE<=2'b00;//DEFAULT
				 stall<=1'b1;
				  hazard_detect<=1'b1;
				 end
			
             else   //DEFAULT
			   begin
				for_MUX_ALU_OP1_SELECT<=2'b00;//DEFAULT
				 for_MUX_ALU_OP2_SELECT<=2'b00;//DEFAULT
				 for_MUX_D2_MUX_SELECT<=2'b00;//DEFAULT
				 f_F_WB_STAGE<=2'b00;//DEFAULT
				 f_E_MEM_STAGE<=2'b00;//DEFAULT
				 stall<=1'b0;
				  hazard_detect<=1'b0;
            end  
	else   //DEFAULT
			   begin
				for_MUX_ALU_OP1_SELECT<=2'b00;//DEFAULT
				 for_MUX_ALU_OP2_SELECT<=2'b00;//DEFAULT
				 for_MUX_D2_MUX_SELECT<=2'b00;//DEFAULT
				 f_F_WB_STAGE<=2'b00;//DEFAULT
				 f_E_MEM_STAGE<=2'b00;//DEFAULT
				 stall<=1'b0;
				  hazard_detect<=1'b0;
            end 
	
else if (INS_WORD_CURRENT[15:12]==4'b0100)  //CURRENT -LW 
   if (INS_WORD_PREV[15:12]==4'b0000 || INS_WORD_PREV[15:12]==4'b0010)//PREV-R-TYPE
           if (INS_WORD_CURRENT[8:6]==INS_WORD_PREV[5:3])//SOURCE OPERAND_1_MATCH
			    begin
				 for_MUX_ALU_OP1_SELECT<=2'b01;//FROM MEM STAGE
				 for_MUX_ALU_OP2_SELECT<=2'b11;//IMMEDIATE OPERAND
				 for_MUX_D2_MUX_SELECT<=2'b00;
				 f_F_WB_STAGE<=2'b00;//NOT NEEDED
				 f_E_MEM_STAGE<=2'b00;//ALU OUTPUT OF MEM_STAGE_SELECTED
             stall<=1'b0;
				 hazard_detect<=1'b1;
				 end
				 else                         //DEFAULT ALL 0
            begin
				 for_MUX_ALU_OP1_SELECT<=2'b00;//DEFAULT
				 for_MUX_ALU_OP2_SELECT<=2'b00;//DEFAULT
				 for_MUX_D2_MUX_SELECT<=2'b00;//DEFAULT
				 f_F_WB_STAGE<=2'b00;//DEFAULT
	  			 f_E_MEM_STAGE<=2'b00;//DEFAULT 
             stall<=1'b0;
				  hazard_detect<=1'b0;				 
	          end
	else if (INS_WORD_PREV[15:12]==4'b0001)//PREV-ADI
           if (INS_WORD_CURRENT[8:6]==INS_WORD_PREV[8:6])//SOURCE OPERAND_1_MATCH
			    begin
				 for_MUX_ALU_OP1_SELECT<=2'b01;//FROM MEM STAGE
				 for_MUX_ALU_OP2_SELECT<=2'b11;//IMMEDIATE OPERAND
				 for_MUX_D2_MUX_SELECT<=2'b00;
				 f_F_WB_STAGE<=2'b00;//NOT NEEDED
				 f_E_MEM_STAGE<=2'b00;//ALU OUTPUT OF MEM_STAGE_FORWARDED
				 stall<=1'b0;
				 hazard_detect<=1'b1;
             end
				 else                         //DEFAULT ALL 0
             begin
				 for_MUX_ALU_OP1_SELECT<=2'b00;//DEFAULT
				 for_MUX_ALU_OP2_SELECT<=2'b00;//DEFAULT
				 for_MUX_D2_MUX_SELECT<=2'b00;//DEFAULT
				 f_F_WB_STAGE<=2'b00;//DEFAULT
				 f_E_MEM_STAGE<=2'b00;//DEFAULT
				 stall<=1'b0;
				 hazard_detect<=1'b0;
				 end
	 else if (INS_WORD_PREV[15:12]==4'b0011)//PREV-LHI
           if (INS_WORD_CURRENT[8:6]==INS_WORD_PREV[11:9])//SOURCE OPERAND_1_MATCH
			    begin
				 for_MUX_ALU_OP1_SELECT<=2'b01;//FROM MEM STAGE
				 for_MUX_ALU_OP2_SELECT<=2'b11;//IMMEDIATE OPERAND
				 for_MUX_D2_MUX_SELECT<=2'b00;
				 f_F_WB_STAGE<=2'b00;//NOT NEEDED
				 f_E_MEM_STAGE<=2'b10;//0pad OF MEM_STAGE_FORWARDED
             stall<=1'b0;
				  hazard_detect<=1'b1;
				  end
				 else                         //DEFAULT ALL 0
             begin
				 for_MUX_ALU_OP1_SELECT<=2'b00;//DEFAULT
				 for_MUX_ALU_OP2_SELECT<=2'b00;//DEFAULT
				 for_MUX_D2_MUX_SELECT<=2'b00;//DEFAULT
				 f_F_WB_STAGE<=2'b00;//DEFAULT
				 f_E_MEM_STAGE<=2'b00;//DEFAULT
	          stall<=1'b0;
				 hazard_detect<=1'b0;
				 end
	 else if (INS_WORD_PREV[15:12]==4'b1000 || INS_WORD_PREV[15:12]==4'b1001)//PREV-JAL or JLR
           if (INS_WORD_CURRENT[8:6]==INS_WORD_PREV[11:9])//SOURCE OPERAND_1_MATCH
			    begin
				 for_MUX_ALU_OP1_SELECT<=2'b01;//FROM MEM STAGE
				 for_MUX_ALU_OP2_SELECT<=2'b11;//IMMEDIATE OPERAND
				 for_MUX_D2_MUX_SELECT<=2'b00;
				 f_F_WB_STAGE<=2'b00;//NOT NEEDED
				 f_E_MEM_STAGE<=2'b01;//PC+1 OF MEM_STAGE_FORWARDED
             stall<=1'b0;
				  hazard_detect<=1'b1;
				  end
				  else                         //DEFAULT ALL 0
				 begin
				 for_MUX_ALU_OP1_SELECT<=2'b00;//DEFAULT
				 for_MUX_ALU_OP2_SELECT<=2'b00;//DEFAULT
				 for_MUX_D2_MUX_SELECT<=2'b00;//DEFAULT
				 f_F_WB_STAGE<=2'b00;//DEFAULT
				 f_E_MEM_STAGE<=2'b00;//DEFAULT
	           stall<=1'b0;
				  hazard_detect<=1'b0;
				  end
	 else if (INS_WORD_PREV[15:12]==4'b0100 ) // PREV-LW
			    if (INS_WORD_CURRENT[8:6]==INS_WORD_PREV[11:9])//SOURCE OPERAND_1_MATCH
			    begin
				 for_MUX_ALU_OP1_SELECT<=2'b00;//DEFAULT
				 for_MUX_ALU_OP2_SELECT<=2'b00;//DEFAULT
				 for_MUX_D2_MUX_SELECT<=2'b00;//DEFAULT
				 f_F_WB_STAGE<=2'b00;//DEFAULT
				 f_E_MEM_STAGE<=2'b00;//DEFAULT
				 stall<=1'b1;
             hazard_detect<=1'b1;
             end				 
             else   //DEFAULT
				 begin
			    for_MUX_ALU_OP1_SELECT<=2'b00;//DEFAULT
				 for_MUX_ALU_OP2_SELECT<=2'b00;//DEFAULT
				 for_MUX_D2_MUX_SELECT<=2'b00;//DEFAULT
				 f_F_WB_STAGE<=2'b00;//DEFAULT
				 f_E_MEM_STAGE<=2'b00;//DEFAULT
				 stall<=1'b0;
				 hazard_detect<=1'b0;
				 end
	else   //DEFAULT
			    begin
				 for_MUX_ALU_OP1_SELECT<=2'b00;//DEFAULT
				 for_MUX_ALU_OP2_SELECT<=2'b00;//DEFAULT
				 for_MUX_D2_MUX_SELECT<=2'b00;//DEFAULT
				 f_F_WB_STAGE<=2'b00;//DEFAULT
				 f_E_MEM_STAGE<=2'b00;//DEFAULT
				 stall<=1'b0;
				 hazard_detect<=1'b0;
				 end
else if (INS_WORD_CURRENT[15:12]==4'b0001)  //CURRENT -ADI
   if (INS_WORD_PREV[15:12]==4'b0000 || INS_WORD_PREV[15:12]==4'b0010)//PREV-R-TYPE
           if (INS_WORD_CURRENT[11:9]==INS_WORD_PREV[5:3])//SOURCE OPERAND_1_MATCH
			    begin
				 for_MUX_ALU_OP1_SELECT<=2'b01;//FROM MEM STAGE
				 for_MUX_ALU_OP2_SELECT<=2'b11;//IMMEDIATE OPERAND
				 for_MUX_D2_MUX_SELECT<=2'b00;
				 f_F_WB_STAGE<=2'b00;//NOT NEEDED
				 f_E_MEM_STAGE<=2'b00;//ALU OUTPUT OF MEM_STAGE_SELECTED
				 stall<=1'b0;
             hazard_detect<=1'b1;
				 end
             else                         //DEFAULT ALL 0
             begin
				 for_MUX_ALU_OP1_SELECT<=2'b00;//DEFAULT
				 for_MUX_ALU_OP2_SELECT<=2'b00;//DEFAULT
				 for_MUX_D2_MUX_SELECT<=2'b00;//DEFAULT
				 f_F_WB_STAGE<=2'b00;//DEFAULT
	  			 f_E_MEM_STAGE<=2'b00;//DEFAULT 	 
             stall<=1'b0;
             hazard_detect<=1'b0;
             end   			 
	else if (INS_WORD_PREV[15:12]==4'b0001)//PREV-ADI
           if (INS_WORD_CURRENT[11:9]==INS_WORD_PREV[8:6])//SOURCE OPERAND_1_MATCH
			    begin
				 for_MUX_ALU_OP1_SELECT<=2'b01;//FROM MEM STAGE
				 for_MUX_ALU_OP2_SELECT<=2'b11;//IMMEDIATE OPERAND
				 for_MUX_D2_MUX_SELECT<=2'b00;
				 f_F_WB_STAGE<=2'b00;//NOT NEEDED
				 f_E_MEM_STAGE<=2'b00;//ALU OUTPUT OF MEM_STAGE_FORWARDED
             stall<=1'b0;
             hazard_detect<=1'b1;
				 end
				 else                         //DEFAULT ALL 0
             begin
				 for_MUX_ALU_OP1_SELECT<=2'b00;//DEFAULT
				 for_MUX_ALU_OP2_SELECT<=2'b00;//DEFAULT
				 for_MUX_D2_MUX_SELECT<=2'b00;//DEFAULT
				 f_F_WB_STAGE<=2'b00;//DEFAULT
				 f_E_MEM_STAGE<=2'b00;//DEFAULT
	          stall<=1'b0;
             hazard_detect<=1'b0;
				 end
	else if (INS_WORD_PREV[15:12]==4'b0011)//PREV-LHI
           if (INS_WORD_CURRENT[11:9]==INS_WORD_PREV[11:9])//SOURCE OPERAND_1_MATCH
			    begin
				 for_MUX_ALU_OP1_SELECT<=2'b01;//FROM MEM STAGE
				 for_MUX_ALU_OP2_SELECT<=2'b11;//IMMEDIATE OPERAND
				 for_MUX_D2_MUX_SELECT<=2'b00;
				 f_F_WB_STAGE<=2'b00;//NOT NEEDED
				 f_E_MEM_STAGE<=2'b10;//0pad OF MEM_STAGE_FORWARDED
				 stall<=1'b0;
             hazard_detect<=1'b1;
				 end
             else                         //DEFAULT ALL 0
             begin
				 for_MUX_ALU_OP1_SELECT<=2'b00;//DEFAULT
				 for_MUX_ALU_OP2_SELECT<=2'b00;//DEFAULT
				 for_MUX_D2_MUX_SELECT<=2'b00;//DEFAULT
				 f_F_WB_STAGE<=2'b00;//DEFAULT
				 f_E_MEM_STAGE<=2'b00;//DEFAULT
				 stall<=1'b0;
             hazard_detect<=1'b0;
				 end
	else if (INS_WORD_PREV[15:12]==4'b1000 || INS_WORD_PREV[15:12]==4'b1001)//PREV-JAL or JLR
           if (INS_WORD_CURRENT[11:9]==INS_WORD_PREV[11:9])//SOURCE OPERAND_1_MATCH
			    begin
				 for_MUX_ALU_OP1_SELECT<=2'b01;//FROM MEM STAGE
				 for_MUX_ALU_OP2_SELECT<=2'b11;//IMMEDIATE OPERAND
				 for_MUX_D2_MUX_SELECT<=2'b00;
				 f_F_WB_STAGE<=2'b00;//NOT NEEDED
				 f_E_MEM_STAGE<=2'b01;//PC+1 OF MEM_STAGE_FORWARDED
				 stall<=1'b0;
             hazard_detect<=1'b1;
             end
				 else                         //DEFAULT ALL 0
             begin
				 for_MUX_ALU_OP1_SELECT<=2'b00;//DEFAULT
				 for_MUX_ALU_OP2_SELECT<=2'b00;//DEFAULT
				 for_MUX_D2_MUX_SELECT<=2'b00;//DEFAULT
				 f_F_WB_STAGE<=2'b00;//DEFAULT
				 f_E_MEM_STAGE<=2'b00;//DEFAULT
				 stall<=1'b0;
             hazard_detect<=1'b0;
				 end
	else if (INS_WORD_PREV[15:12]==4'b0100 ) // PREV-LW
				 if (INS_WORD_CURRENT[11:9]==INS_WORD_PREV[11:9])//SOURCE OPERAND_1_MATCH
			    begin
				 for_MUX_ALU_OP1_SELECT<=2'b00;//DEFAULT
				 for_MUX_ALU_OP2_SELECT<=2'b00;//DEFAULT
				 for_MUX_D2_MUX_SELECT<=2'b00;//DEFAULT
				 f_F_WB_STAGE<=2'b00;//DEFAULT
				 f_E_MEM_STAGE<=2'b00;//DEFAULT
				 stall<=1'b1;
             hazard_detect<=1'b1;
             end				 
             else   //DEFAULT
			    begin
				 for_MUX_ALU_OP1_SELECT<=2'b00;//DEFAULT
				 for_MUX_ALU_OP2_SELECT<=2'b00;//DEFAULT
				 for_MUX_D2_MUX_SELECT<=2'b00;//DEFAULT
				 f_F_WB_STAGE<=2'b00;//DEFAULT
				 f_E_MEM_STAGE<=2'b00;//DEFAULT
				 stall<=1'b0;
				 hazard_detect<=1'b0;
				 end
	else   //DEFAULT
			    begin
				 for_MUX_ALU_OP1_SELECT<=2'b00;//DEFAULT
				 for_MUX_ALU_OP2_SELECT<=2'b00;//DEFAULT
				 for_MUX_D2_MUX_SELECT<=2'b00;//DEFAULT
				 f_F_WB_STAGE<=2'b00;//DEFAULT
				 f_E_MEM_STAGE<=2'b00;//DEFAULT
				 stall<=1'b0;
				 hazard_detect<=1'b0;			 
				 end
else if (INS_WORD_CURRENT[15:12]==4'b0101)  //CURRENT -SW
   if (INS_WORD_PREV[15:12]==4'b0000 || INS_WORD_PREV[15:12]==4'b0010)//PREV-R-TYPE
           if (INS_WORD_CURRENT[8:6]==INS_WORD_PREV[5:3])//SOURCE OPERAND_1_MATCH
			    begin
				 for_MUX_ALU_OP1_SELECT<=2'b01;//FROM MEM STAGE
				 for_MUX_ALU_OP2_SELECT<=2'b11;//IMMEDIATE OPERAND
				 for_MUX_D2_MUX_SELECT<=2'b00;
				 f_F_WB_STAGE<=2'b00;//NOT NEEDED
				 f_E_MEM_STAGE<=2'b00;//ALU OUTPUT OF MEM_STAGE_SELECTED
				 stall<=1'b0;
             hazard_detect<=1'b1;
             end
	        else if (INS_WORD_CURRENT[11:9]==INS_WORD_PREV[5:3])
				 begin
				 for_MUX_ALU_OP1_SELECT<=2'b00;
				 for_MUX_ALU_OP2_SELECT<=2'b11;
				 for_MUX_D2_MUX_SELECT<=2'b01;//FROM MEMORY STAGE
				 f_F_WB_STAGE<=2'b00;//NOT NEEDED
				 f_E_MEM_STAGE<=2'b00;//ALU OUTPUT OF MEM_STAGE_SELECTED
				 stall<=1'b0;
             hazard_detect<=1'b1;
				end
				else                         //DEFAULT ALL 0
             begin
				 for_MUX_ALU_OP1_SELECT<=2'b00;//DEFAULT
				 for_MUX_ALU_OP2_SELECT<=2'b00;//DEFAULT
				 for_MUX_D2_MUX_SELECT<=2'b00;//DEFAULT
				 f_F_WB_STAGE<=2'b00;//DEFAULT
	  			 f_E_MEM_STAGE<=2'b00;//DEFAULT
             stall<=1'b0;
             hazard_detect<=1'b0;
             end 				 
	else if (INS_WORD_PREV[15:12]==4'b0001)//PREV-ADI
           if (INS_WORD_CURRENT[8:6]==INS_WORD_PREV[8:6])//SOURCE OPERAND_1_MATCH
			    begin
				 for_MUX_ALU_OP1_SELECT<=2'b01;//FROM MEM STAGE
				 for_MUX_ALU_OP2_SELECT<=2'b11;//IMMEDIATE OPERAND
				 for_MUX_D2_MUX_SELECT<=2'b00;
				 f_F_WB_STAGE<=2'b00;//NOT NEEDED
				 f_E_MEM_STAGE<=2'b00;//ALU OUTPUT OF MEM_STAGE_FORWARDED
				 stall<=1'b0;
             hazard_detect<=1'b1;
				end
				else if (INS_WORD_CURRENT[11:9]==INS_WORD_PREV[8:6])//SOURCE OPERAND_1_MATCH
			    begin
				 for_MUX_ALU_OP1_SELECT<=2'b00;//
				 for_MUX_ALU_OP2_SELECT<=2'b11;//
				 for_MUX_D2_MUX_SELECT<=2'b01;//FROM MEM STAGE
				 f_F_WB_STAGE<=2'b00;//NOT NEEDED
				 f_E_MEM_STAGE<=2'b00;//ALU OUTPUT OF MEM_STAGE_FORWARDED
				 stall<=1'b0;
             hazard_detect<=1'b1;
             end
				 else                         //DEFAULT ALL 0
             begin
				 for_MUX_ALU_OP1_SELECT<=2'b00;//DEFAULT
				 for_MUX_ALU_OP2_SELECT<=2'b00;//DEFAULT
				 for_MUX_D2_MUX_SELECT<=2'b00;//DEFAULT
				 f_F_WB_STAGE<=2'b00;//DEFAULT
				 f_E_MEM_STAGE<=2'b00;//DEFAULT
				 stall<=1'b0;
             hazard_detect<=1'b0;
				 end
	else if (INS_WORD_PREV[15:12]==4'b0011)//PREV-LHI
           if (INS_WORD_CURRENT[8:6]==INS_WORD_PREV[11:9])//SOURCE OPERAND_1_MATCH
			    begin
				 for_MUX_ALU_OP1_SELECT<=2'b01;//FROM MEM STAGE
				 for_MUX_ALU_OP2_SELECT<=2'b11;//IMMEDIATE OPERAND
				 for_MUX_D2_MUX_SELECT<=2'b00;
				 f_F_WB_STAGE<=2'b00;//NOT NEEDED
				 f_E_MEM_STAGE<=2'b10;//0pad OF MEM_STAGE_FORWARDED
				 stall<=1'b0;
             hazard_detect<=1'b1;
				 end
			  else if (INS_WORD_CURRENT[11:9]==INS_WORD_PREV[11:9])//SOURCE OPERAND_1_MATCH
			    begin
				 for_MUX_ALU_OP1_SELECT<=2'b00;
				 for_MUX_ALU_OP2_SELECT<=2'b11;
				 for_MUX_D2_MUX_SELECT<=2'b01;//FROM MEM STAGE
				 f_F_WB_STAGE<=2'b00;//NOT NEEDED
				 f_E_MEM_STAGE<=2'b10;//0pad OF MEM_STAGE_FORWARDED 
				 stall<=1'b0;
             hazard_detect<=1'b1;
				 end
             else                         //DEFAULT ALL 0
             begin
				 for_MUX_ALU_OP1_SELECT<=2'b00;//DEFAULT
				 for_MUX_ALU_OP2_SELECT<=2'b00;//DEFAULT
				 for_MUX_D2_MUX_SELECT<=2'b00;//DEFAULT
				 f_F_WB_STAGE<=2'b00;//DEFAULT
				 f_E_MEM_STAGE<=2'b00;//DEFAULT
				 stall<=1'b0;
             hazard_detect<=1'b0;
				 end
	else if (INS_WORD_PREV[15:12]==4'b1000 || INS_WORD_PREV[15:12]==4'b1001)//PREV-JAL or JLR
           if (INS_WORD_CURRENT[8:6]==INS_WORD_PREV[11:9])//SOURCE OPERAND_1_MATCH
			    begin
				 for_MUX_ALU_OP1_SELECT<=2'b01;//FROM MEM STAGE
				 for_MUX_ALU_OP2_SELECT<=2'b11;//IMMEDIATE OPERAND
				 for_MUX_D2_MUX_SELECT<=2'b00;
				 f_F_WB_STAGE<=2'b00;//NOT NEEDED
				 f_E_MEM_STAGE<=2'b01;//PC+1 OF MEM_STAGE_FORWARDED
				 stall<=1'b0;
             hazard_detect<=1'b1;
				end
				else if (INS_WORD_CURRENT[11:9]==INS_WORD_PREV[11:9])//SOURCE OPERAND_1_MATCH
			    begin
				 for_MUX_ALU_OP1_SELECT<=2'b00;
				 for_MUX_ALU_OP2_SELECT<=2'b11;//IMMEDIATE OPERAND
				 for_MUX_D2_MUX_SELECT<=2'b01;//FROM MEM STAGE
				 f_F_WB_STAGE<=2'b00;//NOT NEEDED
				 f_E_MEM_STAGE<=2'b01;//PC+1 OF MEM_STAGE_FORWARDED 
				 stall<=1'b0;
             hazard_detect<=1'b1;
				 end
             else                         //DEFAULT ALL 0
             begin
				 for_MUX_ALU_OP1_SELECT<=2'b00;//DEFAULT
				 for_MUX_ALU_OP2_SELECT<=2'b00;//DEFAULT
				 for_MUX_D2_MUX_SELECT<=2'b00;//DEFAULT
				 f_F_WB_STAGE<=2'b00;//DEFAULT
				 f_E_MEM_STAGE<=2'b00;//DEFAULT
				 stall<=1'b0;
             hazard_detect<=1'b0;
				 end
	else if (INS_WORD_PREV[15:12]==4'b0100 ) // PREV-LW
				 if (INS_WORD_CURRENT[8:6]==INS_WORD_PREV[11:9]  || INS_WORD_CURRENT[11:9]==INS_WORD_PREV[11:9])//SOURCE OPERAND_1_MATCH
			    begin
				 for_MUX_ALU_OP1_SELECT<=2'b00;//DEFAULT
				 for_MUX_ALU_OP2_SELECT<=2'b00;//DEFAULT
				 for_MUX_D2_MUX_SELECT<=2'b00;//DEFAULT
				 f_F_WB_STAGE<=2'b00;//DEFAULT
				 f_E_MEM_STAGE<=2'b00;//DEFAULT
				 stall<=1'b1;
             hazard_detect<=1'b1;
             end
				 else   //DEFAULT
			    begin
				 for_MUX_ALU_OP1_SELECT<=2'b00;//DEFAULT
				 for_MUX_ALU_OP2_SELECT<=2'b00;//DEFAULT
				 for_MUX_D2_MUX_SELECT<=2'b00;//DEFAULT
				 f_F_WB_STAGE<=2'b00;//DEFAULT
				 f_E_MEM_STAGE<=2'b00;//DEFAULT
				 stall<=1'b0;
             hazard_detect<=1'b0;
             end 				 
   else   //DEFAULT
			    begin
				 for_MUX_ALU_OP1_SELECT<=2'b00;//DEFAULT
				 for_MUX_ALU_OP2_SELECT<=2'b00;//DEFAULT
				 for_MUX_D2_MUX_SELECT<=2'b00;//DEFAULT
				 f_F_WB_STAGE<=2'b00;//DEFAULT
				 f_E_MEM_STAGE<=2'b00;//DEFAULT
				 stall<=1'b0;
             hazard_detect<=1'b0;
				end 
else if (INS_WORD_CURRENT[15:12]==4'b1001)  //CURRENT -JLR
   if (INS_WORD_PREV[15:12]==4'b0000 || INS_WORD_PREV[15:12]==4'b0010)//PREV-R-TYPE
           
             if (INS_WORD_CURRENT[8:6]==INS_WORD_PREV[5:3])
				 begin
				 for_MUX_ALU_OP1_SELECT<=2'b00;
				 for_MUX_ALU_OP2_SELECT<=2'b00;
				 for_MUX_D2_MUX_SELECT<=2'b01;//FROM MEMORY STAGE
				 f_F_WB_STAGE<=2'b00;//NOT NEEDED
				 f_E_MEM_STAGE<=2'b00;//ALU OUTPUT OF MEM_STAGE_SELECTED
				 stall<=1'b0;
             hazard_detect<=1'b1;
				 end
				 else                         //DEFAULT ALL 0
             begin
				 for_MUX_ALU_OP1_SELECT<=2'b00;//DEFAULT
				 for_MUX_ALU_OP2_SELECT<=2'b00;//DEFAULT
				 for_MUX_D2_MUX_SELECT<=2'b00;//DEFAULT
				 f_F_WB_STAGE<=2'b00;//DEFAULT
	  			 f_E_MEM_STAGE<=2'b00;//DEFAULT
             stall<=1'b0;
             hazard_detect<=1'b0;
             end				 
	else if (INS_WORD_PREV[15:12]==4'b0001)//PREV-ADI
          
				 if (INS_WORD_CURRENT[8:6]==INS_WORD_PREV[8:6])//SOURCE OPERAND_1_MATCH
			    begin
				 for_MUX_ALU_OP1_SELECT<=2'b00;//
				 for_MUX_ALU_OP2_SELECT<=2'b00;//
				 for_MUX_D2_MUX_SELECT<=2'b01;//FROM MEM STAGE
				 f_F_WB_STAGE<=2'b00;//NOT NEEDED
				 f_E_MEM_STAGE<=2'b00;//ALU OUTPUT OF MEM_STAGE_FORWARDED
				 stall<=1'b0;
             hazard_detect<=1'b1;
				 end
             else                         //DEFAULT ALL 0
             begin
				 for_MUX_ALU_OP1_SELECT<=2'b00;//DEFAULT
				 for_MUX_ALU_OP2_SELECT<=2'b00;//DEFAULT
				 for_MUX_D2_MUX_SELECT<=2'b00;//DEFAULT
				 f_F_WB_STAGE<=2'b00;//DEFAULT
				 f_E_MEM_STAGE<=2'b00;//DEFAULT
				 stall<=1'b0;
             hazard_detect<=1'b0;
				 end
	else if (INS_WORD_PREV[15:12]==4'b0011)//PREV-LHI				 
			   if (INS_WORD_CURRENT[8:6]==INS_WORD_PREV[11:9])//SOURCE OPERAND_1_MATCH
			  begin  
				 for_MUX_ALU_OP1_SELECT<=2'b00;
				 for_MUX_ALU_OP2_SELECT<=2'b00;
				 for_MUX_D2_MUX_SELECT<=2'b01;//FROM MEM STAGE
				 f_F_WB_STAGE<=2'b00;//NOT NEEDED
				 f_E_MEM_STAGE<=2'b10;//0pad OF MEM_STAGE_FORWARDED 
				 stall<=1'b0;
             hazard_detect<=1'b1;
				end
             else                         //DEFAULT ALL 0
         begin   
				for_MUX_ALU_OP1_SELECT<=2'b00;//DEFAULT
				 for_MUX_ALU_OP2_SELECT<=2'b00;//DEFAULT
				 for_MUX_D2_MUX_SELECT<=2'b00;//DEFAULT
				 f_F_WB_STAGE<=2'b00;//DEFAULT
				 f_E_MEM_STAGE<=2'b00;//DEFAULT
				 stall<=1'b0;
             hazard_detect<=1'b0;
			end
	else if (INS_WORD_PREV[15:12]==4'b1000 || INS_WORD_PREV[15:12]==4'b1001)//PREV-JAL or JLR
         
			 if (INS_WORD_CURRENT[8:6]==INS_WORD_PREV[11:9])//SOURCE OPERAND_1_MATCH
			    begin
				 for_MUX_ALU_OP1_SELECT<=2'b00;
				 for_MUX_ALU_OP2_SELECT<=2'b00;//IMMEDIATE OPERAND
				 for_MUX_D2_MUX_SELECT<=2'b01;//FROM MEM STAGE
				 f_F_WB_STAGE<=2'b00;//NOT NEEDED
				 f_E_MEM_STAGE<=2'b01;//PC+1 OF MEM_STAGE_FORWARDED 
				 stall<=1'b0;
             hazard_detect<=1'b1;
				 end
				 
             else                         //DEFAULT ALL 0
             begin
				 for_MUX_ALU_OP1_SELECT<=2'b00;//DEFAULT
				 for_MUX_ALU_OP2_SELECT<=2'b00;//DEFAULT
				 for_MUX_D2_MUX_SELECT<=2'b00;//DEFAULT
				 f_F_WB_STAGE<=2'b00;//DEFAULT
				 f_E_MEM_STAGE<=2'b00;//DEFAULT
				 stall<=1'b0;
             hazard_detect<=1'b0;
				 end
	else if (INS_WORD_PREV[15:12]==4'b0100 ) // PREV-LW
			    if (INS_WORD_CURRENT[8:6]==INS_WORD_PREV[11:9])//SOURCE OPERAND_1_MATCH
			    begin 
				 for_MUX_ALU_OP1_SELECT<=2'b00;//DEFAULT
				 for_MUX_ALU_OP2_SELECT<=2'b00;//DEFAULT
				 for_MUX_D2_MUX_SELECT<=2'b00;//DEFAULT
				 f_F_WB_STAGE<=2'b00;//DEFAULT
				 f_E_MEM_STAGE<=2'b00;//DEFAULT
				 stall<=1'b1;
             hazard_detect<=1'b1;
             end
				 else   //DEFAULT
			    begin
				 for_MUX_ALU_OP1_SELECT<=2'b00;//DEFAULT
				 for_MUX_ALU_OP2_SELECT<=2'b00;//DEFAULT
				 for_MUX_D2_MUX_SELECT<=2'b00;//DEFAULT
				 f_F_WB_STAGE<=2'b00;//DEFAULT
				 f_E_MEM_STAGE<=2'b00;//DEFAULT
				 stall<=1'b0;
             hazard_detect<=1'b0;
            end 				 
   else   //DEFAULT
		   begin	 for_MUX_ALU_OP1_SELECT<=2'b00;//DEFAULT
				 for_MUX_ALU_OP2_SELECT<=2'b00;//DEFAULT
				 for_MUX_D2_MUX_SELECT<=2'b00;//DEFAULT
				 f_F_WB_STAGE<=2'b00;//DEFAULT
				 f_E_MEM_STAGE<=2'b00;//DEFAULT
				 stall<=1'b0;
             hazard_detect<=1'b0; 	
		    end
else     //DEFAULT
		begin
			    for_MUX_ALU_OP1_SELECT<=2'b00;//DEFAULT
				 for_MUX_ALU_OP2_SELECT<=2'b00;//DEFAULT
				 for_MUX_D2_MUX_SELECT<=2'b00;//DEFAULT
				 f_F_WB_STAGE<=2'b00;//DEFAULT
				 f_E_MEM_STAGE<=2'b00;//DEFAULT
				 stall<=1'b0;
             hazard_detect<=1'b0;
		end 
end
   
endmodule