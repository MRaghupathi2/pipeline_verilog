module inst_memory(read_mem,rw_address,read_data);

input           read_mem;
input[7:0]      rw_address;
output reg [15:0]    read_data;

integer i;
reg [ 15:0] mem_file [255:0];
initial $readmemh ("inst_mem_vals.hex",mem_file);

always@(*)
begin		
            i = rw_address[7:0];
		if(read_mem == 1'b1)
		   read_data <= mem_file[i] ;
end

endmodule