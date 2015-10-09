/****************************************
______________                ______________
______________ \  /\  /|\  /| ______________
______________  \/  \/ | \/ | ______________
--Module Name:  gen_delta.v
--Project Name: rgb-lab
--Data modified: 2015-10-09 13:23:48 +0800
--author:Young-ÎâÃ÷
--E-mail: wmy367@Gmail.com
****************************************/
`timescale 1ns/1ps
module gen_delta #(
	parameter	X_DISPLACEMENT	= 16,
	parameter	DSIZE			= 16,
	parameter	DT_I			= 8,
	parameter	DT_D			= 4
)(
	input						clock			,
	input [DSIZE-1:0]			y_displacement	,
	output[DT_I+DT_D-1:0]		delta
);

localparam [DSIZE-1:0]	X_RECIPROCAL	= 2**DSIZE/X_DISPLACEMENT; //default : 16'h0100  = 1/16 = 16'h0100/16'hFFFF = 16'h0100/17'h1_0000

reg [2*DSIZE-1:0]	slope;

always@(posedge clock)
	slope	<= y_displacement * X_RECIPROCAL;

reg [DT_I+DT_D-1:0]	delta_reg;		//[3:0].[DT-4:0]
								//32'hxxxx_xxxx_xxxx_xxxx
								//DT'h_______xx.x________
always@(posedge clock)
	if(|slope[2*DSIZE-1:DSIZE+DT_I+1])
			delta_reg	<= {(DT_I+DT_D){1'b1}};
	else 	delta_reg	<= {slope[DSIZE+:DT_I],slope[DSIZE-1-:DT_D]};

assign	delta	= delta_reg;

endmodule

