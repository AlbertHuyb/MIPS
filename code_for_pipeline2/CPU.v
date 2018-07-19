/*
datapath v0.0
姣忎竴涓彉閲忓悕鐨勫悗闈浣嶈〃绀鸿繖涓彉閲忚捣浣滅敤鐨勪綅缃紝鎴栨槸浜х敓杩欎釜鍙橀噺鐨勪綅缃
濡傦細ALUFun_ID,琛ㄧず鍒氶€氳繃ID浜х敓杩欎釜ALUFun; ALUFun_EX,琛ㄧず缁忚繃娈甸棿瀵勫瓨鍣ㄨ緭鍑哄緱鍒扮殑ALUFun
瀵瑰簲鐨勬祦姘寸嚎缁撴瀯鍥捐鏂囦欢澶瑰鐨pipeline_structure.JPG

instruction浼氫竴鐩村線鍚庝紶锛屾槸涓篺orward涓幏鍙栧瘎瀛樺櫒鍋氬噯澶

娌℃€庝箞鍐欐敞閲婏紝鏈夐棶棰橀渶瑕佷慨鏀硅鍦ㄨ鍙ュ悗娉ㄦ槑

todos:
1.瀹炵幇瀵勫瓨鍣ㄧ殑鍓嶅崐鍛ㄦ湡鍚庡崐鍛ㄦ湡鎿嶄綔锛氬姞鍏ヤ竴涓椂閽燂紵
2.灏唂orward鍔犲叆杩涙潵锛岃ˉ鍏呬笉瀹屾暣鐨刦orward
3.灏唄azard鍔犲叆杩涙潵锛岃ˉ鍏呬笉瀹屾暣鐨刪azard
4.纭IRQ淇″彿鐨勬纭€
*/

module CPU(reset, sysclk,led, switch, UART_RX, UART_TX,digi_out1,digi_out2,digi_out3,digi_out4,LED1,LED2,LED3,LED4,show,txen,status,txstatus,tcon,another,rxstatus/*,LED22*/);
input reset, sysclk, UART_RX;
input [7:0] switch;
output [7:0] led;
output [2:0] tcon;
output [3:0] status;

//output [6:0] LED22;
output UART_TX;
output [6:0] digi_out1;	//0: CG,CF,CE,CD,CC,CB,CA
output [6:0] digi_out2;	//1: CG,CF,CE,CD,CC,CB,CA
output [6:0] digi_out3;	//2: CG,CF,CE,CD,CC,CB,CA
output [6:0] digi_out4; //3: CG,CF,CE,CD,CC,CB,CA
output [6:0] LED1;
output [6:0] LED2;
output [6:0] LED3;
output [6:0] LED4;
output show,txen,txstatus,another,rxstatus;

wire [7:0] num1,num2,num3,num4;

BCD test(.din(num1[7:4]),.dout(LED1));
BCD test1(.din(num1[3:0]),.dout(LED2));
BCD test2(.din(num2[7:4]),.dout(LED3));
BCD test3(.din(num2[3:0]),.dout(LED4));

/*
assign LED2 = digi_out2;
assign LED1 = digi_out1;
assign LED3 = digi_out3;
assign LED4 = digi_out4;
*/
wire clk;

Clkdiv divi(sysclk,clk);


reg [31:0] PC_ID,PC_WB;
wire [31:0] PC_plus_ID;
wire [31:0] PC_plus_4_ID, PC_plus_4_EX, PC_plus_4_MEM, PC_plus_4_WB;



wire [31:0] Instruction,Instruction_ID, Instruction_EX, Instruction_MEM,Instruction_WB;
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
wire [31:0] Databus3_WB;
wire [4:0] Write_register_EX;
wire [4:0] Write_register_MEM;
wire [4:0] Write_register_WB;

assign Write_register_EX = 
						(RegDst_EX == 2'b01)? Instruction_EX[20:16]: 
						(RegDst_EX == 2'b00)? Instruction_EX[15:11]: 
						(RegDst_EX == 2'b10)? 5'b11111:
						5'd26;

assign Write_register_MEM = 
						(RegDst_MEM == 2'b01)? Instruction_MEM[20:16]: 
						(RegDst_MEM == 2'b00)? Instruction_MEM[15:11]: 
						(RegDst_MEM == 2'b10)? 5'b11111:
						5'd26;

assign Write_register_WB = IRQ? 5'd26:
						(RegDst_WB == 2'b01)? Instruction_WB[20:16]: 
						(RegDst_WB == 2'b00)? Instruction_WB[15:11]: 
						(RegDst_WB == 2'b10)? 5'b11111:
						0;

wire [31:0] Ext_out_ID;

assign Ext_out_ID = {ExtOp_ID? {16{Instruction_ID[15]}}: 16'h0000, Instruction_ID[15:0]};

wire [31:0] LU_out_ID, LU_out_EX;

assign LU_out_ID = LuOp_ID? {Instruction_ID[15:0], 16'h0000}: Ext_out_ID;

wire [31:0] ALU_inA;
wire [31:0] ALU_inB;
wire [31:0] outZ_EX,outZ_MEM,outZ_WB;
wire [1:0] alusrc1,alusrc2;
wire [31:0] Databus22_EX;

assign Databus22_EX = 
			     (alusrc2==2'b00)? Databus2_EX:
				 (alusrc2==2'b10)? outZ_MEM: 
				 outZ_WB;
				 
assign ALU_inA = ALUSrc1_EX? {17'h00000, Instruction_EX[10:6]}:
				 (alusrc1==2'b00)? Databus1_EX:
				 (alusrc1==2'b10)? outZ_MEM: outZ_WB;

assign ALU_inB = ALUSrc2_EX? LU_out_EX: 
				 Databus22_EX;

wire [31:0] Read_data_MEM,Read_data_WB;
wire [31:0] Read_data1_MEM;
wire [31:0] Read_data2_MEM;						

reg [31:0] PC;

assign Read_data_MEM = (outZ_MEM < 256)? Read_data1_MEM:Read_data2_MEM;
	
wire [31:0] Jump_target_MEM;

assign Jump_target_MEM = {PC_plus_4_MEM[31:28], Instruction_MEM[25:0], 2'b00};
	
wire [31:0] Branch_target_ID,Branch_target_EX,Branch_target_MEM;

assign Branch_target_ID = PC_plus_4_ID + {Ext_out_ID[29:0], 2'b00};

wire pcsrc1,pcsrc2;

wire [31:0] PC_next;
wire [31:0] PC_plus;
wire [31:0] PC_plus_4;
wire [3:0] pcsrc;
assign PC_plus_4 = PC + 32'd4;
wire [31:0] compare1,compare2;
assign compare1 = (pcsrc1 == 1)? outZ_MEM:Databus1_ID;
assign compare2 = (pcsrc2 == 1)? outZ_MEM:Databus2_ID;
assign compare = (compare1 == compare2)? 1:0;

wire special;

assign Databus3_WB = 
				  (IRQ && special)? PC:
				  (IRQ && compare && PCSrc_EX == 3'b001)? PC:
				  (IRQ && PCSrc_EX == 3'b010)? PC:
				  IRQ? PC-4:			  
				  (MemtoReg_WB == 2'b00)? outZ_WB: 
				  (MemtoReg_WB == 2'b01)? Read_data_WB: 
				  (MemtoReg_WB == 2'b10)? PC_plus_4_WB:
				  0;
				  
wire [31:0] Jump_target;
assign Jump_target = {PC_plus_4[31:28], Instruction_ID[25:0], 2'b00};
wire [31:0] Branch_target;
assign Branch_target =(compare==1)? PC + {LU_out_ID[29:0], 2'b00}: PC;
wire PCWrite;
wire IFFlush,EXFlush;

assign PC_next =(PCSrc_ID == 3'b100)? 32'h00000004: 
				(PCSrc_ID == 3'b101)? 32'h00000008:
				(EXFlush)? PC - 4:
				(PCSrc_ID == 3'b001)? Branch_target:
				(PCSrc_ID == 3'b010)? Jump_target:
				(PCSrc_ID == 3'b011)? Databus1_ID: //鏀癸紝涓簉a瀵勫瓨鍣ㄦ湇鍔
				(IFFlush)? PC:				
				(PCSrc_ID == 3'b000)? PC_plus_4: 			
				32'h0;	


wire [11:0] digi;
Peripheral peripheral(.reset(reset),.sysclk(sysclk),.clk(clk),.rd(MemRead_MEM),.wr(MemWrite_MEM),
		.addr(outZ_MEM), .wdata(Databus2_MEM), .rdata(Read_data2_MEM), .led(led),.switch(switch),.digi(digi),
		.irqout(IRQ), .UART_RX(UART_RX), .UART_TX(UART_TX),.txen(txen),.another(another),.txstatus(txstatus),.tcon(tcon),.status(status));
digitube_scan ds(digi,digi_out1,digi_out2,digi_out3,digi_out4); 

							
always @(negedge reset  or posedge clk)
	if (~reset)
		PC <= 32'h0;
	else
		PC <= PC_next;
//IF
InstructionMemory instruction_memory1(.Address(PC), .Instruction(Instruction));

regIFID IFID1(.clk(clk), .reset(reset), .IFFlush(IFFlush), .PC_plus_4(PC_plus_4), .Instruction(Instruction),
	.PC_plus_4_ID(PC_plus_4_ID), .Instruction_ID(Instruction_ID));
	

//ID

Control Control1(.OpCode(Instruction_ID[31:26]), .Funct(Instruction_ID[5:0]), .IRQ(IRQ), 
	.PCSrc(PCSrc_ID), .RegWrite(RegWrite_ID), .RegDst(RegDst_ID), 
	.MemRead(MemRead_ID), .MemWrite(MemWrite_ID), .MemtoReg(MemtoReg_ID), 
	.ALUSrc1(ALUSrc1_ID), .ALUSrc2(ALUSrc2_ID), .ExtOp(ExtOp_ID), .LuOp(LuOp_ID), .ALUFun(ALUFun_ID), .Sign(Sign_ID));

wire regwrite22;
assign regwrite22 = RegWrite_WB || IRQ;
	
RegisterFile register(.reset(reset), .clk(clk), .RegWrite(regwrite22), .Read_register1(Instruction_ID[25:21]), 
	.Read_register2(Instruction_ID[20:16]), .Write_register(Write_register_WB), .Write_data(Databus3_WB), 
	.Read_data1(Databus1_ID), .Read_data2(Databus2_ID),.num1(num1),.num2(num2));


regIDEX IDEX1(.reset(reset),.clk(clk),.Databus1(Databus1_ID), .Databus2(Databus2_ID),.PC_plus_4_ID(PC_plus_4_ID), .Instruction(Instruction_ID),
	.PCSrc(PCSrc_ID), .RegWrite(RegWrite_ID), .MemRead(MemRead_ID), .MemWrite(MemWrite_ID), .MemtoReg(MemtoReg_ID), 
	.ALUSrc1(ALUSrc1_ID), .ALUSrc2(ALUSrc2_ID),.ALUFun(ALUFun_ID), .Sign(Sign_ID), .EXFlush(EXFlush),
	.Lu_out(LU_out_ID), .Branch_target(Branch_target_ID), .RegDst(RegDst_ID),
	.PCSrc_EX(PCSrc_EX), .RegWrite_EX(RegWrite_EX), .MemRead_EX(MemRead_EX), .MemWrite_EX(MemWrite_EX), 
	.MemtoReg_EX(MemtoReg_EX), .ALUFun_EX(ALUFun_EX), .Sign_EX(Sign_EX), .PC_plus_4_EX(PC_plus_4_EX), 
	.ALUSrc1_EX(ALUSrc1_EX), .ALUSrc2_EX(ALUSrc2_EX), .Instruction_EX(Instruction_EX),
	.Databus1_EX(Databus1_EX), .Databus2_EX(Databus2_EX), .Lu_out_EX(LU_out_EX), .Branch_target_EX(Branch_target_EX),
	.RegDst_EX(RegDst_EX));
	
//EX
	
ALU alu1(.clk(clk), .inA(ALU_inA), .inB(ALU_inB), .Sign(Sign_EX), .ALUFun(ALUFun_EX), .outZ(outZ_EX));

regEXMEM EXMEM1(.reset(reset),.clk(clk),.Instruction(Instruction_EX),.outZ(outZ_EX), .Databus1(Databus1_EX), .Databus2(Databus22_EX), .PC_plus_4_EX(PC_plus_4_EX), .PCSrc_EX(PCSrc_EX), .RegWrite_EX(RegWrite_EX), 
	.MemRead_EX(MemRead_EX), .MemWrite_EX(MemWrite_EX), .MemtoReg_EX(MemtoReg_EX), .Write_register_EX(RegDst_EX),
	.Branch_target(Branch_target_EX),
	.Instruction_MEM(Instruction_MEM), .outZ_MEM(outZ_MEM), .Databus1_MEM(Databus1_MEM), .Databus2_MEM(Databus2_MEM), .PCSrc_MEM(PCSrc_MEM),.RegWrite_MEM(RegWrite_MEM), .MemRead_MEM(MemRead_MEM), 
	.MemWrite_MEM(MemWrite_MEM), .MemtoReg_MEM(MemtoReg_MEM), .PC_plus_4_MEM(PC_plus_4_MEM), .Write_register_MEM(RegDst_MEM),
	.Branch_target_MEM(Branch_target_MEM));
//MEM
DataMem data_memory1(.reset(reset), .clk(clk), .rd(MemRead_MEM), .wr(MemWrite_MEM), .addr(outZ_MEM), 
		.wdata(Databus2_MEM), .rdata(Read_data1_MEM),.num1(num3),.num2(num4));

regMEMWB MEMWB1(.reset(reset),.clk(clk),.PC_plus_4_MEM(PC_plus_4_MEM), .RegWrite_MEM(RegWrite_MEM), .MemtoReg_MEM(MemtoReg_MEM), .Write_register_MEM(RegDst_MEM), 
	.Read_Data(Read_data_MEM), .outZ(outZ_MEM),.Instruction_MEM(Instruction_MEM), .IRQ(IRQ),
	.RegWrite_WB(RegWrite_WB), .MemtoReg_WB(MemtoReg_WB), .PC_plus_4_WB(PC_plus_4_WB), .Write_register_WB(RegDst_WB),
	.Read_Data_WB(Read_data_WB), .outZ_WB(outZ_WB),.Instruction_WB(Instruction_WB));
	
//Forward
Forward Forward1(.IDEX_rs(Instruction_EX[25:21]),.IDEX_rt(Instruction_EX[20:16]),.IDEX_alusrc2(ALUSrc2_EX),.IDEX_alusrc1(ALUSrc1_EX),
	.EXMEM_regwr(RegWrite_MEM),.MEMWB_regwr(RegWrite_WB),.EXMEM_rd(Write_register_MEM),.EXMEM_rt(),.MEMWB_rd(Write_register_WB),
	.EXMEM_memwr(MemWrite_MEM),.IDEX_memwr(MemWrite_EX),.EXMEM_aluctrl2(),.IFID_rs(Instruction_ID[25:21]),.IFID_rt(Instruction_ID[20:16]),
	.IDEX_memrd(MemRead_EX),
	.ALUctrl1(alusrc1),.ALUctrl2(alusrc2),.MemWritectrl(),.IFID_pcsrc(PCSrc_ID),
	.CMPctrl1(pcsrc1),.CMPctrl2(pcsrc2));

wire Ifjump;
assign Ifjump = (Instruction_ID[31:26]==6'b000010) || (Instruction_ID[31:26] == 6'b000011) || 
				(Instruction_ID[31:26] == 6'b0 && (Instruction_ID[5:0] == 6'b001000 || Instruction_ID[5:0] == 6'b001001));

Hazard Hd1(.IDEX_memread(MemRead_EX),.IFID_memwr(MemWrite_ID),.IDEX_jump(Ifjump), .IRQ(IRQ), .IDEX_regwr(RegWrite_EX),
		   .IDEX_rt(Instruction_EX[20:16]),.IFID_rs(Instruction_ID[25:21]),.IFID_rt(Instruction_ID[20:16]),
		   .EXMEM_rd(Write_register_EX),.IFID_pcsrc(PCSrc_ID),.stall(),.PCWrite(PCWrite),.IFFlush(IFFlush),.EXFlush(EXFlush),
		   .special(special));

endmodule