module ALU (clk, inA, inB, Sign, ALUFun,outZ);
input [31:0] inA,inB;
input Sign, clk; 
input [5:0]ALUFun;
output [31:0] outZ;
wire [31:0] outZ;
wire tempZ,tempV,tempN;
wire [31:0] result1,result2,result3,result4;

ALU1 addsub(.clk(clk),.inA(inA),.inB(inB),.Sign(Sign),.ALUFun(ALUFun[0]),
	.outZ(tempZ),.outN(tempN),.outV(tempV),.result(result1));

ALU2 compare(.clk(clk),.ALUFun(ALUFun[3:1]),.Z(tempZ),.V(tempV),.N(tempN),
	.result(result2));

ALU3 logic(.clk(clk),.ALUFun(ALUFun[3:0]),.inA(inA),.inB(inB),
	.result(result3));

ALU4 shift(.clk(clk),.ALUFun(ALUFun[1:0]),.inA(inA),.inB(inB),
	.result(result4));

FourMux mux(.clk(clk),.control(ALUFun[5:4]),
	.input1(result1),.input2(result2),.input3(result3),.input4(result4),
	.outZ(outZ));

endmodule

module FourMux(clk,control,input1,input2,input3,input4,outZ);
input [31:0] input1,input2,input3,input4;
input [1:0] control;
input clk;
output [31:0] outZ;

assign outZ = (control == 2'b00) ? input1:
			 (control == 2'b11) ? input2:
			 (control == 2'b01) ? input3:
			 (control == 2'b10) ? input4:
			 32'b0;

endmodule // FourMux

module ALU1 (clk, inA, inB, Sign, ALUFun, outZ, outV, outN, result);
input [31:0] inA,inB;
input Sign,ALUFun,clk;

output reg outZ,outV,outN;
output reg [31:0] result;
reg upper;
wire [32:0] in1,in2,in3;
reg [32:0] temp;

assign in1 = {inA[31],inA};
assign in2 = ALUFun ? ~{inB[31],inB} + 1 : {inB[31],inB};


always @(*)
begin
	temp <= {in1 + in2};
	result <= temp[31:0];
	outZ <= Sign ? (temp[31:0] == 32'b0) : (temp[32:0] == 33'b0);
	outV <= Sign ? (inA[31] && inB[31] && ~temp[31])||(~inA[31] && ~inB[31] && temp[31]) : (in1[32] + in2[32] != temp[32]);
	outN <= Sign ? (result[31]) : 0;
end		
endmodule

module ALU2 (clk,ALUFun,Z,V,N,result);
input clk,Z,V,N;
input [2:0] ALUFun;
output wire [31:0] result;
reg flag;

assign result = {31'b0,flag};

always @(*)
begin
		case(ALUFun)
			3'b000: flag <= ~Z;
			3'b001: flag <= Z;
			3'b010: flag <= N;
			3'b110: flag <= N|Z;
			3'b101: flag <= N;
			3'b111: flag <= ~N;
		endcase // ALUFun

end

endmodule

module ALU3(clk,ALUFun,inA,inB,result);
input clk;
input [3:0] ALUFun;
input [31:0] inA,inB;
output reg [31:0] result;

always @(*)
begin
	case (ALUFun)
		4'b1000: result <= inA & inB;
		4'b1110: result <= inA | inB;
		4'b0110: result <= inA ^ inB;
		4'b0001: result <= ~(inA | inB);
		4'b1010: result <= inA;
	
		default : result <= 0;
	endcase
end
endmodule // ALU3

module ALU4(clk,ALUFun,inA,inB,result);
input clk;
input [1:0] ALUFun;
input [31:0] inA,inB;
output reg [31:0] result;

always @(*)
begin
	case (ALUFun)
		2'b00:
		begin
			result = inA[4] ? {inB[15:0],16'b0} : result;
			result = inA[3] ? {inB[23:0],8'b0} : result;
			result = inA[2] ? {inB[27:0],4'b0} : result;
			result = inA[1] ? {inB[29:0],2'b0} : result;
			result = inA[0] ? {inB[30:0],1'b0} : result;
		end 
		2'b01:
		begin
			result = inA[4] ? {16'b0,inB[31:16]} : result;
			result = inA[3] ? {8'b0,inB[31:8]} : result;
			result = inA[2] ? {4'b0,inB[31:4]} : result;
			result = inA[1] ? {2'b0,inB[31:2]} : result;
			result = inA[0] ? {1'b0,inB[31:1]} : result;
		end
		2'b11: 
		begin
			result = inA[4] ? {{16{inB[31]}},inB[31:16]} : result;
			result = inA[3] ? {{8{inB[31]}},inB[31:8]} : result;
			result = inA[2] ? {{4{inB[31]}},inB[31:4]} : result;
			result = inA[1] ? {{2{inB[31]}},inB[31:2]} : result;
			result = inA[0] ? {{inB[31]},inB[31:1]} : result;
		end
	
		default : result <= 0;
	endcase
end
endmodule // ALU4

