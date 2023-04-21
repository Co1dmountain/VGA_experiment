module vga_colorbar_driver(
		// input
		input						driver_clk				,  // 25.175MHz
		input						sys_rst_n				,
		input		[29:0]			data_from_display		,  // data generate by display module
		// output
		// output		[15:0]			data_to_screen			,  // data to vga & screen
		output		[29:0]			data_to_screen			,  // data to vga & screen
		output						Hsync					,
		output						Fsync					,
		output	reg	[ 9:0]			pixel_xpos				,  // pixel x position
		output	reg	[ 9:0]			pixel_ypos				   // pixel y position
);

	//// define ////
	parameter H_SYNC  = 10'd96; //行同步
	parameter H_BACK  = 10'd48; //行显示后沿
	parameter H_DISP  = 10'd640; //行有效数据
	parameter H_FRONT = 10'd16; //行显示前沿
	parameter H_TOTAL = 10'd800; //行扫描周期
	
	parameter V_SYNC  = 10'd2; //场同步
	parameter V_BACK  = 10'd33; //场显示后沿
	parameter V_DISP  = 10'd480; //场有效数据
	parameter V_FRONT = 10'd10; //场显示前沿
	parameter V_TOTAL = 10'd525; //场扫描周期
	
	//// main code ////
	reg [9:0] h_cnt;
	reg [9:0] v_cnt;
	// h_cnt
	always @(posedge driver_clk or negedge sys_rst_n) begin
		if(!sys_rst_n) begin
			h_cnt <= 'd0;
		end
		else if(h_cnt == H_TOTAL - 1'b1) begin
			h_cnt <= 'd0;
		end
		else begin
			h_cnt <= h_cnt + 1'b1;
		end
	end
	// v_cnt
	always @(posedge driver_clk or negedge sys_rst_n) begin
		if(!sys_rst_n) begin
			v_cnt <= 'd0;
		end
		else begin
			if(h_cnt == H_TOTAL - 1'b1 && v_cnt == V_TOTAL - 1'b1) begin
				v_cnt <= 'd0;
			end
			else if(h_cnt == H_TOTAL - 1'b1 && v_cnt < V_TOTAL - 1'b1) begin
				v_cnt <= v_cnt + 1'b1;
			end
			else begin
				v_cnt <= v_cnt;
			end
		end
		
	end

	// pixel_xpos
	always @(posedge driver_clk or negedge sys_rst_n) begin
		if(!sys_rst_n) begin
			pixel_xpos <= 'd0;
		end
		else if(h_cnt >= H_SYNC + H_BACK && h_cnt < H_TOTAL - H_FRONT) begin
			pixel_xpos <= h_cnt - H_SYNC - H_BACK + 1'b1;
		end
		else begin
			pixel_xpos <= 'd0;
		end
	end
	// pixel_ypos
	always @(posedge driver_clk or negedge sys_rst_n) begin
		if(!sys_rst_n) begin
			pixel_ypos <= 'd0;
		end
		else if(v_cnt >= V_SYNC + V_BACK && v_cnt < V_TOTAL - V_FRONT) begin
			pixel_ypos <= v_cnt - V_SYNC - V_BACK + 1'b1;
		end
		else begin
			pixel_ypos <= 'd0;
		end
	end

	// Hsync
	assign Hsync = (h_cnt <= H_SYNC - 1'b1) ? 1'b0 : 1'b1;
	// Fsync
	assign Fsync = (v_cnt <= V_SYNC - 1'b1) ? 1'b0 : 1'b1;

	// data_to_screen
	assign data_to_screen = ((h_cnt >= H_SYNC + H_BACK && h_cnt < H_TOTAL - H_FRONT) 
							&& (v_cnt >= V_SYNC + V_BACK && v_cnt < V_TOTAL - V_FRONT)) ? data_from_display : 'd0;


endmodule