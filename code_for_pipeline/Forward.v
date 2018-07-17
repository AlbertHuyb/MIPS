module Forward(IDEX_rs,IDEX_rt,IDEX_alusrc2,IDEX_alusrc1,EXMEM_regwr,MEMWB_regwr,EXMEM_rd,EXMEM_rt,MEMWB_rd,EXMEM_memwr,EXMEM_aluctrl2,
	IFID_rs,IFID_rt,IFID_pcsrc,
	,ALUctrl1,ALUctrl2,MemWritectrl,CMPctrl1,CMPctrl2);
input [4:0] IDEX_rs,IDEX_rt,EXMEM_rd,MEMWB_rd,EXMEM_rt,IFID_rs,IFID_rt;
input EXMEM_regwr,MEMWB_regwr,IDEX_alusrc2,IDEX_alusrc1,EXMEM_memwr;
input [1:0] EXMEM_aluctrl2;
input [2:0] IFID_pcsrc;
output [1:0] ALUctrl1,ALUctrl2;
output MemWritectrl;//控制写入内存的数据是否来自于转发，是为1，不是为0
output CMPctrl1,CMPctrl2;

assign ALUctrl1 = 
		//源和写入地址相同，需要写入reg，databus用的是reg里的数，不写入0reg
		(IDEX_rs == EXMEM_rd && EXMEM_regwr && ~IDEX_alusrc1 && EXMEM_rd != 5'b0)? 2'b10:
		//源和写入地址相同，需要写入reg，用的是reg里的数，不写入0reg，且中间指令没有修改这一寄存器
		(IDEX_rs == MEMWB_rd && MEMWB_regwr && ~IDEX_alusrc1 && MEMWB_rd != 5'b0 && (~EXMEM_regwr || EXMEM_rd != IDEX_rs))? 2'b01:
		2'b00;
assign ALUctrl2 = 
		(IDEX_rt == EXMEM_rd && EXMEM_regwr && ~IDEX_alusrc2 && EXMEM_rd != 5'b0)? 2'b10:
        (IDEX_rt == MEMWB_rd && MEMWB_regwr && ~IDEX_alusrc2 && MEMWB_rd != 5'b0 && (~EXMEM_regwr || EXMEM_rd != IDEX_rs))? 2'b01:
        2'b00;

//要将rt 保留到 EXMEM 才能进行判断，解决内存复制的forwarding
assign MemWritectrl = 
		//在最后一个模块，输入要写内存，输出要写寄存器，而且输入的东西正是从输出写的寄存器得来的
		(EXMEM_memwr && MEMWB_regwr && EXMEM_rt == MEMWB_rd && EXMEM_aluctrl2 == 2'b00)? 1'b1:
		1'b0;

//针对beq语句做的forward操作
assign CMPctrl1 = 
		//要进行分支跳转，且上上条指令要写回寄存器，且地址匹配
		//或者是跳寄存器指令
		((IFID_pcsrc == 3'b001 || IFID_pcsrc == 3'b011) && EXMEM_rd != 5'b0 && EXMEM_rd == IFID_rs && EXMEM_regwr)? 1'b1:
		1'b0;
assign CMPctrl2 = 
		((IFID_pcsrc == 3'b001 || IFID_pcsrc == 3'b011) && EXMEM_rd != 5'b0 && EXMEM_rd == IFID_rt && EXMEM_regwr)? 1'b1:
		1'b0;

endmodule
