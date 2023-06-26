module reg_d(input clk,
input data,
output reg reg_data
    );
	 
always @(posedge clk) begin
	reg_data <= data;
end


endmodule