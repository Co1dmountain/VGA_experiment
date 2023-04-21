module vga_colorbar_display(
		// input
		input						driver_clk				,
		input						sys_rst_n				,		
		input		[ 9:0]			pixel_xpos				,// pixel x position
		input		[ 9:0]			pixel_ypos				,// pixel y position	
		// output
		// output	reg [15:0]			pixel_data	
		output	reg [29:0]			pixel_data
);

/*	first verision
	//// define ////
	parameter  H_DISP = 10'd640; //分辨率—行
	parameter  V_DISP = 10'd480; //分辨率—列
//	localparam WHITE  = 16'b11111_111111_11111; //RGB565 白色
//	localparam BLACK  = 16'b00000_000000_00000; //RGB565 黑色
//	localparam RED    = 16'b11111_000000_00000; //RGB565 红色
//	localparam GREEN  = 16'b00000_111111_00000; //RGB565 绿色
//	localparam BLUE   = 16'b00000_000000_11111; //RGB565 蓝色
	localparam WHITE  = 30'b1111111111_1111111111_1111111111; //RGB565 白色
	localparam BLACK  = 30'b0000000000_0000000000_0000000000; //RGB565 黑色
	localparam RED    = 30'b0000011111_0000000000_0000000000; //RGB565 红色
	localparam GREEN  = 30'b0000000000_0000111111_0000000000; //RGB565 绿色
	localparam BLUE   = 30'b0000000000_0000000000_0000011111; //RGB565 蓝色

	//// main code //// 
	
	always @(posedge driver_clk or negedge sys_rst_n) begin 
		if (!sys_rst_n) begin
			pixel_data <= 29'd0; 
		end
		else begin
			if((pixel_xpos >= 0) && (pixel_xpos < (H_DISP/5)*1)) begin
				pixel_data <= WHITE; 
			end
			else if((pixel_xpos >= (H_DISP/5)*1) && (pixel_xpos < (H_DISP/5)*2)) begin
				pixel_data <= BLACK; 
			end
			else if((pixel_xpos >= (H_DISP/5)*2) && (pixel_xpos < (H_DISP/5)*3)) begin
				pixel_data <= RED; 
			end
			else if((pixel_xpos >= (H_DISP/5)*3) && (pixel_xpos < (H_DISP/5)*4)) begin
				pixel_data <= GREEN; 
			end
			else begin
				pixel_data <= BLUE; 
			end
		end
	end
*/	
	
	//// define ////
	wire [13:0] rom_addr;
	wire [15:0] rom_data; 
	
	reg  [13:0] rom_addr_cnt;
	wire 			region_valid;  // valid region
	
	//// main code ////
	// rom_addr_cnt
	always @(posedge driver_clk or negedge sys_rst_n) begin
		 if(!sys_rst_n) begin
			   rom_addr_cnt <= 'd0;
		 end
		 else if(region_valid) begin
				if(rom_addr_cnt == 'd9599) begin
					rom_addr_cnt <= 'd0;
				end
				else begin
					rom_addr_cnt <= rom_addr_cnt + 1'b1;
				end
		 end
		 else begin
				rom_addr_cnt <= rom_addr_cnt;
		 end
	end
	
	// region_valid
	assign region_valid = ((pixel_xpos >= 'd100 && pixel_xpos < 'd340) 
									&& (pixel_ypos >= 'd50 && pixel_ypos < 'd129)) ? 
									1'b1 : 1'b0;
	
	// rom_addr
	assign rom_addr = rom_addr_cnt;
	
	// pixel_data
	always @(posedge driver_clk or negedge sys_rst_n) begin
		if(!sys_rst_n) begin
			pixel_data <= 'd0;
		end
		else if(region_valid) begin
			pixel_data <= {{5'b0, rom_data[11], rom_data[12], rom_data[13], rom_data[14], rom_data[15]},
								{4'b0, rom_data[5], rom_data[6], rom_data[7], rom_data[8], rom_data[9], rom_data[10]},
								{5'b0, rom_data[0], rom_data[1], rom_data[2], rom_data[3], rom_data[4]}
							  };
		end
		else begin
			pixel_data <= 'd0;
		end
	end
	
	
	
	
	
	
	// rom ip
	ip rom0(
		.address		(rom_addr			),    // addr
		.clock		(driver_clk			),    // clk
		.q				(rom_data			)     // data out
	);








endmodule