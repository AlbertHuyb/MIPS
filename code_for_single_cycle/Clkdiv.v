module Clkdiv(sysclk,clk);
input sysclk;
output reg clk;
reg [8:0] count;

initial
	clk <= 0;
//assign clk=sysclk;
always @(posedge  sysclk)
	clk <= ~clk;

endmodule