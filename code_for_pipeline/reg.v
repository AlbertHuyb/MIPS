//有时间根据指令优化一下
module regIFID(clk, reset, PC_plus_4, Instruction, PC_plus_4_ID, Instruction_ID);
 	input clk;
 	input reset;
 	input [31:0] PC_plus_4;
 	input [31:0] Instruction;
 	output reg [31:0] PC_plus_4_ID;
 	output reg [31:0] Instruction_ID;
 	always @(negedge reset  or posedge clk)
	begin
		if (~reset) begin
			PC_plus_4_ID <= 32'h0;
			Instruction_ID <= 0;
		end
		else begin
			PC_plus_4_ID <= PC_plus_4;
			Instruction_ID <= Instruction;
		end
	end
 endmodule // regIFID

//可能还要存一个read_data1, read_data2暂时没想清楚
module regIDEX(clk, reset, PC_plus_4_ID, PCSrc, RegWrite, MemRead, MemWrite, MemtoReg, 
	ALUFun, Sign, Write_register, ALUSrc1, ALUSrc2, Instruction, 
	Databus1, Databus2, Lu_out, Branch_target, RegDst,
	PCSrc_EX, RegWrite_EX, MemRead_EX, MemWrite_EX, MemtoReg_EX, 
	ALUFun_EX, Sign_EX, PC_plus_4_EX, Write_register_EX,
	ALUSrc1_EX, ALUSrc2_EX, Instruction_EX,
	Databus1_EX, Databus2_EX, Lu_out_EX, Branch_target_EX, RegDst_EX);
	input clk;
 	input reset;
	input [31:0] PC_plus_4_ID, Instruction, Databus1, Databus2, Lu_out, Branch_target;
	input [2:0] PCSrc;
	input [1:0] RegDst;
	input RegWrite;
	input MemRead;
	input MemWrite;
	input MemtoReg;
	input ALUSrc1, ALUSrc2;
	input [5:0] ALUFun;
	input Sign;
	input [4:0] Write_register;
	output reg [2:0] PCSrc_EX;
	output reg RegWrite_EX;
	output reg MemRead_EX;
	output reg MemWrite_EX;
	output reg MemtoReg_EX;
	output reg [5:0] ALUFun_EX;
	output reg Sign_EX;
	output reg [31:0] PC_plus_4_EX,Instruction_EX, Databus1_EX,Databus2_EX, Lu_out_EX, Branch_target_EX;
	output reg [4:0] Write_register_EX;
	output reg [1:0] RegDst_EX;
	output reg ALUSrc1_EX, ALUSrc2_EX;

	always @(negedge reset or posedge clk)
	begin
		if (~reset)
		begin
			PC_plus_4_EX <= 32'h0;
			PCSrc_EX <= 3'b0;
			RegWrite_EX <= 0;
			MemRead_EX <= 0;
			MemWrite_EX <= 0;
			MemtoReg_EX <= 0;
			ALUFun_EX <= 0;
			Sign_EX <= 0;
			Write_register_EX <= 0;
			Lu_out_EX <= 0;
			Branch_target_EX <= 0;
			Instruction_EX <= 0;
			Databus1_EX <= 0;
			Databus2_EX <= 0;
			RegDst_EX <= 0;
			ALUSrc1_EX <= 0;
			ALUSrc2_EX <= 0;
		end
		else 
		begin
			PC_plus_4_EX <= PC_plus_4_ID;
			PCSrc_EX <= PCSrc;
			Instruction_EX <= Instruction;
			RegWrite_EX <= RegWrite;
			MemRead_EX <= MemRead;
			MemWrite_EX <= MemWrite;
			MemtoReg_EX <= MemtoReg;
			ALUFun_EX <= ALUFun;
			Sign_EX <= Sign;
			Lu_out_EX <= Lu_out;
			Branch_target_EX <= Branch_target;
			Databus1_EX <= Databus1;
			Databus2_EX <= Databus2;
			Write_register_EX <= Write_register;
			RegDst_EX <= RegDst;
			ALUSrc1_EX <= ALUSrc1;
			ALUSrc2_EX <= ALUSrc2;
			Lu_out_EX <= Lu_out;
		end
	end
endmodule // regIDEX

module regEXMEM(clk , reset, Instruction, outZ, Databus1, Databus2, PC_plus_4_EX, PCSrc_EX, RegWrite_EX, 
	MemRead_EX, MemWrite_EX, MemtoReg_EX, Write_register_EX,Branch_target, RegDst_EX,
	Instruction_MEM, outZ_MEM, Databus1_MEM, Databus2_MEM, PCSrc_MEM, RegWrite_MEM, MemRead_MEM,
	MemWrite_MEM, MemtoReg_MEM, PC_plus_4_MEM, Write_register_MEM,
	Branch_target_MEM, RegDst_MEM);
	input clk;
 	input reset;
	input [31:0] Instruction, outZ, Databus1, Databus2, Branch_target;
	input [31:0] PC_plus_4_EX;
	input [2:0] PCSrc_EX;
	input [1:0] RegDst_EX;
	input RegWrite_EX;
	input MemRead_EX;
	input MemWrite_EX;
	input MemtoReg_EX;
	input Write_register_EX;
	output reg [31:0] Instruction_MEM, outZ_MEM, Databus1_MEM,Databus2_MEM,Branch_target_MEM;
	output reg [2:0] PCSrc_MEM;
	output reg [1:0] RegDst_MEM;
	output reg RegWrite_MEM;
	output reg MemRead_MEM;
	output reg MemWrite_MEM;
	output reg MemtoReg_MEM;
	output reg [31:0] PC_plus_4_MEM;
	output reg [4:0] Write_register_MEM;
	always @(negedge reset or posedge clk)
	begin
		if (~reset)
		begin
			Branch_target_MEM <= 0;
			Instruction_MEM <= 0;
			outZ_MEM <= 0;
			Databus1_MEM <= 0;
			Databus2_MEM <= 0;
			PCSrc_MEM <= 0;
			RegWrite_MEM <= 0;
			MemRead_MEM <= 0;
			MemWrite_MEM <= 0;
			MemtoReg_MEM <= 0;
			PC_plus_4_MEM <= 0;
			Write_register_MEM <= 0;
			RegDst_MEM <= 0;
		end
		else 
		begin
			Branch_target_MEM <= Branch_target;
			Instruction_MEM <= Instruction;
			outZ_MEM <= outZ;
			Databus1_MEM <= Databus1;
			Databus2_MEM <= Databus2;
			PCSrc_MEM <= PCSrc_EX;
			RegWrite_MEM <= RegWrite_EX;
			MemRead_MEM <= MemRead_EX;
			MemWrite_MEM <= MemWrite_EX;
			MemtoReg_MEM <= MemtoReg_EX;
			PC_plus_4_MEM <= PC_plus_4_EX;
			Write_register_MEM <= Write_register_EX;
			RegDst_MEM <= RegDst_EX;
		end
	end
endmodule // regEXMEM

module regMEMWB(clk, reset, Instruction_MEM, PC_plus_4_MEM, DatabusB_MEM, RegWrite_MEM, MemtoReg_MEM, Write_register_MEM, 
	Read_Data, RegDst_MEM,
	DatabusB_WB, RegWrite_WB, MemtoReg_WB, PC_plus_4_WB, Write_register_WB,
	Read_Data_WB, RegDst_WB, Instruction_WB);
	input clk;
 	input reset;
	input [31:0] PC_plus_4_MEM, DatabusB_MEM,Read_Data, Instruction_MEM;
	input [1:0] RegDst_MEM;
	input RegWrite_MEM;
	input MemtoReg_MEM;
	input [4:0] Write_register_MEM;
	output reg RegWrite_WB;
	output reg MemtoReg_WB;
	output reg [31:0] PC_plus_4_WB, DatabusB_WB, Read_Data_WB, Instruction_WB;
	output reg [4:0] Write_register_WB;
	output reg [1:0] RegDst_WB;
	always @(negedge reset or posedge clk)
	begin
		if (~reset)
		begin
			Read_Data_WB <= 0;
			RegWrite_WB <= 0;
			MemtoReg_WB <= 0;
			PC_plus_4_WB <= 0;
			DatabusB_WB <= 0;
			Write_register_WB <= 0;
			RegDst_WB <= 0;
			Instruction_WB <= 0;
		end
		else 
		begin
			Read_Data_WB <= Read_Data;
			RegWrite_WB <= RegWrite_MEM;
			MemtoReg_WB <= MemtoReg_MEM;
			PC_plus_4_WB <= PC_plus_4_MEM;
			DatabusB_WB <= DatabusB_MEM;
			Write_register_WB <= Write_register_MEM;
			RegDst_WB <= RegDst_MEM;
			Instruction_WB <= Instruction_MEM;
		end
	end
endmodule // regMEMWB