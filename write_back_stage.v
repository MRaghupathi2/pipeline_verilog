module write_back_stage(r7_detect_in,writeback_control,rf_a3_in,PC_updated_in,alu_out_in,PC_plus_1_in,ZERO_PADD,data_out_in,rf_d3_write_wb_in,rf_d3_out,
                        d_R7_out,rf_a3_out,rf_d3_write_wb_updated_out);
                     
output [15:0] d_R7_out;
input rf_d3_write_wb_in;
output rf_d3_write_wb_updated_out;
output [2:0] rf_a3_out;
input r7_detect_in;
input [1:0] writeback_control;
input [2:0] rf_a3_in;
input [15:0]  PC_updated_in,alu_out_in,PC_plus_1_in,ZERO_PADD,data_out_in;


output [15:0]rf_d3_out;
wire [15:0] rf_d3;

mux4x1 Mux1(writeback_control,alu_out_in,PC_plus_1_in,ZERO_PADD,data_out_in,rf_d3);
Mux2x1_1bit Mux2(r7_detect_in,rf_d3_write_wb_in,1'b0,rf_d3_write_wb_updated_out);
Mux2x1 Mux3(r7_detect_in,PC_updated_in,rf_d3,d_R7_out);
assign rf_a3_out = rf_a3_in;
assign rf_d3_out=rf_d3;

endmodule