/*
module UART_receiver(reset,quick_clk,uart_rx,rx_data,rx_status);

input uart_rx,quick_clk,reset;
output [7:0] rx_data;
output rx_status;
reg [7:0] rx_data;
reg rx_status;
reg [8:0] cnt;
reg sample_enable;

initial
begin
	sample_enable <= 0;
	rx_status <= 0;
	cnt <= 0;
	rx_data <= 0;
end

always @(negedge reset or posedge quick_clk)
begin
if(~reset)
begin
	sample_enable <= 0;
	rx_status <= 0;
	cnt <= 0;
	rx_data <= 0;
end
else
begin
	if(~uart_rx)
	begin
		if(~sample_enable)
		begin
			sample_enable <= 1;
			cnt <= 0;
		end
	end
	if(cnt == 9'd164)
	begin
		sample_enable <= 0;
		cnt <= 0;
	end
	if(sample_enable)
	begin
		cnt <= cnt + 1;
	end
	case (cnt)
		9'd22 : begin rx_data[0] <= uart_rx; end
		9'd38 : begin rx_data[1] <= uart_rx; end 
		9'd54 : begin rx_data[2] <= uart_rx; end 
		9'd70 : begin rx_data[3] <= uart_rx; end // 8'd70 :
		9'd86 : begin rx_data[4] <= uart_rx; end // 8'd86 :
		9'd102 : begin rx_data[5] <= uart_rx; end // 8'd102 :
		9'd118 : begin rx_data[6] <= uart_rx; end // 8'd118 :
		9'd134 : begin rx_data[7] <= uart_rx; end // 8'd134 :
		9'd138 : begin rx_status <= 1; end // 8'd138 :
		9'd160 : begin	rx_status <= 0; end // 8'd139 :

		default : ;
	endcase
	end
end

endmodule // UART_Receiver
*/

module UART_receiver(reset,clk,UART_RX,RX_DATA,RX_STATUS);
input reset,clk,UART_RX;
output reg [7:0]RX_DATA;
output reg RX_STATUS;

reg [1:0] state;
reg [4:0] count;
reg [3:0] num;
reg [7:0] data;

initial
begin
RX_DATA <= 8'b0000_0000;
RX_STATUS <= 0;
state <=2'b00;
count<=0;
num<=0;
data<=0;
end

always @(posedge clk or negedge reset)
begin

if(~reset)
begin
	RX_DATA <= 8'b0000_0000;
	RX_STATUS <= 0;
	state <=2'b00;
	count<=0;
	num<=0;
	data<=0;
end

else
begin
	case(state)
	
	2'b00:
	begin
		RX_STATUS<=0;
		if(~UART_RX && ~RX_STATUS)
			state<=2'b01;
	end
	
	2'b01:
	begin
		if(count==23)
		begin
			state<=2'b10;
			count<=0;
			data[num]<=UART_RX;
			num=num+1;
		end
		
		else
		begin
			count=count+1;
		end
	end
	
	2'b10:
	begin
		if(count==16)
		begin
			count<=0;
			if(num==8)
			begin
				RX_STATUS<=1;
				RX_DATA<=data;
				num<=9;
			end
				
			else if(num==9)
			begin
				num<=0;
				state<=0;
			end
			
			else
			begin
				data[num]<=UART_RX;
				num=num+1;
			end
		end
		
		else
		begin
			count=count+1;
		end
	end
	
	default:
	begin
		RX_DATA <= 8'b0000_0000;
		RX_STATUS <= 0;
		state <=2'b00;
		count<=0;
		num<=0;
		data<=0;
	end
	
	endcase
end

end


endmodule