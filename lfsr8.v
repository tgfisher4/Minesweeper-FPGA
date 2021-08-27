module lfsr8 (
 input clk,
 output reg [7:0] q);

 initial q = 8'd1;

 always @(posedge clk)
 q <= {q[6:0], q[1]^q[2]^q[3]^q[7]};

endmodule