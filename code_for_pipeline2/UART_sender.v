module UART_sender (reset,quick_clk,tx_data,tx_en,tx_status,uart_tx);
input quick_clk,tx_en,reset;
input [7:0] tx_data;
output uart_tx,tx_status;

reg uart_tx,tx_status;

reg [7:0] cnt;
/*
assign uart_tx = UART_TX;
assign tx_status = TX_STATUS;
*/
initial
begin
	cnt <= 0;
	tx_status <= 1;
	uart_tx <= 1;
end

always @(negedge reset or posedge quick_clk) 
begin
	if(~reset)
	begin
		cnt <= 0;
		tx_status <= 1;
		uart_tx <= 1;
	end
	else
	begin
	if(tx_en && tx_status)
	begin
		tx_status <= 0;
		uart_tx <= 0;
	end
	if(~tx_status)
	begin
		cnt <= cnt + 1;
	end
	if(cnt >= 8'd144)
	begin
		tx_status <= 1;
		cnt <= 0;
	end
	case (cnt)
		8'd16: begin uart_tx <= tx_data[0]; end // 8'd16:
		8'd32: begin uart_tx <= tx_data[1]; end
		8'd48: begin uart_tx <= tx_data[2]; end // 8'd48:
		8'd64: begin uart_tx <= tx_data[3]; end // 8'd64:
		8'd80: begin uart_tx <= tx_data[4]; end // 8'd80:
		8'd96: begin uart_tx <= tx_data[5]; end // 8'd96:
		8'd112: begin uart_tx <= tx_data[6]; end // 8'd112:
		8'd128: begin uart_tx <= tx_data[7]; end // 8'd128:
		8'd144: begin uart_tx <= 1; end // 8'd144:
	
		default : /* default */;
	endcase
	end
end


/*module UART_sender(reset, clk, TX_DATA, TX_EN, TX_STATUS, UART_TX);
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
*/
endmodule