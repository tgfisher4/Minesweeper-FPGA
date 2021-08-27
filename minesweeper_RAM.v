module minesweeper_RAM(
input [7:0] read_addr,
input [7:0] write_addr,
input [0:6] din,
input reset,
input clk,
input we,
output reg [0:6] dout, doutTopLeft, doutTopRight, doutBottomLeft, doutBottomRight, doutTop, doutBottom, doutLeft, doutRight,
output reg [2:0] adjBombs
);
reg [0:6] mem_array [0:255];
always @(posedge clk) begin
	if (we) begin
		if(reset)
			$readmemb("blankBoard.txt", mem_array);
		else
			mem_array[write_addr] <= din;
	end
	dout <= mem_array[read_addr];
	doutTopLeft <= mem_array[read_addr-17];
	doutTopRight <= mem_array[read_addr-15];
	doutBottomLeft <= mem_array[read_addr+15];
	doutBottomRight <= mem_array[read_addr+17];
	doutTop <= mem_array[read_addr-16];
	doutBottom <= mem_array[read_addr+16];
	doutLeft <= mem_array[read_addr-1];
	doutRight <= mem_array[read_addr+1];	
	
	/*
	//topleft
	if(read_addr==0)
		adjBombs <= mem_array[1][0]+mem_array[16][0]+mem_array[17][0];
	//topright
	else if(read_addr==15)
		adjBombs <= mem_array[14][0]+mem_array[30][0]+mem_array[31][0];
	//bottomleft
	else if(read_addr==240)
		adjBombs <= mem_array[224][0]+mem_array[225][0]+mem_array[241][0];
	//bottomright
	else if(read_addr==255)
		adjBombs <= mem_array[238][0]+mem_array[239][0]+mem_array[254][0];
	//top
	else if(read_addr<16)
		adjBombs <= mem_array[read_addr-1][0]+mem_array[read_addr+1][0]+mem_array[read_addr+15][0]+mem_array[read_addr+16][0]+mem_array[read_addr+17][0];
	//bottom
	else if(read_addr>=240)
		adjBombs <= mem_array[read_addr-1][0]+mem_array[read_addr+1][0]+mem_array[read_addr-17][0]+mem_array[read_addr-16][0]+mem_array[read_addr-15][0];
	//left
	else if(read_addr%16==0)
		adjBombs <= mem_array[read_addr-16][0]+mem_array[read_addr-15][0]+mem_array[read_addr+1][0]+mem_array[read_addr+16][0]+mem_array[read_addr+17][0];
	else if(read_addr%16==15)
		adjBombs <= mem_array[read_addr-17][0]+mem_array[read_addr-16][0]+mem_array[read_addr-1][0]+mem_array[read_addr+15][0]+mem_array[read_addr+16][0];
	//middle
	else
		adjBombs <= mem_array[read_addr-17][0]+mem_array[read_addr-16][0]+mem_array[read_addr-15][0]+mem_array[read_addr-1][0]+mem_array[read_addr+1][0]+mem_array[read_addr+15][0]+mem_array[read_addr+16][0]+mem_array[read_addr+17][0];
*/

end
endmodule