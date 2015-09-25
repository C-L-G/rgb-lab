/****************************************
______________                ______________
______________ \  /\  /|\  /| ______________
______________  \/  \/ | \/ | ______________
--Module Name:  root1D3_tb.sv
--Project Name: rgb-lab
--Data modified: 2015-09-25 11:19:09 +0800
--author:Young-ÎâÃ÷
--E-mail: wmy367@Gmail.com
****************************************/
`timescale 1ns/1ps
module root1D3_tb;

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

localparam		DSIZE	= 16;

logic[DSIZE-1:0]	X = 0;
logic[DSIZE-1:0]	Y;

root1D3 #(
	.DSIZE			(DSIZE		)
)root1D3_inst(
	.clock			(clock		),
	.rst_n			(rst_n      ),
	.X				(X			),
	.Y      		(Y          )
);


task automatic gen_indata_task(ref logic [DSIZE-1:0]	data);
	repeat(1000)begin
		@(posedge clock);
		data += (2**DSIZE)/1000;
	end
endtask: gen_indata_task


//---->> SAVE TO FILE <<------------------
int 	file_id;
int		file_id2;
string	file_name	= "E:/work/video_process_module/CIELAB/in_out.txt";
string	file_param	= "E:/work/video_process_module/CIELAB/param.txt";
task save_in_out_to_file;
	int	ii;
	file_id	= $fopen(file_name,"w");
	ii = 0;
	while(1)begin
		@(negedge clock);
		$fwrite(file_id,"%d   %d\n",X,Y);
		ii += 1;
		if(ii == 1000) break;
	end
	$display("---->> SAVE FILE FINISH<<----");
	$fclose(file_id);
endtask:save_in_out_to_file

task save_param_to_file;
begin
	file_id2	= $fopen(file_param,"w");
	$fwrite(file_id2,"%d   %d\n",root1D3_inst.M00,root1D3_inst.C00);
	$fwrite(file_id2,"%d   %d\n",root1D3_inst.M01,root1D3_inst.C01);
	$fwrite(file_id2,"%d   %d\n",root1D3_inst.M02,root1D3_inst.C02);
	$fwrite(file_id2,"%d   %d\n",root1D3_inst.M03,root1D3_inst.C03);
	$fwrite(file_id2,"%d   %d\n",root1D3_inst.M04,root1D3_inst.C04);
	$fwrite(file_id2,"%d   %d\n",root1D3_inst.M05,root1D3_inst.C05);
	$fwrite(file_id2,"%d   %d\n",root1D3_inst.M06,root1D3_inst.C06);
	$fwrite(file_id2,"%d   %d\n",root1D3_inst.M07,root1D3_inst.C07);
	$fwrite(file_id2,"%d   %d\n",root1D3_inst.M08,root1D3_inst.C08);
	$fwrite(file_id2,"%d   %d\n",root1D3_inst.M09,root1D3_inst.C09);
	$fwrite(file_id2,"%d   %d\n",root1D3_inst.M10,root1D3_inst.C10);
	$fwrite(file_id2,"%d   %d\n",root1D3_inst.M11,root1D3_inst.C11);
	$fwrite(file_id2,"%d   %d\n",root1D3_inst.M12,root1D3_inst.C12);
	$fwrite(file_id2,"%d   %d\n",root1D3_inst.M13,root1D3_inst.C13);
	$fwrite(file_id2,"%d   %d\n",root1D3_inst.M14,root1D3_inst.C14);
	$fwrite(file_id2,"%d   %d\n",root1D3_inst.M15,root1D3_inst.C15);
	$fwrite(file_id2,"%d   %d\n",root1D3_inst.M16,root1D3_inst.C16);
	$display("---->> SAVE PARAM FINISH<<----");
	$fclose(file_id2);
end
endtask:save_param_to_file


initial begin
	wait(root1D3_inst.cal_valid);
	fork
		gen_indata_task(X); 
		save_param_to_file;		//matlab script: dlmread("in_out.txt");
		save_in_out_to_file;
	join
end
	
//----<< SAVE TO FILE >>------------------


endmodule
