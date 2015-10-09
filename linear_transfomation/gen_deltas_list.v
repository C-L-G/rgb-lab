/****************************************
______________                ______________
______________ \  /\  /|\  /| ______________
______________  \/  \/ | \/ | ______________
--Module Name:  gen_deltas_list.v
--Project Name: rgb-lab
--Data modified: 2015-10-09 13:23:48 +0800
--author:Young-ÎâÃ÷
--E-mail: wmy367@Gmail.com
****************************************/
`timescale 1ns/1ps
module gen_deltas_list #(
	parameter					DSIZE			= 16, 
    parameter					DT_I			= 8, 
	parameter					DT_D			= 4, 
	parameter [DSIZE-1:0]		M00				= 0,
	parameter [DSIZE-1:0]		M01         	= 16+M00,
	parameter [DSIZE-1:0]		M02         	= 16+M01,
	parameter [DSIZE-1:0]		M03         	= 16+M02,
	parameter [DSIZE-1:0]		M04         	= 16+M03,
	parameter [DSIZE-1:0]		M05         	= 16+M04,
	parameter [DSIZE-1:0]		M06         	= 16+M05,
	parameter [DSIZE-1:0]		M07         	= 16+M06,
	parameter [DSIZE-1:0]		M08         	= 16+M07,
	parameter [DSIZE-1:0]		M09         	= 16+M08,
	parameter [DSIZE-1:0]		M10         	= 16+M09,
	parameter [DSIZE-1:0]		M11         	= 16+M10,
	parameter [DSIZE-1:0]		M12         	= 16+M11,
	parameter [DSIZE-1:0]		M13         	= 16+M12,
	parameter [DSIZE-1:0]		M14         	= 16+M13,
	parameter [DSIZE-1:0]		M15         	= 16+M14,
	parameter [DSIZE-1:0]		M16         	= 16+M15
)(
	input					clock		,
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
	input [DSIZE-1:0]		C16			,  

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
	output [DT_I+DT_D-1:0]			delta14     ,
	output [DT_I+DT_D-1:0]			delta15 
);


reg [3:0]	cstate,nstate;
localparam 	IDLE	= 4'd0	,
			LAT		= 4'd1  ,
			FSH		= 4'd2  ;

always@(posedge clock,negedge rst_n)
	if(~rst_n)	cstate	= IDLE;
	else		cstate	= nstate;

reg		cnt_fsh;

always@(*)
	case(cstate)
	IDLE:	nstate	= LAT;
	LAT: 	if(cnt_fsh)		nstate	= FSH;
			else			nstate	= LAT;
	FSH:	if(cal_begin)	nstate	= IDLE;  
			else			nstate	= FSH;
	default:				nstate	= IDLE;
	endcase

always@(posedge clock,negedge rst_n)begin:COUNTER
reg [2:0]	cnt;
	if(~rst_n)begin
		cnt_fsh	<= 1'b0;
		cnt		<= 3'd0;
	end else begin
		cnt_fsh	<= &cnt;
		case(nstate)
		LAT:	cnt	<= cnt + 1'b1;
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


reg [DSIZE-1:0]		DC00		;
reg [DSIZE-1:0]		DC01        ;
reg [DSIZE-1:0]		DC02        ;
reg [DSIZE-1:0]		DC03        ;
reg [DSIZE-1:0]		DC04        ;
reg [DSIZE-1:0]		DC05        ;
reg [DSIZE-1:0]		DC06        ;
reg [DSIZE-1:0]		DC07        ;
reg [DSIZE-1:0]		DC08        ;
reg [DSIZE-1:0]		DC09        ;
reg [DSIZE-1:0]		DC10        ;
reg [DSIZE-1:0]		DC11        ;
reg [DSIZE-1:0]		DC12        ;
reg [DSIZE-1:0]		DC13        ;
reg [DSIZE-1:0]		DC14        ;
reg [DSIZE-1:0]		DC15        ;

//always@(posedge clock)begin
always@(*)begin
	DC00	= C01	- C00	;	
	DC01    = C02	- C01   ;
	DC02    = C03	- C02   ;
	DC03    = C04	- C03   ;
	DC04    = C05	- C04   ;
	DC05    = C06	- C05   ;
	DC06    = C07	- C06   ;
	DC07    = C08	- C07   ;
	DC08    = C09	- C08   ;
	DC09    = C10	- C09   ;
	DC10    = C11	- C10   ;
	DC11    = C12	- C11   ;
	DC12    = C13	- C12   ;
	DC13    = C14	- C13   ;
	DC14    = C15	- C14   ;
	DC15    = C16	- C15   ;
end
	

		
  

gen_delta #(.X_DISPLACEMENT(M01-M00),.DSIZE(DSIZE),.DT_I(DT_I),.DT_D(DT_D))gen_delta_inst00(.clock(clock),.y_displacement(DC00),.delta(delta00));
gen_delta #(.X_DISPLACEMENT(M02-M01),.DSIZE(DSIZE),.DT_I(DT_I),.DT_D(DT_D))gen_delta_inst01(.clock(clock),.y_displacement(DC01),.delta(delta01));
gen_delta #(.X_DISPLACEMENT(M03-M02),.DSIZE(DSIZE),.DT_I(DT_I),.DT_D(DT_D))gen_delta_inst02(.clock(clock),.y_displacement(DC02),.delta(delta02));
gen_delta #(.X_DISPLACEMENT(M04-M03),.DSIZE(DSIZE),.DT_I(DT_I),.DT_D(DT_D))gen_delta_inst03(.clock(clock),.y_displacement(DC03),.delta(delta03));
gen_delta #(.X_DISPLACEMENT(M05-M04),.DSIZE(DSIZE),.DT_I(DT_I),.DT_D(DT_D))gen_delta_inst04(.clock(clock),.y_displacement(DC04),.delta(delta04));
gen_delta #(.X_DISPLACEMENT(M06-M05),.DSIZE(DSIZE),.DT_I(DT_I),.DT_D(DT_D))gen_delta_inst05(.clock(clock),.y_displacement(DC05),.delta(delta05));
gen_delta #(.X_DISPLACEMENT(M07-M06),.DSIZE(DSIZE),.DT_I(DT_I),.DT_D(DT_D))gen_delta_inst06(.clock(clock),.y_displacement(DC06),.delta(delta06));
gen_delta #(.X_DISPLACEMENT(M08-M07),.DSIZE(DSIZE),.DT_I(DT_I),.DT_D(DT_D))gen_delta_inst07(.clock(clock),.y_displacement(DC07),.delta(delta07));
gen_delta #(.X_DISPLACEMENT(M09-M08),.DSIZE(DSIZE),.DT_I(DT_I),.DT_D(DT_D))gen_delta_inst08(.clock(clock),.y_displacement(DC08),.delta(delta08));
gen_delta #(.X_DISPLACEMENT(M10-M09),.DSIZE(DSIZE),.DT_I(DT_I),.DT_D(DT_D))gen_delta_inst09(.clock(clock),.y_displacement(DC09),.delta(delta09));
gen_delta #(.X_DISPLACEMENT(M11-M10),.DSIZE(DSIZE),.DT_I(DT_I),.DT_D(DT_D))gen_delta_inst10(.clock(clock),.y_displacement(DC10),.delta(delta10));
gen_delta #(.X_DISPLACEMENT(M12-M11),.DSIZE(DSIZE),.DT_I(DT_I),.DT_D(DT_D))gen_delta_inst11(.clock(clock),.y_displacement(DC11),.delta(delta11));
gen_delta #(.X_DISPLACEMENT(M13-M12),.DSIZE(DSIZE),.DT_I(DT_I),.DT_D(DT_D))gen_delta_inst12(.clock(clock),.y_displacement(DC12),.delta(delta12));
gen_delta #(.X_DISPLACEMENT(M14-M13),.DSIZE(DSIZE),.DT_I(DT_I),.DT_D(DT_D))gen_delta_inst13(.clock(clock),.y_displacement(DC13),.delta(delta13));
gen_delta #(.X_DISPLACEMENT(M15-M14),.DSIZE(DSIZE),.DT_I(DT_I),.DT_D(DT_D))gen_delta_inst14(.clock(clock),.y_displacement(DC14),.delta(delta14));   
gen_delta #(.X_DISPLACEMENT(M16-M15),.DSIZE(DSIZE),.DT_I(DT_I),.DT_D(DT_D))gen_delta_inst15(.clock(clock),.y_displacement(DC15),.delta(delta15));   


assign	cal_valid	= !cal_begin && valid;


endmodule
																												       
