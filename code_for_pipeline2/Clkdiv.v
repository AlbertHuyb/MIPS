module Clkdiv(sysclk,clk);
input sysclk;
output reg clk;
reg [9:0] count;

initial 
begin
	clk <=0;
	count <=0;
end
/*
always @(*)
	clk<=sysclk;
*/


always @(posedge sysclk)
begin


	if(count==10'b0000010111)
	begin
		count<=0;
		clk<=~clk;
	end
	else
	begin
		count<=count+1;
	end
end

endmodule