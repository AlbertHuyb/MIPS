`timescale 1ns/1ps

module DataMem (reset,clk,rd,wr,addr,wdata,rdata,num1,num2);
input reset,clk;
input rd,wr;
input [31:0] addr;	//Address Must be Word Aligned
output [31:0] rdata;
input [31:0] wdata;

output [7:0] num1;
output [7:0] num2;

parameter RAM_SIZE = 256;
reg [31:0] RAMDATA [RAM_SIZE-1:0];

assign num1 = RAMDATA[10][7:0];
assign num2 = RAMDATA[11][7:0];

assign rdata=(rd && (addr < RAM_SIZE))?RAMDATA[addr[31:2]]:32'b0;


always@(posedge clk) 
begin
	if(wr && (addr < RAM_SIZE)) RAMDATA[addr[31:2]]<=wdata;
end

endmodule
