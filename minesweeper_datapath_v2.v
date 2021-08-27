module minesweeper_datapath_v2(
	input clk,
	
	//control signals
	input en_workPosition, en_cursorPosition, en_dout, en_bombCounter, en_revealQueue, en_size, en_numFlags, en_queueIndex,
	input [3:0] s_revealQueue,
	input [2:0] s_workPosition, s_cursorPosition, s_size, s_dout,
	input [1:0] s_numFlags, 
	input s_bombCounter, s_queueIndex,
	
	input [7:0] keyCode,
	input [2:0] adjBombs, 
	input [0:6] din,
	input [7:0] random,
	input [9:0] currTime,
	input en_we,
	input en_rstBoard,
	input en_bestTime,
	
//flags
	output atTopEdge, atLeftEdge, atRightEdge, atBottomEdge,
	output queueEmpty, noSurrounding, bomb, flagged, covered, posLast, enoughBombs, flagsRemain, queueIndexZero, queueIndexSize, endDequeue, shift, updateTime, queued,
	output upPressed, downPressed, leftPressed, rightPressed, enterPressed, fPressed,
	
	output reg [7:0] workPosition,
	output reg [7:0] cursorPosition,
	output reg [0:6] dout,
	output reg [9:0] bestTime,
	output reg we,
	output reg rstBoard,
	output reg [5:0] numFlags
);
	integer i; 

	reg [5:0] bombCounter;
	reg [7:0] revealQueue [0:255];
	reg [7:0] size;
	//reg [5:0] numFlags;
	reg [7:0] queueIndex;
	reg wasMaxPos;
	
	initial bestTime=10'd999;
	always@(posedge clk)
		if(en_bestTime)
			bestTime<= currTime;

	// workPosition stage
	always @(posedge clk)
		if(en_workPosition) begin
			case (s_workPosition)
				0: workPosition <= 0;
				1: workPosition <= workPosition+1;
				2: workPosition <= random;
				3: workPosition <= revealQueue[size-1];
				4: workPosition <= cursorPosition;
				5: workPosition <= revealQueue[queueIndex];
				default: ;
			endcase
			wasMaxPos <= workPosition==255&s_workPosition==1;
		end
		
	//cursorPosition
	always @(posedge clk)
		if(en_cursorPosition) begin
			case (s_cursorPosition)
				0: cursorPosition <= 119;
				1: cursorPosition <= cursorPosition+1;
				2: cursorPosition <= cursorPosition-1;
				3: cursorPosition <= cursorPosition+16;
				4: cursorPosition <= cursorPosition-16;
				default: ;
			endcase
		end
		
	//dout
	always @(posedge clk)
		if(en_dout) begin
			case (s_dout)
				0: dout <= 7'b1000010;
				1: dout <= {din[0], adjBombs, din[4], 2'b10};
				2: dout <= {din[0:3], ~din[4], din[5], 1'b0};
				3: dout <= {din[0:4], 2'b00};
				4: dout <= {din[0:5], 1'b1};
				5: dout <= {din[0:5], 1'b0};
				default: ;
			endcase
		end
		
	//bombCounter
	always @(posedge clk)
		if(en_bombCounter)begin
			case (s_bombCounter)
				0: bombCounter<= 0;
				1: bombCounter <= bombCounter+1;
				default: ;
			endcase
		end
		
	//queueIndex
	always @(posedge clk)
		if(en_queueIndex)begin
			case (s_queueIndex)
				0: queueIndex <= size;
				1: queueIndex <= queueIndex+1;
				default: ;
			endcase
		end
		
	//size
	always @(posedge clk)
		if(en_size) begin
			case(s_size)
				0: size <= 0;
				1: size <= size+3;
				2: size <= size+5;
				3: size <= size+8;
				4: size <= size-1;
				default: ;
			endcase
		end
		
	always @(posedge clk)
		if(en_numFlags) begin
			case(s_numFlags)
				0: numFlags <=40;
				1: numFlags <= numFlags+1;
				2: numFlags <= numFlags-1;
				default: ;
			endcase
		end
		
	always @(posedge clk)
		if(en_revealQueue)begin
			case (s_revealQueue)
			0: $readmemh("blankQueue.txt", revealQueue);
			
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
				revealQueue[size] <= workPosition-1;
				revealQueue[size+1] <= workPosition+1;
				revealQueue[size+2] <= workPosition+15;
				revealQueue[size+3] <= workPosition+16;
				revealQueue[size+4] <= workPosition+17;
			end
			
			6: begin 
				revealQueue[size] <= workPosition-1;
				revealQueue[size+1] <= workPosition+1;
				revealQueue[size+2] <= workPosition-17;
				revealQueue[size+3] <= workPosition-16;
				revealQueue[size+4] <= workPosition-15;
			end
			
			7: begin 
				revealQueue[size] <= workPosition-16;
				revealQueue[size+1] <= workPosition-15;
				revealQueue[size+2] <= workPosition+1;
				revealQueue[size+3] <= workPosition+16;
				revealQueue[size+4] <= workPosition+17;
			end
			
			8: begin 
				revealQueue[size] <= workPosition-17;
				revealQueue[size+1] <= workPosition-16;
				revealQueue[size+2] <= workPosition-1;
				revealQueue[size+3] <= workPosition+15;
				revealQueue[size+4] <= workPosition+16;
			end
			
			9: begin 
				revealQueue[size] <= workPosition-17;
				revealQueue[size+1] <= workPosition-16;
				revealQueue[size+2] <= workPosition-15;
				revealQueue[size+3] <= workPosition-1;
				revealQueue[size+4] <= workPosition+1;
				revealQueue[size+5] <= workPosition+15;
				revealQueue[size+6] <= workPosition+16;
				revealQueue[size+7] <= workPosition+17;
			end
			
			10: begin
				//intended behavior: revealQueue <= {revealQueue[1:255],0};
				
				//generate  
					for (i= 0 ; i <= 254; i=i+1) 
					begin : shiftFirst
						revealQueue[i]<=revealQueue[i+1];
					end
				//endgenerate 
				
			end
			
			11: begin
				//intended behavior: revealQueue <= {revealQueue[0: queueIndex-1], revealQueue[queueIndex+1: 255], 0};
				
				revealQueue[workPosition] <= revealQueue[workPosition+1];
				//endgenerate
			
			end
			
			
			default:  ;
			endcase
		end
		
	always @(posedge clk)
		we<=en_we;
	always @(posedge clk)
		rstBoard<=en_rstBoard;

	//flags
	assign enoughBombs = bombCounter==40;
	assign atTopEdge = workPosition < 16 ;
	assign atLeftEdge = (workPosition % 16) ==0;
	assign atRightEdge = (workPosition % 16) ==15;
	assign atBottomEdge = workPosition >= 240;
	assign queueEmpty = size==0;
	assign noSurrounding = din[1:3] ==0;
	assign bomb = din[0];
	assign flagged = din[4];
	assign covered = din[5];
	assign queued = din[6];
	assign posLast = (workPosition==0)&wasMaxPos; //& (lastPosition==255);
	assign upPressed = keyCode==8'h75;
	assign downPressed = keyCode==8'h72;//is this valid
	assign rightPressed = keyCode==8'h74;
	assign leftPressed = keyCode==8'h6B;
	assign enterPressed = keyCode==8'h5A;
	assign fPressed = keyCode==8'h2B;
	assign flagsRemain = numFlags>0;
	assign queueIndexZero = queueIndex==0;
	assign queueIndexSize = queueIndex==size;
	assign endDequeue = workPosition==size+1;
	assign shift = workPosition>=queueIndex;
	assign updateTime = currTime<bestTime;
	
endmodule