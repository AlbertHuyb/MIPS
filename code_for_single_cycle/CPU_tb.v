`timescale 1ns/1ps

module CPU_tb;
reg sysclk,reset;

CPU cpu1(.clk(sysclk),.reset(reset));

initial 
begin
	sysclk <= 0;
	reset <= 1;
end

always #10 sysclk <= ~sysclk;

endmodule // CPU_tb
