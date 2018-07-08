module UART_sender(reset, clk, TX_DATA, TX_EN, TX_STATUS, UART_TX);
input reset,clk,TX_EN;
input [7:0] TX_DATA;
output reg UART_TX,TX_STATUS;

reg [8:0] data;
reg state;
reg [4:0] count;
reg [3:0] num;

initial
begin
UART_TX<=1;
TX_STATUS<=1;
data<=0;
state<=0;
count<=0;
num<=0;
end

always @(posedge clk or negedge reset)
begin

if(~reset)
begin
	UART_TX<=1;
	TX_STATUS<=1;
	data<=0;
	state<=0;
	count<=0;
	num<=0;
end

else
begin
	if(~state)
	begin
		if(TX_EN)
		begin
			state<=1;
			TX_STATUS<=0;
			data[8:1]<=TX_DATA;
		end
		
		else
		begin
			UART_TX<=1;
		end
	end
	
	else
	begin
		if(count==16)
		begin
			count<=0;
			if(num==9)
			begin
				state<=0;
				TX_STATUS<=1;
				num<=0;
				UART_TX<=1;
			end
			else
			begin
				UART_TX<=data[num];
				num=num+1;
			end
		end
		
		else
		begin
			count=count+1;
		end
			
	end
end


end

endmodule