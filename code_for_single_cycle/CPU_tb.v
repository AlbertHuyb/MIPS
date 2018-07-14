`timescale 1ns/1ps

module CPU_tb;
reg sysclk,reset,UART_RX;
reg [7:0] switch;
wire [7:0]led;
wire [11:0]digi;
wire UART_TX;

CPU cpu1(reset, sysclk, led, switch, digi, UART_RX, UART_TX);

initial 
begin
	sysclk <= 0;
	reset <= 1;
	#2 reset<=0;
	#2 reset<=1;
end

always #1 sysclk <= ~sysclk;

endmodule // CPU_tb
