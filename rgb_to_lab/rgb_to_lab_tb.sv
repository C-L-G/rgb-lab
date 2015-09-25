/****************************************
______________                ______________
______________ \  /\  /|\  /| ______________
______________  \/  \/ | \/ | ______________
--Module Name:  rgb_to_lab_tb.sv
--Project Name: rgb-lab
--Data modified: 2015-09-25 11:19:09 +0800
--author:Young-ÎâÃ÷
--E-mail: wmy367@Gmail.com
****************************************/
`timescale 1ns/1ps
module rgb_to_lab_tb;

import StreamFilePkg::*;

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

//----->> GEN IMAGE DATA <<-------------
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
	
//-----<< GEN RANDOM DATA >>------------
//----->> SAVE TO FILE <<---------------
StreamFileClass streamfile = new("E:/work/video_process_module/CIELAB/rgb_lab.txt");

task save_rgb_lab (
	int	rdata,
	int	gdata,
	int	bdata,
	int	cie_ldata,
	int	cie_adata,
	int	cie_bdata,
	int xdata,
	int ydata,
	int zdata
);

streamfile.puts({rdata,gdata,bdata,cie_ldata,cie_adata,cie_bdata,xdata,ydata,zdata});

endtask: save_rgb_lab
//-----<< SAVE TO FILE >>---------------
initial begin
	wait(rst_n);
	gen_fringe_data(R,G,B);
	gen_random_rgb(R,G,B,1000);
end

initial begin
	wait(rst_n);
//	repeat(4)	@(posedge clock);
	$display("--->>SAVING TO FINISH .....");
	repeat(1000)begin
		@(negedge clock);
		save_rgb_lab(R,G,B,CIE_L,CIE_A,CIE_B,rgb_to_lab_inst.X,rgb_to_lab_inst.Y,rgb_to_lab_inst.Z);
	end
	streamfile.close_file();
	$display("---->>SAVE TO FILE FINISH");
end

endmodule

	




