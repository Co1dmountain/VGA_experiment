module vga_colorbar_top(
		// input
		input					sys_clk				,
		// input					sys_rst_n			,
		// output
		//output		[15:0]		data_to_screen		,
		output		[29:0]		data_to_screen		,
		output					BLANK				,
		output					SYNC				,
		output					HSYNC				,
		output					FSYNC				,
		output					O_CLOCK				
);
	
	//// define ////
	wire [29:0] pixel_data;
	//wire [15:0] data_to_screen;
	wire [ 9:0] pixel_xpos;
	wire [ 9:0] pixel_ypos;
	reg		   driver_clk;
	//wire			driver_clk;
	
	/////
	reg [15:0] rst_cnt = 0;
	reg sys_rst_n_reg;
	wire					sys_rst_n	;	
	//// main code ////
	always @(posedge sys_clk) begin
		if(rst_cnt == 16'd1000) begin
			rst_cnt <= 16'd2000		;
		end
		else if(rst_cnt < 16'd1000) begin
			rst_cnt <= rst_cnt + 1		;
		end
		else begin
			rst_cnt <= rst_cnt			;
		end
	end
	  
	always @(posedge sys_clk) begin
		if(rst_cnt == 16'd2000) begin
			sys_rst_n_reg 	<= 1'b1;
		end
		else begin
			sys_rst_n_reg 	<= 1'b0;
		end
	end
	
	assign sys_rst_n = sys_rst_n_reg;
	/////
	

	
	//// main code ////
	assign BLANK = 1'b1;
	assign SYNC = 1'b0;
	assign O_CLOCK = driver_clk;
	always @(posedge sys_clk or negedge sys_rst_n) begin
		if(!sys_rst_n) begin
			driver_clk <= 1'b0;
		end
		else begin
			driver_clk <= ~driver_clk;
		end
	end
	/// inst ///
	
	vga_colorbar_driver U_vga_colorbar_driver(
			.driver_clk				(driver_clk			),
			.sys_rst_n				(sys_rst_n			),
			.data_from_display		(pixel_data			),
			.data_to_screen			(data_to_screen		),
			.Hsync					(HSYNC				),
			.Fsync					(FSYNC				),
			.pixel_xpos				(pixel_xpos			),
			.pixel_ypos				(pixel_ypos			) 
	);
	
	
	vga_colorbar_display U_vga_colorbar_display(
			.driver_clk				(driver_clk			),
	        .sys_rst_n				(sys_rst_n			),
	        .pixel_xpos				(pixel_xpos			),
	        .pixel_ypos				(pixel_ypos			),
	        .pixel_data	            (pixel_data			)
	);
	
	
//	ccd97_pll3 u_ccd97_pll3(
//	sys_clk,
//	driver_clk);
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
endmodule