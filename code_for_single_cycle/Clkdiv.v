module Clkdiv(sysclk,clk);
input sysclk;
output clk;
reg [8:0] count;

assign clk=sysclk;
endmodule