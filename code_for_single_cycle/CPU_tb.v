`timescale 1ns/1ps

module CPU_tb;
reg sysclk,reset,UART_RX;
reg [7:0] switch;
wire [7:0]led;
wire [6:0] digi_out1;	//0: CG,CF,CE,CD,CC,CB,CA
wire [6:0] digi_out2;	//1: CG,CF,CE,CD,CC,CB,CA
wire [6:0] digi_out3;	//2: CG,CF,CE,CD,CC,CB,CA
wire [6:0] digi_out4;	//3: CG,CF,CE,CD,CC,CB,CA
wire UART_TX;

CPU cpu1(reset, sysclk, led, switch, UART_RX, UART_TX,digi_out1,digi_out2,digi_out3,digi_out4);

initial 
begin
	sysclk <= 0;
	reset <= 1;
	#2 reset<=0;
	#2 reset<=1;
	UART_RX <= 0;

end

always #1 sysclk <= ~sysclk;
always #20 UART_RX <= ~UART_RX;
endmodule // CPU_tb
