	
module WriteRegister(reset, clk, RegWrite, Write_register, Write_data,);
	input reset, clk;
	input RegWrite;
	input [4:0] Write_register;
	input [31:0] Write_data;
	
	reg [31:0] RF_data[31:1];
	
	integer i;
	always @(negedge reset or posedge clk)
		if (!reset)
			for (i = 1; i < 32; i = i + 1)
				RF_data[i] <= 32'h00000000;
		else if (RegWrite && (Write_register != 5'b00000))
			RF_data[Write_register] <= Write_data;

endmodule
			