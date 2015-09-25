/****************************************
______________                ______________
______________ \  /\  /|\  /| ______________
______________  \/  \/ | \/ | ______________
--Module Name:  gen_delta_same_DM.v
--Project Name: rgb-lab
--Data modified: 2015-09-25 11:19:09 +0800
--author:Young-ÎâÃ÷
--E-mail: wmy367@Gmail.com
****************************************/
`timescale	1ns/1ps
module gen_delta_same_DM #(
	parameter					DSIZE			= 16, 
    parameter					DT_I			= 8,  
	parameter					DT_D			= 4,
	parameter [DSIZE-1:0]		DM				= 16
)(
	input					clock 		,
	input					rst_n       ,
	input					cal_begin   ,
	output					cal_valid   ,

	input [DSIZE-1:0]		C00			, 
	input [DSIZE-1:0]		C01         , 
	input [DSIZE-1:0]		C02         , 
	input [DSIZE-1:0]		C03         , 
	input [DSIZE-1:0]		C04         , 
	input [DSIZE-1:0]		C05         , 
	input [DSIZE-1:0]		C06         , 
	input [DSIZE-1:0]		C07         , 
	input [DSIZE-1:0]		C08         , 
	input [DSIZE-1:0]		C09         , 
	input [DSIZE-1:0]		C10         , 
	input [DSIZE-1:0]		C11         , 
	input [DSIZE-1:0]		C12         , 
	input [DSIZE-1:0]		C13         , 
	input [DSIZE-1:0]		C14         , 
	input [DSIZE-1:0]		C15         ,  

	output [DT_I+DT_D-1:0]			delta00 	,
	output [DT_I+DT_D-1:0]			delta01     ,
	output [DT_I+DT_D-1:0]			delta02     ,
	output [DT_I+DT_D-1:0]			delta03     ,
	output [DT_I+DT_D-1:0]			delta04     ,
	output [DT_I+DT_D-1:0]			delta05     ,
	output [DT_I+DT_D-1:0]			delta06     ,
	output [DT_I+DT_D-1:0]			delta07     ,
	output [DT_I+DT_D-1:0]			delta08     ,
	output [DT_I+DT_D-1:0]			delta09     ,
	output [DT_I+DT_D-1:0]			delta10     ,
	output [DT_I+DT_D-1:0]			delta11     ,
	output [DT_I+DT_D-1:0]			delta12     ,
	output [DT_I+DT_D-1:0]			delta13     ,
	output [DT_I+DT_D-1:0]			delta14      
);

reg [3:0]	cstate,nstate;
localparam 	IDLE	= 4'd0	,
			PREPARE	= 4'd1	,
			WAIT_D	= 4'd2  ,
			CATCH_D	= 4'd3	,
			FSH		= 4'd4  ;

always@(posedge clock,negedge rst_n)
	if(~rst_n)	cstate	= IDLE;
	else if(cal_begin)
				cstate	= IDLE;
	else		cstate	= nstate;

reg		cnt_fsh;
reg		list_fsh;

always@(*)
	case(cstate)
	IDLE:		nstate	= PREPARE;
	PREPARE: 	nstate	= WAIT_D;
	WAIT_D:  	if(cnt_fsh)	nstate	= CATCH_D;
				else		nstate	= WAIT_D;
	CATCH_D:	if(list_fsh)nstate	= FSH;
				else		nstate	= PREPARE;
	default:	nstate	= IDLE;
	endcase

reg	[3:0]		list_cnt;

always@(posedge clock,negedge rst_n)
	if(~rst_n)	list_cnt	<= 4'd0;
	else
		case(nstate)
		IDLE:	list_cnt	<= 4'd0;
		CATCH_D:begin
					if(list_cnt < 4'd14)
							list_cnt	<= list_cnt + 1'b1;
					else	list_cnt	<= list_cnt;
		end
		default:;
		endcase

always@(posedge clock,negedge rst_n)
	if(~rst_n)	list_fsh	<= 1'b0;
	else		list_fsh	<= list_cnt == 4'd14;


reg [DSIZE-1:0]	p_displacement;

always@(posedge clock,negedge rst_n)
	if(~rst_n)	p_displacement	<= {DSIZE{1'b0}};
	else 
		case(nstate)
		IDLE:	p_displacement	<= {DSIZE{1'b0}};
		PREPARE:begin
			case(list_cnt)
			4'd0:	p_displacement	<= C01-C00;
			4'd1:	p_displacement	<= C02-C01;
			4'd2:	p_displacement	<= C03-C02;
			4'd3:	p_displacement	<= C04-C03;
			4'd4:	p_displacement	<= C05-C04;
			4'd5:	p_displacement	<= C06-C05;
			4'd6:	p_displacement	<= C07-C06;
			4'd7:	p_displacement	<= C08-C07;
			4'd8:	p_displacement	<= C09-C08;
			4'd9:	p_displacement	<= C10-C09;
			4'd10:	p_displacement	<= C11-C10;
			4'd11:	p_displacement	<= C12-C11;
			4'd12:	p_displacement	<= C13-C12;
			4'd13:	p_displacement	<= C14-C13;
			4'd14:	p_displacement	<= C15-C14;
			default:p_displacement	<= {DSIZE{1'b0}};
			endcase
		end
		default:;
		endcase

always@(posedge clock,negedge rst_n)begin:COUNTER
reg [2:0]	cnt;
	if(~rst_n)begin
		cnt_fsh	<= 1'b0;
		cnt		<= 3'd0;
	end else begin
		cnt_fsh	<= &cnt;
		case(nstate)
		WAIT_D:	cnt	<= cnt + 1'b1;
		default:cnt	<= 3'd0;
		endcase
end end

reg		valid;
always@(posedge clock,negedge rst_n)
	if(~rst_n)	valid	<= 1'b0;
	else 
		case(nstate)
		FSH:	valid	<= 1'b1;
		default:valid	<= 1'b0;
		endcase

reg [DT_I+DT_D-1:0]	delta [14:0];
wire[DT_I+DT_D-1:0]	rel_delta;

always@(posedge clock)
	case(nstate)
	CATCH_D:	delta[list_cnt] = rel_delta;
	default:;
	endcase


gen_delta #(
	.X_DISPLACEMENT		(DM),
	.DSIZE				(DSIZE),
	.DT_I				(DT_I),
	.DT_D				(DT_D)
)gen_delta_inst00(
	.clock				(clock),
	.y_displacement		(p_displacement),
	.delta				(rel_delta)
);
	

assign	cal_valid	= !cal_begin && valid;

assign	delta00		= delta[ 0]; 
assign	delta01		= delta[ 1];
assign	delta02		= delta[ 2]; 
assign	delta03		= delta[ 3];
assign	delta04		= delta[ 4]; 
assign	delta05		= delta[ 5];
assign	delta06		= delta[ 6]; 
assign	delta07		= delta[ 7];
assign	delta08		= delta[ 8]; 
assign	delta09		= delta[ 9];
assign	delta10		= delta[10]; 
assign	delta11		= delta[11];
assign	delta12		= delta[12]; 
assign	delta13		= delta[13];
assign	delta14		= delta[14]; 

endmodule




				
