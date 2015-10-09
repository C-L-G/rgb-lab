/****************************************
______________                ______________
______________ \  /\  /|\  /| ______________
______________  \/  \/ | \/ | ______________
--Module Name:  linear_transfomation_tb.sv
--Project Name: rgb-lab
--Data modified: 2015-10-09 13:23:48 +0800
--author:Young-ÎâÃ÷
--E-mail: wmy367@Gmail.com
****************************************/
`timescale 1ns/1ps
module linear_transfomation_tb;

//----->> CLOCK AND RESET <<------------
wire		clk_50M;
wire		clock;
wire		rst_n;
assign		clock	= clk_50M;

clock_rst clk_rst_inst(
	.clock		(clk_50M),
	.rst		(rst_n)
);

defparam clk_rst_inst.ACTIVE = 0;
initial begin:INITIAL_CLOCK
	clk_rst_inst.run(10 , 1000/50 ,0);
end
//-----<< CLOCK AND RESET >>------------

localparam		DSIZE	= 12,
				DT_I	= 8, 
				DT_D	= 4;
//----->> RANDOM BLOCK <<---------------
class RandomPacket;
	rand  logic [DSIZE-1:0]	data;
	integer		min_d	= 0;
	integer		max_d	= 255;

	constraint c { data inside {[min_d:max_d]};}
endclass

RandomPacket Rp;
initial begin
	Rp = new();
end

task automatic Random_in_task (output logic [DSIZE-1:0] data,input integer min,input integer max);
	Rp.min_d	= min;
	Rp.max_d	= max;
	assert(Rp.randomize());
	data		= Rp.data;
endtask:Random_in_task
//-----<< RANDOM BLOCK >>---------------
	
bit					cal_begin;
bit					cal_valid;
logic [DSIZE-1:0]	indata = 0;
logic [DSIZE-1:0]	outdata; 

logic [DSIZE-1:0]	C00		;	
logic [DSIZE-1:0]	C01		;    
logic [DSIZE-1:0]	C02		;    
logic [DSIZE-1:0]	C03		;    
logic [DSIZE-1:0]	C04		;    
logic [DSIZE-1:0]	C05		;    
logic [DSIZE-1:0]	C06		;    
logic [DSIZE-1:0]	C07		;    
logic [DSIZE-1:0]	C08		;    
logic [DSIZE-1:0]	C09		;    
logic [DSIZE-1:0]	C10		;    
logic [DSIZE-1:0]	C11		;    
logic [DSIZE-1:0]	C12		;    
logic [DSIZE-1:0]	C13		;    
logic [DSIZE-1:0]	C14		;    
logic [DSIZE-1:0]	C15		;
logic [DSIZE-1:0]	C16		;  
	
	
//----->> INSTANCE <<------------------------

localparam	DM	= 2**DSIZE/16;

linear_transfomation #(
	.DSIZE				(DSIZE		),
	.DT_I				(DT_I	    ),  
	.DT_D				(DT_D	    ),
	.M00				(DM* 0      ),
	.M01         		(DM* 1      ),
	.M02         		(DM* 2      ),
	.M03         		(DM* 3      ),
	.M04         		(DM* 4      ),
	.M05         		(DM* 5      ),
	.M06         		(DM* 6      ),
	.M07         		(DM* 7      ),
	.M08         		(DM* 8      ),
	.M09         		(DM* 9      ),
	.M10         		(DM*10      ),
	.M11         		(DM*11      ),
	.M12         		(DM*12      ),
	.M13         		(DM*13      ),
	.M14         		(DM*14      ),
	.M15         		(DM*15      ),
	.M16				(DM*16-1		)
)linear_transfomation_inst(
	.clock 				(clk_50M	),	
	.rst_n     			(rst_n      ),
	.cal_begin  		(cal_begin  ),
	.cal_valid          (cal_valid  ),
	.indata   			(indata     ),
	.outdata            (outdata    ),
	
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
	.C16                (C16        )
);
//-----<< INSTANCE >>------------------------
//----->> TEST TASK <<-----------------------
task refresh_C_task;
begin
	wait(rst_n);
	cal_begin   = 0;
	@(posedge clock);
	cal_begin	= 1;
	@(posedge clock);
	cal_begin	= 0;
	wait(cal_valid);
end
endtask:refresh_C_task

task automatic gen_indata_task(ref logic [DSIZE-1:0]	data);
	repeat(256)begin
		@(posedge clock);
		data += DM/16;
	end
endtask: gen_indata_task

task set_C_model_0_task;
	C00		= DM*  0;
	C01		= DM*  1;
	C02		= DM*  2;
	C03		= DM*  3;
	C04		= DM*  4;
	C05		= DM*  5;
	C06		= DM*  6;
	C07		= DM*  7;
	C08		= DM*  8;
	C09		= DM*  9;
	C10		= DM* 10;
	C11		= DM* 11;
	C12		= DM* 12;
	C13		= DM* 13;
	C14		= DM* 14;
	C15		= DM* 15; 
	C16		= DM* 16;
endtask:set_C_model_0_task

task set_C_model_1_task;
	C00		= DM*  0/2;
	C01		= DM*  1/2;
	C02		= DM*  2/2;
	C03		= DM*  3/2;
	C04		= DM*  4/2;
	C05		= DM*  5/2;
	C06		= DM*  6/2;
	C07		= DM*  7/2;
	C08		= DM*  8/2;
	C09		= DM*  9/2;
	C10		= DM* 10/2;
	C11		= DM* 11/2;
	C12		= DM* 12/2;
	C13		= DM* 13/2;
	C14		= DM* 14/2;
	C15		= DM* 15/2;
	C16		= DM* 16/2;
endtask:set_C_model_1_task

task set_C_model_2_task;
	C00		= 0;
	Random_in_task(C01,DM* 0 + 1,DM * 1 );
	Random_in_task(C02,DM* 1 + 1,DM * 2 );
	Random_in_task(C03,DM* 2 + 1,DM * 3 );
	Random_in_task(C04,DM* 3 + 1,DM * 4 );
	Random_in_task(C05,DM* 4 + 1,DM * 5 );
	Random_in_task(C06,DM* 5 + 1,DM * 6 );
	Random_in_task(C07,DM* 6 + 1,DM * 7 );
	Random_in_task(C08,DM* 7 + 1,DM * 8 );
	Random_in_task(C09,DM* 8 + 1,DM * 9 );
	Random_in_task(C10,DM* 9 + 1,DM *10 );
	Random_in_task(C11,DM*10 + 1,DM *11 );
	Random_in_task(C12,DM*11 + 1,DM *12 );
	Random_in_task(C13,DM*12 + 1,DM *13 );
	Random_in_task(C14,DM*13 + 1,DM *14 );
	Random_in_task(C15,DM*14 + 1,DM *15 );
	Random_in_task(C16,DM*15 + 1,DM *16 );
endtask:set_C_model_2_task

task set_C_model_sqr_task;    
	C00		=      0;
	C01		=      1;                     
	C02		=      4;                     
	C03		=      9;                     
	C04		=     16;                     
	C05		=     25;                     
	C06		=     36;                     
	C07		=     49;                     
	C08		=     64;                     
	C09		=     81;                     
	C10		=    100;                     
	C11		=    121;                     
	C12		=    144;                     
	C13		=    169;                     
	C14		=    196;                     
	C15		=    225;
	C16		=    255;                     
endtask:set_C_model_sqr_task 

task set_C_model_log_task;    
	C00		=       0	;
	C01		=      26	;                   
	C02		=      50	;                   
	C03		=      72	;                   
	C04		=      92	;                   
	C05		=     110	;                   
	C06		=     127	;                   
	C07		=     144	;                   
	C08		=     159	;                   
	C09		=     173	;                   
	C10		=     187	;                   
	C11		=     200	;                   
	C12		=     212	;                   
	C13		=     224	;                   
	C14		=     235	;                   
	C15		=     246	; 
	C16		=     255	; 
endtask:set_C_model_log_task

task set_C_model_cir_task;    
	C00		=         0	;   
	C01		=        90	;                  
	C02		=       124	;                  
	C03		=       150	;                  
	C04		=       170	;                  
	C05		=       186	;                  
	C06		=       200	;                  
	C07		=       212	;                  
	C08		=       222	;                  
	C09		=       231	;                  
	C10		=       238	;                  
	C11		=       244	;                  
	C12		=       248	;                  
	C13		=       252	;                  
	C14		=       254	;                  
	C15		=       255	;
	C16		=       255	;
endtask:set_C_model_cir_task

task set_C_model_ivan_R;
   C00		= 		0   	;
   C01		=     	82      ;
   C02		=     	421     ;
   C03		=     	878     ;
   C04		=     	1373    ;
   C05		=     	1826    ;
   C06		=     	2163    ;
   C07		=     	2375    ;
   C08		=     	2491    ;
   C09		=     	2546    ;
   C10		=     	2570    ;
   C11		=     	2596    ;
   C12		=     	2656    ;
   C13		=     	2783    ;
   C14		=     	3009    ;
   C15		=     	3365    ;
   C16		=     	3884    ;
endtask:set_C_model_ivan_R

task set_C_model_ivan_Gb;
	 C00		=	82   	;
     C01		=	134     ;
     C02		=	435     ;
     C03		=	887     ;
     C04		=	1387    ;
     C05		=	1834    ;
     C06		=	2137    ;
     C07		=	2300    ;
     C08		=	2393    ;
     C09		=	2483    ;
     C10		=	2641    ;
     C11		=	2935    ;
     C12		=	3434    ;
     C13		=	4095    ;
     C14		=	4095    ;
     C15		=	4095    ;
     C16		=	4095    ; 
endtask:set_C_model_ivan_Gb
                      

//-----<< TEST TASK >>-----------------------
//----->> VISUAL DETAL <<--------------------
real	D00		;
real	D01		;
real	D02		;
real	D03		;
real	D04		;
real	D05		;
real	D06		;
real	D07		;
real	D08		;
real	D09		;
real	D10		;
real	D11		;
real	D12		;
real	D13		;
real	D14		;
real	D15		;


always@(*)begin
	D00	= trans_to_real(linear_transfomation_inst.delta00);
	D01	= trans_to_real(linear_transfomation_inst.delta01);
	D02	= trans_to_real(linear_transfomation_inst.delta02);
	D03	= trans_to_real(linear_transfomation_inst.delta03);
	D04	= trans_to_real(linear_transfomation_inst.delta04);
	D05	= trans_to_real(linear_transfomation_inst.delta05);
	D06	= trans_to_real(linear_transfomation_inst.delta06);
	D07	= trans_to_real(linear_transfomation_inst.delta07);
	D08	= trans_to_real(linear_transfomation_inst.delta08);
	D09	= trans_to_real(linear_transfomation_inst.delta09);
	D10	= trans_to_real(linear_transfomation_inst.delta10);
	D11	= trans_to_real(linear_transfomation_inst.delta11);
	D12	= trans_to_real(linear_transfomation_inst.delta12);
	D13	= trans_to_real(linear_transfomation_inst.delta13);
	D14	= trans_to_real(linear_transfomation_inst.delta14);
	D15	= trans_to_real(linear_transfomation_inst.delta15);
end

function real trans_to_real ( input [DT_I+DT_D-1:0] D);
	trans_to_real	= real'(D[DT_D+:DT_I]) + real'(D[DT_D-1:0])/2**(DT_D);
endfunction: trans_to_real   
//-----<< VISUAL DETAL >>--------------------
//---->> SAVE TO FILE <<------------------
int 	file_id;
int		file_id2;
string	file_name	= "E:/work/other_module/linear_transfomation/in_out.txt";
string	file_param	= "E:/work/other_module/linear_transfomation/param.txt";
task save_in_out_to_file;
	int	ii;
	file_id	= $fopen(file_name,"w");
	ii = 0;
	while(1)begin
		@(negedge clock);
		$fwrite(file_id,"%d   %d\n",indata,outdata);
		ii += 1;
		if(ii == 260) break;
	end
	$display("---->> SAVE FILE FINISH<<----");
	$fclose(file_id);
endtask:save_in_out_to_file

task save_param_to_file;
begin
	file_id2	= $fopen(file_param,"w");
	$fwrite(file_id2,"%d   %d\n",linear_transfomation_inst.M00,C00);
	$fwrite(file_id2,"%d   %d\n",linear_transfomation_inst.M01,C01);
	$fwrite(file_id2,"%d   %d\n",linear_transfomation_inst.M02,C02);
	$fwrite(file_id2,"%d   %d\n",linear_transfomation_inst.M03,C03);
	$fwrite(file_id2,"%d   %d\n",linear_transfomation_inst.M04,C04);
	$fwrite(file_id2,"%d   %d\n",linear_transfomation_inst.M05,C05);
	$fwrite(file_id2,"%d   %d\n",linear_transfomation_inst.M06,C06);
	$fwrite(file_id2,"%d   %d\n",linear_transfomation_inst.M07,C07);
	$fwrite(file_id2,"%d   %d\n",linear_transfomation_inst.M08,C08);
	$fwrite(file_id2,"%d   %d\n",linear_transfomation_inst.M09,C09);
	$fwrite(file_id2,"%d   %d\n",linear_transfomation_inst.M10,C10);
	$fwrite(file_id2,"%d   %d\n",linear_transfomation_inst.M11,C11);
	$fwrite(file_id2,"%d   %d\n",linear_transfomation_inst.M12,C12);
	$fwrite(file_id2,"%d   %d\n",linear_transfomation_inst.M13,C13);
	$fwrite(file_id2,"%d   %d\n",linear_transfomation_inst.M14,C14);
	$fwrite(file_id2,"%d   %d\n",linear_transfomation_inst.M15,C15);
	$fwrite(file_id2,"%d   %d\n",linear_transfomation_inst.M16,C16);
	$display("---->> SAVE PARAM FINISH<<----");
	$fclose(file_id2);
end
endtask:save_param_to_file


initial begin
	wait(cal_valid);
	save_param_to_file;		//matlab script: dlmread("in_out.txt");
	save_in_out_to_file;
end
	
//----<< SAVE TO FILE >>------------------


initial begin
//	set_C_model_0_task;
//	set_C_model_1_task; 
//	set_C_model_2_task; 
//	set_C_model_sqr_task;
//	set_C_model_log_task;
//	set_C_model_cir_task;
	set_C_model_ivan_R;
	refresh_C_task;
	gen_indata_task(indata);
end




endmodule


	
