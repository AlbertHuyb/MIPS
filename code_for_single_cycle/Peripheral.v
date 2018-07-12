`timescale 1ns/1ps

module Peripheral (reset,sysclk,clk,rd,wr,addr,wdata,rdata,led,switch,digi,irqout,UART_RX,UART_TX);
input sysclk;
input UART_RX;
output reg UART_TX;


input reset,clk;
input rd,wr;
input [31:0] addr;
input [31:0] wdata;
output [31:0] rdata;
reg [31:0] rdata;

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

always@(*) begin
	if(rd) begin
		case(addr)
			32'h40000000: rdata <= TH;			
			32'h40000004: rdata <= TL;			
			32'h40000008: rdata <= {29'b0,TCON};				
			32'h4000000C: rdata <= {24'b0,led};			
			32'h40000010: rdata <= {24'b0,switch};
			32'h40000014: rdata <= {20'b0,digi};
			
			32'h4000001C: rdata <= {24'b0, UART_RXD};
			32'h40000020: rdata <= {27'b0, UART_CON};
			
			default: rdata <= 32'b0;
		endcase
	end
	else
		rdata <= 32'b0;
end

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
			else TL <= TL + 1;
		end
		
		
		if (TX_EN == 1'b1)
			UART_CON[4] <= 1'b0;
		
		if(rd && addr == 32'h4000001C) 
		begin
			If_Read <= 1'b1;
			UART_CON[3] <= 1'b0;
		end
		
		if (~rd && RX_STATUS == 1'b1 && UART_CON[1] == 1'b1 && If_Read == 1'b0) 
		begin
			UART_CON[3] <= 1'b1;
            UART_RXD <= RX_DATA;
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
				32'h40000020:UART_CON <= wdata[4:0];
				
				default: ;
			endcase
		end
	end
end
endmodule

