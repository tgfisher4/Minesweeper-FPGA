module image_change (
   input    VGA_CLK,
	input 	[7:0] cursorPosition,
	input 	[7:0] workPosition,
   input    [7:0] xvga,
   input    [6:0] yvga,
	input 			we2,
	input rst,
	input 	[0:6] din,
	input 	[1:0] gState,
   output   [2:0] color
   );
    

   wire [2:0] sprite_color, background_color, colIn, w_screen, l_screen;
   wire [7:0] x = 32+(cursorPosition % 16)*6;
	wire [6:0] y= 17+(cursorPosition / 16)*6;
   wire in_sprite = (xvga >= x) & (xvga < (x + 6)) & (yvga >= y) & (yvga < (y + 6));
	wire [7:0] xs = xvga-x;
	wire [6:0] ys = yvga-y;
   reg  in_sprite_delayed;
	wire [2:0]step1;
   wire [7:0] xw = 32+(workPosition % 16)*6;
   wire [6:0] yw = 17+(workPosition / 16)*6;
   always @(posedge VGA_CLK)
      in_sprite_delayed <= in_sprite;
   
	cursor_rom cursor_rom ( 
      .clk  (VGA_CLK),    			
      .x    (xs[2:0]),
      .y    (ys[2:0]),  
      .dout (sprite_color)
	);
	wire [2:0] b_color;
	b_rom b_rom(
		.clk(VGA_CLK),
		.x (xvga),
		.y (yvga),
		.dout(b_color),
	.loss_rom (loss_rom),
     .clk  (VGA_CLK),    			
      .x    (xvga),
      .y    (yvga),  
      .dout (l_screen)
	);
	
	
	won_rom won_rom(
     .clk  (VGA_CLK),    			
      .x    (xvga),
      .y    (yvga),  
      .dout (w_screen)
	);
	 board_change board_change (
		.VGA_CLK(VGA_CLK),
		.workPosition(workPosition),
		.xvga(xvga),
		.yvga(yvga),
		.din(din),
		.we(we1),
		.color(colIn)
    );
	
	 wire we1;
	
	background_ram background_ram( 
	.clk  (VGA_CLK),
		.colIn(colIn),
		.we1(we1),
		.we2(we2),
      .x    (xvga),
      .y    (yvga),  
      .dout (background_color)
	);
	
   assign color = rst ? b_color : (gState != 0 ? (gState ==2 ?  l_screen : w_screen) : 
	(in_sprite_delayed ? sprite_color : background_color));
   
endmodule
