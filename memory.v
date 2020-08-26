module memory(read_mem,write_mem,rw_address,write_data,read_data);
input           read_mem;
input           write_mem;
input [15:0]rw_address;
input [15:0]write_data;
output  [15:0]read_data;

integer i;
reg [15:0] data_mem_file[15:0];
initial $readmemh ("mem_vals.hex",data_mem_file);
always@(*)
begin		
         if(write_mem == 1'b1 && i==rw_address[3:0])//&& read_mem == 1'b0)
			     data_mem_file[i] <= write_data;	
			   //else if(write_mem == 1'b0 && read_mem == 1'b1)
			     //      read_data <= data_mem_file[i] ;
				  else 
					 begin  data_mem_file[0] <= data_mem_file[0];
							  data_mem_file[1] <= data_mem_file[1];
							  data_mem_file[2] <= data_mem_file[2];
							  data_mem_file[3] <= data_mem_file[3];
							  data_mem_file[4] <= data_mem_file[4];
							  data_mem_file[5] <= data_mem_file[5];
							  data_mem_file[6] <= data_mem_file[6];
							  data_mem_file[7] <= data_mem_file[7];
							  data_mem_file[8] <= data_mem_file[8];
							  data_mem_file[9] <= data_mem_file[9];
							  data_mem_file[10] <= data_mem_file[10];
							  data_mem_file[11] <= data_mem_file[11];
							  data_mem_file[12] <= data_mem_file[12];
							  data_mem_file[13] <= data_mem_file[13];
							  data_mem_file[14] <= data_mem_file[14];
							  data_mem_file[15] <= data_mem_file[15];
					 end 							  
end
assign  read_data = data_mem_file[i] ;

always@(*)
begin		i = rw_address[3:0];
end

endmodule


