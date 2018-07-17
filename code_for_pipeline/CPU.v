/*
datapath v0.0
每一个变量名的后面2位表示这个变量起作用的位置，或是产生这个变量的位置
如：ALUFun_ID,表示刚通过ID产生这个ALUFun; ALUFun_EX,表示经过段间寄存器输出得到的ALUFun
对应的流水线结构图见文件夹外的 pipeline_structure.JPG

instruction会一直往后传，是为forward中获取寄存器做准备

没怎么写注释，有问题需要修改请在语句后注明

todos:
1.实现寄存器的前半周期后半周期操作：加入一个时钟？
2.将forward加入进来，补充不完整的forward
3.将hazard加入进来，补充不完整的hazard
4.确认IRQ信号的正确性
*/

module CPU(reset, sysclk, led, switch, digi, UART_RX, UART_TX,LED1,LED2,LED3);
input reset, sysclk, UART_RX;
input [7:0] switch;
output [7:0] led;
output [11:0] digi;
output UART_TX;

wire clk;

Clkdiv divi(sysclk,clk);

output wire [7:0] LED1,LED2,LED3;
wire [3:0] bcd_in1,bcd_in2;

BCD L1(.din(bcd_in1),.dout(LED1));
BCD L2(.din(bcd_in2),.dout(LED2));
reg [31:0] PC;
wire [31:0] PC_ID,PC_WB;
wire [31:0] PC_next;
wire [31:0] PC_plus_ID;
wire [31:0] PC_plus_4_ID, PC_plus_4_EX, PC_plus_4_MEM, PC_plus_4_WB;

assign PC_plus_4_ID = PC_ID + 32'd4;
assign PC_WB = PC_plus_4_WB - 32'd4;

wire [31:0] Instruction_ID, Instruction_EX, Instruction_MEM, Instruction_WB;
wire [2:0] PCSrc_ID, PCSrc_EX, PCSrc_MEM;
wire RegWrite_ID, RegWrite_EX, RegWrite_MEM, RegWrite_WB;
wire [1:0] RegDst_ID, RegDst_EX, RegDst_MEM, RegDst_WB;
wire MemRead_ID, MemRead_EX, MemRead_MEM;
wire MemWrite_ID, MemWrite_EX,MemWrite_MEM;
wire [1:0] MemtoReg_ID, MemtoReg_EX, MemtoReg_MEM, MemtoReg_WB;
wire ALUSrc1_ID,ALUSrc1_EX;
wire ALUSrc2_ID,ALUSrc2_EX;

wire ExtOp_ID;
wire LuOp_ID;

wire Sign_ID,Sign_EX;
wire IRQ;
wire [5:0]ALUFun_ID, ALUFun_EX;
wire [31:0] Databus1_ID, Databus1_EX, Databus1_MEM;
wire [31:0] Databus2_ID, Databus2_EX, Databus2_MEM;
wire Databus3_WB;
wire [4:0] Write_register_WB;

assign Write_register_WB = 
						(RegDst_WB == 2'b01)? Instruction_WB[20:16]: 
						(RegDst_WB == 2'b00)? Instruction_WB[15:11]: 
						(RegDst_WB == 2'b10)? 5'b11111:
						5'd26;

wire [31:0] Ext_out_ID;

assign Ext_out_ID = {ExtOp_ID? {16{Instruction_ID[15]}}: 16'h0000, Instruction_ID[15:0]};

wire [31:0] LU_out_ID, LU_out_EX;

assign LU_out_ID = LuOp_ID? {Instruction_ID[15:0], 16'h0000}: Ext_out_ID;

wire [31:0] ALU_inA;
wire [31:0] ALU_inB;
wire [31:0] outZ_EX,outZ_MEM,outZ_WB;

assign ALU_inA = ALUSrc1_EX? {17'h00000, Instruction_EX[10:6]}:Databus1_EX;
assign ALU_inB = ALUSrc2_EX? LU_out_EX: Databus2_EX;

wire [31:0] Read_data_MEM,Read_data_WB;
wire [31:0] Read_data1_MEM;
wire [31:0] Read_data2_MEM;						

assign Read_data_MEM = (outZ_MEM < 256)? Read_data1_MEM:Read_data2_MEM;
assign Databus3_WB = 
				  (MemtoReg_WB == 2'b00)? outZ_WB: 
				  (MemtoReg_WB == 2'b01)? Read_data_WB: 
				  (MemtoReg_WB == 2'b10)? PC_plus_4_WB:
				  PC_WB;
	
wire [31:0] Jump_target_MEM;

assign Jump_target_MEM = {PC_plus_4_MEM[31:28], Instruction_MEM[25:0], 2'b00};
	
wire [31:0] Branch_target_ID,Branch_target_EX,Branch_target_MEM;

assign Branch_target_ID = PC_plus_4_ID + {Ext_out_ID[29:0], 2'b00};
	
assign PC_next =(PCSrc_MEM == 3'b000)? PC_plus_4_MEM: 
				(PCSrc_MEM == 3'b001)? Branch_target_MEM:
				(PCSrc_MEM == 3'b010)? Jump_target_MEM:
				(PCSrc_MEM == 3'b011)? Databus1_MEM: 
				(PCSrc_MEM == 3'b100)? 32'h80000004: 
				(PCSrc_MEM == 3'b101)? 32'h80000008:
				32'h0;	

Peripheral peripheral(.reset(reset),.sysclk(sysclk),.clk(clk),.rd(MemRead_MEM),.wr(MemWrite_MEM),
		.addr(outZ_MEM), .wdata(Databus2_MEM), .rdata(Read_data2_MEM), .led(led),.switch(switch),.digi(digi),
		.irqout(IRQ), .UART_RX(UART_RX), .UART_TX(UART_TX),.rcv_data(bcd_in1),.send_data(bcd_in2));
/*
Peripheral peripheral(.reset(reset),.sysclk(sysclk),.clk(clk),.rd(MemRead),.wr(MemWrite),
		.addr(outZ), .wdata(Databus2), .rdata(Read_data2), .led(led),.switch(switch),.digi(digi),
		.irqout(IRQ), .UART_RX(UART_RX), .UART_TX(UART_TX));
		*/
							
always @(negedge reset  or posedge clk)
	if (~reset)
		PC <= 32'h0;
	else
		PC <= PC_next;
//IF
InstructionMemory instruction_memory1(.Address(PC), .Instruction(Instruction));

regIFID IFID1(.clk(clk), .reset(reset), .PC_plus_4(PC_plus_4), .Instruction(Instruction),
	.PC_plus_4_ID(PC_plus_4_ID), .Instruction_ID(Instruction_ID));

//ID

Control Control1(.OpCode(Instruction_ID[31:26]), .Funct(Instruction_ID[5:0]), .IRQ(IRQ), 
	.PCSrc(PCSrc_ID), .RegWrite(RegWrite_ID), .RegDst(RegDst_ID), 
	.MemRead(MemRead_ID), .MemWrite(MemWrite_ID), .MemtoReg(MemtoReg_ID), 
	.ALUSrc1(ALUSrc1_ID), .ALUSrc2(ALUSrc2_ID), .ExtOp(ExtOp_ID), .LuOp(LuOp_ID), .ALUFun(ALUFun_ID), .Sign(Sign_ID));

RegisterFile register_file1(.reset(reset), .clk(clk), .RegWrite(RegWrite_WB), .Read_register1(Instruction_ID[25:21]), 
	.Read_register2(Instruction_ID[20:16]),.Write_register(Write_register_WB), .Write_data(Databus3_WB), 
	.Read_data1(Databus1_ID), .Read_data2(Databus2_ID));

regIDEX IDEX1(.clk(clk), .reset(reset), .Databus1(Databus1_ID), .Databus2(Databus2_ID),.PC_plus_4_ID(PC_plus_4_ID), .Instruction(Instruction_ID),
	.PCSrc(PCSrc_ID), .RegWrite(RegWrite_ID), .MemRead(MemRead_ID), .MemWrite(MemWrite_ID), .MemtoReg(MemtoReg_ID), 
	.ALUSrc1(ALUSrc1_ID), .ALUSrc2(ALUSrc2_ID),.ALUFun(ALUFun_ID), .Sign(Sign_ID), .Write_register(RegDst), 
	.Lu_out(LU_out_ID), .Branch_target(Branch_target_ID), .RegDst(RegDst_ID),
	.PCSrc_EX(PCSrc_EX), .RegWrite_EX(RegWrite_EX), .MemRead_EX(MemRead_EX), .MemWrite_EX(MemWrite_EX), 
	.MemtoReg_EX(MemtoReg_EX), .ALUFun_EX(ALUFun_EX), .Sign_EX(Sign_EX), .PC_plus_4_EX(PC_plus_4_EX), 
	.Write_register_EX(Write_register_EX),.ALUSrc1_EX(ALUSrc1_EX), .ALUSrc2_EX(ALUSrc2_EX), .Instruction_EX(Instruction_EX),
	.Databus1_EX(Databus1_EX), .Databus2_EX(Databus2_EX), .Lu_out_EX(LU_out_EX), .Branch_target_EX(Branch_target_EX),
	.RegDst_EX(RegDst_EX));

//EX
	
ALU alu1(.clk(clk), .inA(ALU_inA), .inB(ALU_inB), .Sign(Sign_EX), .ALUFun(ALUFun_EX), .outZ(outZ_EX));

regEXMEM EXMEM1(.clk(clk), .reset(reset), .Instruction(Instruction_EX),.outZ(outZ_EX), .Databus1(Databus1_EX), .Databus2(Databus2_EX), .PC_plus_4_EX(PC_plus_4_EX), .PCSrc_EX(PCSrc_EX), .RegWrite_EX(RegWrite_EX), 
	.MemRead_EX(MemRead_EX), .MemWrite_EX(MemWrite_EX), .MemtoReg_EX(MemtoReg_EX), .Write_register_EX(Write_register_EX),
	.Branch_target(Branch_target_EX), .RegDst_EX(RegDst_EX),
	.Instruction_MEM(Instruction_MEM), .outZ_MEM(outZ_MEM), .Databus1_MEM(Databus1_MEM), .Datebus2_MEM(Databus2_MEM), .PCSrc_MEM(PCSrc_MEM),.RegWrite_MEM(RegWrite_MEM), .MemRead_MEM(MemRead_MEM), 
	.MemWrite_MEM(MemWrite_MEM), .MemtoReg_MEM(MemtoReg_MEM), .PC_plus_4_MEM(PC_plus_4_MEM), .Write_register_MEM(Write_register_MEM),
	.Branch_target_MEM(Branch_target_MEM), .RegDst_MEM(RegDst_MEM));
//MEM
DataMem data_memory1(.reset(reset), .clk(clk), .rd(MemRead_MEM), .wr(MemWrite_MEM), .addr(outZ_MEM), 
		.wdata(Databus2_MEM), .rdata(Read_data1_MEM));

regMEMWB MEMWB1(.clk(clk), .reset(reset), .Instruction_MEM(Instruction_MEM), .PC_plus_4_MEM(PC_plus_4_MEM), .DatabusB_MEM(DatabusB_MEM), .RegWrite_MEM(RegWrite_MEM), .MemtoReg_MEM(MemtoReg_MEM), .Write_register_MEM(Write_register_MEM), 
	.Read_data(Read_data_MEM), .outZ(outZ_MEM), .RegDst_MEM(RegDst_MEM),
	.DatabusB_WB(DatabusB_WB), .RegWrite_WB(RegWrite_WB), .MemtoReg_WB(MemtoReg_WB), .PC_plus_4_WB(PC_plus_4_WB), .Write_register_WB(Write_register_WB),
	.Read_data_WB(Read_data_WB), .outZ_WB(outZ_WB), .RegDst_WB(RegDst_MEM), .Instruction_WB(Instruction_WB));
//WB	
endmodule