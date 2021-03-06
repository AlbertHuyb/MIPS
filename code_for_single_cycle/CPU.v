module CPU(reset, sysclk,led, switch, UART_RX, UART_TX,digi_out1,digi_out2,digi_out3,digi_out4);
input reset, sysclk, UART_RX;
input [7:0] switch;
output [7:0] led;
output UART_TX;
output [6:0] digi_out1;	//0: CG,CF,CE,CD,CC,CB,CA
output [6:0] digi_out2;	//1: CG,CF,CE,CD,CC,CB,CA
output [6:0] digi_out3;	//2: CG,CF,CE,CD,CC,CB,CA
output [6:0] digi_out4;	//3: CG,CF,CE,CD,CC,CB,CA

wire clk;

Clkdiv divi(sysclk,clk);

reg [31:0] PC;
wire [31:0] PC_next;
wire [31:0] PC_plus;
wire [31:0] PC_plus_4;
assign PC_plus_4 = PC + 32'd4;
wire [31:0] Instruction;
wire [2:0] PCSrc;
wire RegWrite;
wire [1:0] RegDst;
wire MemRead;
wire MemWrite;
wire [1:0] MemtoReg;
wire ALUSrc1;
wire ALUSrc2;
wire ExtOp;
wire LuOp;
wire Sign;
wire [5:0] ALUOp;
wire IRQ;
wire [5:0]ALUFun;
wire [31:0] Databus1, Databus2, Databus3;
wire [4:0] Write_register;
assign Write_register = (RegDst == 2'b01)? Instruction[20:16]: 
							(RegDst == 2'b00)? Instruction[15:11]: 
							(RegDst == 2'b10) ? 5'b11111:26;
wire [31:0] Ext_out;
assign Ext_out = {ExtOp? {16{Instruction[15]}}: 16'h0000, Instruction[15:0]};
wire [31:0] LU_out;
assign LU_out = LuOp? {Instruction[15:0], 16'h0000}: Ext_out;
wire [31:0] ALU_inA;
wire [31:0] ALU_inB;
wire [31:0] outZ;

assign ALU_inA = ALUSrc1? {17'h00000, Instruction[10:6]}:Databus1;
assign ALU_inB = ALUSrc2? LU_out: Databus2;

wire [31:0] Read_data;
wire [31:0] Read_data1;
wire [31:0] Read_data2;						

assign Read_data = (outZ<256)? Read_data1:Read_data2;
assign Databus3 = (MemtoReg == 2'b00)? outZ: 
					  (MemtoReg == 2'b01)? Read_data: 
					  (MemtoReg == 2'b10)? PC_plus_4:PC;
	
wire [31:0] Jump_target;
assign Jump_target = {PC_plus_4[31:28], Instruction[25:0], 2'b00};
	
wire [31:0] Branch_target;

assign Branch_target = outZ[0]? PC_plus_4 + {LU_out[29:0], 2'b00}: PC_plus_4;
	
assign PC_next = (PCSrc == 3'b000)? PC_plus_4: 
					 (PCSrc == 3'b001)? Branch_target:
					 (PCSrc == 3'b010)? Jump_target:
					 (PCSrc == 3'b011)? Databus1: 
					 (PCSrc == 3'b100)? 32'h00000004: 
					 (PCSrc == 3'b101)? 32'h00000008:
					 32'h0;	

wire [11:0] digi;
Peripheral peripheral(.reset(reset),.sysclk(sysclk),.clk(clk),.rd(MemRead),.wr(MemWrite),
		.addr(outZ), .wdata(Databus2), .rdata(Read_data2), .led(led),.switch(switch),.digi(digi),
		.irqout(IRQ), .UART_RX(UART_RX), .UART_TX(UART_TX));

digitube_scan  ds(digi,digi_out1,digi_out2,digi_out3,digi_out4);		
							
always @(negedge reset or posedge clk)
begin
	if (~reset)
		PC <= 32'h0;
	else
		PC <= PC_next;
end

	InstructionMemory instruction_memory1(.Address(PC), .Instruction(Instruction));

	Control Control1(.OpCode(Instruction[31:26]), .Funct(Instruction[5:0]), .IRQ(IRQ), 
	.PCSrc(PCSrc), .RegWrite(RegWrite), .RegDst(RegDst), 
	.MemRead(MemRead), .MemWrite(MemWrite), .MemtoReg(MemtoReg), 
	.ALUSrc1(ALUSrc1), .ALUSrc2(ALUSrc2), .ExtOp(ExtOp), .LuOp(LuOp), .ALUFun(ALUFun), .Sign(Sign));


	RegisterFile register_file1(.reset(reset), .clk(clk), .RegWrite(RegWrite), 
		.Read_register1(Instruction[25:21]), .Read_register2(Instruction[20:16]), .Write_register(Write_register),
		.Write_data(Databus3), .Read_data1(Databus1), .Read_data2(Databus2));

	
	
	ALU alu1(.clk(clk), .inA(ALU_inA), .inB(ALU_inB), .Sign(Sign), .ALUFun(ALUFun), .outZ(outZ));
	

	DataMem data_memory1(.reset(reset), .clk(clk), .rd(MemRead), .wr(MemWrite), .addr(outZ), 
		.wdata(Databus2), .rdata(Read_data1));
	


endmodule