module covered_rom  (
 input clk,
 input [2:0] x,
 input [2:0] y,
 output reg [2:0] dout
 );
 
 
parameter IMAGE_FILE = "covered.mem";
   
   wire [5:0] addr  = 6*y + x;
   
   reg [2:0] mem [0:35];
   initial $readmemh(IMAGE_FILE, mem);

   always @(posedge clk)
         dout <= mem[addr];
   
endmodule

