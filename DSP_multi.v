module mult_DSP #(parameter in1_width=6,parameter in2_width=6)(
    input [in1_width-1:0] in1,
    input [in2_width-1:0] in2,
    output reg [in1_width+in2_width-1:0] mult_out
    );
	
	 always @(*)begin
		mult_out = in1*in2 ;
	 end	 

endmodule