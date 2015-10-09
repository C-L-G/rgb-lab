/****************************************
______________                ______________
______________ \  /\  /|\  /| ______________
______________  \/  \/ | \/ | ______________
--Module Name:  linear_transfomation_func.v
--Project Name: rgb-lab
--Data modified: 2015-10-09 13:23:48 +0800
--author:Young-ÎâÃ÷
--E-mail: wmy367@Gmail.com
****************************************/
`timescale 1ns/1ps
module linear_transfomation_func #(
	parameter	DSIZE		= 12,
	parameter	DT_I		= 8,
	parameter	DT_D		= 4
)(
	input					clock 		,
	input [DSIZE-1:0]		indata      ,
	output[DSIZE-1:0]		outdata     ,
                        	
	input [DT_I+DT_D-1:0]			delta00 	,
	input [DT_I+DT_D-1:0]			delta01     ,
	input [DT_I+DT_D-1:0]			delta02     ,
	input [DT_I+DT_D-1:0]			delta03     ,
	input [DT_I+DT_D-1:0]			delta04     ,
	input [DT_I+DT_D-1:0]			delta05     ,
	input [DT_I+DT_D-1:0]			delta06     ,
	input [DT_I+DT_D-1:0]			delta07     ,
	input [DT_I+DT_D-1:0]			delta08     ,
	input [DT_I+DT_D-1:0]			delta09     ,
	input [DT_I+DT_D-1:0]			delta10     ,
	input [DT_I+DT_D-1:0]			delta11     ,
	input [DT_I+DT_D-1:0]			delta12     ,
	input [DT_I+DT_D-1:0]			delta13     ,
	input [DT_I+DT_D-1:0]			delta14     ,
	input [DT_I+DT_D-1:0]			delta15     ,

	input [DSIZE-1:0]		M00			,
	input [DSIZE-1:0]		M01         ,
	input [DSIZE-1:0]		M02         ,
	input [DSIZE-1:0]		M03         ,
	input [DSIZE-1:0]		M04         ,
	input [DSIZE-1:0]		M05         ,
	input [DSIZE-1:0]		M06         ,
	input [DSIZE-1:0]		M07         ,
	input [DSIZE-1:0]		M08         ,
	input [DSIZE-1:0]		M09         ,
	input [DSIZE-1:0]		M10         ,
	input [DSIZE-1:0]		M11         ,
	input [DSIZE-1:0]		M12         ,
	input [DSIZE-1:0]		M13         ,
	input [DSIZE-1:0]		M14         ,
	input [DSIZE-1:0]		M15			,

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

wire[15:0]		cmp;

assign	cmp[ 0]	=  indata > M00;
assign	cmp[ 1]	=  indata > M01;
assign	cmp[ 2]	=  indata > M02;
assign	cmp[ 3]	=  indata > M03;
assign	cmp[ 4]	=  indata > M04;
assign	cmp[ 5]	=  indata > M05;
assign	cmp[ 6]	=  indata > M06;
assign	cmp[ 7]	=  indata > M07;
assign	cmp[ 8]	=  indata > M08;
assign	cmp[ 9]	=  indata > M09;
assign	cmp[10]	=  indata > M10;
assign	cmp[11]	=  indata > M11;
assign	cmp[12]	=  indata > M12;
assign	cmp[13]	=  indata > M13;
assign	cmp[14]	=  indata > M14;
assign	cmp[15]	=  indata > M15;

//---->> LAT 1 <<--------
reg[15:0]		cmp_lat1;

always@(posedge clock)	cmp_lat1	= cmp;

reg[DSIZE-1:0]	indata_lat1;
always@(posedge clock)	indata_lat1	= indata;
	
//----<< LAT 1 >>--------
//---->> LAT 2 <<--------

reg [DSIZE-1:0]	M_L_lat2;
reg [DSIZE-1:0]	M_H_lat2; 

always@(posedge clock)
	M_L_lat2 <= select(	cmp_lat1[7:0],
						M00	,
            			M01	,
            			M02	,
            			M03	,
            			M04	,
            			M05	,
            			M06	,
            			M07	);

always@(posedge clock)
	M_H_lat2 <= select(	cmp_lat1[15:8],
						M08	,
            			M09	,
            			M10	,
            			M11	,
            			M12	,
            			M13	,
            			M14	,
            			M15	);

reg [DT_I+DT_D-1:0]	D_L_lat2;
reg [DT_I+DT_D-1:0]	D_H_lat2;
always@(posedge clock)
	D_L_lat2 <= select(	cmp_lat1[7:0],
						delta00	,
            			delta01	,
            			delta02	,
            			delta03	,
            			delta04	,
            			delta05	,
            			delta06	,
            			delta07	);

always@(posedge clock)
	D_H_lat2 <= select(	cmp_lat1[15:8],
						delta08	,
            			delta09	,
            			delta10	,
            			delta11	,
            			delta12	,
            			delta13	,
            			delta14	,
            			delta15	);

reg 	h_l_lat2;
always@(posedge clock)
	if(|cmp_lat1[15:8])
			h_l_lat2	<= 1'b1;
	else	h_l_lat2	<= 1'b0;

reg [DSIZE-1:0]	indata_lat2;
always@(posedge clock)	indata_lat2	<= indata_lat1;

reg [DSIZE-1:0]	indata_H_lat2;
reg [DSIZE-1:0]	indata_L_lat2;

always@(posedge clock)
	indata_L_lat2 <= select(	cmp_lat1[7:0],
						C00	,
            			C01	,
            			C02	,
            			C03	,
            			C04	,
            			C05	,
            			C06	,
            			C07	);
always@(posedge clock)
	indata_H_lat2 <= select(	cmp_lat1[15:8],
						C08	,
            			C09	,
            			C10	,
            			C11	,
            			C12	,
            			C13	,
            			C14	,
            			C15	);

//----<< LAT 2 >>--------
//---->> LAT 3 <<--------
reg [DSIZE-1:0]		M_lat3;
reg [DT_I+DT_D-1:0]	D_lat3;
always@(posedge clock)	M_lat3	<= h_l_lat2? M_H_lat2 : M_L_lat2;
always@(posedge clock)	D_lat3	<= h_l_lat2? D_H_lat2 : D_L_lat2;

reg [DSIZE-1:0]	indata_lat3;
always@(posedge clock)	indata_lat3	<= indata_lat2;

reg [DSIZE-1:0]	Cdata_lat3;
always@(posedge clock)	Cdata_lat3	<= h_l_lat2? indata_H_lat2 : indata_L_lat2;
//----<< LAT 3 >>--------
//---->> LAT 4 <<--------
reg [DSIZE-1:0]	Sub_lat4;
always@(posedge clock)	Sub_lat4	<= indata_lat3 - M_lat3;

reg [DT_I+DT_D-1:0]	D_lat4;
always@(posedge clock)	D_lat4		<= D_lat3;

reg [DSIZE-1:0]	indata_lat4;
always@(posedge clock)	indata_lat4	<= Cdata_lat3; 
//----<< LAT 4 >>--------
//---->> LAT 5 <<--------
reg [DSIZE+DT_I+DT_D-1:0]	Mul_lat5;
always@(posedge clock)	Mul_lat5	<= Sub_lat4 * D_lat4;

reg [DSIZE-1:0]	indata_lat5;
always@(posedge clock)	indata_lat5	<= indata_lat4; 
//----<< LAT 5 >>--------
//---->> LAT 6 <<--------
reg [DSIZE:0]	odata_lat6;

always@(posedge clock)	odata_lat6	<= indata_lat5 + { Mul_lat5[DSIZE+DT_I+DT_D-1:DT_D+1], |Mul_lat5[DT_D:DT_D-2]};
//----<< LAT 6 >>--------
//---->> FUNC DEFINE <<--------
function automatic [DSIZE-1:0] select;
	input [7:0]				key	;
	input [DSIZE-1:0]		S00	;
	input [DSIZE-1:0]		S01	;
	input [DSIZE-1:0]		S02	;
	input [DSIZE-1:0]		S03	;
	input [DSIZE-1:0]		S04	;
	input [DSIZE-1:0]		S05	;
	input [DSIZE-1:0]		S06	;
	input [DSIZE-1:0]		S07	;		
begin
	casex(key)
	8'b1111_1111:	select	= S07;
	8'b0111_1111:	select	= S06;
	8'b0011_1111:	select	= S05;
	8'b0001_1111:	select	= S04;
	8'b0000_1111:	select	= S03;
	8'b0000_0111:	select	= S02;
	8'b0000_0011:	select	= S01;
	8'b0000_0001:	select	= S00; 
	8'b0000_0000:	select	= S00;
	default:		select	= S00;
	endcase
end
endfunction
//----<< FUNC DEFINE >>--------

assign	outdata	= odata_lat6[DSIZE]? {DSIZE{1'b1}} : odata_lat6[DSIZE-1:0];

//----->> TEST <<--------------
integer test_data;
always@(*)	test_data	= { Mul_lat5[DSIZE+DT_I+DT_D-1:DT_D+1], |Mul_lat5[DT_D:DT_D-2]};
//-----<< TEST >>--------------
endmodule
