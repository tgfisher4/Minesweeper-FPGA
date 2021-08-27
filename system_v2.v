module system_v2(
	input [7:0] keyCode,
	input clk,
	input reset,
	output [1:0] gameOverState,
	output [0:6] dout,
	output [7:0] workPosition,
	output [7:0] cursorPosition,
	output we,
	output [9:0] bestTime,
	output [5:0] numFlags
);

wire weWire, rstBoard;
wire [0:6] doutWire, dinWire;
wire [7:0] random, workPositionWire;
wire [2:0] adjBombs;
wire [9:0] currTime;

assign workPosition = workPositionWire;
assign dout = doutWire;
assign we = weWire;

minesweeper_processor_v2 processor(
	.clk(clk),
	.reset(reset),
	.din(dinWire),
	.random(random),
	.keyCode(keyCode),
	.adjBombs(adjBombs),
	.workPosition(workPositionWire),
	.cursorPosition(cursorPosition),
	.dout(doutWire),
	.we(weWire),
	.rstBoard(rstBoard),
	.gameOverState(gameOverState),
	.currTime(currTime),
	.bestTime(bestTime),
	.numFlags(numFlags)
);

minesweeper_RAM RAM(
	.read_addr(workPositionWire),
	.write_addr(workPositionWire),
	.din(doutWire),
	.reset(rstBoard),
	.clk(clk),
	.we(we),
	.dout(dinWire),
	.adjBombs(adjBombs)
);

counter counter(
	.CLOCK_50(clk),
	.reset(reset),
	.pTime(currTime)
);
 
 
lfsr8 RNG(
	.clk(clk),
	.q(random)
);

endmodule