module rslt_ff #(parameter width=6) (input clk,
input rst,
input [width-1 : 0]rst_val,
input [width-1 :0] data_in,
input w_en /*active low*/,
output reg [width-1 : 0] data_out);

always @(posedge clk) begin
	if(rst) begin
		data_out <= rst_val;
	end
	else begin
		if(w_en)begin
			data_out <= data_out;
		end
		else begin
			data_out <= data_in;
		end
	end
end

endmodule