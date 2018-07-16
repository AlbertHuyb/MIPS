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

endmodule