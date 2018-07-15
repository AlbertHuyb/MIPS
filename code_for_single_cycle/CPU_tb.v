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
	
	#20 UART_RX <= 0;
	#40 UART_RX <= 1;
	#60 UART_RX <= 0;
	#80 UART_RX <= 1;
	#100 UART_RX <= 0;
	#120 UART_RX <= 1;
	#140 UART_RX <= 1;
	#160 UART_RX <= 0;

	#220 UART_RX <= 0;
	#240 UART_RX <= 1;
	#260 UART_RX <= 0;
	#280 UART_RX <= 1;
	#300 UART_RX <= 0;
	#320 UART_RX <= 1;
	#340 UART_RX <= 1;
	#360 UART_RX <= 0;
end

always #1 sysclk <= ~sysclk;

endmodule // CPU_tb
