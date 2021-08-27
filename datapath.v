module minesweeper_datapath(
	input  en_position, en_bombCounter, s_bombCounter, 
	input [2:0] s_position, s_board,
	input [1:0] s_readMemNext,
	input en_board, s_board, en_bombOrNumber, s_bombOrNumber, 
	input en_readMemNext, en_revealQueue, s_revealQueue,
	input keyCode,
//flags
	output enoughBombs, atTopEdge, atLeftEdge,atRightEdge, 
	output atBottomEdge, queueEmpty, noSurrounding, bomb, flagged,
	output covered, posLast, upPressed, downPressed, rightPressed, 
	output leftPressed, enterPressed, fPressed, nextNumberGen, nextGameHub, nextRevealSquare, nextCheckPosition

);

	// position stage
	
	//if(en_position)
		//if(S_position
	
	
	
	assign enoughBombs = bombCounter==40 ;
	assign atTopEdge = position < 16 ;
	assign atLeftEdge = (position % 16) ==0;
	assign atRightEdge = (position % 16) ==15;
	assign atBottomEdge = position >= 240;
	assign queueEmpty = revealQueue.size()==0;
	assign noSurrounding = board[1:3] ==0;
	assign bomb = board[0];
	assign flagged = board[4];
	assign covered = board[5];
	assign posLast = position==256;
	assign upPressed = keyCode==75;
	assign downPressed = keyCode==72;
	assign rightPressed = keyCode==74;
	assign leftPressed = keyCode==6B;
	assign enterPressed = keyCode==5A;
	assign fPressed = keyCode==2B;
	assign nextNumberGen = readMemNext==0;
	assign nextGameHub = readMemNext==1;
	assign nextRevealSquare = readMemNext==2;
	assign nextCheckPosition = bombOrNumber==1;