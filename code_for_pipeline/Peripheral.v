module Peripheral (reset,sysclk,clk,rd,wr,addr,wdata,rdata,led,switch,digi,irqout,UART_RX,UART_TX,p1,p2);
input sysclk;
input UART_RX;
output UART_TX;


input reset,clk;
input rd,wr;
input [31:0] addr;
input [31:0] wdata;
output [31:0] rdata;

output [7:0] led;
reg [7:0] led;
input [7:0] switch;
output [11:0] digi;
reg [11:0] digi;
output irqout;

reg [31:0] TH,TL;
reg [2:0] TCON;
assign irqout = TCON[2];

reg [7:0] UART_TXD;
reg [7:0] UART_RXD;
reg [4:0] UART_CON;

output [3:0] p1,p2;
assign p1=UART_RXD[3:0];
assign p2=UART_TXD[3:0];

wire RX_STATUS;
wire TX_STATUS;
wire clk16;
reg TX_EN;
reg If_Read;

wire [7:0] RX_DATA;

UART_clock UC(sysclk,reset,clk16);
UART_receiver UR(reset,clk16, UART_RX, RX_DATA, RX_STATUS);
UART_sender US(reset, clk16, UART_TXD, TX_EN, TX_STATUS, UART_TX);


always @(posedge clk16)
	TX_EN <= (TX_STATUS && UART_CON[4] && UART_CON[0])?1:0;
 	
assign rdata = (~(rd && addr[30]))?0:
	(addr[5:2]==0)?TH:
	(addr[5:2]==1)?TL:
	(addr[5:2]==2)?{29'b0,TCON}:
	(addr[5:2]==4)?{24'b0,switch}:
	(addr[5:2]==5)?{20'b0,digi}:
	(addr[5:2]==7)?{24'b0, UART_RXD}:
	(addr[5:2]==8)?{27'b0, UART_CON}:32'b0;


always@(negedge reset or posedge clk) begin
	if(~reset) begin
		TH <= 32'b0;
		TL <= 32'b0;
		TCON <= 3'b0;
		
		UART_TXD <= 8'b0;
		UART_RXD <= 8'b0;
		UART_CON <= 5'b00011;
		If_Read <= 1'b0;
		
	end
	else begin
		if(TCON[0]) begin	//timer is enabled
			if(TL==32'hffffffff) begin
				TL <= TH;
				if(TCON[1]) TCON[2] <= 1'b1;		//irq is enabled
			end
			else 
			begin
				TL <= TL + 1;
				TCON[2] <=0;
			end
		end
		
		
		if (TX_EN == 1'b1)
			UART_CON[4] <= 1'b0;
		
		if(rd && addr == 32'h4000001C) //读数据之后清零
		begin
			If_Read <= 1'b1;
			//读过了
			UART_CON[3] <= 1'b0;
		end
		
		if (RX_STATUS == 1'b1 && UART_CON[1] == 1'b1) 
		//没有在读数据，而且收好了一个数据，而且接收中断使能，而且没读过
		begin
			UART_CON[3] <= 1'b1;
			//收好了数据
            UART_RXD <= RX_DATA;
            //把数据放过去
        end
		
        if (RX_STATUS == 1'b0)
            If_Read <= 1'b0;
			
        if(rd && addr == 32'h40000020)
              UART_CON[3:2] <= 2'b0;
			  
		if(wr) begin
			case(addr)
				32'h40000000: TH <= wdata;
				32'h40000004: TL <= wdata;
				32'h40000008: TCON <= wdata[2:0];		
				32'h4000000C: led <= wdata[7:0];			
				32'h40000014: digi <= wdata[11:0];
				
				32'h40000018:begin 
                    UART_TXD <= wdata[7:0];   
                    UART_CON[4] <= 1'b1;
                end
				32'h40000020: UART_CON <= wdata[4:0];
				
				default: ;
			endcase
		end
	end
end
endmodule

