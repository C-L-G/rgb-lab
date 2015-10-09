/****************************************
______________                ______________
______________ \  /\  /|\  /| ______________
______________  \/  \/ | \/ | ______________
--Module Name:  root3.v
--Project Name: rgb-lab
--Data modified: 2015-10-09 13:23:48 +0800
--author:Young-ÎâÃ÷
--E-mail: wmy367@Gmail.com
****************************************/
`timescale 1ns/1ps
module root3 #(
	parameter	DSIZE	= 16
)(
	input				clock	,
	input				rst_n	,
	input [DSIZE-1:0]	X		,
	output[DSIZE-1:0]	Y
);


localparam		DT_I	= 2,
				DT_D	= 16;

localparam	[DSIZE-1:0]	
				C00		=  0			* 2**DSIZE ,
				C01     =  0.00856   	* 2**DSIZE ,
				C02     =  0.017092  	* 2**DSIZE ,
				C03     =  0.0299702  	* 2**DSIZE ,
				C04     =  0.0480893 	* 2**DSIZE ,
				C05     =  0.0723442  	* 2**DSIZE ,
				C06     =  0.10363  	* 2**DSIZE ,
				C07     =  0.14284  	* 2**DSIZE ,
				C08     =  0.19087  	* 2**DSIZE ,
				C09     =  0.248616  	* 2**DSIZE ,
				C10     =  0.31697  	* 2**DSIZE ,
				C11     =  0.396829 	* 2**DSIZE ,
				C12     =  0.489086  	* 2**DSIZE ,
				C13     =  0.594637 	* 2**DSIZE ,
				C14     =  0.714377 	* 2**DSIZE ,
				C15     =  0.8492 		* 2**DSIZE ,
				C16     =  1.0 			* 2**DSIZE -1;


localparam[DSIZE-1:0]	M00		= 0		     * 2**DSIZE;
localparam[DSIZE-1:0]	M01		= 0.204562   * 2**DSIZE;
localparam[DSIZE-1:0]	M02		= 0.257591   * 2**DSIZE;
localparam[DSIZE-1:0]	M03		= 0.310620   * 2**DSIZE;
localparam[DSIZE-1:0]	M04		= 0.363649   * 2**DSIZE;
localparam[DSIZE-1:0]	M05		= 0.416679   * 2**DSIZE;
localparam[DSIZE-1:0]	M06		= 0.469708   * 2**DSIZE;
localparam[DSIZE-1:0]	M07		= 0.522737   * 2**DSIZE;
localparam[DSIZE-1:0]	M08		= 0.575766   * 2**DSIZE;
localparam[DSIZE-1:0]	M09		= 0.628796   * 2**DSIZE;
localparam[DSIZE-1:0]	M10		= 0.681825   * 2**DSIZE;
localparam[DSIZE-1:0]	M11		= 0.734854   * 2**DSIZE;
localparam[DSIZE-1:0]	M12		= 0.787883   * 2**DSIZE;
localparam[DSIZE-1:0]	M13		= 0.840912   * 2**DSIZE;
localparam[DSIZE-1:0]	M14		= 0.893942   * 2**DSIZE;
localparam[DSIZE-1:0]	M15		= 0.946971   * 2**DSIZE;
localparam[DSIZE-1:0]	M16		=      1.0   * 2**DSIZE-1;

linear_transfomation_verb #(
	.DSIZE				(DSIZE		),
	.DT_I				(DT_I	    ),  
	.DT_D				(DT_D	    ),
	.M00				(M00    	),
	.M01         		(M01    	),
	.M02         		(M02    	),
	.M03         		(M03    	),
	.M04         		(M04    	),
	.M05         		(M05    	),
	.M06         		(M06    	),
	.M07         		(M07    	),
	.M08         		(M08    	),
	.M09         		(M09    	),
	.M10         		(M10    	),
	.M11         		(M11    	),
	.M12         		(M12    	),
	.M13         		(M13    	),
	.M14         		(M14    	),
	.M15         		(M15    	),
	.M16				(M16		),
	.C00				(C00		),	
	.C01                (C01        ),
	.C02                (C02        ),
	.C03                (C03        ),
	.C04                (C04        ),
	.C05                (C05        ),
	.C06                (C06        ),
	.C07                (C07        ),
	.C08                (C08        ),
	.C09                (C09        ),
	.C10                (C10        ),
	.C11                (C11        ),
	.C12                (C12        ),
	.C13                (C13        ),
	.C14                (C14        ),
	.C15                (C15        ),
	.C16                (C16		)
)linear_transfomation_inst(
	.clock 				(clock		),	
	.rst_n     			(rst_n      ),
	.indata   			(X		    ),
	.outdata            (Y		    )
);


endmodule


