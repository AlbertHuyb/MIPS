module UART_clock(sysclk,reset,UART_clk);
input sysclk,reset;
output reg UART_clk;
reg[8:0] counter = 0;

initial 
begin
UART_clk<=0;
end

always @(posedge sysclk or negedge reset)
begin
	if(~reset)
	begin
		counter <= 0;
		UART_clk <=0;
	end
	else if(counter == 162)
	begin
		counter <= 0;
		UART_clk =~ UART_clk;
	end
	else
		counter <= counter + 1;
end

endmodule
