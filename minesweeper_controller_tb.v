`timescale 1ns/1ns

module minesweeper_controller_tb();

reg clk, reset;

//flags
reg enoughBombs, atTopEdge, atLeftEdge,atRightEdge; 
reg atBottomEdge, queueEmpty, noSurrounding, bomb, flagged;
reg covered, posLast, upPressed, downPressed, rightPressed;
reg leftPressed, enterPressed, fPressed, nextNumberGen, nextGameHub;
reg nextRevealSquare, nextCheckPosition, flagsRemain;

//outputs for datapath
wire en_position, en_bombCounter, s_bombCounter;
wire en_board, en_bombOrNumber, s_bombOrNumber, we, rstBoard;
wire [2:0] s_position, s_board, s_size;
wire [1:0] s_updateBoardNext, s_numFlags;
wire [3:0] s_revealQueue;
wire en_updateBoardNext, en_revealQueue, en_size, en_numFlags;


minesweeper_controller uut(
	.clk(clk),
	.reset(reset),
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
	.en_position(en_position),
	.en_bombCounter(en_bombCounter),
	.s_bombCounter(s_bombCounter),
	.en_board(en_board),
	.en_bombOrNumber(en_bombOrNumber),
	.s_bombOrNumber(s_bombOrNumber),
	.we(we),
	.rstBoard(rstBoard),
	.s_position(s_position),
	.s_board(s_board),
	.s_updateBoardNext(s_updateBoardNext),
	.en_updateBoardNext(en_updateBoardNext),
	.en_revealQueue(en_revealQueue),
	.s_revealQueue(s_revealQueue),
	.en_size(en_size),
	.s_size(s_size),
	.en_numFlags(en_numFlags),
	.s_numFlags(s_numFlags),
	.flagsRemain(flagsRemain)
);

always
	#5 clk=~clk;
	

initial begin
	// set all flags to 0
	clk=0; reset=1; enoughBombs=0; atTopEdge=0; atLeftEdge=0; atRightEdge=0; atBottomEdge=0; queueEmpty=0; noSurrounding=0; bomb=0; flagged=0; covered=0; posLast=0; upPressed=0; downPressed=0; rightPressed=0; leftPressed=0; enterPressed=0; fPressed=0; nextNumberGen=0; nextGameHub=0; nextRevealSquare=0; nextCheckPosition=0; 
	
	#10 reset=0;
	#40 nextCheckPosition=0; //cycles through init, initializeBoard, getRandom, bombGen, is on updateRAM, to checkLastBomb
	#10 enoughBombs=0; //to bombGen
	#10; //to update RAM
	#10 nextCheckPosition=0; //to checkLastBomb
	#10 enoughBombs=1; //to readyNumberGen
	#10; //to updateBoard
	#10 nextNumberGen=1; //to numberGen
	#10; //to update RAM
	#10 nextCheckPosition=1; //to checkLastPosition
	#10 posLast=0; //to updateBoard
	#10 nextNumberGen=1; //to numberGen
	#10; //to updateRAM
	#10 nextCheckPosition=1; //to checkLastPosition
	#10 posLast=1; //to readyGameHub
	#10;//to updateBoard
	#10 nextGameHub=1; nextNumberGen=0;//to gameHub
	#10; //to gameHub
	
	#10 upPressed=1; //to checkTopEdge
	#10 atTopEdge=1; // to gameHub
	#10 upPressed=1; //to checkTopEdge
	#10 atTopEdge=0; //to up
	#10; //to gameHub
	
	#10 downPressed=1; upPressed=0; //to checkBottomEdge
	#10 atBottomEdge=1; // to gameHub
	#10 downPressed=1; //to checkBottomEdge
	#10 atBottomEdge=0; //to up
	#10; //to gameHub
	
	#10 leftPressed=1; downPressed=0; //to checkLeftEdge
	#10 atLeftEdge=1; // to gameHub
	#10 leftPressed=1; //to checkTopEdge
	#10 atLeftEdge=0; //to up
	#10; //to gameHub
	
	#10 rightPressed=1; leftPressed=0; //to checkRightEdge
	#10 atRightEdge=1; // to gameHub
	#10 rightPressed=1; //to checkTopEdge
	#10 atRightEdge=0; //to up
	#10; //to gameHub
	
	#10 fPressed=1; rightPressed=0;//to checkCovered
	#10 covered=0; //to gameHub
	#10 fPressed=1; //to checkCovered
	#10 covered=1; flagged=0; flagsRemain=1;//to plantFlag
	#10; //to gameHub
	#10 fPressed=1; //to checkCovered
	#10 covered=1; flagged=0; flagsRemain=0;//to gameHub
	#10 fPressed=1; //to checkCovered
	#10 covered=1; flagged=1;//to retractFlag
	#10; //to gameHub
	
	#10 enterPressed=1; fPressed=0;//to checkFlagged
	#10 flagged=1; //to gameHub
	#10 enterPressed=1; //to checkFlagged
	#10 flagged=0; //to checkBomb
	#10 bomb=0; //to coveredToReveal
	#10 covered=0; queueEmpty=1; //to gameHub
	#10 enterPressed=1; //to checkFlagged
	#10 flagged=0; //to checkBomb
	#10 bomb=0; //to coveredToReveal
	#10 covered=0; queueEmpty=0;//to getNext
	#10; //to updateBoard
	#10 nextRevealSquare=1; nextGameHub=0; //to coveredToReveal
	
	//topLeftCorner
	#10 covered=1; //to revealSquare
	#10 noSurrounding=1; //to addNeighbors
	#10 atTopEdge=1; atLeftEdge=1; //to topLeftCornerState
	#10; //to getNext
	#10; //to updateBoard
	#10 nextRevealSquare=1; nextGameHub=0; //to coveredToReveal
	
	//topRightCorner
	#10 covered=1; //to revealSquare
	#10 noSurrounding=1; //to addNeighbors
	#10 atTopEdge=1; atRightEdge=1; atLeftEdge=0; //to topRightCornerState
	#10; //to getNext
	#10; //to updateBoard
	#10 nextRevealSquare=1; nextGameHub=0; //to coveredToReveal
	
	//bottomLeftCorner
	#10 covered=1; //to revealSquare
	#10 noSurrounding=1; //to addNeighbors
	#10 atBottomEdge=1; atLeftEdge=1; atRightEdge=0; atTopEdge=0;//to bottomLeftCornerState
	#10; //to getNext
	#10; //to updateBoard
	#10 nextRevealSquare=1; nextGameHub=0; //to coveredToReveal
	
	//bottomRightCorner
	#10 covered=1; //to revealSquare
	#10 noSurrounding=1; //to addNeighbors
	#10 atBottomEdge=1; atRightEdge=1; atLeftEdge=0;//to bottomRightCornerState
	#10; //to getNext
	#10; //to updateBoard
	#10 nextRevealSquare=1; nextGameHub=0; //to coveredToReveal

	//topEdge
	#10 covered=1; //to revealSquare
	#10 noSurrounding=1; //to addNeighbors
	#10 atTopEdge=1; atRightEdge=0; atBottomEdge=0;//to topEdgeState
	#10; //to getNext
	#10; //to updateBoard
	#10 nextRevealSquare=1; nextGameHub=0; //to coveredToReveal
	
	//bottomEdge
	#10 covered=1; //to revealSquare
	#10 noSurrounding=1; //to addNeighbors
	#10 atBottomEdge=1; atTopEdge=0; //to bottomState
	#10; //to getNext
	#10; //to updateBoard
	#10 nextRevealSquare=1; nextGameHub=0; //to coveredToReveal
	
	//leftEdge
	#10 covered=1; //to revealSquare
	#10 noSurrounding=1; //to addNeighbors
	#10 atLeftEdge=1; atBottomEdge=0; //to leftEdgeState
	#10; //to getNext
	#10; //to updateBoard
	#10 nextRevealSquare=1; nextGameHub=0; //to coveredToReveal
	
	//rightEdge
	#10 covered=1; //to revealSquare
	#10 noSurrounding=1; //to addNeighbors
	#10 atRightEdge=1; atLeftEdge=0; //to rightEdgeState
	#10; //to getNext
	#10; //to updateBoard
	#10 nextRevealSquare=1; nextGameHub=0; //to coveredToReveal
	
	//middle
	#10 covered=1; //to revealSquare
	#10 noSurrounding=1; //to addNeighbors
	#10 atRightEdge=0; //to atMiddle
	#10; //to getNext
	#10; //to updateBoard
	#10 nextRevealSquare=1; nextGameHub=0; //to coveredToReveal
	
	#10 covered=1; //to revealSquare
	#10 noSurrounding=0; queueEmpty=1; //to gameHub
	
	#10 enterPressed=1; //to checkFlagged
	#10 flagged=0; //to checkBomb
	#10 bomb=1; //to gameOver
	#10; //to gameOver
	#10 reset=1; //to init
	#10;
	
$stop;
end

endmodule
