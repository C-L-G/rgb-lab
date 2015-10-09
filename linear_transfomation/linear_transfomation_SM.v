/****************************************
______________                ______________
______________ \  /\  /|\  /| ______________
______________  \/  \/ | \/ | ______________
--Module Name:  linear_transfomation_SM.v
--Project Name: rgb-lab
--Data modified: 2015-10-09 13:23:48 +0800
--author:Young-ÎâÃ÷
--E-mail: wmy367@Gmail.com
****************************************/
`timescale 1ns/1ps
module linear_transfomation_SM #(
	parameter	DSIZE		= 12,
	parameter	DT_I		= 8,
	parameter	DT_D		= 4,
	parameter	DM			= 16    
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
	input [DSIZE-1:0]		C15         
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
    
    
    
gen_delta_same_DM #(
	.DSIZE				(DSIZE		),				 
    .DT_I				(DT_I		),
	.DT_D				(DT_D		),
	.DM					(DM		    )
)gen_delta_same_DM_inst(
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
/*	output [DT-1:0]		*/	.delta14    (delta14    )
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
/*	input [DT-1:0]		*/	.delta15    ({(DT_I+DT_D){1'b0}}          ),
/*                      */
/*	input [DSIZE-1:0]	*/	.M00		(DM *  0	),			
/*	input [DSIZE-1:0]	*/	.M01        (DM *  1    ),
/*	input [DSIZE-1:0]	*/	.M02        (DM *  2    ),
/*	input [DSIZE-1:0]	*/	.M03        (DM *  3    ),
/*	input [DSIZE-1:0]	*/	.M04        (DM *  4    ),
/*	input [DSIZE-1:0]	*/	.M05        (DM *  5    ),
/*	input [DSIZE-1:0]	*/	.M06        (DM *  6    ),
/*	input [DSIZE-1:0]	*/	.M07        (DM *  7    ),
/*	input [DSIZE-1:0]	*/	.M08        (DM *  8    ),
/*	input [DSIZE-1:0]	*/	.M09        (DM *  9    ),
/*	input [DSIZE-1:0]	*/	.M10        (DM * 10    ),
/*	input [DSIZE-1:0]	*/	.M11        (DM * 11    ),
/*	input [DSIZE-1:0]	*/	.M12        (DM * 12    ),
/*	input [DSIZE-1:0]	*/	.M13        (DM * 13    ),
/*	input [DSIZE-1:0]	*/	.M14        (DM * 14    ),
/*	input [DSIZE-1:0]	*/	.M15        (DM * 15    ),

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
