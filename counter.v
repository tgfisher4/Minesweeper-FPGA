module counter(
	input CLOCK_50,
	input reset,
	output reg [9:0] pTime
	
	);




	reg [27:0] count1 = 0;
	reg [9:0] count2 = 0; 
	parameter oneSec = 28'd49_999_999 ;
 

	 always @(posedge CLOCK_50)begin
		pTime <= count2;
		 if (reset) begin
		 count1 <= 0;
		 count2 <=0;
		 end
		 
		 else if (count1 >= oneSec) begin
		 
		 if(count2 <= 999)begin
				count1 <= 0;
				count2 <= count2 + 1;
		 end
			
		 end
		 else begin
		 count1 <= count1 + 1;
	 end
	 end
endmodule 