/****************************************
______________                ______________
______________ \  /\  /|\  /| ______________
______________  \/  \/ | \/ | ______________
--Module Name:  Fn_FFn.v
--Project Name: rgb-lab
--Data modified: 2015-10-09 13:23:48 +0800
--author:Young-ÎâÃ÷
--E-mail: wmy367@Gmail.com
****************************************/
`timescale 1ns/1ps
module Fn_FFn #(
	parameter	DSIZE	= 16
)(
	input				clock		,
	input				rst_n       ,
	input [DSIZE-1:0]	Fx          ,
	input [DSIZE-1:0]	Fy          ,
	input [DSIZE-1:0]	Fz          ,
	input				sign_Fx		,
	input				sign_Fz		,
	output[DSIZE-1:0]	FFx         ,
	output[DSIZE-1:0]	FFy         ,
	output[DSIZE-1:0]	FFz			,
	output				sign_FFx	,
	output				sign_FFz	
); 


//----->> FFX <<---------------------
wire	Cxy;
assign	Cxy	= Fx > Fy;

reg [DSIZE:0]		ffx;
reg					sign_ffx;
always@(posedge clock)
	if(sign_Fx)
		if(Cxy)
				ffx		<= Fx-Fy;
		else	ffx		<= Fy-Fx;
	else		ffx		<= Fx+Fy;

always@(posedge clock)
	if(sign_Fx)
		if(Cxy)
				sign_ffx		<= 1'b1;
		else	sign_ffx		<= 1'b0;
	else		sign_ffx		<= 1'b0;

//-----<< FFX >>---------------------
//----->> FFY <<---------------------

reg [DSIZE-1:0]	ffy;

always@(posedge clock)
	ffy		<= Fy;

//-----<< FFY >>---------------------	
//----->> FFZ <<---------------------
wire		Cyz;
assign		Cyz	= Fy > Fz;

reg [DSIZE:0]	ffz;
reg				sign_ffz;

always@(posedge clock)
	if(sign_Fz)
		ffz		<= Fy + Fz;
	else 
		if(Cyz)
				ffz	<= Fy - Fz;
		else	ffz	<= Fz - Fy;

always@(posedge clock)
	if(sign_Fz)
		sign_ffz		<= 1'b0;
	else 
		if(Cyz)
				sign_ffz	<= 1'b0;
		else	sign_ffz	<= 1'b1;

//-----<< FFZ >>---------------------

//assign	FFx			= ffx;
//assign	FFy			= ffy;
//assign	FFz			= ffz;
assign	sign_FFx	= sign_ffx;
assign	sign_FFz	= sign_ffz;

ceiling #(
	.DSIZE		(DSIZE+1),
	.CSIZE		(1),		//must smaller than DSIZE
	.OSIZE		(DSIZE),        //must not bigger than DSIZE-CSIZE
	.SEQUENTIAL	("TRUE")
)ffx_ceiling(
	.clock		(clock	),
	.indata 	(ffx    ),
	.outdata	(FFx    )
);

ceiling #(
	.DSIZE		(DSIZE+1),
	.CSIZE		(1),		//must smaller than DSIZE
	.OSIZE		(DSIZE),        //must not bigger than DSIZE-CSIZE
	.SEQUENTIAL	("TRUE")
)ffz_ceiling(
	.clock		(clock	),
	.indata 	(ffz    ),
	.outdata	(FFz    )
);

reg [DSIZE-1:0]	ffy_reg;
reg				x_sign,z_sign;

always@(posedge clock)begin
	ffy_reg	<= ffy;
	x_sign	<= sign_ffx;
	z_sign	<= sign_ffz;
end

assign	FFy			= ffy_reg;
assign	sign_FFx	= x_sign;
assign	sign_FFz	= z_sign;


endmodule




	
