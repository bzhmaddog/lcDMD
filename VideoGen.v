// (c) KNJN LLC 2013

////////////////////////////////////////////////////////////////////////
module VideoGen(
	input clk,
	input rclk,
	input clk180,
	output reg DrawArea, hSync, vSync,
	output [7:0] red, green, blue
);

//h
parameter hDrawArea = 1280;
parameter hSyncPorch = 32;
parameter hSyncLen = 96;
parameter hFrameSize = 1440;

//v
parameter vDrawArea = 390;
parameter vSyncPorch = 1;
parameter vSyncLen = 24;
parameter vFrameSize = 442;

reg [11:0] CounterX, CounterY;
reg [7:0] R, G, B;
reg [3:0] x_count = 0;
reg [3:0] y_count = 0;
reg [7:0] pixel_x = 0;
reg [5:0] pixel_y = 0;

wire [7:0] px_r, px_g, px_b;


RamScreenGen myScreenGen(
	.clk(rclk),
	.clk180(clk180),
   .x(pixel_x),
   .y(pixel_y),
   .o_r(px_r),
   .o_g(px_g),
   .o_b(px_b) 
);


always @(posedge clk) begin
 
 if (CounterX==hFrameSize-1) begin
	CounterX <= 12'd0;
	x_count <= 4'd0;
	pixel_x <= 8'd0;
 end else begin
	CounterX <= CounterX+12'd1;
  
   if (x_count >= 9) begin
		x_count <= 4'd0;
		pixel_x <= pixel_x+8'd1;
	end else begin
		x_count <= x_count+4'd1;
	end
	
 end
end

always @(posedge clk) begin
 if (CounterX==hFrameSize-1) begin
	if (CounterY==vFrameSize-1) begin
		CounterY <= 12'd0;
		y_count <= 4'd0;
		pixel_y <= 6'd0;
	end else begin
		CounterY <= CounterY+12'd1;
		
		if (y_count >= 9) begin
			y_count <= 4'd0;
			pixel_y <= pixel_y+6'd1;
		end else begin
			y_count <= y_count+4'd1;
		end
	
	end
 end
end

always @(posedge clk) DrawArea <= (CounterX<hDrawArea) && (CounterY<vDrawArea);
always @(posedge clk) hSync <= (CounterX>=hDrawArea+hSyncPorch) && (CounterX<hDrawArea+hSyncPorch+hSyncLen);
always @(posedge clk) vSync <= (CounterY>=vDrawArea+vSyncPorch) && (CounterY<vDrawArea+vSyncPorch+vSyncLen);

////////////////////////////////////////////////////////////////////////
	
	always @(posedge clk) begin

		// draw 2px black border around every 8x8 pixels
		if (x_count == 0 || x_count == 9 || y_count == 0 || y_count == 9) begin
			R <= 0;
			G <= 0;
			B <= 0;
		end else begin
		
			R <= px_r;
			G <= px_g;
			B <= px_b;
			
			/*if (pixel_y == 0 || pixel_y == 38 || pixel_x == 0 || pixel_x == 127) begin
				R <= 255;
				G <= 132;
				B <= 9;
			end else begin
				R <= 50;
				G <= 50;
				B <= 50;
			end*/
		end
			
	end


	assign red = R;
	assign green = G;
	assign blue = B;

endmodule

////////////////////////////////////////////////////////////////////////