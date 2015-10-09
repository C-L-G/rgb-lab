/****************************************
______________                ______________
______________ \  /\  /|\  /| ______________
______________  \/  \/ | \/ | ______________
--Module Name:  matrix_multiper_complement.v
--Project Name: rgb-lab
--Data modified: 2015-10-09 13:23:48 +0800
--author:Young-ÎâÃ÷
--E-mail: wmy367@Gmail.com
****************************************/
`timescale 1ns/1ps
module #(
	parameter	DSIZE	= 16  	,
	parameter	MSIZE	= 16
)(
	input				clock	,
	input [DSIZE-1:0]	A      	,
	input [DSIZE-1:0]	B      	,
	input [DSIZE-1:0]	C      	,

	input [MSIZE-1:0]	M00  	,
	input [MSIZE-1:0]	M01     ,
	input [MSIZE-1:0]	M02     ,
	input [MSIZE-1:0]	M10     ,
	input [MSIZE-1:0]	M11     ,
	input [MSIZE-1:0]	M12     ,
	input [MSIZE-1:0]	M20     ,
	input [MSIZE-1:0]	M21     ,
	input [MSIZE-1:0]	M22     ,
	
	output[DSIZE-1:0]	X 		,
	output[DSIZE-1:0]	Y     	,
	output[DSIZE-1:0]	Z
);

