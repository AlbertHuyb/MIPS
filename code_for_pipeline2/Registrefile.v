
module RegisterFile(reset, clk, RegWrite, Read_register1, Read_register2, Write_register, Write_data, Read_data1, Read_data2,num1,num2);
	input reset, clk;
	input RegWrite;
	input [4:0] Read_register1, Read_register2, Write_register;
	input [31:0] Write_data;
	output [31:0] Read_data1, Read_data2;
	output [7:0] num1,num2;

	
	wire clk2;
	assign clk2=~clk;
	reg [31:0] RF_data[31:1];
	/*
	assign num1 = RF_data[4][7:0];
	assign num2 = RF_data[5][7:0];
	*/
	assign num1[7:4] = RF_data[19][3:0];
	assign num1[3:0] = RF_data[20][3:0];
	assign num2[7:4] = RF_data[21][3:0];
	assign num2[3:0] = RF_data[22][3:0];
	
	assign Read_data1 = (Read_register1 == 5'b00000)? 32'h00000000: RF_data[Read_register1];
	assign Read_data2 = (Read_register2 == 5'b00000)? 32'h00000000: RF_data[Read_register2];
	
	integer i;
	always @(negedge reset or posedge clk2)
		if (!reset)
			for (i = 1; i < 32; i = i + 1)
				RF_data[i] <= 32'h00000000;
		else if (RegWrite && (Write_register != 5'b00000))
			RF_data[Write_register] <= Write_data;

endmodule
			