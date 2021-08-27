module minesweeper_controller_v2 (
	input clk,
	input reset,
	
	//control signals
	output reg en_workPosition, en_cursorPosition, en_dout, en_bombCounter, 
	output reg en_revealQueue, en_size, en_numFlags, en_queueIndex,
	
	output reg [3:0] s_revealQueue, s_dout,
	output reg [2:0] s_workPosition, s_cursorPosition, s_size, 
	output reg [1:0] s_numFlags, 
	output reg s_bombCounter, s_queueIndex,
	
	output reg we, rstBoard, en_bestTime,
	output reg [1:0] gameOverState,

	
	//flags
	input atTopEdge, atLeftEdge, atRightEdge, atBottomEdge,
	input queueEmpty, noSurrounding, bomb, flagged, covered, posLast, enoughBombs, flagsRemain, 
	input queueIndexZero, queueIndexSize, shift, endDequeue, updateTime, queued,
	
	input upPressed, downPressed, leftPressed, rightPressed, enterPressed, fPressed
 );

	parameter init = 6'd0;
	parameter initializeBoard = 6'd1;
	parameter getRandom = 6'd2;
	parameter placeBomb = 6'd3;
	parameter checkLastBomb = 6'd4;
	parameter rstWorkPosLoad = 6'd5;
	parameter checkWorkPosLoad = 6'd6;
	parameter incrWorkPosLoad = 6'd7;
	parameter topLeftLoad = 6'd8;
	parameter topRightLoad = 6'd9;
	parameter bottomLeftLoad = 6'd10;
	parameter bottomRightLoad = 6'd11;
	parameter topLoad = 6'd12;
	parameter bottomLoad = 6'd13;
	parameter leftLoad = 6'd14;
	parameter rightLoad = 6'd15;
	parameter middleLoad = 6'd59;
	parameter syncPosition= 6'd16;
	parameter gameHub = 6'd17;
	parameter checkTopEdge = 6'd18;
	parameter checkBottomEdge = 6'd19;
	parameter checkLeftEdge = 6'd20;
	parameter checkRightEdge = 6'd21;
	parameter up = 6'd22;
	parameter down = 6'd23;
	parameter left = 6'd24;
	parameter right = 6'd25;
	parameter checkCovered = 6'd26;
	parameter plantFlag = 6'd27;
	parameter retractFlag =6'd28;
	parameter checkFlagged = 6'd29;
	parameter checkBomb = 6'd30;
	parameter gameOver = 6'd31;
	parameter revealSquare = 6'd32;
	parameter getNext = 6'd33;
	parameter loopReadMem = 6'd34;
	parameter addNeighbors = 6'd35;
	parameter topLeftState = 6'd36;
	parameter topRightState = 6'd37;
	parameter bottomLeftState = 6'd38;
	parameter bottomRightState = 6'd39;
	parameter topState = 6'd40;
	parameter bottomState = 6'd41;
	parameter leftState = 6'd42;
	parameter rightState = 6'd43;
	parameter middleState = 6'd44;
	parameter workPosToQIndex = 6'd45;
	parameter readMemRemoval = 6'd46;
	parameter checkLastIndex = 6'd47;
	parameter dequeueFirst = 6'd48;
	parameter dequeue = 6'd49;
	parameter checkWorkPos = 6'd50;
	parameter shiftIntoPosition = 6'd51;
	parameter incrPosDequeue = 6'd52;
	parameter incrQIndex = 6'd53;
	parameter rstWorkPosWinChecker = 6'd54;
	parameter checkWin = 6'd55;
	parameter checkNotWin = 6'd56;
	parameter gameWon = 6'd57;
	parameter updateBestTime = 6'd58;


 
 
	reg [5:0] state, next_state;

	always @(posedge clk)
		if (reset)
			state <= init;
		else
			state <= next_state;

	always @(*) begin
		en_workPosition = 0;
		s_workPosition = 0;
		en_cursorPosition = 0;
		s_cursorPosition = 0;
		en_dout = 0;
		s_dout = 0;
		en_bombCounter = 0;
		s_bombCounter = 0;
		en_revealQueue = 0;
		s_revealQueue = 0;
		en_size=0;
		s_size=0;
		en_numFlags=0;
		s_numFlags=0;
		en_queueIndex=0;
		s_queueIndex=0;
		
		we=0;
		rstBoard=0;
		en_bestTime=0;
		gameOverState=0;
		next_state = init;
 
		case (state)
 
		init: begin
			en_workPosition = 1;
			s_workPosition = 0;
			en_bombCounter = 1;
			s_bombCounter = 0;
			en_numFlags = 1;
			s_numFlags = 0;
			en_cursorPosition =1;
			s_cursorPosition=0;
			next_state = initializeBoard;
		end
 
		initializeBoard: begin
			rstBoard = 1;
			we = 1;
			next_state = getRandom;
		end
 
		getRandom: begin
			en_workPosition= 1; 
			s_workPosition= 2;
			next_state = placeBomb;
		end
		
		placeBomb: begin
			en_dout=1;
			s_dout = 0;
			we=1;
			en_bombCounter=1;
			s_bombCounter=1;
			next_state = checkLastBomb;
		end
		
		checkLastBomb: begin
			if(enoughBombs) 
				next_state = rstWorkPosLoad;
			else
				next_state = getRandom;
		end
		
		rstWorkPosLoad: begin
			en_workPosition=1;
			s_workPosition=0;
			next_state=topLeftLoad;
		end
		
		checkWorkPosLoad: begin
			if (atTopEdge&atLeftEdge)
				next_state=topLeftLoad;
			else if (atTopEdge&atRightEdge)
				next_state=topRightLoad;
				
			else if (atBottomEdge&atLeftEdge)
				next_state=bottomLeftLoad;
			else if (atBottomEdge&atRightEdge)
				next_state=bottomRightLoad;
				
			else if(atTopEdge)
				next_state=topLoad;
			else if(atBottomEdge)
				next_state=bottomLoad;
			else if(atLeftEdge)
				next_state=leftLoad;
			else if(atRightEdge)
				next_state=rightLoad;
				
			else 
				next_state = middleLoad;
		end	
			
		incrWorkPosLoad : begin
			en_workPosition=1; s_workPosition=1;
			next_state=checkWorkPosLoad;
		end
		
		topLeftLoad: begin
			en_dout=1; s_dout=6;
			we=1;
			next_state=incrWorkPosLoad;
		end
		
		topRightLoad: begin
			en_dout=1; s_dout=7;
			we=1;
			next_state=incrWorkPosLoad;
		end
		
		bottomLeftLoad: begin
			en_dout=1; s_dout=8;
			we=1;
			next_state=incrWorkPosLoad;
		end
		
		bottomRightLoad: begin
			en_dout=1; s_dout=9;
			we=1;
			next_state=syncPosition;
		end
		
		topLoad: begin
			en_dout=1; s_dout=10;
			we=1;
			next_state=incrWorkPosLoad;
		end
		
		bottomLoad: begin
			en_dout=1; s_dout=11;
			we=1;
			next_state=incrWorkPosLoad;
		end
		
		leftLoad: begin
			en_dout=1; s_dout=12;
			we=1;
			next_state=incrWorkPosLoad;
		end
		
		rightLoad: begin
			en_dout=1; s_dout=13;
			we=1;
			next_state=incrWorkPosLoad;
		end
		
		middleLoad: begin
			en_dout=1; s_dout=14;
			we=1;
			next_state=incrWorkPosLoad;
		end
		
		syncPosition: begin 
			en_workPosition=1;
			s_workPosition=4;
			next_state = gameHub;
		end
		
		gameHub:begin 
			if (enterPressed)
				next_state = checkFlagged;
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
		
		up: begin
			en_cursorPosition=1; 
			s_cursorPosition= 4;
			next_state = syncPosition;
		end
		
		down: begin
		
			en_cursorPosition=1; 
			s_cursorPosition= 3;
			next_state = syncPosition;
		end
		
		left: begin
		
			en_cursorPosition=1; 
			s_cursorPosition= 2;
			next_state = syncPosition;
		end
		
		right: begin
		
			en_cursorPosition=1; 
			s_cursorPosition= 1;
			next_state = syncPosition;
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
			en_dout=1;
			s_dout=2; 
			we=1;
			en_numFlags =1;
			s_numFlags=2;
			next_state = gameHub;
		end
		
		retractFlag: begin
			en_dout=1;
			s_dout=2; 
			we=1;
			en_numFlags =1;
			s_numFlags=1;
			next_state = gameHub;
		end
		
		checkFlagged: begin
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
				next_state = revealSquare;
		end
		
		gameOver:begin
			gameOverState=2;
			next_state=gameOver;

		end
		
		revealSquare: begin
			en_dout=1;
			s_dout=3;
			we=1;

			if(covered&noSurrounding) 
				next_state =addNeighbors;
			else if(queueEmpty) 
				next_state = rstWorkPosWinChecker;
			else 
				next_state = getNext;

		end
		
		getNext: begin
			en_workPosition =1;
			s_workPosition=3;
			en_size=1;
			s_size=4;
			next_state = loopReadMem;
		end
		
		loopReadMem: begin
			//allows din to update
			en_dout=1; s_dout=5; we=1;
			next_state=revealSquare;
		end
		
		addNeighbors: begin 
			en_queueIndex=1;
			s_queueIndex=0;
			if (atTopEdge&atLeftEdge)
				next_state=topLeftState;
			else if (atTopEdge&atRightEdge)
				next_state=topRightState;
				
			else if (atBottomEdge&atLeftEdge)
				next_state=bottomLeftState;
			else if (atBottomEdge&atRightEdge)
				next_state=bottomRightState;
				
			else if(atTopEdge)
				next_state=topState;
			else if(atBottomEdge)
				next_state=bottomState;
			else if(atLeftEdge)
				next_state=leftState;
			else if(atRightEdge)
				next_state=rightState;
				
			else 
				next_state = middleState;
		end
		

		topLeftState: begin
			en_size=1;
			s_size=1;
			en_revealQueue=1;
			s_revealQueue=1;
			next_state=workPosToQIndex;
		end
		
		topRightState: begin
			en_size=1;
			s_size=1;
			en_revealQueue=1;
			s_revealQueue=2;
			next_state=workPosToQIndex;
		end
		
		bottomLeftState: begin
			en_size=1;
			s_size=1;
			en_revealQueue=1;
			s_revealQueue=3;
			next_state=workPosToQIndex;
		end
		
		bottomRightState: begin
			en_size=1;
			s_size=1;
			en_revealQueue=1;
			s_revealQueue=4;
			next_state=workPosToQIndex;
		end
		
		topState: begin
			en_size=1;
			s_size=2;
			en_revealQueue=1;
			s_revealQueue=5;
			next_state=workPosToQIndex;
		end
		
		bottomState: begin
			en_size=1;
			s_size=2;
			en_revealQueue=1;
			s_revealQueue=6;
			next_state=workPosToQIndex;
		end
		
		leftState: begin
			en_size=1;
			s_size=2;
			en_revealQueue=1;
			s_revealQueue=7;
			next_state=workPosToQIndex;
		end
		
		rightState: begin
			en_size=1;
			s_size=2;
			en_revealQueue=1;
			s_revealQueue=8;
			next_state=workPosToQIndex;
		end
		
		middleState: begin
			en_size=1;
			s_size=3;
			en_revealQueue=1;
			s_revealQueue=9;
			next_state=workPosToQIndex;
		end
		
		workPosToQIndex: begin
			en_workPosition=1;
			s_workPosition=5;
			next_state=readMemRemoval;
		end
		
		readMemRemoval: begin
			next_state=checkLastIndex;
		end
		
		checkLastIndex: begin
			if(queueIndexSize&~queueEmpty)
				next_state=getNext;
			else if(queueIndexSize)
				next_state=rstWorkPosWinChecker;
			else if(queueIndexZero&(~covered|queued))
				next_state=dequeueFirst;
			else if(~covered|queued)
				next_state=dequeue;
			else
				next_state=incrQIndex;
		end
		
		dequeueFirst: begin
			en_revealQueue=1;
			s_revealQueue=10;
			en_size=1;
			s_size=4;
			next_state=workPosToQIndex;
		end
		
		dequeue: begin
			en_workPosition=1;
			s_workPosition=0;
			en_size=1;
			s_size=4;
			next_state=checkWorkPos;
		end
		
		checkWorkPos: begin
			if(endDequeue)
				next_state=workPosToQIndex;
			else if(shift)
				next_state=shiftIntoPosition;
			else
				next_state=incrPosDequeue;
		end
		
		shiftIntoPosition: begin
			en_revealQueue=1;
			s_revealQueue=11;
			next_state=incrPosDequeue;
		end
		
		incrPosDequeue: begin
			en_workPosition=1;
			s_workPosition=1;
			next_state=checkWorkPos;
		end
		
		incrQIndex: begin
			en_queueIndex=1;
			s_queueIndex=1;
			en_dout=1; s_dout=4;
			we=1;
			next_state=workPosToQIndex;
		end
		
		rstWorkPosWinChecker: begin
			en_workPosition=1;
			s_workPosition=0;
			next_state=checkWin;
		end
		
		checkWin: begin
			if(posLast)
				next_state=gameWon;
			else
				next_state=checkNotWin;
		end
		
		checkNotWin: begin
			en_workPosition=1;
			s_workPosition=1;
			if(~bomb&covered)
				next_state=syncPosition;
			else
				next_state=checkWin;
		end
		
		gameWon: begin
			gameOverState=1;
			if(updateTime)
				next_state=updateBestTime;
			else
				next_state=gameWon;
		end
		
		updateBestTime: begin
			gameOverState=1;
			en_bestTime=1;
			next_state=gameWon;
		end
		

 default: ;
 endcase
 end

endmodule