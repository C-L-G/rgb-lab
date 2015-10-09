/****************************************
______________                ______________
______________ \  /\  /|\  /| ______________
______________  \/  \/ | \/ | ______________
--Module Name:  lab_map_space.v
--Project Name: rgb-lab
--Data modified: 2015-10-09 13:23:48 +0800
--author:Young-ÎâÃ÷
--E-mail: wmy367@Gmail.com
****************************************/
`timescale 1ns/1ps
module lab_map_space #(
	parameter	DSIZE	= 16
)(
	input				clock  		,
	input				rst_n       ,
	input [6:0]			CIE_L       ,
	input [9:0] 		CIE_A       ,
	input [8:0]			CIE_B       ,
	output[DSIZE-1:0]	US_L        ,
	output[DSIZE-1:0]	US_A        ,
	output[DSIZE-1:0]	US_B        ,
	output				sign_a      ,
	output				sign_b
);

//--->> L / 116 <<------------

localparam [DSIZE-6:0]	M116	=  0.008620 * (2**DSIZE);
localparam [DSIZE-2:0]	M16		=   0.13793 * (2**DSIZE);

wire[DSIZE-5+7-1:0]	Mfy;
assign	Mfy	= CIE_L * M116;

reg [DSIZE-1:0]		Sfy;
reg	[DSIZE-2:0]		SM16;
reg					up8;

always@(posedge clock)begin
//	Sfy		<= Mfy[DSIZE-5+7-1-:DSIZE];
	Sfy		<= (CIE_L>8)? CIE_L + 16 : CIE_L;
	up8		<= CIE_L > 8;
end


reg [DSIZE-1:0]	Fy;

always@(posedge clock)
//	Fy	<= Sfy + M16;
	Fy	<= up8? Sfy * M116 : (Sfy << 8);

//---<< L / 116 >>------------
//--->> A / 500 <<------------
reg [8:0]		abs_adata;
reg				sign_adata;

always@(posedge clock)begin
	abs_adata	<= CIE_A[9]? 10'd512 - CIE_A[8:0] : CIE_A[8:0];
	sign_adata	<= CIE_A[9];
end

localparam	[DSIZE-6:0]	M500	= 0.002 * (2**DSIZE);

wire[DSIZE-5+9-1:0]		Mfx;
assign	Mfx		= abs_adata * M500;

reg [DSIZE-1:0]	Fx;
reg				sign_Fx;
always@(posedge clock)begin
	Fx		<= Mfx[0+:DSIZE];
	sign_Fx	<= sign_adata;
end
//---<< A / 500 >>------------
//--->> B / 200 <<------------
reg [7:0]		abs_bdata;
reg				sign_bdata;

always@(posedge clock)begin
	abs_bdata	<= CIE_B[8]? 10'd256 - CIE_B[7:0] : CIE_B[7:0];
	sign_bdata	<= CIE_B[8];
end

localparam	[DSIZE-6:0]	M200	= 0.005 * (2**DSIZE);

wire[DSIZE-5+8-1:0]		Mfz;
assign	Mfz		= abs_bdata * M200;

reg [DSIZE-1:0]		Fz;
reg					sign_Fz;
always@(posedge clock)begin
	Fz		<= Mfz[0+:DSIZE];
	sign_Fz	<= sign_bdata;
end
//---<< B / 200 >>------------

assign	US_L	= Fy;
assign	US_A	= Fx;
assign	US_B	= Fz;

assign	sign_a	= sign_Fx;
assign	sign_b	= sign_Fz;

endmodule

