module minesweeper_controller (
	input clk,
	input reset,
	
	//control signals
	output reg en_position, en_bombCounter, s_bombCounter, en_size,
	output reg en_board, en_bombOrNumber, s_bombOrNumber, we, rstBoard,
	output reg [2:0] s_position, s_board, s_size,
	output reg [1:0] s_updateBoardNext, s_numFlags,
	output reg en_updateBoardNext, en_revealQueue, en_numFlags,
	output reg [3:0] s_revealQueue,
	
	//flags
	input enoughBombs, atTopEdge, atLeftEdge,atRightEdge, flagsRemain,
	input atBottomEdge, queueEmpty, noSurrounding, bomb, flagged,
	input covered, posLast, upPressed, downPressed, rightPressed, 
	input leftPressed, enterPressed, fPressed, nextNumberGen, nextGameHub, nextRevealSquare, nextCheckPosition

 );

	parameter init = 6'd0;
	parameter initializeBoard = 6'd1;
	parameter getRandom = 6'd2;
	parameter bombGen = 6'd3;
	parameter updateRAM = 6'd4;
	parameter checkLastBomb = 6'd5;
	parameter numberGen = 6'd6;
	parameter checkLastPosition = 6'd7;
	parameter readyNumberGen = 6'd8;
	parameter readyGameHub = 6'd9;
	parameter gameHub = 6'd10;
	parameter up = 6'd11;
	parameter down = 6'd12;
	parameter left = 6'd13;
	parameter right = 6'd14;
	parameter checkCovered = 6'd15;
	parameter plantFlag = 6'd16;
	parameter checkFlag = 6'd17;
	parameter checkBomb = 6'd18;
	parameter gameOver = 6'd19;
	parameter revealSquare = 6'd20;
	parameter addNeighbors = 6'd21;
	parameter getNext = 6'd22;
	parameter checkTopEdge = 6'd23;
	parameter checkBottomEdge = 6'd24;
	parameter checkLeftEdge = 6'd25;
	parameter checkRightEdge = 6'd26;
	parameter updateBoard = 6'd27;
	parameter coveredToReveal = 6'd28;
	parameter topLeftCornerState = 6'd29;
	parameter topRightCornerState = 6'd30;
	parameter bottomLeftCornerState = 6'd31;
	parameter bottomRightCornerState = 6'd32;
	parameter topEdgeState = 6'd33;
	parameter bottomEdgeState = 6'd34;
	parameter leftEdgeState = 6'd35;
	parameter rightEdgeState = 6'd36;
	parameter atMiddle = 6'd37;
	parameter retractFlag =6'd38;
 
 
	reg [5:0] state, next_state;

	always @(posedge clk)
		if (reset)
			state <= init;
		else
			state <= next_state;

	always @(*) begin
		en_position = 0;
		en_bombCounter = 0;
		s_bombCounter = 0;
		en_board = 0;
		en_bombOrNumber= 0;
		s_bombOrNumber = 0;
		we=0;
		rstBoard=0;
		s_position = 0;
		s_board = 0;
		s_updateBoardNext = 0;
		en_updateBoardNext = 0;
		en_revealQueue = 0;
		s_revealQueue = 0;
		en_size=0;
		s_size=0;
		en_numFlags=0;
		s_numFlags=0;
		next_state = init;
 
		case (state)
 
		init: begin
			en_position = 1; 
			s_position = 0;
			en_bombCounter = 1; 
			s_bombCounter = 0;
			en_numFlags=1;
			s_numFlags=0;
			next_state = initializeBoard;
		end
 
		initializeBoard: begin
			rstBoard = 1;
			we = 1;
			next_state = getRandom;
		end
 
		getRandom: begin
			en_position= 1; 
			s_position= 2;
			next_state = bombGen;
		end
		
		bombGen: begin
			en_board = 1; 
			s_board = 4;
			en_bombOrNumber=1; 
			s_bombOrNumber=0;
			next_state = updateRAM;
		end
		
		updateRAM: begin 
			we=1;
			if(nextCheckPosition) 
				next_state = checkLastPosition;
			else
				next_state = checkLastBomb;
		end
		
		checkLastBomb: begin
			en_bombCounter =1; 
			s_bombCounter=1;
			if(enoughBombs) 
				next_state = readyNumberGen;
			else
				next_state = getRandom;
				

		end
		
		numberGen: begin
			en_board=1; 
			s_board=1;
			en_bombOrNumber=1; 
			s_bombOrNumber=1;
			next_state = updateRAM;

		end
		
		checkLastPosition: begin
			en_position=1; 
			s_position=1;
			en_updateBoardNext=1; 
			s_updateBoardNext= 0;
			if(posLast) 
				next_state = readyGameHub;
			else
				next_state = updateBoard;

		end
		
		readyNumberGen: begin
			en_position=1; 
			s_position= 0;
			en_updateBoardNext= 1; 
			s_updateBoardNext= 0;
			next_state = updateBoard;
			
		end
		
		readyGameHub: begin 
			en_position = 1; 
			s_position=0;
			en_updateBoardNext =1; 
			s_updateBoardNext= 1;
			next_state = updateBoard;
		end
		
		gameHub:begin 

			we= 1;
			en_board =1; 
			s_board= 0;
			if (enterPressed)
				next_state = checkFlag;
			else if (fPressed) 
				next_state = checkCovered;
			else if(upPressed) 
				next_state =	checkTopEdge;
			else if(downPressed) 
				next_state =	checkBottomEdge;
			else if(leftPressed) 
				next_state =	checkLeftEdge;
			else if(rightPressed) 
				next_state =	checkRightEdge;
			else 
				next_state =	gameHub;
				
		end
		
		up: begin
		
			en_position=1; 
			s_position= 4;
			next_state = gameHub;
		end
		
		down: begin
		
			en_position=1; 
			s_position= 5;
			next_state = gameHub;
		end
		
		left: begin
		
			en_position=1; 
			s_position= 6;
			next_state = gameHub;
		end
		
		right: begin
		
			en_position=1; 
			s_position= 7;
			next_state = gameHub;
		end
		
		checkCovered: begin
			if(covered&~flagged&flagsRemain) 
				next_state = plantFlag;
			else if(covered&flagged)
				next_state = retractFlag;
			else
				next_state = gameHub;

		end
		
		plantFlag: begin
			en_board=1; 
			s_board=3;
			en_numFlags=1;
			s_numFlags=2;
			next_state = gameHub;
		end
		
		retractFlag: begin
			en_board=1; 
			s_board=3;
			en_numFlags=1;
			s_numFlags=1;
			next_state = gameHub;
		end
		
		checkFlag: begin
			if(flagged)
				next_state = gameHub;
			else
				next_state = checkBomb;
		end
		
		checkBomb: begin
			en_revealQueue= 1; 
			s_revealQueue= 0;
			en_size=1;
			s_size=0;
			if(bomb)
				next_state = gameOver;
			else
				next_state = coveredToReveal;
		end
		
		gameOver:begin
			if(reset)
				next_state = init;
			else
				next_state = gameOver;

		end
		
		revealSquare: begin
			en_board=1; 
			s_board= 2;
			if(noSurrounding) 
				next_state =addNeighbors;
			else if(queueEmpty) 
				next_state = gameHub;
			else 
				next_state = getNext;

		end
		
		addNeighbors: begin 
			if (atTopEdge&atLeftEdge)
				next_state=topLeftCornerState;
			else if (atTopEdge&atRightEdge)
				next_state=topRightCornerState;
				
			else if (atBottomEdge&atLeftEdge)
				next_state=bottomLeftCornerState;
			else if (atBottomEdge&atRightEdge)
				next_state=bottomRightCornerState;
				
			else if(atTopEdge)
				next_state=topEdgeState;
			else if(atBottomEdge)
				next_state=bottomEdgeState;
			else if(atLeftEdge)
				next_state=leftEdgeState;
			else if(atRightEdge)
				next_state=rightEdgeState;
				
			else 
				next_state = atMiddle;
		end
		
		getNext: begin
			en_position= 1; 
			s_position= 3;
			en_updateBoardNext= 1; 
			s_updateBoardNext= 2;
			en_size= 1; 
			s_size= 4;
			next_state = updateBoard;
		end
		
		checkTopEdge: begin
			if(atTopEdge) 
				next_state = gameHub;
			else 
				next_state = up; 
		end
		
		checkBottomEdge: begin
			if(atBottomEdge) 
				next_state = gameHub;
			else 
				next_state = down; 
		end
		
		checkLeftEdge: begin
			if(atLeftEdge) 
				next_state = gameHub;
			else 
				next_state = left; 
		end
		
		checkRightEdge: begin
			if(atRightEdge) 
				next_state = gameHub;
			else 
				next_state = right; 
		end
		
		updateBoard: begin
			en_board= 1; 
			s_board=0;
			if(nextNumberGen) 
				next_state = numberGen;
			else if(nextGameHub) 
				next_state = gameHub;
			else if(nextRevealSquare) 
				next_state = coveredToReveal;

		
		end
		
		coveredToReveal: begin
			if(covered)
				next_state=revealSquare;
			else if(queueEmpty)
				next_state=gameHub;
			else
				next_state=getNext;
				
		end
		

		topLeftCornerState: begin
			en_size=1;
			s_size=1;
			en_revealQueue=1;
			s_revealQueue=1;
			next_state=getNext;
		end
		
		topRightCornerState: begin
			en_size=1;
			s_size=1;
			en_revealQueue=1;
			s_revealQueue=2;
			next_state=getNext;
		end
		
		bottomLeftCornerState: begin
			en_size=1;
			s_size=1;
			en_revealQueue=1;
			s_revealQueue=3;
			next_state=getNext;
		end
		
		bottomRightCornerState: begin
			en_size=1;
			s_size=1;
			en_revealQueue=1;
			s_revealQueue=4;
			next_state=getNext;
		end
		
		topEdgeState: begin
			en_size=1;
			s_size=2;
			en_revealQueue=1;
			s_revealQueue=5;
			next_state=getNext;
		end
		
		bottomEdgeState: begin
			en_size=1;
			s_size=2;
			en_revealQueue=1;
			s_revealQueue=6;
			next_state=getNext;
		end
		
		leftEdgeState: begin
			en_size=1;
			s_size=2;
			en_revealQueue=1;
			s_revealQueue=7;
			next_state=getNext;
		end
		
		rightEdgeState: begin
			en_size=1;
			s_size=2;
			en_revealQueue=1;
			s_revealQueue=8;
			next_state=getNext;
		end
		
		atMiddle: begin
			en_size=1;
			s_size=3;
			en_revealQueue=1;
			s_revealQueue=9;
			next_state=getNext;
		end

		

 default: ;
 endcase
 end

endmodule