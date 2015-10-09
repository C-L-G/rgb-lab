/****************************************
______________                ______________
______________ \  /\  /|\  /| ______________
______________  \/  \/ | \/ | ______________
--Module Name:  CIELAB_tb.sv
--Project Name: rgb-lab
--Data modified: 2015-10-09 13:23:48 +0800
--author:Young-ÎâÃ÷
--E-mail: wmy367@Gmail.com
****************************************/
`timescale 1ns/1ps
module CIELAB_tb;

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
//----->> INSTANCE <<-------------------
localparam		DSIZE = 16;

logic[DSIZE-1:0]		R = 0,G = 0,B = 0;
logic signed[DSIZE-1:0]		CIE_L,CIE_A,CIE_B;

rgb_to_lab_verb #(
	.DSIZE		(DSIZE			)
)rgb_to_lab_inst(
	.clock		(clock			),
	.R          (R              ),
	.G          (G              ),
	.B          (B              ),
	.CIE_L      (CIE_L          ),
	.CIE_A      (CIE_A          ),
	.CIE_B      (CIE_B          )
);

wire[DSIZE-1:0]	OUT_R,OUT_G,OUT_B;

lab_to_rgb #(
	.DSIZE		(DSIZE			)
)lab_to_rgb_inst(
	.clock 		(clock			),
	.CIE_L  	(CIE_L          ),
	.CIE_A  	(CIE_A          ),
	.CIE_B  	(CIE_B          ),
	.R      	(OUT_R          ),
	.G      	(OUT_G          ),
	.B      	(OUT_B          )
);
//----<< INSTANCE >>-------------------
//----->> GEN IMAGE DATA <<------------
logic[2:0] cnt = 0;
task automatic gen_fringe_data (
	ref logic [DSIZE-1:0] 	data0,
	ref logic [DSIZE-1:0]	data1,
	ref logic [DSIZE-1:0]	data2
);
cnt	= 0;
repeat(8)begin
	@(posedge clock);
	data0	= cnt[0] ? {DSIZE{1'b1}} : {DSIZE{1'b0}};
	data1	= cnt[1] ? {DSIZE{1'b1}} : {DSIZE{1'b0}};
	data2	= cnt[2] ? {DSIZE{1'b1}} : {DSIZE{1'b0}};
	cnt += 1;
end
endtask: gen_fringe_data

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

task automatic Random_in_task (ref logic [DSIZE-1:0] data,input integer min,input integer max);
	Rp.min_d	= min;
	Rp.max_d	= max;
	assert(Rp.randomize());
	data		= Rp.data;
endtask:Random_in_task
//-----<< RANDOM BLOCK >>---------------
//----->> GEN RANDOM DATA <<------------

task automatic gen_random_rgb (
	ref logic [DSIZE-1:0]	rdata,
	ref logic [DSIZE-1:0]	gdata,
	ref logic [DSIZE-1:0]	bdata,
	input int				num = 100
);
repeat(num)begin
	@(posedge clock);
	Random_in_task(rdata,0,2**DSIZE);
	Random_in_task(gdata,0,2**DSIZE);
	Random_in_task(bdata,0,2**DSIZE);
end
@(posedge clock);
rdata	= {DSIZE{1'b0}};
gdata	= {DSIZE{1'b0}};
bdata	= {DSIZE{1'b0}};
endtask: gen_random_rgb

initial begin
	wait(rst_n);
	gen_fringe_data(R,G,B);
	gen_random_rgb(R,G,B,1000);
	//R	= {DSIZE{1'b1}};
	//G	= {DSIZE{1'b0}};
	//B	= {DSIZE{1'b0}}; 
end 
	
//-----<< GEN RANDOM DATA >>------------
//-----<< SAVE TO FILE >>---------------

logic [DSIZE-1:0]	SR,SG,SB;

latency #(
	.DSIZE	(3*DSIZE),
	.LAT	(25		)
)lat_rgb(
	clock,
	rst_n,
	{R,G,B},
	{SR,SG,SB}
);

logic signed[DSIZE-1:0]		SCIE_L,SCIE_A,SCIE_B;
always@(CIE_L,CIE_A,CIE_B)begin
	{SCIE_L,SCIE_A,SCIE_B}	= {CIE_L,CIE_A,CIE_B};
end

stream_to_file #(
	.FILE_PATH		("E:/work/video_process_module/CIELAB/in_out_rgb.txt"),
	.HEAD_MARK		(""),
	.DATA_SPLIT		("     "),
	.TRIGGER_TOTAL	(1000	)
)lab_to_file_inst(
	.enable				(1'b1		),
	.posedge_trigger	(			),
	.negedge_trigger    (clock		),
	.signal_trigger     (			),
	.data 		        ('{SR,SG,SB,OUT_R,OUT_G,OUT_B})
);



endmodule




