module minesweeper_processor(
	input clk,
	input reset,
	input [0:5] din,
	input [7:0] random,
	input [7:0] keyCode,
	input [2:0] adjBombs,
	output [7:0] position,
	output [0:5] dout,
	output we,
	output rstBoard
);

	
	//control signals
wire en_position, en_bombCounter, s_bombCounter, en_size;
wire en_board, en_bombOrNumber, s_bombOrNumber;
wire [2:0] s_position, s_board, s_size;
wire [1:0] s_updateBoardNext, s_numFlags;
wire en_updateBoardNext, en_revealQueue, en_numFlags;
wire [3:0] s_revealQueue;
	
	//flags
wire enoughBombs, atTopEdge, atLeftEdge,atRightEdge, flagsRemain;
wire atBottomEdge, queueEmpty, noSurrounding, bomb, flagged;
wire covered, posLast, upPressed, downPressed, rightPressed; 
wire leftPressed, enterPressed, fPressed, nextNumberGen, nextGameHub, nextRevealSquare, nextCheckPosition;

minesweeper_controller controller(
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

minesweeper_datapath datapath(
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
	.board(dout)
);

endmodule