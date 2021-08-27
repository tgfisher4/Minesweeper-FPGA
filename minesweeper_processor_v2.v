module minesweeper_processor_v2(
	input clk,
	input reset,
	input [0:6] din,
	input [7:0] random,
	input [7:0] keyCode,
	input [2:0] adjBombs,
	input [9:0] currTime,
	output [7:0] workPosition,
	output [7:0] cursorPosition,
	output [0:6] dout,
	output we,
	output rstBoard,
	output [9:0] bestTime,
	output [1:0] gameOverState,
	output [5:0] numFlags
);

	
	//control signals
wire en_workPosition, en_cursorPosition, en_dout, en_bombCounter, en_revealQueue, en_size, en_numFlags, en_queueIndex;
wire [3:0] s_revealQueue;
wire [2:0] s_workPosition, s_cursorPosition, s_size, s_dout;
wire [1:0] s_numFlags;
wire s_bombCounter, s_queueIndex;
wire en_we, en_rstBoard, en_bestTime;
	
	//flags
wire atTopEdge, atLeftEdge, atRightEdge, atBottomEdge;
wire queueEmpty, noSurrounding, bomb, flagged, covered, posLast, enoughBombs, flagsRemain, queueIndexZero, queueIndexSize, endDequeue, shift, updateTime, queued;
wire upPressed, downPressed, leftPressed, rightPressed, enterPressed, fPressed;

minesweeper_controller_v2 controller(
	.clk(clk),
	.reset(reset),
	
	//flags
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
	.enoughBombs(enoughBombs), 
	.flagsRemain(flagsRemain),
	.upPressed(upPressed), 
	.downPressed(downPressed), 
	.leftPressed(leftPressed), 
	.rightPressed(rightPressed), 
	.enterPressed(enterPressed), 
	.fPressed(fPressed),
	.queueIndexZero(queueIndexZero),
	.queueIndexSize(queueIndexSize),
	.endDequeue(endDequeue),
	.shift(shift),
	.updateTime(updateTime),
	.queued(queued),
	
	//control signals
	.en_workPosition(en_workPosition), 
	.en_cursorPosition(en_cursorPosition), 
	.en_dout(en_dout), 
	.en_bombCounter(en_bombCounter), 
	.en_revealQueue(en_revealQueue), 
	.en_size(en_size), 
	.en_numFlags(en_numFlags),
	.en_queueIndex(en_queueIndex),
	.s_revealQueue(s_revealQueue),
	.s_workPosition(s_workPosition), 
	.s_cursorPosition(s_cursorPosition), 
	.s_size(s_size),
	.s_numFlags(s_numFlags),
	.s_dout(s_dout),
	.s_bombCounter(s_bombCounter),
	.s_queueIndex(s_queueIndex),
	.en_bestTime(en_bestTime),
	
	.we(en_we),
	.rstBoard(en_rstBoard),
	.gameOverState(gameOverState)
);

minesweeper_datapath_v2 datapath(
	.clk(clk),
	.we(we),
	.en_we(en_we),
	.rstBoard(rstBoard),
	.en_rstBoard(en_rstBoard),
	
	//control signals
	.en_workPosition(en_workPosition), 
	.en_cursorPosition(en_cursorPosition), 
	.en_dout(en_dout), 
	.en_bombCounter(en_bombCounter), 
	.en_revealQueue(en_revealQueue), 
	.en_size(en_size), 
	.en_numFlags(en_numFlags),
	.en_queueIndex(en_queueIndex),
	.s_revealQueue(s_revealQueue),
	.s_workPosition(s_workPosition), 
	.s_cursorPosition(s_cursorPosition), 
	.s_size(s_size),
	.s_numFlags(s_numFlags),
	.s_dout(s_dout),
	.s_bombCounter(s_bombCounter),
	.s_queueIndex(s_queueIndex),
	.en_bestTime(en_bestTime),
	
	.keyCode(keyCode),
	.adjBombs(adjBombs), 
	.din(din),
	.
	.random(random),
	.currTime(currTime),
	.bestTime(bestTime),
	
//flags
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
	.enoughBombs(enoughBombs), 
	.flagsRemain(flagsRemain),
	.upPressed(upPressed), 
	.downPressed(downPressed), 
	.leftPressed(leftPressed), 
	.rightPressed(rightPressed), 
	.enterPressed(enterPressed), 
	.fPressed(fPressed),
	.queueIndexZero(queueIndexZero),
	.queueIndexSize(queueIndexSize),
	.endDequeue(endDequeue),
	.shift(shift),
	.updateTime(updateTime),
	.queued(queued),
	
	.workPosition(workPosition),
	.cursorPosition(cursorPosition),
	.dout(dout),
	.numFlags(numFlags)
);

endmodule