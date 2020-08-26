module reg_file(A1,A2,A3,reg_write,R7_write,d_out1,d_out2,d_in3,d_R7,R0,R1,R2,R3,R4,R5,R6,R7);
				 
input		[2:0] A1	;		
input		[2:0] A2	;	
input		[2:0] A3	;
input		     	reg_write;	
input	   		R7_write	;	
output	 [15:0] d_out1;	
output	[15:0] d_out2;		
input		[15:0] d_in3;		
input		[15:0] d_R7;	
output [15:0]R0,R1,R2,R3,R4,R5,R6,R7;
				
//output	 [15:0] R0;              
//output	 [15:0] R1;             
//output	 [15:0] R2 ;            
//output	 [15:0] R3 ;    
//output    [15:0] R4 ;        
//output    [15:0] R5;        
//output	 [15:0] R6;             
//output	 [15:0] R7 ;   

integer i,j,k;
reg [ 15:0] reg_file [7:0] ;   
										 
initial $readmemh ("reg_file_init_vals.hex",reg_file);
always@(*)
begin			
//		if(R7_write==1'b1 && reg_write == 1'b1 && A3 == 3'b111 )
//				       reg_file[7] <= d_R7;
//			else 
			   if(R7_write == 1'b1 && reg_write == 1'b1 && A3!=3'b000)
				   begin  
                      reg_file[0] <=reg_file[0];
							 reg_file[i] <=d_in3;
							 reg_file[7] <=d_R7;
					end
			           else if(reg_write == 1'b1 && R7_write==1'b1 && A3==3'b000)
                                 begin 
											      reg_file[0] <=d_in3;
						                     reg_file[7] <=d_R7;
					                  end								
			           else if(R7_write == 1'b1)
						               reg_file[7] <= d_R7;
						  else
						     begin reg_file[0] <= reg_file[0];  
						      reg_file[1] <= reg_file[1];
								reg_file[2] <= reg_file[2];
								reg_file[3] <= reg_file[3];
								reg_file[4] <= reg_file[4];
								reg_file[5] <= reg_file[5];
								reg_file[6] <= reg_file[6];
								reg_file[7] <= reg_file[7]; end
								
 end	
assign 	d_out1 =reg_file[j];
assign	d_out2 =reg_file[k];
	
always@(*)
begin		i = A3[2:0];
         j = A1[2:0];
         k = A2[2:0];
end
	
assign   R0   =  reg_file[0];    
assign 	R1   =  reg_file[1];         
assign 	R2   =  reg_file[2];        
assign 	R3   =  reg_file[3];       
assign	R4   =  reg_file[4];         
assign	R5   =  reg_file[5];      
assign	R6   =  reg_file[6];      
assign 	R7   =  reg_file[7];         
			
		
endmodule


					
				
		