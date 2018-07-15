module Clkdiv(sysclk,clk);
input sysclk;
//output reg clk;
output wire clk;

assign clk = sysclk;
//reg [8:0] count;

/*
initial 
begin
	clk <=0;
	count <=0;
end

always @(posedge sysclk)
begin

	if(count==9'b111111111)
	begin
		count<=0;
		clk<=~clk;
	end
	else
	begin
		count<=count+1;
	end
end
*/
endmodule