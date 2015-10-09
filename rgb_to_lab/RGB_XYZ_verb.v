/****************************************
______________                ______________
______________ \  /\  /|\  /| ______________
______________  \/  \/ | \/ | ______________
--Module Name:  RGB_XYZ_verb.v
--Project Name: rgb-lab
--Data modified: 2015-10-09 13:23:48 +0800
--author:Young-ÎâÃ÷
--E-mail: wmy367@Gmail.com
****************************************/
`timescale 1ns/1ps
module RGB_XYZ_verb #(
	parameter		DSIZE	= 16
)(
	input				clock	,
	input [DSIZE-1:0]	R       ,
	input [DSIZE-1:0]	G       ,
	input [DSIZE-1:0]	B       ,
	output[DSIZE-1:0]	X       ,
	output[DSIZE-1:0]	Y       ,
	output[DSIZE-1:0]	Z        
);

/*
   0.433475729410000   0.375805852600000   0.189619160310000
   0.212671000000000   0.715160000000000   0.072169000000000
   0.017757914092623   0.109476520866973   0.872765565040404
*/

localparam	MSIZE	= 16;  

localparam	[MSIZE-1:0]
M00		= 0.433475	* 2**(MSIZE-1),
M01		= 0.375805	* 2**(MSIZE-1),
M02		= 0.189619	* 2**(MSIZE-1),
M10		= 0.212671	* 2**(MSIZE-1),
M11		= 0.715160	* 2**(MSIZE-1),
M12		= 0.072169	* 2**(MSIZE-1),
M20		= 0.017757	* 2**(MSIZE-1),
M21		= 0.109476	* 2**(MSIZE-1),
M22		= 0.872765	* 2**(MSIZE-1);

wire[DSIZE:0]	mx,my,mz;


matrix_multiper_verb #(         
	.DSIZE		(DSIZE			),           
	.MSIZE		(MSIZE			)           
)matrix_multiper_inst(                                
	.clock		(clock		),	
	.iR     	(R          ),
	.iG     	(G          ),
	.iB     	(B          ),
            
	.M00		(M00 		), 	
	.M01        (M01        ),
	.M02        (M02        ),
	.M10        (M10        ),
	.M11        (M11        ),
	.M12        (M12        ),
	.M20        (M20        ),
	.M21        (M21        ),
	.M22        (M22        ),
	        
	.Ro 		(mx			),	
	.Go         (my	        ),
	.Bo         (mz         )
);    

assign	X	= mx [DSIZE-1:0];
assign	Y	= my [DSIZE-1:0];
assign	Z 	= mz [DSIZE-1:0];

endmodule

                       
