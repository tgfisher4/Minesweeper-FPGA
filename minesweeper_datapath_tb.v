`timescale 1ns/1ns

module minesweeper_datapath_tb();

	reg clk;
	reg  en_position, en_bombCounter, s_bombCounter; 
	reg [2:0] s_position, s_board, s_size;
	reg [1:0] s_updateBoardNext, s_numFlags;
	reg en_board, en_bombOrNumber, s_bombOrNumber, en_size; 
	reg en_updateBoardNext, en_revealQueue, en_numFlags;
	reg [3:0] s_revealQueue;
	reg [7:0] keyCode;
	reg [2:0] adjBombs;
	reg [5:0] din;
	reg [7:0] random;
	
//flags
	wire enoughBombs, atTopEdge, atLeftEdge,atRightEdge;
	wire atBottomEdge, queueEmpty, noSurrounding, bomb, flagged;
	wire covered, posLast, upPressed, downPressed, rightPressed;
	wire leftPressed, enterPressed, fPressed, nextNumberGen;
	wire nextGameHub, nextRevealSquare, nextCheckPosition, flagsRemain;
	
	wire [0:5] board;
	wire [7:0] position;
	
	/*
	wire [5:0] board;
	wire [1:0] updateBoardNext;
	wire bombOrNumber;
	wire [5:0]bombCounter;
	*/

	minesweeper_datapath uut(
	.clk(clk),
	.en_position(en_position), 
	.en_bombCounter(en_bombCounter), 
	.s_bombCounter(s_bombCounter), 
	.s_position(s_position), 
	.s_board(s_board),
	.s_updateBoardNext(s_updateBoardNext),
	.en_board(en_board),  
	.en_bombOrNumber(en_bombOrNumber), 
	.s_bombOrNumber(s_bombOrNumber), 
	.en_updateBoardNext(en_updateBoardNext), 
	.en_revealQueue(en_revealQueue), 
	.s_revealQueue(s_revealQueue),
	.keyCode(keyCode),
	.adjBombs(adjBombs),
	.din(din),
	.random(random),
	.en_size(en_size),
	.s_size(s_size),
	.en_numFlags(en_numFlags),
	.s_numFlags(s_numFlags),
//flags
	.enoughBombs(enoughBombs), 
	.atTopEdge(atTopEdge), 
	.atLeftEdge(atLeftEdge),
	.atRightEdge(atRightEdge), 
	.atBottomEdge(atBottomEdge), 
	.queueEmpty(queueEmpty), 
	.noSurrounding(noSurrounding), 
	.bomb(bomb), 
	.flagged(flagged),
	.covered(covered), 
	.posLast(posLast), 
	.upPressed(upPressed), 
	.downPressed(downPressed), 
	.rightPressed(rightPressed), 
	.leftPressed(leftPressed),
	.enterPressed(enterPressed), 
	.fPressed(fPressed), 
	.nextNumberGen(nextNumberGen), 
	.nextGameHub(nextGameHub), 
	.nextRevealSquare(nextRevealSquare), 
	.nextCheckPosition(nextCheckPosition), 
	.flagsRemain(flagsRemain),
	
	.position(position),
	.board(board)
	/*
	.updateBoardNext(updateBoardNext),
	.bombOrNumber(bombOrNumber),
	.bombCounter(bombCounter)
	*/
	);
	
	always
		#5 clk=~clk;
	
	initial begin
	//set all inputs to 0
		clk=0; en_position=0; en_bombCounter=0; s_bombCounter=0; s_position=0; s_board=0; s_updateBoardNext=0 ;en_board=0; s_board=0; en_bombOrNumber=0; s_bombOrNumber=0; en_updateBoardNext=0; en_revealQueue=0; s_revealQueue=0; keyCode=0; adjBombs=0; din=0; random=0;
		
		//position
		#10 en_position=1; s_position=0; //now pos=0, atTopEdge=1
		#10 en_position=1; s_position=1; //now pos=1
		#10 en_position=1; s_position=2; random=240; //now pos=240, atBottomEdge=1
		#10 en_position=1; s_position=0; //now pos=0 (test 3 later)
		#10 en_position=1; s_position=5; //now pos=16, atLeftEdge=1
		#10 en_position=1; s_position=6; //now pos=15, atRightEdge=1
		#10 en_position=1; s_position=7; //now pos=16, atLeftEdge=1
		#10 en_position=1; s_position=1; //now pos=17, no indicators
		#10 en_position=1; s_position=4; //now pos=1, atTopEdge=1
		//#10;

		
		//board
		#10 en_board=1; s_board=0; din= 6'b100111 ; en_position=0;//now board=1 001 11, bomb=1, flagged=1, covered=1
		#10 en_board=1; s_board=1; adjBombs=3'd5;//now board=1 101 11
		#10 en_board=1; s_board=2; //now board=1 101 10, covered=0
		#10 en_board=1; s_board=3; //now board=1 101 00, flagged=0;
		#10 en_board=1; s_board=3; //now board=1 101 10, flagged=1;
		#10 en_board=1; s_board=4; //now board=100001, noSurrounding=1
		//#10;
		
		//bombCounter
		#10 en_bombCounter=1; s_bombCounter=0; en_board=0; //now bombCounter=0
		#10 en_bombCounter=1; s_bombCounter=1; //now bombCounter=1
		#400; //now enoughBombs=1;
		
		//bombOrNumber
		#10 en_bombOrNumber=1; s_bombOrNumber=0; en_bombCounter=0; //now bombOrNumber=0, checkNextPosition=0
		#10 en_bombOrNumber=1; s_bombOrNumber=1; //now bombOrNumber=1, checkNextPosition=1;
		
		//updateBoardNext
		#10 en_updateBoardNext=1; s_updateBoardNext=0; en_bombOrNumber=0; //now updateBoardNext=0, nextNumberGen=1
		#10 en_updateBoardNext=1; s_updateBoardNext=1; //now updateBoardNext=1, nextGameHub=1
		#10 en_updateBoardNext=1; s_updateBoardNext=2; //now updateBoardNext=2, nextRevealSquare=1
		
		//numFlags
		#10 en_numFlags=1; s_numFlags=0; en_updateBoardNext=0; //now numFlags=40, flagsRemain=1
		#10 en_numFlags=1; s_numFlags=1; //now numFlags=41
		#10 en_numFlags=1; s_numFlags=2; //now numFlags=40;
		while(uut.numFlags != 0)
			#10;
		//now numFlags=0, flagsRemain=0;
		
		
		//size
		#10 en_size=1; s_size=0; en_updateBoardNext=0; //now size=0, queueEmpty=1
		#10 en_size=1; s_size=1; //now size=3, queueEmpty=0
		#10 en_size=1; s_size=2; //now size=8
		#10 en_size=1; s_size=3; //now size=16
		#10 en_size=1; s_size=4; //now size=15
		

		
		//revealQueue and position 3
		
		//topleft
		#10 en_revealQueue=1; s_revealQueue=0; en_size=0; //now revealQueue={}
		#10 en_size=1; s_size=0; en_revealQueue=0;//now size=0
		#10 en_revealQueue=1; s_revealQueue=1; en_size=0;//now revealQueue=[1, 16, 17]
		#10 en_size=1; s_size=1; en_revealQueue=0;//now size=3
		#10 en_position=1; s_position=3; en_size=0;//now position=17
		#10 en_size=1; s_size=4; en_position=0;//now size=2
		#10 en_position=1; s_position=3; en_size=0;//now position=16
		#10 en_size=1; s_size=4; en_position=0;//now size=1
		#10 en_position=1; s_position=3; en_size=0;//now position=1
		#10 en_size=1; s_size=4; en_position=0;//now size=0, queueEmpty=1
		
		//topright
		#10 en_revealQueue=1; s_revealQueue=0; en_size=0; //now revealQueue={}
		#10 en_size=1; s_size=0; en_revealQueue=0;//now size=0
		#10 en_revealQueue=1; s_revealQueue=2; en_size=0;//now revealQueue=[14, 30, 31]
		#10 en_size=1; s_size=1; en_revealQueue=0;//now size=3
		#10 en_position=1; s_position=3; en_size=0;//now position=31
		#10 en_size=1; s_size=4; en_position=0;//now size=2
		#10 en_position=1; s_position=3; en_size=0;//now position=30
		#10 en_size=1; s_size=4; en_position=0;//now size=1
		#10 en_position=1; s_position=3; en_size=0;//now position=14
		#10 en_size=1; s_size=4; en_position=0;//now size=0
		
		//bottomleft
		#10 en_revealQueue=1; s_revealQueue=0; en_size=0; //now revealQueue={}
		#10 en_size=1; s_size=0; en_revealQueue=0;//now size=0
		#10 en_revealQueue=1; s_revealQueue=3; en_size=0;//now revealQueue=[224, 225, 241]
		#10 en_size=1; s_size=1; en_revealQueue=0;//now size=3
		#10 en_position=1; s_position=3; en_size=0;//now position=241
		#10 en_size=1; s_size=4; en_position=0;//now size=2
		#10 en_position=1; s_position=3; en_size=0;//now position=225
		#10 en_size=1; s_size=4; en_position=0;//now size=1
		#10 en_position=1; s_position=3; en_size=0;//now position=224
		#10 en_size=1; s_size=4; en_position=0;//now size=0
		
		//bottomright
		#10 en_revealQueue=1; s_revealQueue=0; en_size=0; //now revealQueue={}
		#10 en_size=1; s_size=0; en_revealQueue=0;//now size=0
		#10 en_revealQueue=1; s_revealQueue=4; en_size=0;//now revealQueue=[238, 239, 254]
		#10 en_size=1; s_size=1; en_revealQueue=0;//now size=3
		#10 en_position=1; s_position=3; en_size=0;//now position=254
		#10 en_size=1; s_size=4; en_position=0;//now size=2
		#10 en_position=1; s_position=3; en_size=0;//now position=239
		#10 en_size=1; s_size=4; en_position=0;//now size=1
		#10 en_position=1; s_position=3; en_size=0;//now position=238
		#10 en_size=1; s_size=4; en_position=0;//now size=0
		
		//top
		#10 en_revealQueue=1; s_revealQueue=0; en_size=0; //now revealQueue={}
		#10 en_size=1; s_size=0; en_revealQueue=0;//now size=0
		#10 en_position=1; s_position=2; random=8; en_size=0;//now pos=8, atTopEdge=1
		#10 en_revealQueue=1; s_revealQueue=5; en_position=0;//now revealQueue=[7, 9, 23, 24, 25]
		#10 en_size=1; s_size=2; en_revealQueue=0;//now size=5
		#10 en_position=1; s_position=3; en_size=0;//now position=25
		#10 en_size=1; s_size=4; en_position=0;//now size=4
		#10 en_position=1; s_position=3; en_size=0;//now position=24
		#10 en_size=1; s_size=4; en_position=0;//now size=3
		#10 en_position=1; s_position=3; en_size=0;//now position=23
		#10 en_size=1; s_size=4; en_position=0;//now size=2
		#10 en_position=1; s_position=3; en_size=0;//now position=9
		#10 en_size=1; s_size=4; en_position=0;//now size=1
		#10 en_position=1; s_position=3; en_size=0;//now position=7
		#10 en_size=1; s_size=4; en_position=0;//now size=0
		
		//bottom
		#10 en_revealQueue=1; s_revealQueue=0; en_size=0; //now revealQueue={}
		#10 en_size=1; s_size=0; en_revealQueue=0;//now size=0
		#10 en_position=1; s_position=2; random=254; en_size=0;//now pos=254, atBottomEdge=1
		#10 en_revealQueue=1; s_revealQueue=6; en_position=0;//now revealQueue=[253, 255, 237, 238, 239]
		#10 en_size=1; s_size=2; en_revealQueue=0;//now size=5
		#10 en_position=1; s_position=3; en_size=0;//now position=239
		#10 en_size=1; s_size=4; en_position=0;//now size=4
		#10 en_position=1; s_position=3; en_size=0;//now position=238
		#10 en_size=1; s_size=4; en_position=0;//now size=3
		#10 en_position=1; s_position=3; en_size=0;//now position=237
		#10 en_size=1; s_size=4; en_position=0;//now size=2
		#10 en_position=1; s_position=3; en_size=0;//now position=255
		#10 en_size=1; s_size=4; en_position=0;//now size=1
		#10 en_position=1; s_position=3; en_size=0;//now position=253
		#10 en_size=1; s_size=4; en_position=0;//now size=0
		
		//left
		#10 en_revealQueue=1; s_revealQueue=0; en_size=0; //now revealQueue={}
		#10 en_size=1; s_size=0; en_revealQueue=0;//now size=0
		#10 en_position=1; s_position=2; random=16; en_size=0;//now pos=16, atLeftEdge=1
		#10 en_revealQueue=1; s_revealQueue=7; en_position=0;//now revealQueue=[0, 1, 17, 32, 33]
		#10 en_size=1; s_size=2; en_revealQueue=0;//now size=5
		#10 en_position=1; s_position=3; en_size=0;//now position=33
		#10 en_size=1; s_size=4; en_position=0;//now size=4
		#10 en_position=1; s_position=3; en_size=0;//now position=32
		#10 en_size=1; s_size=4; en_position=0;//now size=3
		#10 en_position=1; s_position=3; en_size=0;//now position=17
		#10 en_size=1; s_size=4; en_position=0;//now size=2
		#10 en_position=1; s_position=3; en_size=0;//now position=1
		#10 en_size=1; s_size=4; en_position=0;//now size=1
		#10 en_position=1; s_position=3; en_size=0;//now position=0
		#10 en_size=1; s_size=4; en_position=0;//now size=0
		
		//right
		#10 en_revealQueue=1; s_revealQueue=0; en_size=0; //now revealQueue={}
		#10 en_size=1; s_size=0; en_revealQueue=0;//now size=0
		#10 en_position=1; s_position=2; random=31; en_size=0;//now pos=31, atRightEdge=1
		#10 en_revealQueue=1; s_revealQueue=8; en_position=0;//now revealQueue=[14, 15, 30, 46, 47]
		#10 en_size=1; s_size=2; en_revealQueue=0;//now size=5
		#10 en_position=1; s_position=3; en_size=0;//now position=47
		#10 en_size=1; s_size=4; en_position=0;//now size=4
		#10 en_position=1; s_position=3; en_size=0;//now position=46
		#10 en_size=1; s_size=4; en_position=0;//now size=3
		#10 en_position=1; s_position=3; en_size=0;//now position=30
		#10 en_size=1; s_size=4; en_position=0;//now size=2
		#10 en_position=1; s_position=3; en_size=0;//now position=15
		#10 en_size=1; s_size=4; en_position=0;//now size=1
		#10 en_position=1; s_position=3; en_size=0;//now position=14
		#10 en_size=1; s_size=4; en_position=0;//now size=0
		
		//middle
		#10 en_revealQueue=1; s_revealQueue=0; en_size=0; //now revealQueue={}
		#10 en_size=1; s_size=0; en_revealQueue=0;//now size=0
		#10 en_position=1; s_position=2; random=24; en_size=0;//now pos=24
		#10 en_revealQueue=1; s_revealQueue=9; en_position=0;//now revealQueue=[7, 8, 9, 23, 25, 39, 40, 41]
		#10 en_size=1; s_size=3; en_revealQueue=0;//now size=8
		#10 en_position=1; s_position=3; en_size=0;//now position=41
		#10 en_size=1; s_size=4; en_position=0;//now size=7
		#10 en_position=1; s_position=3; en_size=0;//now position=40
		#10 en_size=1; s_size=4; en_position=0;//now size=6
		#10 en_position=1; s_position=3; en_size=0;//now position=39
		#10 en_size=1; s_size=4; en_position=0;//now size=5
		#10 en_position=1; s_position=3; en_size=0;//now position=25
		#10 en_size=1; s_size=4; en_position=0;//now size=4
		#10 en_position=1; s_position=3; en_size=0;//now position=23
		#10 en_size=1; s_size=4; en_position=0;//now size=3
		#10 en_position=1; s_position=3; en_size=0;//now position=9
		#10 en_size=1; s_size=4; en_position=0;//now size=2
		#10 en_position=1; s_position=3; en_size=0;//now position=8
		#10 en_size=1; s_size=4; en_position=0;//now size=1
		#10 en_position=1; s_position=3; en_size=0;//now position=7
		#10 en_size=1; s_size=4; en_position=0;//now size=0
		#10 en_size=0;
		
		

		//general flags
		#10 en_position=1; s_position=2; random=255;//now position=255
		#10 en_position=1; s_position=1; //now position=256, postLast=1
		#10 keyCode=8'h75; //upPressed
		#10 keyCode=8'h72;//downPressed is this valid
		#10 keyCode=8'h74; //rightPressed
		#10 keyCode=8'h6B; //leftPressed
		#10 keyCode=8'h5A; //enterPressed
		#10 keyCode=8'h2B; //fPressed
		#10;
		
		
	$stop;
	end
	
	endmodule