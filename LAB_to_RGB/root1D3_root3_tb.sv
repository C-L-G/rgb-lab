/****************************************
______________                ______________
______________ \  /\  /|\  /| ______________
______________  \/  \/ | \/ | ______________
--Module Name:  root1D3_root3_tb.sv
--Project Name: rgb-lab
--Data modified: 2015-10-09 13:23:48 +0800
--author:Young-ÎâÃ÷
--E-mail: wmy367@Gmail.com
****************************************/
`timescale 1ns/1ps
module root1D3_root3_tb;

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
localparam	DSIZE	= 16;

logic[DSIZE-1:0]	X,Y,Z;

root1D3 #(
	.DSIZE			(DSIZE		)
)root1D3_inst(
	.clock			(clock		),
	.rst_n			(rst_n      ),
	.X				(X			),
	.Y      		(Y          )
);

root3 #(
	.DSIZE		(DSIZE			)
)X_root3_inst(
	.clock		(clock			),
	.rst_n		(rst_n			),
	.X			(Y				),
	.Y      	(Z				)
);

initial begin
	X = 0;
	wait(rst_n);
	@(posedge clock);
	repeat(1000)begin
		@(posedge clock);
		X	+= 1*(2**DSIZE)/1000;
	end
end

//-----<< SAVE TO FILE >>---------------
logic [DSIZE-1:0]	SX,SY,SZ;

always@(X,Y,Z)begin
	{SX,SY,SZ}	= {X,Y,Z};
end


stream_to_file #(
	.FILE_PATH		("E:/work/video_process_module/CIELAB/root.txt"),
	.HEAD_MARK		(""),
	.DATA_SPLIT		("     "),
	.TRIGGER_TOTAL	(1000	)
)root_to_file_inst(
	.enable				(1'b1		),
	.posedge_trigger	(			),
	.negedge_trigger    (clock		),
	.signal_trigger     (			),
	.data 		        ('{SX,SY,SZ})
);

endmodule


