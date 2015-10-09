/****************************************
______________                ______________
______________ \  /\  /|\  /| ______________
______________  \/  \/ | \/ | ______________
--Module Name:  linear_transfomation.v
--Project Name: rgb-lab
--Data modified: 2015-10-09 13:23:48 +0800
--author:Young-ÎâÃ÷
--E-mail: wmy367@Gmail.com
****************************************/
`timescale 1ns/1ps
module linear_transfomation #(
	parameter					DSIZE			= 12,
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
	parameter [DSIZE-1:0]		M16         	= 16+M15-1
)(
	input					clock 		,	
	input					rst_n       ,
	input					cal_begin   ,
	output					cal_valid   ,
	input [DSIZE-1:0]		indata      ,
	output[DSIZE-1:0]		outdata     ,

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
	input [DSIZE-1:0]		C16           
);
 
  

wire [DT_I+DT_D-1:0]			delta00 	;
wire [DT_I+DT_D-1:0]			delta01     ;
wire [DT_I+DT_D-1:0]			delta02     ;
wire [DT_I+DT_D-1:0]			delta03     ;
wire [DT_I+DT_D-1:0]			delta04     ;
wire [DT_I+DT_D-1:0]			delta05     ;
wire [DT_I+DT_D-1:0]			delta06     ;
wire [DT_I+DT_D-1:0]			delta07     ;
wire [DT_I+DT_D-1:0]			delta08     ;
wire [DT_I+DT_D-1:0]			delta09     ;
wire [DT_I+DT_D-1:0]			delta10     ;
wire [DT_I+DT_D-1:0]			delta11     ;
wire [DT_I+DT_D-1:0]			delta12     ;
wire [DT_I+DT_D-1:0]			delta13     ;
wire [DT_I+DT_D-1:0]			delta14     ;  
wire [DT_I+DT_D-1:0]			delta15     ;     
    
    
gen_deltas_list #(
	.DSIZE				(DSIZE		),				 
    .DT_I				(DT_I		),
	.DT_D				(DT_D		),
	.M00				(M00		),
	.M01         		(M01		),
	.M02         		(M02		),
	.M03         		(M03		),
	.M04         		(M04		),
	.M05         		(M05		),
	.M06         		(M06		),
	.M07         		(M07		),
	.M08         		(M08		),
	.M09         		(M09		),
	.M10         		(M10		),
	.M11         		(M11		),
	.M12         		(M12		),
	.M13         		(M13		),
	.M14         		(M14		),
	.M15         		(M15		),
	.M16         		(M16		)
)gen_deltas_list_inst(
/*	input				*/	.clock 		(clock 		),		
/*	input				*/	.rst_n      (rst_n      ), 
/*	input				*/	.cal_begin  (cal_begin  ), 
/*	output				*/	.cal_valid  (cal_valid  ), 
/*                      */
/*	input [DSIZE-1:0]	*/	.C00		(C00		),			
/*	input [DSIZE-1:0]	*/	.C01        (C01        ),
/*	input [DSIZE-1:0]	*/	.C02        (C02        ),
/*	input [DSIZE-1:0]	*/	.C03        (C03        ),
/*	input [DSIZE-1:0]	*/	.C04        (C04        ),
/*	input [DSIZE-1:0]	*/	.C05        (C05        ),
/*	input [DSIZE-1:0]	*/	.C06        (C06        ),
/*	input [DSIZE-1:0]	*/	.C07        (C07        ),
/*	input [DSIZE-1:0]	*/	.C08        (C08        ),
/*	input [DSIZE-1:0]	*/	.C09        (C09        ),
/*	input [DSIZE-1:0]	*/	.C10        (C10        ),
/*	input [DSIZE-1:0]	*/	.C11        (C11        ),
/*	input [DSIZE-1:0]	*/	.C12        (C12        ),
/*	input [DSIZE-1:0]	*/	.C13        (C13        ),
/*	input [DSIZE-1:0]	*/	.C14        (C14        ),
/*	input [DSIZE-1:0]	*/	.C15        (C15        ),
/*	input [DSIZE-1:0]	*/	.C16        (C16        ),
/*                      */
/*	output [DT-1:0]		*/	.delta00	(delta00	), 	
/*	output [DT-1:0]		*/	.delta01    (delta01    ),
/*	output [DT-1:0]		*/	.delta02    (delta02    ),
/*	output [DT-1:0]		*/	.delta03    (delta03    ),
/*	output [DT-1:0]		*/	.delta04    (delta04    ),
/*	output [DT-1:0]		*/	.delta05    (delta05    ),
/*	output [DT-1:0]		*/	.delta06    (delta06    ),
/*	output [DT-1:0]		*/	.delta07    (delta07    ),
/*	output [DT-1:0]		*/	.delta08    (delta08    ),
/*	output [DT-1:0]		*/	.delta09    (delta09    ),
/*	output [DT-1:0]		*/	.delta10    (delta10    ),
/*	output [DT-1:0]		*/	.delta11    (delta11    ),
/*	output [DT-1:0]		*/	.delta12    (delta12    ),
/*	output [DT-1:0]		*/	.delta13    (delta13    ),
/*	output [DT-1:0]		*/	.delta14    (delta14    ),
/*	output [DT-1:0]		*/	.delta15    (delta15    )
);


linear_transfomation_func #(
	.DSIZE			(DSIZE	),	
	.DT_I			(DT_I	),
	.DT_D			(DT_D	)
)linear_transfomation_func_inst(
/*	input				*/	.clock 		(clock 		),		
/*	input [DSIZE-1:0]	*/	.indata     (indata     ),
/*	output[DSIZE-1:0]	*/	.outdata    (outdata    ),
/*                      */  	
/*	input [DT-1:0]		*/	.delta00 	(delta00	),	
/*	input [DT-1:0]		*/	.delta01    (delta01    ),
/*	input [DT-1:0]		*/	.delta02    (delta02    ),
/*	input [DT-1:0]		*/	.delta03    (delta03    ),
/*	input [DT-1:0]		*/	.delta04    (delta04    ),
/*	input [DT-1:0]		*/	.delta05    (delta05    ),
/*	input [DT-1:0]		*/	.delta06    (delta06    ),
/*	input [DT-1:0]		*/	.delta07    (delta07    ),
/*	input [DT-1:0]		*/	.delta08    (delta08    ),
/*	input [DT-1:0]		*/	.delta09    (delta09    ),
/*	input [DT-1:0]		*/	.delta10    (delta10    ),
/*	input [DT-1:0]		*/	.delta11    (delta11    ),
/*	input [DT-1:0]		*/	.delta12    (delta12    ),
/*	input [DT-1:0]		*/	.delta13    (delta13    ),
/*	input [DT-1:0]		*/	.delta14    (delta14    ),
/*	input [DT-1:0]		*/	.delta15    (delta15 	),
/*                      */
/*	input [DSIZE-1:0]	*/	.M00		(M00		),			
/*	input [DSIZE-1:0]	*/	.M01        (M01		),
/*	input [DSIZE-1:0]	*/	.M02        (M02		),
/*	input [DSIZE-1:0]	*/	.M03        (M03		),
/*	input [DSIZE-1:0]	*/	.M04        (M04		),
/*	input [DSIZE-1:0]	*/	.M05        (M05		),
/*	input [DSIZE-1:0]	*/	.M06        (M06		),
/*	input [DSIZE-1:0]	*/	.M07        (M07		),
/*	input [DSIZE-1:0]	*/	.M08        (M08		),
/*	input [DSIZE-1:0]	*/	.M09        (M09		),
/*	input [DSIZE-1:0]	*/	.M10        (M10		),
/*	input [DSIZE-1:0]	*/	.M11        (M11		),
/*	input [DSIZE-1:0]	*/	.M12        (M12		),
/*	input [DSIZE-1:0]	*/	.M13        (M13		),
/*	input [DSIZE-1:0]	*/	.M14        (M14		),
/*	input [DSIZE-1:0]	*/	.M15        (M15		),

/*	input [DSIZE-1:0]	*/	.C00		(C00		),			
/*	input [DSIZE-1:0]	*/	.C01        (C01        ),
/*	input [DSIZE-1:0]	*/	.C02        (C02        ),
/*	input [DSIZE-1:0]	*/	.C03        (C03        ),
/*	input [DSIZE-1:0]	*/	.C04        (C04        ),
/*	input [DSIZE-1:0]	*/	.C05        (C05        ),
/*	input [DSIZE-1:0]	*/	.C06        (C06        ),
/*	input [DSIZE-1:0]	*/	.C07        (C07        ),
/*	input [DSIZE-1:0]	*/	.C08        (C08        ),
/*	input [DSIZE-1:0]	*/	.C09        (C09        ),
/*	input [DSIZE-1:0]	*/	.C10        (C10        ),
/*	input [DSIZE-1:0]	*/	.C11        (C11        ),
/*	input [DSIZE-1:0]	*/	.C12        (C12        ),
/*	input [DSIZE-1:0]	*/	.C13        (C13        ),
/*	input [DSIZE-1:0]	*/	.C14        (C14        ),
/*	input [DSIZE-1:0]	*/	.C15        (C15        )
);


endmodule
