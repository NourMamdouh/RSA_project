module bram #(parameter num_width=12, parameter N_width=6)(input clk,
input [N_width-1:0] N,
input [num_width-1:0] num,
output reg [N_width-1:0] out);
reg [N_width-1:0] bram [0:2**(N_width+num_width) - 1];
integer i,k;
initial begin
	for(i=0;i<2**num_width; i=i+1) begin
		for(k=0;k<2**N_width; k=k+1) begin
			if(k==0) begin
				bram[(2**N_width)*i + k] = 0;
			end
			else begin
				bram[(2**N_width)*i + k] = i%k;
			end
			
		end
	end
end


always @(posedge clk)begin
	out <= bram[(2**N_width)*num + N];
end

endmodule