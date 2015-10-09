/****************************************
______________                ______________
______________ \  /\  /|\  /| ______________
______________  \/  \/ | \/ | ______________
--Module Name:  lab_to_rgb.v
--Project Name: rgb-lab
--Data modified: 2015-10-09 13:23:48 +0800
--author:Young-ÎâÃ÷
--E-mail: wmy367@Gmail.com
****************************************/
`timescale 1ns/1ps
module lab_to_rgb #(
	parameter	DSIZE	= 16
)(
	input				clock 	,
	input [6:0]			CIE_L   ,
	input [9:0]			CIE_A   ,
	input [8:0]			CIE_B   ,
	output[DSIZE-1:0]	R       ,
	output[DSIZE-1:0]	G       ,
	output[DSIZE-1:0]	B       
);


wire[DSIZE-1:0]			US_L;
wire[DSIZE-1:0]			US_A;
wire[DSIZE-1:0]			US_B;
wire					sign_us_a;
wire					sign_us_b;

lab_map_space #(
	.DSIZE		(DSIZE			)
)lab_map_space_inst(
	.clock  	(clock			),
	.rst_n      (1'b1           ),
	.CIE_L      (CIE_L          ),
	.CIE_A      (CIE_A          ),
	.CIE_B      (CIE_B          ),
	.US_L       (US_L           ),
	.US_A       (US_A           ),
	.US_B       (US_B           ),
	.sign_a     (sign_us_a      ),
	.sign_b     (sign_us_b      )
);  

wire[DSIZE-1:0]	FFx;
wire[DSIZE-1:0]	FFy;
wire[DSIZE-1:0]	FFz;
wire			sign_FFx;
wire			sign_FFz;

Fn_FFn #(
	.DSIZE		(DSIZE			)
)Fn_FFn_inst(
	.clock		(clock			),
	.rst_n      (1'b1           ),
	.Fx         (US_A           ),
	.Fy         (US_L           ),
	.Fz         (US_B           ),
	.sign_Fx	(sign_us_a      ),
	.sign_Fz	(sign_us_b      ),
	.FFx        (FFx            ),
	.FFy        (FFy            ),
	.FFz		(FFz		    ),
	.sign_FFx	(sign_FFx	    ),
	.sign_FFz	(sign_FFz	    )
); 


wire[DSIZE-1:0]		X,Y,Z;

root3 #(
	.DSIZE		(DSIZE			)
)X_root3_inst(
	.clock		(clock			),
	.rst_n		(1'b1			),
	.X			(FFx			),
	.Y      	(X				)
);

root3 #(
	.DSIZE		(DSIZE			)
)Y_root3_inst(
	.clock		(clock			),
	.rst_n		(1'b1			),
	.X			(FFy			),
	.Y      	(Y				)
);

root3 #(
	.DSIZE		(DSIZE			)
)Z_root3_inst(
	.clock		(clock			),
	.rst_n		(1'b1			),
	.X			(FFz			),
	.Y      	(Z				)
);

XYZ_to_RGB #(
	.DSIZE		(DSIZE			)
)XYZ_to_RGB_inst(
	.clock 		(clock			),
	.X		    (X              ),
	.Y		    (Y              ),
	.Z		    (Z              ),
	.R		    (R              ),
	.G		    (G              ),
	.B		    (B              ),
	.sign_r	    (               ),
	.sign_g	    (               ),
	.sign_b     (               )
);


endmodule  

