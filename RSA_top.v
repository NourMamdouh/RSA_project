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
reg [N_width-1 : 0] ff_rslt_in;
wire [N_width-1 : 0] ff_rslt_out;
reg [N_width-1 : 0] mult_in1;
wire [expo_width-1 : 0] Res_rst_val;
reg [counter_width-1:0] end_cnt_val;

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

	
	always @(*) begin
		if(expo==0)begin
			end_cnt_val = expo; //no need to operate, counter rst value is the final result
		end
		else begin
			end_cnt_val = expo+1;
		end
	end
		
///////////////////////////////////////////////	 
	 	 
	 mult_DSP #(N_width,base_width) mult_top (
    .in1(mult_in1), 
    .in2(base), 
    .mult_out(mult_out_top)
    );
	 
	always @(*)begin
		if(top_cntr_out==0)begin
			mult_in1 = 1;
		end
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
	
//////////////////////////////////////	
	 	 
	 rslt_ff #(.width(N_width)) rslt (
    .clk(CLK_OUT1), 
    .rst(start),
	 .rst_val(Res_rst_val), 
    .data_in(ff_rslt_in),
	 .w_en(done), // write enable is active low, so once done turns to 1, result ff keeps its final result
    .data_out(ff_rslt_out)
    );
	 
always @(*) begin ff_rslt_in = mod_out; end

 //when expo=0, counter is no longer our guide
 // if expo=0 and N=1, then result= 1%1 = 0 --> Res_rst_val=0
 // if expo =0 and N equals anything but zero, then result = 1 --> Res_rst_val=1
 // ic case of any other values but the two previously discussed case, the correct value to start with is always 1 --> Res_rst_val=1
assign Res_rst_val = (expo == 0 && N==1) ? 0:1;
	 

///////////////////////////////////// 	 
		
assign result = done==1? ff_rslt_out : 0; //output port (result) value is always zero unless the correct final result value is ready
assign valid = done;


endmodule