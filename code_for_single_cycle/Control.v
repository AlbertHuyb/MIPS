
module Control(OpCode, Funct, IRQ, 
	PCSrc, RegWrite, RegDst, 
	MemRead, MemWrite, MemtoReg, 
	ALUSrc1, ALUSrc2, ExtOp, LuOp, ALUFun, Sign);
	input [5:0] OpCode;
	input [5:0] Funct;
	input IRQ;
	output [2:0] PCSrc;
	output RegWrite;
	output [1:0] RegDst;
	output MemRead;
	output MemWrite;
	output [1:0] MemtoReg;
	output ALUSrc1;
	output ALUSrc2;
	output ExtOp;
	output LuOp;
	output Sign;
	output [5:0] ALUFun;
	
	// Your code below
	assign PCSrc = 
		IRQ ? 3'b100:
		((OpCode >= 6'h04 && OpCode <= 6'h07) || OpCode == 6'h01) ? 3'b001:
		(OpCode == 6'h02 || OpCode == 6'h03) ? 3'b010:
		(OpCode == 0 && (Funct == 6'h08 || Funct == 6'h09)) ? 3'b011:
		(OpCode >= 6'h08 && OpCode <= 6'h10) ? 3'b000:
		(OpCode == 6'h23 || OpCode == 6'h2b) ? 3'b000:
		(OpCode == 0 && (Funct >= 6'h20 && Funct <= 6'h27)) ? 3'b000:
		(OpCode == 0 && (Funct == 6'h00 || Funct == 6'h02 || Funct == 6'h03 || Funct == 6'h2a)) ? 3'b000:
		3'b101;

	assign RegWrite = 
		(OpCode == 6'h10 || OpCode == 6'h2b) ? 1'b0:
		(OpCode >= 6'h01 && OpCode <= 6'h07 && OpCode != 6'h03) ? 1'b0:
		(OpCode == 6'h00 && Funct == 6'h08) ? 1'b0:
		1'b1;

	assign RegDst = 
		(OpCode == 6'h00 )? 2'b00:
		(OpCode == 6'h03 )? 2'b10:
		(OpCode >= 6'h04 && OpCode <= 6'h10)? 2'b01:
		(OpCode == 6'h01 || OpCode == 6'h02 || OpCode == 6'h23 || OpCode == 6'h2b)? 2'b01:
		2'b11;

	assign MemRead = 
		(OpCode == 6'h23)? 1'b1:
		1'b0;

	assign MemWrite = 
		(OpCode == 6'h2b)? 1'b1:
		1'b0;

	assign MemtoReg = 
		(OpCode == 6'h23)? 2'b01:
		(OpCode >= 6'h08 && OpCode <= 6'h0f) ? 2'b00:
		(OpCode == 0 && (Funct >= 6'h20 && Funct <= 6'h27)) ? 2'b00:
		(OpCode == 0 && (Funct == 6'h00 || Funct == 6'h02 || Funct == 6'h03 || Funct == 6'h2a)) ? 2'h00:
		2'b10;

	assign ALUSrc1 = 
		(OpCode == 6'h00 && Funct <= 6'h03)? 1'b1:
		1'b0;

	assign ALUSrc2 = 
		(OpCode >= 6'h08 && OpCode != 6'h10)? 1'b1:
		1'b0;

	assign ExtOp = 
		(OpCode >= 6'h0c && OpCode <= 6'h0e)? 1'b0:
		1'b1;

	assign LuOp =
		(OpCode == 6'h0f)? 1'b1:
		1'b0;

	assign Sign = 
		(OpCode == 6'h10 || OpCode == 6'h09 || OpCode == 6'h0b) ? 1'b0:
		(OpCode == 6'h00 && Funct <= 6'h01) ? 1'b0:
		1'b1;
	// Your code above
	
	assign ALUFun[5:0] = 
		(OpCode == 6'h00 && (Funct == 6'h22 || Funct == 6'h23))? 6'b000001:
		(OpCode == 6'h00 && Funct == 6'h24)? 6'b011000:
		(OpCode == 6'h0d || (OpCode == 6'h00 && Funct == 6'h25))? 6'b011110: 
		(OpCode == 6'h0e || (OpCode == 6'h00 && Funct == 6'h26))? 6'b010110:
		(OpCode == 6'h00 && Funct == 6'h27)? 6'b010001:
		(OpCode == 6'h0c)? 6'b011000:
		(OpCode == 6'h00 && Funct == 6'h00)? 6'h100000:
		(OpCode == 6'h00 && Funct == 6'h02)? 6'h100001:
		(OpCode == 6'h00 && Funct == 6'h03)? 6'h100011:
		(OpCode == 6'h00 && Funct == 6'h2a)? 6'h110101:
		(OpCode == 6'h0a || OpCode == 6'h0b)? 6'h110101:
		(OpCode == 6'h04)? 6'h110011:
		(OpCode == 6'h05)? 6'h110001:
		(OpCode == 6'h06)? 6'h111101:
		(OpCode == 6'h07)? 6'h111111:
		(OpCode == 6'h01)? 6'h111011:
		6'b000000;
	
endmodule