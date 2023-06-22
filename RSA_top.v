module RSA_top #(parameter base_width=6, parameter expo_width=6, parameter N_width= 6) (input [expo_width-1 : 0] expo,
input clk, 
input start,
input [base_width-1 : 0] base,
input [N_width-1 : 0] N,
output [N_width-1 : 0] result,
output valid);


parameter mult_width = base_width + N_width ;
wire [mult_width-1 : 0] mult_out_top;
wire [N_width-1 : 0] mod_out;
wire done;
wire [expo_width-1 : 0] top_cntr_out;
reg [N_width-1 : 0] rslt_in;
wire [N_width-1 : 0] rslt_out;
reg [N_width-1 : 0] mult_in1;
wire [expo_width-1 : 0] Res_rst_val;



//////////////////////////////////////////////////////

	 counter #(.cntr_width(expo_width)) top_cntr (
    .rst(start), 
    .clk(clk), 
    .end_val(expo), 
    .done(done), 
    .cntr_out(top_cntr_out)
    );	
 
		
///////////////////////////////////////////////	 
	 	 
	 mult_DSP #(N_width,base_width) mult_top (
    .in1(mult_in1), 
    .in2(base), 
    .mult_out(mult_out_top)
    );
	 
	always @(*)begin
		if(start)begin
			mult_in1 = 1;
		end
		else begin
			mult_in1 = mod_out;
		end
	end

////////////////////////////////////	 
	bram #(.num_width(mult_width),.N_width(N_width)) mod (
    .clk(clk), 
    .N(N), 
    .num(mult_out_top), 
    .out(mod_out)
    );
	
//////////////////////////////////////	
	 	 
	 rslt_ff #(.width(N_width)) rslt (
    .clk(clk), 
    .rst(start),
	 .rst_val(Res_rst_val), 
    .data_in(rslt_in),
	 .done(done),
    .data_out(rslt_out)
    ); 
always @(*) begin rslt_in = mod_out; end

 //when expo=0, counter is no longer our guide
 // if expo=0 and N=1, then result= 1%1 = 0 --> Res_rst_val=0
 // if expo =0 and N equals anything but zero, then result = 1 --> Res_rst_val=1
 // ic case of any other values but the two previously discussed case, the correct value to start with is always 1 --> Res_rst_val=1
assign Res_rst_val = (expo == 0 && N==1) ? 0:1;  
	 
////////////////////////////////////	 	 
		
assign result = done==1? rslt_out : 0;  //output port (result) value is always zero unless the correct result value is ready
assign valid = done;


endmodule