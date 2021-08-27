module minesweeper_controller (
	input clk,
	input reset,
	output reg en_position, en_bombCounter, s_bombCounter, 
	output reg en_board, en_bombOrNumber, s_bombOrNumber, we, rstBoard,
	output reg [2:0] s_position, s_board,
	output reg [1:0] s_readMemNext,
	output reg en_readMemNext, en_revealQueue, s_revealQueue,
	input enoughBombs, atTopEdge, atLeftEdge,atRightEdge, 
	input atBottomEdge, queueEmpty, noSurrounding, bomb, flagged,
	input covered, posLast, upPressed, downPressed, rightPressed, 
	input leftPressed, enterPressed, fPressed, nextNumberGen, nextGameHub, nextRevealSquare, nextCheckPosition

 );

	parameter init = 5'd0;
	parameter initializeBoard = 5'd1;
	parameter getRandom = 5'd2;
	parameter bombGen = 5'd3;
	parameter updateRAM = 5'd4;
	parameter checkLastBomb = 5'd5;
	parameter numberGen = 5'd6;
	parameter checkLastPosition = 5'd7;
	parameter readyNumberGen = 5'd8;
	parameter readyGameHub = 5'd9;
	parameter gameHub = 5'd10;
	parameter up = 5'd11;
	parameter down = 5'd12;
	parameter left = 5'd13;
	parameter right = 5'd14;
	parameter checkCovered = 5'd15;
	parameter toggleFlag = 5'd16;
	parameter checkFlag = 5'd17;
	parameter checkBomb = 5'd18;
	parameter gameOver = 5'd19;
	parameter revealSquare = 5'd20;
	parameter addNeighbors = 5'd21;
	parameter getNext = 5'd22;
	parameter checkTopEdge = 5'd23;
	parameter checkBottomEdge = 5'd24;
	parameter checkLeftEdge = 5'd25;
	parameter checkRightEdge = 5'd26;
	parameter updateWorkspace = 5'd27;
 
 
	reg [4:0] state, next_state;

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
		s_position = 0;
		s_board = 0;
		s_readMemNext = 0;
		en_readMemNext = 0;
		en_revealQueue = 0;
		s_revealQueue = 0;
		next_state = init;
 
		case (state)
 
		init: begin
			en_position = 1; 
			s_position = 0;
			en_bombCounter = 1; 
			s_bombCounter = 0;
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
			s_bombOrNumber=0
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
				next_state = bombGen;
				

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
			en_readMemNext=1; 
			s_readMemNext= 0;
			if(posLast) 
				next_state = readyGameHub;
			else
				next_state = updateWorkspace;

		end
		
		readyNumberGen: begin
			en_position=1; 
			s_position= 0;
			en_readMemNext= 1; 
			s_readMemNext= 0;
			next_state = updateWorkspace;
			
		end
		
		readyGameHub: begin 
			en_position = 1; 
			s_position=0;
			en_readMemNext =1; 
			s_readMemNext= 1;
			next_state = updateWorkspace;
		end
		
		gameHub:begin 
			en_revealQueue= 1; 
			s_revealQueue= 0;
			we= 1;
			en_board =1; 
			s_board= 0;
			if (enterPressed)
				next_state = checkFlag;
			else if (fPressed) 
				next_state = checkCovered;
			else if(upPressed) 
				next_state =	checkTopEdge
			else if(downPressed) 
				next_state =	checkDownEdge
			else if(leftPressed) 
				next_state =	checkLeftEdge
			else if(rightPressed) 
				next_state =	checkRightEdge
			else 
				next_state =	gameHub
				
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
			if(covered) 
				next_state = toggleFlag;
			else
				next_state = gameHub;

		end
		
		toggleFlag: begin
			en_board=1; 
			s_board=3;
			next_state = gameHub;
		end
		
		checkFlag: begin
			if(flagged)
				next_state = gameHub;
			else
				next_state = checkBomb;
		end
		
		checkBomb: begin
			if(bomb)
				next_state = gameOver;
			else
				next_state = revealSquare;
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
			else if queueEmpty 
				next_state = gameHub;
			else 
				next_state = getNext;

		end
		
		addNeighbors: begin 
			en_revealQueue= 1; 
			s_revealQueue= 1;
			next_state = getNext;
		end
		
		getNext: begin
			en_position= 1; 
			s_position= 3;
			en_readMemNext= 1; 
			s_readMemNext= 2;
			next_state = updateWorkspace;
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
		
		updateWorkspace: begin
			en_board= 1; 
			s_board=0;
			if(nextNumberGen) 
				next_state = numberGen;
			else if(nextGameHub) 
				next_state = gameHub;
			else if(nextRevealSquare) 
				next_state = revealSquare;

		
		end



			




 default: ;
 endcase
 end

endmodule