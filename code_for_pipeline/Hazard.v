
module Hazard(IDEX_memread,IFID_memwr,IDEX_jump,IDEX_regwr,IDEX_rt,IFID_rs,IFID_rt,EXMEM_rd,IFID_pcsrc,stall,PCWrite,IFFlush,EXFlush);
input IDEX_memread,IFID_memwr,IDEX_jump,IDEX_regwr;
input [4:0] IDEX_rt,IFID_rs,IFID_rt,EXMEM_rd;
input [2:0] IFID_pcsrc;
output stall,PCWrite,IFFlush,EXFlush;

//stall 实现方法：PC保持不变，给IFID送一串0，这样的话，在下一个时钟周期，就会从原来的PC再取指令，IFID_REG得到原来的指令
//而从IFID_REG取到0故IDEX_REG也是0


//！！可能存在的问题，jump之后的清空和取址

assign PCWrite = ~stall;
assign IFFlush = stall;
assign IFFlush = IDEX_jump? 1'b1:
		//后一条指令不写内存而且前一条指令要读内存，说明不是内存的复制，只能stall一个周期
		(~IFID_memwr && IDEX_memread && (IDEX_rt == IFID_rs || IDEX_rt == IFID_rt))? 1'b1:
		//前一条指令要写寄存器，后一条指令要进行分支跳转或跳寄存器但用于比较的寄存器是前一个的运算结果
		//这里假设EX部分算出rd的mux是即时的，就是说假设IDEX_REG改变之后，rd就会相应改变，所以用这个rd来判断
		(IDEX_regwr && (IFID_pcsrc == 3'b001 || IFID_pcsrc == 3'b011) && (IFID_rt == EXMEM_rd || IFID_rs == EXMEM_rd))? 1'b1:
		1'b0;
assign EXFlush = 
		//后一条指令不写内存而且前一条指令要读内存，说明不是内存的复制，只能stall一个周期
		(~IFID_memwr && IDEX_memread && (IDEX_rt == IFID_rs || IDEX_rt == IFID_rt))? 1'b1:
		//前一条指令要写寄存器，后一条指令要进行分支跳转或跳寄存器但用于比较的寄存器是前一个的运算结果
		//这里假设EX部分算出rd的mux是即时的，就是说假设IDEX_REG改变之后，rd就会相应改变，所以用这个rd来判断
		(IDEX_regwr && (IFID_pcsrc == 3'b001 || IFID_pcsrc == 3'b011) && (IFID_rt == EXMEM_rd || IFID_rs == EXMEM_rd))? 1'b1:
		1'b0;

endmodule // Hazard
