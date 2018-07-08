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
				state<=2'b00;
				RX_STATUS<=1;
				RX_DATA<=data;
				num<=0;
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