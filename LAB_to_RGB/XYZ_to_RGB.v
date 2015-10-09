/****************************************
______________                ______________
______________ \  /\  /|\  /| ______________
______________  \/  \/ | \/ | ______________
--Module Name:  XYZ_to_RGB.v
--Project Name: rgb-lab
--Data modified: 2015-10-09 13:23:48 +0800
--author:Young-ÎâÃ÷
--E-mail: wmy367@Gmail.com
****************************************/
`timescale 1ns/1ps
module XYZ_to_RGB #(
	parameter	DSIZE	= 16
)(
	input				clock	,
	input [DSIZE-1:0]	X		,
	input [DSIZE-1:0]	Y		,
	input [DSIZE-1:0]	Z		,
	output[DSIZE-1:0]	R		,
	output[DSIZE-1:0]	G		,
	output[DSIZE-1:0]	B		,
	output				sign_r	,
	output				sign_g	,
	output				sign_b 
);  
    
/*
  3.083315768500000  -1.537150000000000  -0.542705201000000
 -0.922247084000000   1.875992000000000   0.045237861600000
  0.052949072000000  -0.204043000000000   1.150988754600000
*/

localparam	MSIZE	= 16;  

localparam	[MSIZE-2:0]
M00		=  3.0833157685	* 2**(MSIZE-2-1),
M01		=  1.5371500000	* 2**(MSIZE-2-1),
M02		=  0.5427052010	* 2**(MSIZE-2-1),
M10		=  0.9222470840	* 2**(MSIZE-2-1),
M11		=  1.8759920000	* 2**(MSIZE-2-1),
M12		=  0.0452378616	* 2**(MSIZE-2-1),
M20		=  0.0529490720	* 2**(MSIZE-2-1),
M21		=  0.2040430000	* 2**(MSIZE-2-1),
M22		=  1.1509887546	* 2**(MSIZE-2-1);

wire[DSIZE+2+1:0]		mr,mg,mb;

matrix_multiper_verb3 #(         
	.DSIZE		(DSIZE			),           
	.MSIZE		(MSIZE			),
	.NSIZE		(2				)        
)matrix_multiper_inst(                                
	.clock		(clock			),	
	.iR     	(X          	),
	.iG     	(Y          	),
	.iB     	(Z          	),
            
	.M00		({1'b0,M00}		 	), 	
	.M01        ({1'b1,M01}		    ),
	.M02        ({1'b1,M02}		    ),
	.M10        ({1'b1,M10}		    ),
	.M11        ({1'b0,M11}		    ),
	.M12        ({1'b0,M12}		    ),
	.M20        ({1'b0,M20}		    ),
	.M21        ({1'b1,M21}		    ),
	.M22        ({1'b0,M22}		    ),
	        
	.Ro 		(mr			),	
	.Go         (mg	        ),
	.Bo         (mb         )
);    


assign	sign_r		= mr[DSIZE+2+1];
assign	sign_g		= mg[DSIZE+2+1];
assign	sign_b		= mb[DSIZE+2+1];

wire[DSIZE-1:0]	ceil_r,ceil_g,ceil_b;
reg [DSIZE-1:0]	r_reg,g_reg,b_reg;

ceiling #(
	.DSIZE		(DSIZE+3),
	.CSIZE		(3),		//must smaller than DSIZE
	.OSIZE		(DSIZE),        //must not bigger than DSIZE-CSIZE
	.SEQUENTIAL	("FALSE")
)r_ceiling(
	.clock		(clock	),
	.indata 	(mr[DSIZE+2:0]    ),
	.outdata	(ceil_r    )
);

ceiling #(
	.DSIZE		(DSIZE+3),
	.CSIZE		(3),		//must smaller than DSIZE
	.OSIZE		(DSIZE),        //must not bigger than DSIZE-CSIZE
	.SEQUENTIAL	("FALSE")
)g_ceiling(
	.clock		(clock	),
	.indata 	(mg[DSIZE+2:0]    ),
	.outdata	(ceil_g    )
);

ceiling #(
	.DSIZE		(DSIZE+3),
	.CSIZE		(3),		//must smaller than DSIZE
	.OSIZE		(DSIZE),        //must not bigger than DSIZE-CSIZE
	.SEQUENTIAL	("FALSE")
)b_ceiling(
	.clock		(clock	),
	.indata 	(mb[DSIZE+2:0]    ),
	.outdata	(ceil_b    )
);

always@(posedge clock)begin
	r_reg	<= sign_r? {DSIZE{1'b0}} : ceil_r;
	g_reg	<= sign_g? {DSIZE{1'b0}} : ceil_g;
	b_reg	<= sign_b? {DSIZE{1'b0}} : ceil_b;
end  

assign	R			=	r_reg;
assign	G			=	g_reg;
assign	B			=	b_reg;

endmodule
