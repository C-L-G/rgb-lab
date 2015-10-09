/****************************************
______________                ______________
______________ \  /\  /|\  /| ______________
______________  \/  \/ | \/ | ______________
--Module Name:  rgb_to_lab_verb.v
--Project Name: rgb-lab
--Data modified: 2015-10-09 13:23:48 +0800
--author:Young-ÎâÃ÷
--E-mail: wmy367@Gmail.com
****************************************/
`timescale 1ns/1ps
module rgb_to_lab_verb #(
	parameter	DSIZE	= 16
)(
	input				clock	,
	input [DSIZE-1:0]	R       ,
	input [DSIZE-1:0]	G       ,
	input [DSIZE-1:0]	B       ,
	output[DSIZE-1:0]	CIE_L   ,
	output[DSIZE-1:0]	CIE_A   ,
	output[DSIZE-1:0]	CIE_B
);

//----->> Mult Matrix <<----------
wire[DSIZE-1:0]	X,Y;
wire[DSIZE-1:0]	Z;


RGB_XYZ_verb #(
	.DSIZE			(DSIZE		)
)RGB_XYZ_inst(
	.clock			(clock		),
	.R              (R          ),
	.G              (G          ),
	.B              (B          ),
	.X              (X          ),
	.Y              (Y          ),
	.Z              (Z          )
);
//-----<< Mult Matrix >>----------
//----->> F(t) = t**(1/3)<<-------
wire[DSIZE-1:0]		Fx;
wire[DSIZE-1:0]		Fy;
wire[DSIZE-1:0]		Fz;

root1D3 #(
	.DSIZE			(DSIZE	)
)root1D3_fx_inst(
	.clock			(clock		),
	.rst_n			(1'b0       ),
	.X				(X			),
	.Y      		(Fx         )
);

root1D3 #(
	.DSIZE			(DSIZE		)
)root1D3_fy_inst(
	.clock			(clock		),
	.rst_n			(1'b0       ),
	.X				(Y			),
	.Y      		(Fy         )
);

root1D3 #(
	.DSIZE			(DSIZE	)
)root1D3_fz_inst(
	.clock			(clock		),
	.rst_n			(1'b0       ),
	.X				(Z			),
	.Y      		(Fz         )
);
//-----<< F(t) = t**(1/3)>>-------
//----->> MAP TO LAB <<-----------
reg [DSIZE+8-1:0]	ML;
reg [DSIZE-1:0]		SXY;
reg [DSIZE-1:0]		SYZ;
reg					sign_SXY;
reg					sign_SYZ;
reg					L_up_16;

localparam[DSIZE-1:0]	UP16	= 0.137932 * 2**DSIZE;

wire				sign_xy;
wire				sign_yz;
wire				l_up_16;
assign	sign_xy	= Fx < Fy;
assign	sign_yz	= Fy < Fz;
assign	l_up_16	= Fy > UP16;

always@(posedge clock)begin
	ML			<= l_up_16? Fy * 8'd116 : Fy << 8;
	SXY			<= sign_xy? (Fy-Fx) : (Fx-Fy);
	SYZ			<= sign_yz? (Fz-Fy) : (Fy-Fz);
	sign_SXY	<= sign_xy;
	sign_SYZ	<= sign_yz;
	L_up_16		<= l_up_16;
	
end

//--->> MAP to 100 200 500 <<----

wire[DSIZE-1+9:0]	a500;
wire[DSIZE-1+8:0]	b200;

assign	a500	= SXY * 9'd500;
assign	b200	= SYZ * 8'd200;

reg [DSIZE-1:0]		a_sign;
reg [DSIZE-1:0]		b_sign;

always@(posedge clock)begin
	if(sign_SXY)
			a_sign	<= 	(1'b1 << DSIZE) - a500[DSIZE-1+9-:9];
	else	a_sign	<= a500[DSIZE-1+9-:9];
end

always@(posedge clock)begin
	if(sign_SYZ)
			b_sign	<= 	(1'b1 << DSIZE) - b200[DSIZE-1+8-:8];
	else	b_sign	<= b200[DSIZE-1+8-:8];
end
//---<< MAP to 100 200 500 >>----
reg [DSIZE-1:0]		l_data;

always@(posedge clock)begin
	l_data	<= L_up_16? ML[DSIZE+8-1-:8]-5'd16 : ML[DSIZE+8-1-:8];
end


assign	CIE_L	= l_data;
assign	CIE_A	= a_sign;
assign	CIE_B	= b_sign;

endmodule


