module Forwarding_logic(OPCODE_CURRENT,OPCODE_PREVIOUS,OPCODE_PREV_PREV,RS1_CURRENT,RS2_CURRENT,RD_PREVIOUS,RD_PREV_PREV,RS1_C_VALID,RS2_C_VALID,RD_P_VALID,RD_PP_VALID,for_MUX_ALU_OP1_SELECT,for_MUX_ALU_OP2_SELECT,for_MUX_D2_MUX_SELECT,f_E_MEM_STAGE,f_F_WB_STAGE,for_MUX_ALU_OP1_SELECT_VALID,for_MUX_ALU_OP2_SELECT_VALID,for_MUX_D2_MUX_SELECT_VALID,f_E_MEM_STAGE_VALID,f_F_WB_STAGE_VALID,hazard_detect,stall);

input [5:0] OPCODE_CURRENT, OPCODE_PREVIOUS,OPCODE_PREV_PREV;
input [2:0] RS1_CURRENT,RS2_CURRENT,RD_PREVIOUS,RD_PREV_PREV;
input RS1_C_VALID,RS2_C_VALID,RD_P_VALID,RD_PP_VALID;

output  reg hazard_detect;
output  reg stall;
output reg [1:0] for_MUX_ALU_OP1_SELECT,for_MUX_ALU_OP2_SELECT,for_MUX_D2_MUX_SELECT;
output reg [1:0] f_E_MEM_STAGE,f_F_WB_STAGE;

output reg for_MUX_ALU_OP1_SELECT_VALID,for_MUX_ALU_OP2_SELECT_VALID,for_MUX_D2_MUX_SELECT_VALID,f_E_MEM_STAGE_VALID,f_F_WB_STAGE_VALID;

always@(*)
begin

if (RD_PREVIOUS==RS1_CURRENT && RD_P_VALID==1'b1 && RS1_C_VALID==1'b1)
begin
	case (OPCODE_PREVIOUS[5:2])
		4'b0000: begin                                          //ADD-RTYPE
		          for_MUX_ALU_OP1_SELECT<=2'b01;//FROM MEM STAGE
					 for_MUX_ALU_OP1_SELECT_VALID<=1'b1;		    

					 f_E_MEM_STAGE<=2'b00;//ALU OUTPUT OF MEM_STAGE_SELECTED
				    f_E_MEM_STAGE_VALID<=1'b1;
					 stall<=1'b0;
				    hazard_detect<=1'b1;
					 end
       
		4'b0010: begin                                          //NAND-RTYPE
		          for_MUX_ALU_OP1_SELECT<=2'b01;//FROM MEM STAGE
					 for_MUX_ALU_OP1_SELECT_VALID<=1'b1;
				   
					 

					 f_E_MEM_STAGE<=2'b00;//ALU OUTPUT OF MEM_STAGE_SELECTED
				    f_E_MEM_STAGE_VALID<=1'b1;
					 stall<=1'b0;
				    hazard_detect<=1'b1;
					 end
     
      4'b0001: begin                                          //ADI
		          for_MUX_ALU_OP1_SELECT<=2'b01;//FROM MEM STAGE
					 for_MUX_ALU_OP1_SELECT_VALID<=1'b1;

					 
					 f_E_MEM_STAGE<=2'b00;//ALU OUTPUT OF MEM_STAGE_SELECTED
				    f_E_MEM_STAGE_VALID<=1'b1;
					 stall<=1'b0;
				    hazard_detect<=1'b1;
					 end 
					 
		
      4'b0011: begin                                          //LHI
		          for_MUX_ALU_OP1_SELECT<=2'b01;//FROM MEM STAGE
					 for_MUX_ALU_OP1_SELECT_VALID<=1'b1;

					 

					 f_E_MEM_STAGE<=2'b10;//O PAD OF MEM_STAGE_FORWARDED
				    f_E_MEM_STAGE_VALID<=1'b1;
					 stall<=1'b0;
				    hazard_detect<=1'b1;
					 end 	
					 
		4'b1000: begin                                          //JAL
		          for_MUX_ALU_OP1_SELECT<=2'b01;//FROM MEM STAGE
					 for_MUX_ALU_OP1_SELECT_VALID<=1'b1;

					 
					 f_E_MEM_STAGE<=2'b01;//PC+1 OF MEM_STAGE_FORWARDED
				    f_E_MEM_STAGE_VALID<=1'b1;
					 stall<=1'b0;
				    hazard_detect<=1'b1;
					 end 			 
					 
      4'b1001: begin                                          //JLR
		          for_MUX_ALU_OP1_SELECT<=2'b01;//FROM MEM STAGE
					 for_MUX_ALU_OP1_SELECT_VALID<=1'b1;

					 
					 f_E_MEM_STAGE<=2'b01;//PC+1 OF MEM_STAGE_FORWARDED
				    f_E_MEM_STAGE_VALID<=1'b1;
					 stall<=1'b0;
				    hazard_detect<=1'b1;
					 end 	
					 
		4'b0100: begin                          //LW
		          for_MUX_ALU_OP1_SELECT<=2'b00;//DEFAULT
					 for_MUX_ALU_OP1_SELECT_VALID<=1'b0;


					
					 f_E_MEM_STAGE<=2'b00;//
				    f_E_MEM_STAGE_VALID<=1'b0;
					 stall<=1'b1;//LW STALL
				    hazard_detect<=1'b1;//LW HAZARD
					end
     default: begin                //DEFAULT
	             for_MUX_ALU_OP1_SELECT<=2'b00;//DEFAULT
					 for_MUX_ALU_OP1_SELECT_VALID<=1'b0;

					 f_E_MEM_STAGE<=2'b00;
				    f_E_MEM_STAGE_VALID<=1'b0;
					 stall<=1'b0;
				    hazard_detect<=1'b0;//DEFAULT
					end
	endcase
		
	if (RD_PREV_PREV==RS2_CURRENT && RD_PP_VALID==1'b1 && RS2_C_VALID==1'b1 && (OPCODE_CURRENT[5:2]!=4'b0101)) 	 
		    if(OPCODE_PREV_PREV[5:2]==4'b0000 || OPCODE_PREV_PREV[5:2]==4'b0010 ||OPCODE_PREV_PREV[5:2]==4'b0001) //RTYPE AND ADI
			    begin
				 for_MUX_ALU_OP2_SELECT<=2'b10;  //FROM WB STAGE
			    for_MUX_ALU_OP2_SELECT_VALID<=1'b1;
				 f_F_WB_STAGE<=2'b00;//ALU OUTPUT FROM WB STAGE
				 f_F_WB_STAGE_VALID<=1'b1;
				 for_MUX_D2_MUX_SELECT<=2'b00;
				 for_MUX_D2_MUX_SELECT_VALID<=1'b0;
		       end
			 else if (OPCODE_PREV_PREV[5:2]==4'b0011)   //LHI
	          begin
				 for_MUX_ALU_OP2_SELECT<=2'b10;  //FROM WB STAGE
			    for_MUX_ALU_OP2_SELECT_VALID<=1'b1;
				 f_F_WB_STAGE<=2'b10;//OPAD FROM WB STAGE
				 f_F_WB_STAGE_VALID<=1'b1;
				 for_MUX_D2_MUX_SELECT<=2'b00;
				 for_MUX_D2_MUX_SELECT_VALID<=1'b0;
		       end
          else if (OPCODE_PREV_PREV[5:2]==4'b1000 || OPCODE_PREV_PREV[5:2]==4'b1001) //JAL,JLR
             begin
				 for_MUX_ALU_OP2_SELECT<=2'b10;  //FROM WB STAGE
			    for_MUX_ALU_OP2_SELECT_VALID<=1'b1;
				 f_F_WB_STAGE<=2'b01;//PC+1 FROM WB STAGE
				 f_F_WB_STAGE_VALID<=1'b1;
				 for_MUX_D2_MUX_SELECT<=2'b00;
				 for_MUX_D2_MUX_SELECT_VALID<=1'b0;
		       end 
			 else if (OPCODE_PREV_PREV[5:2]==4'b0100) //LW
	          begin
				 for_MUX_ALU_OP2_SELECT<=2'b10;  //FROM WB STAGE
			    for_MUX_ALU_OP2_SELECT_VALID<=1'b1;
				 f_F_WB_STAGE<=2'b11;//DATA_OUT FROM WB STAGE
				 f_F_WB_STAGE_VALID<=1'b1;
				 for_MUX_D2_MUX_SELECT<=2'b00;
				 for_MUX_D2_MUX_SELECT_VALID<=1'b0;
		       end 
		    else
				 begin
				 for_MUX_ALU_OP2_SELECT<=2'b00;  //DEFAULT
			    for_MUX_ALU_OP2_SELECT_VALID<=1'b0;
				 f_F_WB_STAGE<=2'b00;//DATA_OUT FROM WB STAGE
				 f_F_WB_STAGE_VALID<=1'b0;
				 for_MUX_D2_MUX_SELECT<=2'b00;
				 for_MUX_D2_MUX_SELECT_VALID<=1'b0;
		       end 

	
	else if (RD_PREV_PREV==RS2_CURRENT && RD_PP_VALID==1'b1 && RS2_C_VALID==1'b1 && (OPCODE_CURRENT[5:2]==4'b0101) )    	 		
		if(OPCODE_PREV_PREV[5:2]==4'b0000 || OPCODE_PREV_PREV[5:2]==4'b0010 ||OPCODE_PREV_PREV[5:2]==4'b0001) //RTYPE AND ADI
			    begin
				 for_MUX_ALU_OP2_SELECT<=2'b00;  
			    for_MUX_ALU_OP2_SELECT_VALID<=1'b0;
				 f_F_WB_STAGE<=2'b00;//ALU OUTPUT FROM WB STAGE
				 f_F_WB_STAGE_VALID<=1'b1;
				 for_MUX_D2_MUX_SELECT<=2'b10;//FROM WB STAGE
				 for_MUX_D2_MUX_SELECT_VALID<=1'b1;
		       end
			 else if (OPCODE_PREV_PREV[5:2]==4'b0011)   //LHI
	          begin
				 for_MUX_ALU_OP2_SELECT<=2'b00; 
			    for_MUX_ALU_OP2_SELECT_VALID<=1'b0;
				 f_F_WB_STAGE<=2'b10;//OPAD FROM WB STAGE
				 f_F_WB_STAGE_VALID<=1'b1;
		       for_MUX_D2_MUX_SELECT<=2'b10; //FROM WB STAGE
				for_MUX_D2_MUX_SELECT_VALID<=1'b1;
				 end
          else if (OPCODE_PREV_PREV[5:2]==4'b1000 || OPCODE_PREV_PREV[5:2]==4'b1001) //JAL,JLR
             begin
				 for_MUX_ALU_OP2_SELECT<=2'b00;  
			    for_MUX_ALU_OP2_SELECT_VALID<=1'b0;
				 f_F_WB_STAGE<=2'b01;//PC+1 FROM WB STAGE
				 f_F_WB_STAGE_VALID<=1'b1;
				 for_MUX_D2_MUX_SELECT<=2'b10; //FROM WB STAGE
				 for_MUX_D2_MUX_SELECT_VALID<=1'b1;
		      
				end 
			 else if (OPCODE_PREV_PREV[5:2]==4'b0100) //LW
	          begin
				 for_MUX_ALU_OP2_SELECT<=2'b00;  
			    for_MUX_ALU_OP2_SELECT_VALID<=1'b0;
				 f_F_WB_STAGE<=2'b11;//DATA_OUT FROM WB STAGE
				 f_F_WB_STAGE_VALID<=1'b1;
		       for_MUX_D2_MUX_SELECT<=2'b10; //FROM WB STAGE
				 for_MUX_D2_MUX_SELECT_VALID<=1'b1;
				 
				 end 
		    else
				 begin
				 for_MUX_ALU_OP2_SELECT<=2'b00;  //DEFAULT
			    for_MUX_ALU_OP2_SELECT_VALID<=1'b0;
				 f_F_WB_STAGE<=2'b00;//DATA_OUT FROM WB STAGE
				 f_F_WB_STAGE_VALID<=1'b0;
		       for_MUX_D2_MUX_SELECT<=2'b00; //DEFAULT
				 for_MUX_D2_MUX_SELECT_VALID<=1'b0;
				 
				 end 
	   
         	
	
	else
				 begin
				 for_MUX_ALU_OP2_SELECT<=2'b00;  //DEFAULT
			    for_MUX_ALU_OP2_SELECT_VALID<=1'b0;
				 f_F_WB_STAGE<=2'b00;//DATA_OUT FROM WB STAGE
				 f_F_WB_STAGE_VALID<=1'b0;
				 for_MUX_D2_MUX_SELECT<=2'b00; //DEFAULT
				 for_MUX_D2_MUX_SELECT_VALID<=1'b0;
				 
				 
		       end 	

	
	end		

	
	
	//FORWARDING MUX 2 (EXCEPT JLR AND SW)		
		
else if (RD_PREVIOUS==RS2_CURRENT && RD_P_VALID==1'b1 && RS2_C_VALID==1'b1 && OPCODE_CURRENT[5:2]!=4'b0101 && OPCODE_CURRENT[5:2]!=4'b1001 && OPCODE_CURRENT[5:2]!=4'b0111)
 begin
 case (OPCODE_PREVIOUS[5:2])
		 4'b0000: begin                                          //ADD-RTYPE
		          
				    for_MUX_ALU_OP2_SELECT<=2'b01;//FROM MEM STAGE
					 for_MUX_ALU_OP2_SELECT_VALID<=1'b1;
				    for_MUX_D2_MUX_SELECT<=2'b00;
					 for_MUX_D2_MUX_SELECT_VALID<=1'b0;
					 
				    
					 f_E_MEM_STAGE<=2'b00;//ALU OUTPUT OF MEM_STAGE_SELECTED
				    f_E_MEM_STAGE_VALID<=1'b1;
					 stall<=1'b0;
				    hazard_detect<=1'b1;
					 end
       
		 4'b0010: begin                                          //NAND-RTYPE
		       
				    for_MUX_ALU_OP2_SELECT<=2'b01;//FROM MEM STAGE
					 for_MUX_ALU_OP2_SELECT_VALID<=1'b1;
				    for_MUX_D2_MUX_SELECT<=2'b00;
					 for_MUX_D2_MUX_SELECT_VALID<=1'b0;
					 

					 f_E_MEM_STAGE<=2'b00;//ALU OUTPUT OF MEM_STAGE_SELECTED
				    f_E_MEM_STAGE_VALID<=1'b1;
					 stall<=1'b0;
				    hazard_detect<=1'b1;
					 end
     
       4'b0001: begin                                          //ADI
		          
				    for_MUX_ALU_OP2_SELECT<=2'b01;//FROM MEM STAGE
					 for_MUX_ALU_OP2_SELECT_VALID<=1'b1;
				    for_MUX_D2_MUX_SELECT<=2'b00;
					 for_MUX_D2_MUX_SELECT_VALID<=1'b0;

					 f_E_MEM_STAGE<=2'b00;//ALU OUTPUT OF MEM_STAGE_SELECTED
				    f_E_MEM_STAGE_VALID<=1'b1;
					 stall<=1'b0;
				    hazard_detect<=1'b1;
					 end 
					 
		
       4'b0011: begin                                          //LHI
		          
				    for_MUX_ALU_OP2_SELECT<=2'b01;//FROM MEM STAGE
					 for_MUX_ALU_OP2_SELECT_VALID<=1'b1;
				    for_MUX_D2_MUX_SELECT<=2'b00;
					 for_MUX_D2_MUX_SELECT_VALID<=1'b0;
					 

					 f_E_MEM_STAGE<=2'b10;//O PAD OF MEM_STAGE_FORWARDED
				    f_E_MEM_STAGE_VALID<=1'b1;
					 stall<=1'b0;
				    hazard_detect<=1'b1;
					 end 	
					 
		4'b1000: begin                                          //JAL
		        
				    for_MUX_ALU_OP2_SELECT<=2'b01;//FROM MEM STAGE
					 for_MUX_ALU_OP2_SELECT_VALID<=1'b1;
				    for_MUX_D2_MUX_SELECT<=2'b00;
					 for_MUX_D2_MUX_SELECT_VALID<=1'b0;

					 f_E_MEM_STAGE<=2'b01;//PC+1 OF MEM_STAGE_FORWARDED
				    f_E_MEM_STAGE_VALID<=1'b1;
					 stall<=1'b0;
				    hazard_detect<=1'b1;
					 end 			 
					 
      4'b1001: begin                                          //JLR
		          
				    for_MUX_ALU_OP2_SELECT<=2'b01;//FROM MEM STAGE
					 for_MUX_ALU_OP2_SELECT_VALID<=1'b1;
				    for_MUX_D2_MUX_SELECT<=2'b00;
					 for_MUX_D2_MUX_SELECT_VALID<=1'b0;

					 f_E_MEM_STAGE<=2'b01;//PC+1 OF MEM_STAGE_FORWARDED
				    f_E_MEM_STAGE_VALID<=1'b1;
					 stall<=1'b0;
				    hazard_detect<=1'b1;
					 end 	
		4'b0100: begin                          //LW
				    for_MUX_ALU_OP2_SELECT<=2'b00;
					 for_MUX_ALU_OP2_SELECT_VALID<=1'b0;
				    for_MUX_D2_MUX_SELECT<=2'b00;
					 for_MUX_D2_MUX_SELECT_VALID<=1'b0;
					 

					 f_E_MEM_STAGE<=2'b00;//
				    f_E_MEM_STAGE_VALID<=1'b0;
					 stall<=1'b1;//LW STALL
				    hazard_detect<=1'b1;//LW HAZARD
					end
					 
     default: begin                //DEFAULT
	             for_MUX_ALU_OP1_SELECT<=2'b00;//DEFAULT
					 for_MUX_ALU_OP1_SELECT_VALID<=1'b0;
				    for_MUX_ALU_OP2_SELECT<=2'b00;
					 for_MUX_ALU_OP1_SELECT_VALID<=1'b0;
				    for_MUX_D2_MUX_SELECT<=2'b00;
					 for_MUX_D2_MUX_SELECT_VALID<=1'b0;
					 
				    f_F_WB_STAGE<=2'b00;//NOT NEEDED
				    f_F_WB_STAGE_VALID<=1'b0;
					 f_E_MEM_STAGE<=2'b00;
				    f_E_MEM_STAGE_VALID<=1'b0;
					 stall<=1'b0;
				    hazard_detect<=1'b0;//DEFAULT
					end
		endcase

 if (RD_PREV_PREV==RS1_CURRENT && RD_PP_VALID==1'b1 && RS1_C_VALID==1'b1)        		 
		    if(OPCODE_PREV_PREV[5:2]==4'b0000 || OPCODE_PREV_PREV[5:2]==4'b0010 ||OPCODE_PREV_PREV[5:2]==4'b0001) //RTYPE AND ADI
			    begin
				 for_MUX_ALU_OP1_SELECT<=2'b10;  //FROM WB STAGE
			    for_MUX_ALU_OP1_SELECT_VALID<=1'b1;
				 f_F_WB_STAGE<=2'b00;//ALU OUTPUT FROM WB STAGE
				 f_F_WB_STAGE_VALID<=1'b1;
		       end
			 else if (OPCODE_PREV_PREV[5:2]==4'b0011)   //LHI
	          begin
				 for_MUX_ALU_OP1_SELECT<=2'b10;  //FROM WB STAGE
			    for_MUX_ALU_OP1_SELECT_VALID<=1'b1;
				 f_F_WB_STAGE<=2'b10;//OPAD FROM WB STAGE
				 f_F_WB_STAGE_VALID<=1'b1;
		       end
          else if (OPCODE_PREV_PREV[5:2]==4'b1000 || OPCODE_PREV_PREV[5:2]==4'b1001) //JAL,JLR
             begin
				 for_MUX_ALU_OP1_SELECT<=2'b10;  //FROM WB STAGE
			    for_MUX_ALU_OP1_SELECT_VALID<=1'b1;
				 f_F_WB_STAGE<=2'b01;//PC+1 FROM WB STAGE
				 f_F_WB_STAGE_VALID<=1'b1;
		       end 
			 else if (OPCODE_PREV_PREV[5:2]==4'b0100) //LW
	          begin
				 for_MUX_ALU_OP1_SELECT<=2'b10;  //FROM WB STAGE
			    for_MUX_ALU_OP1_SELECT_VALID<=1'b1;
				 f_F_WB_STAGE<=2'b11;//DATA_OUT FROM WB STAGE
				 f_F_WB_STAGE_VALID<=1'b1;
		       end 
		    else
				 begin
				 for_MUX_ALU_OP1_SELECT<=2'b00;  //DEFAULT
			    for_MUX_ALU_OP1_SELECT_VALID<=1'b0;
				 f_F_WB_STAGE<=2'b00;//DATA_OUT FROM WB STAGE
				 f_F_WB_STAGE_VALID<=1'b0;
		       end 
	   
else
				 begin
				 for_MUX_ALU_OP1_SELECT<=2'b00;  //DEFAULT
			    for_MUX_ALU_OP1_SELECT_VALID<=1'b0;
				 f_F_WB_STAGE<=2'b00;//DATA_OUT FROM WB STAGE
				 f_F_WB_STAGE_VALID<=1'b0;
		        
	          end
		 	
		

end

		//D2 MUX FORWARDING FOR JLR AND SW		
		
else if (RD_PREVIOUS==RS2_CURRENT && RD_P_VALID==1'b1 && RS2_C_VALID==1'b1 && (OPCODE_CURRENT[5:2]==4'b0101 || OPCODE_CURRENT[5:2]==4'b1001 || OPCODE_CURRENT[5:2]==4'b0111))
begin 
 case (OPCODE_PREVIOUS[5:2])
		 4'b0000: begin                                          //ADD-RTYPE
		        
				    for_MUX_ALU_OP2_SELECT<=2'b00;
					 for_MUX_ALU_OP2_SELECT_VALID<=1'b0;
				    for_MUX_D2_MUX_SELECT<=2'b01;
					 for_MUX_D2_MUX_SELECT_VALID<=1'b1;//FROM MEM STAGE
					 
				    f_F_WB_STAGE<=2'b00;//NOT NEEDED
				    f_F_WB_STAGE_VALID<=1'b0;
					 f_E_MEM_STAGE<=2'b00;//ALU OUTPUT OF MEM_STAGE_SELECTED
				    f_E_MEM_STAGE_VALID<=1'b1;
					 stall<=1'b0;
				    hazard_detect<=1'b1;
					 end
       
		 4'b0010: begin                                          //NAND-RTYPE
		          
				    for_MUX_ALU_OP2_SELECT<=2'b00;
					 for_MUX_ALU_OP2_SELECT_VALID<=1'b0;
				    for_MUX_D2_MUX_SELECT<=2'b01;
					 for_MUX_D2_MUX_SELECT_VALID<=1'b1;//FROM MEM STAGE
					 
				    f_F_WB_STAGE<=2'b00;//NOT NEEDED
				    f_F_WB_STAGE_VALID<=1'b0;
					 f_E_MEM_STAGE<=2'b00;//ALU OUTPUT OF MEM_STAGE_SELECTED
				    f_E_MEM_STAGE_VALID<=1'b1;
					 stall<=1'b0;
				    hazard_detect<=1'b1;
					 end
     
       4'b0001: begin                                          //ADI
		         
				    for_MUX_ALU_OP2_SELECT<=2'b00;
					 for_MUX_ALU_OP2_SELECT_VALID<=1'b0;
				    for_MUX_D2_MUX_SELECT<=2'b01;//FROM MEM STAGE
					 for_MUX_D2_MUX_SELECT_VALID<=1'b1;
					 
					 f_E_MEM_STAGE<=2'b00;//ALU OUTPUT OF MEM_STAGE_SELECTED
				    f_E_MEM_STAGE_VALID<=1'b1;
					 stall<=1'b0;
				    hazard_detect<=1'b1;
					 end 
					 
		
       4'b0011: begin                                          //LHI
		        
				    for_MUX_ALU_OP2_SELECT<=2'b00;
					 for_MUX_ALU_OP2_SELECT_VALID<=1'b0;
				    for_MUX_D2_MUX_SELECT<=2'b01;//FROM MEM STAGE
					 for_MUX_D2_MUX_SELECT_VALID<=1'b1;
					 
				   
					 f_E_MEM_STAGE<=2'b10;//O PAD OF MEM_STAGE_FORWARDED
				    f_E_MEM_STAGE_VALID<=1'b1;
					 stall<=1'b0;
				    hazard_detect<=1'b1;
					 end 	
					 
		4'b1000: begin                                          //JAL
		        
				    for_MUX_ALU_OP2_SELECT<=2'b00;
					 for_MUX_ALU_OP2_SELECT_VALID<=1'b0;
				    for_MUX_D2_MUX_SELECT<=2'b01;//FROM MEM STAGE
					 for_MUX_D2_MUX_SELECT_VALID<=1'b1;
					 
				   
					 f_E_MEM_STAGE<=2'b01;//PC+1 OF MEM_STAGE_FORWARDED
				    f_E_MEM_STAGE_VALID<=1'b1;
					 stall<=1'b0;
				    hazard_detect<=1'b1;
					 end 			 
					 
      4'b1001: begin                                          //JLR
		          
				    for_MUX_ALU_OP2_SELECT<=2'b00;
					 for_MUX_ALU_OP2_SELECT_VALID<=1'b0;
				    for_MUX_D2_MUX_SELECT<=2'b01;//FROM MEM STAGE
					 for_MUX_D2_MUX_SELECT_VALID<=1'b1;
					 
				    
					 f_E_MEM_STAGE<=2'b01;//PC+1 OF MEM_STAGE_FORWARDED
				    f_E_MEM_STAGE_VALID<=1'b1;
					 stall<=1'b0;
				    hazard_detect<=1'b1;
					 end 	
     4'b0100: begin                          //LW
		         
				    for_MUX_ALU_OP2_SELECT<=2'b00;
					 for_MUX_ALU_OP2_SELECT_VALID<=1'b0;
				    for_MUX_D2_MUX_SELECT<=2'b00;
					 for_MUX_D2_MUX_SELECT_VALID<=1'b0;
					 
				    
					 f_E_MEM_STAGE<=2'b00;//
				    f_E_MEM_STAGE_VALID<=1'b0;
					 stall<=1'b1;//LW STALL
				    hazard_detect<=1'b1;//LW HAZARD
					end					 
     default: begin                //DEFAULT
	            
				    for_MUX_ALU_OP2_SELECT<=2'b00;
					 for_MUX_ALU_OP2_SELECT_VALID<=1'b0;
				    for_MUX_D2_MUX_SELECT<=2'b00;
					 for_MUX_D2_MUX_SELECT_VALID<=1'b0;
					 
				   
					 f_E_MEM_STAGE<=2'b00;
				    f_E_MEM_STAGE_VALID<=1'b0;
					 stall<=1'b0;
				    hazard_detect<=1'b0;//DEFAULT
					end
		endcase	

if (RD_PREV_PREV==RS1_CURRENT && RD_PP_VALID==1'b1 && RS1_C_VALID==1'b1)        		 
		    if(OPCODE_PREV_PREV[5:2]==4'b0000 || OPCODE_PREV_PREV[5:2]==4'b0010 ||OPCODE_PREV_PREV[5:2]==4'b0001) //RTYPE AND ADI
			    begin
				 for_MUX_ALU_OP1_SELECT<=2'b10;  //FROM WB STAGE
			    for_MUX_ALU_OP1_SELECT_VALID<=1'b1;
				 f_F_WB_STAGE<=2'b00;//ALU OUTPUT FROM WB STAGE
				 f_F_WB_STAGE_VALID<=1'b1;
		       end
			 else if (OPCODE_PREV_PREV[5:2]==4'b0011)   //LHI
	          begin
				 for_MUX_ALU_OP1_SELECT<=2'b10;  //FROM WB STAGE
			    for_MUX_ALU_OP1_SELECT_VALID<=1'b1;
				 f_F_WB_STAGE<=2'b10;//OPAD FROM WB STAGE
				 f_F_WB_STAGE_VALID<=1'b1;
		       end
          else if (OPCODE_PREV_PREV[5:2]==4'b1000 || OPCODE_PREV_PREV[5:2]==4'b1001) //JAL,JLR
             begin
				 for_MUX_ALU_OP1_SELECT<=2'b10;  //FROM WB STAGE
			    for_MUX_ALU_OP1_SELECT_VALID<=1'b1;
				 f_F_WB_STAGE<=2'b01;//PC+1 FROM WB STAGE
				 f_F_WB_STAGE_VALID<=1'b1;
		       end 
			 else if (OPCODE_PREV_PREV[5:2]==4'b0100) //LW
	          begin
				 for_MUX_ALU_OP1_SELECT<=2'b10;  //FROM WB STAGE
			    for_MUX_ALU_OP1_SELECT_VALID<=1'b1;
				 f_F_WB_STAGE<=2'b11;//DATA_OUT FROM WB STAGE
				 f_F_WB_STAGE_VALID<=1'b1;
		       end 
		    else
				 begin
				 for_MUX_ALU_OP1_SELECT<=2'b00;  //DEFAULT
			    for_MUX_ALU_OP1_SELECT_VALID<=1'b0;
				 f_F_WB_STAGE<=2'b00;//DATA_OUT FROM WB STAGE
				 f_F_WB_STAGE_VALID<=1'b0;
		       end 
	   
else
				 begin
	          for_MUX_ALU_OP1_SELECT<=2'b00;  //DEFAULT
			    for_MUX_ALU_OP1_SELECT_VALID<=1'b0;
				 f_F_WB_STAGE<=2'b00;//DATA_OUT FROM WB STAGE
				 f_F_WB_STAGE_VALID<=1'b0;
		        
	          end
	


	
end



//WRITEBACK STAGE FOR FORWARDING MUX 1	
else if (RD_PREV_PREV==RS1_CURRENT && RD_PP_VALID==1'b1 && RS1_C_VALID==1'b1)
 case (OPCODE_PREV_PREV[5:2])
		 4'b0000: begin                                          //ADD-RTYPE
		          for_MUX_ALU_OP1_SELECT<=2'b10;//FROM WB STAGE
					 for_MUX_ALU_OP1_SELECT_VALID<=1'b1;
				    for_MUX_ALU_OP2_SELECT<=2'b00;
					 for_MUX_ALU_OP2_SELECT_VALID<=1'b0;
				    for_MUX_D2_MUX_SELECT<=2'b00;
					 for_MUX_D2_MUX_SELECT_VALID<=1'b0;
					 
				    f_F_WB_STAGE<=2'b00;//ALU OUTPUT OF WB_STAGE_SELECTED
				    f_F_WB_STAGE_VALID<=1'b1;
					 f_E_MEM_STAGE<=2'b00;
				    f_E_MEM_STAGE_VALID<=1'b0;
					 stall<=1'b0;
				    hazard_detect<=1'b1;
					 end
       
		 4'b0010: begin                                          //NAND-RTYPE
		          for_MUX_ALU_OP1_SELECT<=2'b10;   //FROM WB STAGE
					 for_MUX_ALU_OP1_SELECT_VALID<=1'b1;
				    for_MUX_ALU_OP2_SELECT<=2'b00;
					 for_MUX_ALU_OP2_SELECT_VALID<=1'b0;
				    for_MUX_D2_MUX_SELECT<=2'b00;
					 for_MUX_D2_MUX_SELECT_VALID<=1'b0;
					 
				    f_F_WB_STAGE<=2'b00;//ALU OUTPUT OF WB_STAGE_SELECTED
				    f_F_WB_STAGE_VALID<=1'b1;
					 f_E_MEM_STAGE<=2'b00;
				    f_E_MEM_STAGE_VALID<=1'b0;
					 stall<=1'b0;
				    hazard_detect<=1'b1;
					 end
     
       4'b0001: begin                                          //ADI
		          for_MUX_ALU_OP1_SELECT<=2'b10;//FROM WB STAGE
					 for_MUX_ALU_OP1_SELECT_VALID<=1'b1;
				    for_MUX_ALU_OP2_SELECT<=2'b00;
					 for_MUX_ALU_OP2_SELECT_VALID<=1'b0;
				    for_MUX_D2_MUX_SELECT<=2'b00;
					 for_MUX_D2_MUX_SELECT_VALID<=1'b0;
					 
				    f_F_WB_STAGE<=2'b00;//ALU OUTPUT OF WB_STAGE_SELECTED
				    f_F_WB_STAGE_VALID<=1'b1;
					 f_E_MEM_STAGE<=2'b00;
				    f_E_MEM_STAGE_VALID<=1'b0;
					 stall<=1'b0;
				    hazard_detect<=1'b1;
					 end 
					 
		
       4'b0011: begin                                          //LHI
		          for_MUX_ALU_OP1_SELECT<=2'b10;//FROM WB STAGE
					 for_MUX_ALU_OP1_SELECT_VALID<=1'b1;
				    for_MUX_ALU_OP2_SELECT<=2'b00;
					 for_MUX_ALU_OP2_SELECT_VALID<=1'b0;
				    for_MUX_D2_MUX_SELECT<=2'b00;
					 for_MUX_D2_MUX_SELECT_VALID<=1'b0;
					 
				    f_F_WB_STAGE<=2'b10;//O PAD OF WB_STAGE_FORWARDED
				    f_F_WB_STAGE_VALID<=1'b1;
					 f_E_MEM_STAGE<=2'b00;
				    f_E_MEM_STAGE_VALID<=1'b0;
					 stall<=1'b0;
				    hazard_detect<=1'b1;
					 end 	
					 
		4'b1000: begin                                          //JAL
		          for_MUX_ALU_OP1_SELECT<=2'b10;//FROM WB STAGE
					 for_MUX_ALU_OP1_SELECT_VALID<=1'b1;
				    for_MUX_ALU_OP2_SELECT<=2'b00;
					 for_MUX_ALU_OP2_SELECT_VALID<=1'b0;
				    for_MUX_D2_MUX_SELECT<=2'b00;
					 for_MUX_D2_MUX_SELECT_VALID<=1'b0;
					 
				    f_F_WB_STAGE<=2'b01;//PC+1 OF WB_STAGE_FORWARDED
				    f_F_WB_STAGE_VALID<=1'b1;
					 f_E_MEM_STAGE<=2'b00;
				    f_E_MEM_STAGE_VALID<=1'b0;
					 stall<=1'b0;
				    hazard_detect<=1'b1;
					 end 			 
					 
      4'b1001: begin                                          //JLR
		          for_MUX_ALU_OP1_SELECT<=2'b10;//FROM WB STAGE
					 for_MUX_ALU_OP1_SELECT_VALID<=1'b1;
				    for_MUX_ALU_OP2_SELECT<=2'b00;
					 for_MUX_ALU_OP2_SELECT_VALID<=1'b0;
				    for_MUX_D2_MUX_SELECT<=2'b00;
					 for_MUX_D2_MUX_SELECT_VALID<=1'b0;
					 
				    f_F_WB_STAGE<=2'b01;//PC+1 OF WB_STAGE_FORWARDED
				    f_F_WB_STAGE_VALID<=1'b1;
					 f_E_MEM_STAGE<=2'b00;//PC+1 OF MEM_STAGE_FORWARDED
				    f_E_MEM_STAGE_VALID<=1'b0;
					 stall<=1'b0;
				    hazard_detect<=1'b1;
					 end 	
					 
		4'b0100: begin                          //LW
		          for_MUX_ALU_OP1_SELECT<=2'b10;//FROM WB STAGE
					 for_MUX_ALU_OP1_SELECT_VALID<=1'b1;
				    for_MUX_ALU_OP2_SELECT<=2'b00;
					 for_MUX_ALU_OP2_SELECT_VALID<=1'b0;
				    for_MUX_D2_MUX_SELECT<=2'b00;
					 for_MUX_D2_MUX_SELECT_VALID<=1'b0;
					 
				    f_F_WB_STAGE<=2'b11;//DATA_OUT_OF_WB_STAGE
				    f_F_WB_STAGE_VALID<=1'b1;
					 f_E_MEM_STAGE<=2'b00;//
				    f_E_MEM_STAGE_VALID<=1'b0;
					 stall<=1'b0;
				    hazard_detect<=1'b1;//NO LW HAZARD
					end
     default: begin                //DEFAULT
	             for_MUX_ALU_OP1_SELECT<=2'b00;//DEFAULT
					 for_MUX_ALU_OP1_SELECT_VALID<=1'b0;
				    for_MUX_ALU_OP2_SELECT<=2'b00;
					 for_MUX_ALU_OP2_SELECT_VALID<=1'b0;
				    for_MUX_D2_MUX_SELECT<=2'b00;
					 for_MUX_D2_MUX_SELECT_VALID<=1'b0;
					 
				    f_F_WB_STAGE<=2'b00;//NOT NEEDED
				    f_F_WB_STAGE_VALID<=1'b0;
					 f_E_MEM_STAGE<=2'b00;
				    f_E_MEM_STAGE_VALID<=1'b0;
					 stall<=1'b0;
				    hazard_detect<=1'b0;//DEFAULT
					end
		endcase


//WRITEBACK STAGE FORWARDING MUX 2 (EXCEPT JLR AND SW)						
else if ((RD_PREV_PREV==RS2_CURRENT) && (RD_PP_VALID==1'b1) && (RS2_C_VALID==1'b1) && OPCODE_CURRENT[5:2]!=4'b0101 && OPCODE_CURRENT[5:2]!=4'b1001 && OPCODE_CURRENT[5:2]!=4'b0111)
 case (OPCODE_PREV_PREV[5:2])
		 4'b0000: begin                                          //ADD-RTYPE
		          for_MUX_ALU_OP1_SELECT<=2'b00;
					 for_MUX_ALU_OP1_SELECT_VALID<=1'b0;
				    for_MUX_ALU_OP2_SELECT<=2'b10;//FROM WB STAGE
					 for_MUX_ALU_OP2_SELECT_VALID<=1'b1;
				    for_MUX_D2_MUX_SELECT<=2'b00;
					 for_MUX_D2_MUX_SELECT_VALID<=1'b0;
					 
				    f_F_WB_STAGE<=2'b00;//ALU OUTPUT OF WB_STAGE_SELECTED
				    f_F_WB_STAGE_VALID<=1'b1;
					 f_E_MEM_STAGE<=2'b00;
				    f_E_MEM_STAGE_VALID<=1'b0;
					 stall<=1'b0;
				    hazard_detect<=1'b1;
					 end
       
		 4'b0010: begin                                          //NAND-RTYPE
		          for_MUX_ALU_OP1_SELECT<=2'b00;
					 for_MUX_ALU_OP1_SELECT_VALID<=1'b0;
				    for_MUX_ALU_OP2_SELECT<=2'b10;//FROM WB STAGE
					 for_MUX_ALU_OP2_SELECT_VALID<=1'b1;
				    for_MUX_D2_MUX_SELECT<=2'b00;
					 for_MUX_D2_MUX_SELECT_VALID<=1'b0;
					 
				    f_F_WB_STAGE<=2'b00;//ALU OUTPUT OF WB_STAGE_SELECTED
				    f_F_WB_STAGE_VALID<=1'b1;
					 f_E_MEM_STAGE<=2'b00;
				    f_E_MEM_STAGE_VALID<=1'b0;
					 stall<=1'b0;
				    hazard_detect<=1'b1;
					 end
     
       4'b0001: begin                                          //ADI
		          for_MUX_ALU_OP1_SELECT<=2'b00;
					 for_MUX_ALU_OP1_SELECT_VALID<=1'b0;
				    for_MUX_ALU_OP2_SELECT<=2'b10;//FROM WB STAGE
					 for_MUX_ALU_OP2_SELECT_VALID<=1'b1;
				    for_MUX_D2_MUX_SELECT<=2'b00;
					 for_MUX_D2_MUX_SELECT_VALID<=1'b0;
					 
				    f_F_WB_STAGE<=2'b00;//ALU OUTPUT OF WB_STAGE_SELECTED
				    f_F_WB_STAGE_VALID<=1'b1;
					 f_E_MEM_STAGE<=2'b00;
				    f_E_MEM_STAGE_VALID<=1'b0;
					 stall<=1'b0;
				    hazard_detect<=1'b1;
					 end 
					 
		
       4'b0011: begin                                          //LHI
		          for_MUX_ALU_OP1_SELECT<=2'b00;
					 for_MUX_ALU_OP1_SELECT_VALID<=1'b0;
				    for_MUX_ALU_OP2_SELECT<=2'b10;//FROM WB STAGE
					 for_MUX_ALU_OP2_SELECT_VALID<=1'b1;
				    for_MUX_D2_MUX_SELECT<=2'b00;
					 for_MUX_D2_MUX_SELECT_VALID<=1'b0;
					 
				    f_F_WB_STAGE<=2'b10;//O PAD OF WB_STAGE_FORWARDED
				    f_F_WB_STAGE_VALID<=1'b1;
					 f_E_MEM_STAGE<=2'b00;
				    f_E_MEM_STAGE_VALID<=1'b0;
					 stall<=1'b0;
				    hazard_detect<=1'b1;
					 end 	
					 
		4'b1000: begin                                          //JAL
		          for_MUX_ALU_OP1_SELECT<=2'b00;
					 for_MUX_ALU_OP1_SELECT_VALID<=1'b0;
				    for_MUX_ALU_OP2_SELECT<=2'b10;//FROM WB STAGE
					 for_MUX_ALU_OP2_SELECT_VALID<=1'b1;
				    for_MUX_D2_MUX_SELECT<=2'b00;
					 for_MUX_D2_MUX_SELECT_VALID<=1'b0;
					 
				    f_F_WB_STAGE<=2'b01;//PC+1 OF WB_STAGE_FORWARDED
				    f_F_WB_STAGE_VALID<=1'b1;
					 f_E_MEM_STAGE<=2'b00;
				    f_E_MEM_STAGE_VALID<=1'b0;
					 stall<=1'b0;
				    hazard_detect<=1'b1;
					 end 			 
					 
      4'b1001: begin                                          //JLR
		          for_MUX_ALU_OP1_SELECT<=2'b00;
					 for_MUX_ALU_OP1_SELECT_VALID<=1'b0;
				    for_MUX_ALU_OP2_SELECT<=2'b10;//FROM WB STAGE
					 for_MUX_ALU_OP2_SELECT_VALID<=1'b1;
				    for_MUX_D2_MUX_SELECT<=2'b00;
					 for_MUX_D2_MUX_SELECT_VALID<=1'b0;
					 
				    f_F_WB_STAGE<=2'b01;//PC+1 OF WB_STAGE_FORWARDED
				    f_F_WB_STAGE_VALID<=1'b1;
					 f_E_MEM_STAGE<=2'b00;
				    f_E_MEM_STAGE_VALID<=1'b0;
					 stall<=1'b0;
				    hazard_detect<=1'b1;
					 end 	
		4'b0100: begin                          //LW
		          for_MUX_ALU_OP1_SELECT<=2'b00;
					 for_MUX_ALU_OP1_SELECT_VALID<=1'b0;
				    for_MUX_ALU_OP2_SELECT<=2'b10;
					 for_MUX_ALU_OP2_SELECT_VALID<=1'b1;
				    for_MUX_D2_MUX_SELECT<=2'b00;
					 for_MUX_D2_MUX_SELECT_VALID<=1'b0;
					 
				    f_F_WB_STAGE<=2'b11;//DATA_OUT OF WB_STAGE_FORWARDED
				    f_F_WB_STAGE_VALID<=1'b1;
					 f_E_MEM_STAGE<=2'b00;//
				    f_E_MEM_STAGE_VALID<=1'b0;
					 stall<=1'b0;
				    hazard_detect<=1'b1;//LW HAZARD
					end
					 
     default: begin                //DEFAULT
	             for_MUX_ALU_OP1_SELECT<=2'b00;//DEFAULT
					 for_MUX_ALU_OP1_SELECT_VALID<=1'b0;
				    for_MUX_ALU_OP2_SELECT<=2'b00;
					 for_MUX_ALU_OP2_SELECT_VALID<=1'b0;
				    for_MUX_D2_MUX_SELECT<=2'b00;
					 for_MUX_D2_MUX_SELECT_VALID<=1'b0;
					 
				    f_F_WB_STAGE<=2'b00;//NOT NEEDED
				    f_F_WB_STAGE_VALID<=1'b0;
					 f_E_MEM_STAGE<=2'b00;
				    f_E_MEM_STAGE_VALID<=1'b0;
					 stall<=1'b0;
				    hazard_detect<=1'b0;//DEFAULT
					end
		endcase		
		
//WRITEBACK STAGE D2 MUX FORWARDING FOR JLR AND SW				
else if (RD_PREV_PREV==RS2_CURRENT && RD_PP_VALID==1'b1 && RS2_C_VALID==1'b1 && (OPCODE_CURRENT[5:2]==4'b0101 || OPCODE_CURRENT[5:2]==4'b1001 || OPCODE_CURRENT[5:2]==4'b0111))
 case (OPCODE_PREV_PREV[5:2])
		 4'b0000: begin                                          //ADD-RTYPE
		          for_MUX_ALU_OP1_SELECT<=2'b00;
					 for_MUX_ALU_OP1_SELECT_VALID<=1'b0;
				    for_MUX_ALU_OP2_SELECT<=2'b00;
					 for_MUX_ALU_OP2_SELECT_VALID<=1'b0;
				    for_MUX_D2_MUX_SELECT<=2'b10;
					 for_MUX_D2_MUX_SELECT_VALID<=1'b1;
					 
				    f_F_WB_STAGE<=2'b00;//ALU OUTPUT OF WB_STAGE_SELECTED
				    f_F_WB_STAGE_VALID<=1'b1;
					 f_E_MEM_STAGE<=2'b00;
				    f_E_MEM_STAGE_VALID<=1'b0;
					 stall<=1'b0;
				    hazard_detect<=1'b1;
					 end
       
		 4'b0010: begin                                          //NAND-RTYPE
		          for_MUX_ALU_OP1_SELECT<=2'b00;
					 for_MUX_ALU_OP1_SELECT_VALID<=1'b0;
				    for_MUX_ALU_OP2_SELECT<=2'b00;
					 for_MUX_ALU_OP2_SELECT_VALID<=1'b0;
				    for_MUX_D2_MUX_SELECT<=2'b10;//FROM WB STAGE
					 for_MUX_D2_MUX_SELECT_VALID<=1'b1;
					 
				    f_F_WB_STAGE<=2'b00;//ALU OUTPUT OF WB_STAGE_SELECTED
				    f_F_WB_STAGE_VALID<=1'b1;
					 f_E_MEM_STAGE<=2'b00;
				    f_E_MEM_STAGE_VALID<=1'b0;
					 stall<=1'b0;
				    hazard_detect<=1'b1;
					 end
     
       4'b0001: begin                                          //ADI
		          for_MUX_ALU_OP1_SELECT<=2'b00;
					 for_MUX_ALU_OP1_SELECT_VALID<=1'b0;
				    for_MUX_ALU_OP2_SELECT<=2'b00;
					 for_MUX_ALU_OP2_SELECT_VALID<=1'b0;
				    for_MUX_D2_MUX_SELECT<=2'b10;//FROM WB STAGE
					 for_MUX_D2_MUX_SELECT_VALID<=1'b1;
					 
				    f_F_WB_STAGE<=2'b00;//ALU OUTPUT OF WB_STAGE_SELECTED
				    f_F_WB_STAGE_VALID<=1'b1;
					 f_E_MEM_STAGE<=2'b00;
				    f_E_MEM_STAGE_VALID<=1'b0;
					 stall<=1'b0;
				    hazard_detect<=1'b1;
					 end 
					 
		
       4'b0011: begin                                          //LHI
		          for_MUX_ALU_OP1_SELECT<=2'b00;
					 for_MUX_ALU_OP1_SELECT_VALID<=1'b0;
				    for_MUX_ALU_OP2_SELECT<=2'b00;
					 for_MUX_ALU_OP2_SELECT_VALID<=1'b0;
				    for_MUX_D2_MUX_SELECT<=2'b10;//FROM WB STAGE
					 for_MUX_D2_MUX_SELECT_VALID<=1'b1;
					 
				    f_F_WB_STAGE<=2'b10;//O PAD OF WB_STAGE_FORWARDED
				    f_F_WB_STAGE_VALID<=1'b1;
					 f_E_MEM_STAGE<=2'b00;
				    f_E_MEM_STAGE_VALID<=1'b0;
					 stall<=1'b0;
				    hazard_detect<=1'b1;
					 end 	
					 
		4'b1000: begin                                          //JAL
		          for_MUX_ALU_OP1_SELECT<=2'b00;
					 for_MUX_ALU_OP1_SELECT_VALID<=1'b0;
				    for_MUX_ALU_OP2_SELECT<=2'b00;
					 for_MUX_ALU_OP2_SELECT_VALID<=1'b0;
				    for_MUX_D2_MUX_SELECT<=2'b10;//FROM WB STAGE
					 for_MUX_D2_MUX_SELECT_VALID<=1'b1;
					 
				    f_F_WB_STAGE<=2'b01;//PC+1 OF WB_STAGE_FORWARDED
				    f_F_WB_STAGE_VALID<=1'b1;
					 f_E_MEM_STAGE<=2'b00;
				    f_E_MEM_STAGE_VALID<=1'b0;
					 stall<=1'b0;
				    hazard_detect<=1'b1;
					 end 			 
					 
      4'b1001: begin                                          //JLR
		          for_MUX_ALU_OP1_SELECT<=2'b00;
					 for_MUX_ALU_OP1_SELECT_VALID<=1'b0;
				    for_MUX_ALU_OP2_SELECT<=2'b00;
					 for_MUX_ALU_OP2_SELECT_VALID<=1'b0;
				    for_MUX_D2_MUX_SELECT<=2'b10;//FROM WB STAGE
					 for_MUX_D2_MUX_SELECT_VALID<=1'b1;
					 
				    f_F_WB_STAGE<=2'b01;//PC+1 OF WB_STAGE_FORWARDED
				    f_F_WB_STAGE_VALID<=1'b1;
					 f_E_MEM_STAGE<=2'b00;
				    f_E_MEM_STAGE_VALID<=1'b0;
					 stall<=1'b0;
				    hazard_detect<=1'b1;
					 end 	
     4'b0100: begin                          //LW
		          for_MUX_ALU_OP1_SELECT<=2'b00;
					 for_MUX_ALU_OP1_SELECT_VALID<=1'b0;
				    for_MUX_ALU_OP2_SELECT<=2'b00;
					 for_MUX_ALU_OP2_SELECT_VALID<=1'b0;
				    for_MUX_D2_MUX_SELECT<=2'b10;//FROM WB STAGE
					 for_MUX_D2_MUX_SELECT_VALID<=1'b0;
					 
				    f_F_WB_STAGE<=2'b11;//DATA_OUT_WB_STAGE_FORWARDED
				    f_F_WB_STAGE_VALID<=1'b1;
					 f_E_MEM_STAGE<=2'b00;//
				    f_E_MEM_STAGE_VALID<=1'b0;
					 stall<=1'b0;//LW STALL
				    hazard_detect<=1'b1;//LW HAZARD
					end					 
     default: begin                //DEFAULT
	             for_MUX_ALU_OP1_SELECT<=2'b00;//DEFAULT
					 for_MUX_ALU_OP1_SELECT_VALID<=1'b0;
				    for_MUX_ALU_OP2_SELECT<=2'b00;
					 for_MUX_ALU_OP2_SELECT_VALID<=1'b0;
				    for_MUX_D2_MUX_SELECT<=2'b00;
					 for_MUX_D2_MUX_SELECT_VALID<=1'b0;
					 
				    f_F_WB_STAGE<=2'b00;//NOT NEEDED
				    f_F_WB_STAGE_VALID<=1'b0;
					 f_E_MEM_STAGE<=2'b00;
				    f_E_MEM_STAGE_VALID<=1'b0;
					 stall<=1'b0;
				    hazard_detect<=1'b0;//DEFAULT
					end
		endcase	
else
   begin
	            for_MUX_ALU_OP1_SELECT<=2'b00;//DEFAULT
					 for_MUX_ALU_OP1_SELECT_VALID<=1'b0;
				    for_MUX_ALU_OP2_SELECT<=2'b00;
					 for_MUX_ALU_OP2_SELECT_VALID<=1'b0;
				    for_MUX_D2_MUX_SELECT<=2'b00;
					 for_MUX_D2_MUX_SELECT_VALID<=1'b0;
					 
				    f_F_WB_STAGE<=2'b00;
				    f_F_WB_STAGE_VALID<=1'b0;
					 f_E_MEM_STAGE<=2'b00;
				    f_E_MEM_STAGE_VALID<=1'b0;
					 stall<=1'b0;
				    hazard_detect<=1'b0;//DEFAULT
	
	end







end
endmodule