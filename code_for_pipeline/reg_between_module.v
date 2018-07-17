/*
Write your code for reg between module here.
And add what you need.
Good Luck!
*/

module IFIDreg(clk, reset, PC_plus_4, Instruction, PC_plus_4_1, Instruction_1);
 	input reset,clk;
 	input [31:0] PC_plus_4;
 	input [31:0] Instruction;
 	output [31:0] PC_plus_4_1;
 	output [31:0] Instruction_1;
 	always @(negedge reset  or posedge clk)
	begin
		if (~reset)
		begin
			PC_plus_4_1 <= 32'h0;
			Instruction_1 <= 0;
		end
		else 
		begin
			PC_plus_4_1 <= PC_plus_4;
			Instruction_1 <= Instruction;
		end
	end
endmodule // IFIDreg

module IDEXreg(PC_plus_4_1, PCSrc, RegWrite, MemRead, MemWrite, MemtoReg, 
	ALUFun, Sign, inA, inB, Write_register, 
	PCSrc_1, RegWrite_1, MemRead_1, MemWrite_1, MemtoReg_1, 
	ALUFun_1, Sign_1, PC_plus_4_2, inA_1, inB_1, Write_register_1);
	input [31:0] PC_plus_4_1;
	input [2:0] PCSrc;
	input RegWrite;
	input MemRead;
	input MemWrite;
	input MemtoReg;
	input [5:0] ALUFun;
	input Sign;
	input [31:0] inA;
	input [31:0] inB;
	input [4:0] Write_register;
	output [2:0] PCSrc_1;
	output RegWrite_1;
	output MemRead_1;
	output MemWrite_1;
	output MemtoReg_1;
	output [5:0] ALUFun_1;
	output Sign_1;
	output [31:0] PC_plus_4_2;
	output [31:0] inA_1;
	output [31:0] inB_1;
	output [4:0] Write_register_1;
	always @(negedge reset or posedge clk)
	begin
		if (~reset)
			PC_plus_4_2 <= 32'h0;
			PCSrc_1 <= 3'b0;
			RegWrite_1 <= 0;
			MemRead_1 <= 0;
			MemWrite_1 <= 0;
			MemtoReg_1 <= 0;
			ALUFun_1 <= 0;
			Sign_1 <= 0;
			inA_1 <= 0;
			inB_1 <= 0;
			Write_register_1 <= 0;
		else begin
			PC_plus_4_1 <= PC_plus_4;
			Instruction_1 <= Instruction;
			RegWrite_1 <= RegWrite;
			MemRead_1 <= MemRead;
			MemWrite_1 <= MemWrite;
			MemtoReg_1 <= MemtoReg;
			ALUFun_1 <= ALUFun;
			Sign_1 <= Sign;
			inA_1 <= inA;
			inB_1 <= inB;
			Write_register_1 <= Write_register;
		end
	end
endmodule // IDEXreg

module EXMEMreg(outZ, DatabusB, PC_plus_4_2, PCSrc_1, RegWrite_1, MemRead_1, MemWrite_1, MemtoReg_1, Write_register_1,
	outZ_1, DatebusB_1, PCSrc_2, RegWrite_2, MemRead_2, MemWrite_2, MemtoReg_2, PC_plus_4_3, Write_register_2);
	input [31:0] outZ, DatebusB;
	input [31:0] PC_plus_4_2;
	input [2:0] PCSrc_1;
	input RegWrite_1;
	input MemRead_1;
	input MemWrite_1;
	input MemtoReg_1;
	input Write_register_1;
	output [31:0] outZ_1, DatabusB_2;
	output [2:0] PCSrc_2;
	output RegWrite_2;
	output MemRead_2;
	output MemWrite_2;
	output MemtoReg_2;
	output [31:0] PC_plus_4_3;
	output [4:0] Write_register_2;
	always @(negedge reset or posedge clk)
	begin
		if (~reset)
			outZ_1 <= 0;
			DatebusB_1 <= 0;
			PCSrc_2 <= 0;
			RegWrite_2 <= 0;
			MemRead_2 <= 0;
			MemWrite_2 <= 0;
			MemtoReg_2 <= 0;
			PC_plus_4_3 <= 0;
			Write_register_2 <= 0;
		else begin
			outZ_1 <= outZ;
			DatabusB_1 <= DatabusB;
			PCSrc_2 <= PCSrc_1;
			RegWrite_2 <= RegWrite_1;
			MemRead_2 <= MemRead_1;
			MemWrite_2 <= MemWrite_1;
			MemtoReg_2 <= MemtoReg_1;
			PC_plus_4_3 <= PC_plus_4_2;
			Write_register_2 <= Write_register_1;
		end
	end
endmodule // EXMEMreg

module MEMWBreg(PC_plus_4_3, DatabusB_1, RegWrite_2, MemtoReg_2, Write_register_2, 
	DatabusB_2, RegWrite_3, MemtoReg_3, PC_plus_4_4, Write_register_3);
	input [31:0] PC_plus_4_3, DatabusB_1;
	input RegWrite_2;
	input MemtoReg_2;
	input [4:0] Write_register_2;
	output RegWrite_3;
	output MemtoReg_3;
	output [31:0] PC_plus_4_4, DatabusB_2;
	output [4:0] Write_register_3;
	always @(negedge reset or posedge clk)
	begin
		if (~reset)
			RegWrite_3 <= 0;
			MemtoReg_3 <= 0;
			PC_plus_4_4 <= 0;
			DatabusB_2 <= 0;
			Write_register_3 <= 0;
		else begin
			RegWrite_3 <= RegWrite_2;
			MemtoReg_3 <= MemtoReg_2;
			PC_plus_4_4 <= PC_plus_4_3;
			DatabusB_2 <= DatabusB_1;
			Write_register_3 <= Write_register_2;
		end
	end
endmodule // MEMWBreg
