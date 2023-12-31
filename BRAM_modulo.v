module bram #(parameter num_width=12, parameter N_width=6)(input clk,
input [N_width-1:0] N,
input [num_width-1:0] num,
output reg [N_width-1:0] out);
reg [N_width-1:0] bram [0:2**(N_width+num_width)- 2**(num_width+1) - 1];
integer i,k;
//starting from N=2,so as not to waste ram resources 
initial begin
	for(i=0;i<2**num_width; i=i+1) begin
		for(k=2;k<2**N_width ; k=k+1) begin
			bram[(2**N_width-2)*(i) + k-2] = i%k;
		end
	end
end


always @(posedge clk)begin
	out <= bram[(2**N_width-2)*(num) + N-2];
end

endmodule