module minesweeper_datapath(
	input clk,
	
	//control signals
	input  en_position, en_bombCounter, s_bombCounter, en_size,
	input [2:0] s_position, s_board, s_size,
	input [1:0] s_updateBoardNext, s_numFlags,
	input en_board, en_bombOrNumber, s_bombOrNumber, 
	input en_updateBoardNext, en_revealQueue, en_numFlags,
	input [3:0] s_revealQueue,
	
	input [7:0] keyCode,
	input [2:0] adjBombs, 
	input [5:0] din,
	input [7:0] random,
	
//flags
	output enoughBombs, atTopEdge, atLeftEdge,atRightEdge, 
	output atBottomEdge, queueEmpty, noSurrounding, bomb, flagged,
	output covered, posLast, upPressed, downPressed, rightPressed, 
	output leftPressed, enterPressed, fPressed, nextNumberGen, 
	output nextGameHub, nextRevealSquare, nextCheckPosition, flagsRemain,
	
	output reg [7:0] position,
	output reg [0:5] board

);

	//reg [0:5] board;
	reg [1:0] updateBoardNext;
	reg bombOrNumber;
	reg [5:0] bombCounter;
	reg [7:0] revealQueue [0:255];
	reg [7:0] size;
	reg [7:0] lastPosition;
	reg [5:0] numFlags;

	// position stage
	always @(posedge clk)
		if(en_position)begin
			if(s_position == 0)
				position <= 0;
			else if(s_position == 1)
				position <= position + 8'd1;
			else if(s_position == 2)
				position <= random;
			else if(s_position == 3)
				position <= revealQueue[size-1];
			else if(s_position == 4)
				position <= position - 8'd16;
			else if(s_position == 5)
				position <= position + 8'd16;
			else if(s_position == 6)
				position <= position - 8'd1;
			else if(s_position == 7)
				position <= position + 8'd1;
		lastPosition<=position;
		end
		
	
	always @(posedge clk)
		if(en_board) begin
			if(s_board == 0)
				board <= din;
			else if(s_board ==  1)
				board[1:3] <= adjBombs;
			else if(s_board == 2)
				board[5] <= 0;
			else if(s_board == 3)
				board[4] <= ~board[4];
			else if(s_board == 4)
				board <= 6'b100001;
			
		end
		
	

	always @(posedge clk)
		if(en_bombCounter)begin
			if(s_bombCounter == 0)
				bombCounter <= 0;
			else if(s_bombCounter == 1)
				bombCounter <= bombCounter + 1;
			
		end
		
	always @(posedge clk)
		if(en_revealQueue)begin
			case (s_revealQueue)
			
			0: 
				$readmemh("blankQueue.txt", revealQueue);
			1: begin 
				revealQueue[size] <= 1;
				revealQueue[size+1] <= 16;
				revealQueue[size+2] <= 17;
			end
			
			2: begin 
				revealQueue[size] <= 14;
				revealQueue[size+1] <= 30;
				revealQueue[size+2] <= 31;
			end
			
			3: begin 
				revealQueue[size] <= 224;
				revealQueue[size+1] <= 225;
				revealQueue[size+2] <= 241;
			end
			
			4: begin 
				revealQueue[size] <= 238;
				revealQueue[size+1] <= 239;
				revealQueue[size+2] <= 254;
			end
			
			5: begin 
				revealQueue[size] <= position-1;
				revealQueue[size+1] <= position+1;
				revealQueue[size+2] <= position+15;
				revealQueue[size+3] <= position+16;
				revealQueue[size+4] <= position+17;
			end
			
			6: begin 
				revealQueue[size] <= position-1;
				revealQueue[size+1] <= position+1;
				revealQueue[size+2] <= position-17;
				revealQueue[size+3] <= position-16;
				revealQueue[size+4] <= position-15;
			end
			
			7: begin 
				revealQueue[size] <= position-16;
				revealQueue[size+1] <= position-15;
				revealQueue[size+2] <= position+1;
				revealQueue[size+3] <= position+16;
				revealQueue[size+4] <= position+17;
			end
			
			8: begin 
				revealQueue[size] <= position-17;
				revealQueue[size+1] <= position-16;
				revealQueue[size+2] <= position-1;
				revealQueue[size+3] <= position+15;
				revealQueue[size+4] <= position+16;
			end
			
			9: begin 
				revealQueue[size] <= position-17;
				revealQueue[size+1] <= position-16;
				revealQueue[size+2] <= position-15;
				revealQueue[size+3] <= position-1;
				revealQueue[size+4] <= position+1;
				revealQueue[size+5] <= position+15;
				revealQueue[size+6] <= position+16;
				revealQueue[size+7] <= position+17;
			end
			
			
			default:  ;
			endcase
		end

	
	always @(posedge clk)
		if(en_bombOrNumber)begin
			if(s_bombOrNumber)
				bombOrNumber <=1;
			else
				bombOrNumber <=0;
		end
	
	always @(posedge clk)
		if(en_updateBoardNext)begin
			if(s_updateBoardNext == 0)
				updateBoardNext <= 0;
			else if(s_updateBoardNext == 1)
				updateBoardNext <= 1;
			else if(s_updateBoardNext == 2)
				updateBoardNext <= 2;
			
		end
		
	always @(posedge clk)
		if(en_size) begin
			if(s_size==0)
				size <=0;
			else if(s_size==1)
				size <= size+3;
			else if(s_size==2)
				size <= size+5;
			else if(s_size==3)
				size <= size+8;
			else if(s_size==4)
				size <= size-1;
		
		end
		
	always @(posedge clk)
		if(en_numFlags) begin
			if(s_numFlags==0)
				numFlags <= 40;
			else if(s_numFlags==1)
				numFlags <= numFlags+1;
			else if(s_numFlags==2)
				numFlags <= numFlags-1;
				
		end

	
	assign enoughBombs = bombCounter==39 ;
	assign atTopEdge = position < 16 ;
	assign atLeftEdge = (position % 16) ==0;
	assign atRightEdge = (position % 16) ==15;
	assign atBottomEdge = position >= 240;
	assign queueEmpty = size==0;
	assign noSurrounding = board[1:3] ==0;
	assign bomb = board[0];
	assign flagged = board[4];
	assign covered = board[5];
	assign posLast = (position==0) & (lastPosition==255);
	assign upPressed = keyCode==8'h75;
	assign downPressed = keyCode==8'h72;//is this valid
	assign rightPressed = keyCode==8'h74;
	assign leftPressed = keyCode==8'h6B;
	assign enterPressed = keyCode==8'h5A;
	assign fPressed = keyCode==8'h2B;
	assign nextNumberGen = updateBoardNext==0;
	assign nextGameHub = updateBoardNext==1;
	assign nextRevealSquare = updateBoardNext==2;
	assign nextCheckPosition = bombOrNumber==1;
	assign flagsRemain = numFlags>0;
endmodule