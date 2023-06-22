module counter #(parameter cntr_width=6)(
    input rst,
	input clk,
    input [cntr_width-1 :0] end_val,
    output reg done,
    output reg [cntr_width-1:0] cntr_out
    );
always @(posedge clk)begin
	if(rst) begin
		cntr_out <= 0;
	end
	else begin
		if(cntr_out == end_val) begin
			cntr_out <= cntr_out;
		end
		else begin
			cntr_out <= cntr_out+1;
		end
	end
end

always@(*) begin
	if(cntr_out == end_val) begin
		done = 1;
	end
	else begin
		done = 0;
	end
end

endmodule