module RSA_top #(parameter base_width=4, parameter expo_width=4, parameter N_width= 4) (input [expo_width-1 : 0] expo,
input clk_n,
input clk_p,
input RESET,
input start,
input [base_width-1 : 0] base,
input [N_width-1 : 0] N,
output [N_width-1 : 0] result,
output valid);


parameter mult_width = base_width + N_width ;
parameter counter_width = expo_width+1;

wire [mult_width-1 : 0] mult_out_top;
wire [N_width-1 : 0] mod_out;
wire [expo_width-1 : 0] top_cntr_out;
wire [N_width-1 : 0] ff_rslt_in;
wire [N_width-1 : 0] ff_rslt_out;
reg [N_width-1 : 0] mult_in1;
reg [expo_width-1 : 0] Res_rst_val;
reg [counter_width-1:0] end_cnt_val;
reg [N_width-1 : 0] N_top;

wire done;



  clk_gen ip_clk
   (// Clock in ports
    .CLK_IN1_P(clk_p),    // IN
    .CLK_IN1_N(clk_n),    // IN
    // Clock out ports
    .CLK_OUT1(CLK_OUT1),     // OUT
    // Status and control signals
    .RESET(RESET));       // IN

//////////////////////////////////////////////////////

	 counter #(.cntr_width(counter_width)) top_cntr (
    .rst(start), 
    .clk(CLK_OUT1), 
    .end_val(end_cnt_val), 
    .done(done), // once done signal is on, result is ready to be accounted for
    .cntr_out(top_cntr_out)
    );	

	
		
///////////////////////////////////////////////	 
	 	 
	 mult_DSP #(N_width,base_width) mult_top (
    .in1(mult_in1), 
    .in2(base), 
    .mult_out(mult_out_top)
    );
	 
	always @(*)begin
		if(top_cntr_out==0)begin
			mult_in1 = 1; 
		else begin
			mult_in1 = mod_out;
		end
	end

////////////////////////////////////	 
	bram #(.num_width(mult_width),.N_width(N_width)) mod (
    .clk(CLK_OUT1), 
    .N(N), 
    .num(mult_out_top), 
    .out(mod_out)
    );
	
always @(*) begin
	if(N > 1)begin 
		N_top = N;
	end
	else begin // special cases, N_top could be any value but 0 or 1 --> 2 is chosen
		N_top = 2; 
	end
end
	
//////////////////////////////////////	
	 	 
	 rslt_ff #(.width(N_width)) rslt (
    .clk(CLK_OUT1), 
    .rst(start),
	 .rst_val(Res_rst_val), 
    .data_in(ff_rslt_in),
	 .w_en(done), // write enable is active low, so once done turns to 1, result ff keeps its final result
    .data_out(ff_rslt_out)
    );
	 
assign  ff_rslt_in = mod_out; 


/////////////////////////////////////

// dealing with special cases (exceptions)
always @(*) begin
	if(N==0 || N==1) begin
		Res_rst_val = 0;
		end_cnt_val = 0; // result is already ready, no need to count
	end
	else begin
		if(expo==0)begin
			Res_rst_val = 1;
			end_cnt_val = 0; // result is already ready, no need to count
		end
		else begin //normal cases
			Res_rst_val = 0; //could be any value
			end_cnt_val = expo+1;
		end
	end
end 
/////////////////////////////////////	 	 
		
assign result = done==1? ff_rslt_out : 0; //output port (result) value is always zero unless the correct final result value is ready
assign valid = done;


endmodule