`timescale 1ns / 1ns

module vga_colorbar_top_tb();
	
	//// define ////
	reg sys_clk						;
    //reg sys_rst_n					;
    
    wire [29:0] data_to_screen		;
    wire HSYNC						;
    wire FSYNC						;
	wire BLANK						;
	wire SYNC						;
	
	//// main code ////
	initial begin
		sys_clk = 1'b0;
		//sys_rst_n = 1'b0;
		//#100
		//sys_rst_n = 1'b1;
	end
	
	always #10 sys_clk <= ~sys_clk;


	vga_colorbar_top U_vga_colorbar_top(
			.sys_clk			(sys_clk			),
	        //.sys_rst_n			(sys_rst_n			),
	        .data_to_screen		(data_to_screen		),
	        .HSYNC				(HSYNC				),
	        .FSYNC				(FSYNC				),
	        .SYNC				(SYNC				),
	        .BLANK				(FSYNC				)
			
	);





























endmodule