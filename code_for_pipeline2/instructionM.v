module InstructionMemory(Address, Instruction);
	input [31:0] Address;
	output reg [31:0] Instruction;
	
	always @(*)
		case (Address[9:2])
		/*
8'd0: Instruction <= 32'b00001000000000000000000000001110;
8'd1: Instruction <= 32'b00001000000000000000000000110100;
8'd2: Instruction <= 32'b00001000000000000000000010001011;
8'd3: Instruction <= 32'b00010000100001010000000000000011;
8'd4: Instruction <= 32'b00000000100001010100000000101010;
8'd5: Instruction <= 32'b00010001000100000000000000000011;
8'd6: Instruction <= 32'b00001000000000000000000000001011;
8'd7: Instruction <= 32'b00000000100000000001000000100000;
8'd8: Instruction <= 32'b00001000000000000000000010001011;
8'd9: Instruction <= 32'b00000000101001000010100000100010;
8'd10: Instruction <= 32'b00001000000000000000000000000011;
8'd11: Instruction <= 32'b00000000100001010010000000100010;
8'd12: Instruction <= 32'b00000000000000000000000000000000;
8'd13: Instruction <= 32'b00001000000000000000000000000011;
8'd14: Instruction <= 32'b00111100000000010100000000000000;
8'd15: Instruction <= 32'b00110100001000010000000000100000;
8'd16: Instruction <= 32'b00000000000000010100000000100000;
8'd17: Instruction <= 32'b10001101000010010000000000000000;
8'd18: Instruction <= 32'b00110001001010010000000000001000;
8'd19: Instruction <= 32'b00010001001000001111111111111101;
8'd20: Instruction <= 32'b00000000000000000000000000000000;
8'd21: Instruction <= 32'b00111100000000010100000000000000;
8'd22: Instruction <= 32'b00110100001000010000000000011100;
8'd23: Instruction <= 32'b00000000000000010010000000100000;
8'd24: Instruction <= 32'b10001100100001000000000000000000;
8'd25: Instruction <= 32'b00000000100000001000100000100000;
8'd26: Instruction <= 32'b00000000000000000000000000000000;
8'd27: Instruction <= 32'b00111100000000010100000000000000;
8'd28: Instruction <= 32'b00110100001000010000000000100000;
8'd29: Instruction <= 32'b00000000000000010100000000100000;
8'd30: Instruction <= 32'b10001101000010010000000000000000;
8'd31: Instruction <= 32'b00110001001010010000000000001000;
8'd32: Instruction <= 32'b00010001001000001111111111111101;
8'd33: Instruction <= 32'b00000000000000000000000000000000;
8'd34: Instruction <= 32'b00111100000000010100000000000000;
8'd35: Instruction <= 32'b00110100001000010000000000011100;
8'd36: Instruction <= 32'b00000000000000010010100000100000;
8'd37: Instruction <= 32'b10001100101001010000000000000000;
8'd38: Instruction <= 32'b00000000101000001001000000100000;
8'd39: Instruction <= 32'b00000000000000000000000000000000;
8'd40: Instruction <= 32'b00111100000000010100000000000000;
8'd41: Instruction <= 32'b00110100001011110000000000000000;
8'd42: Instruction <= 32'b10101101111000000000000000001000;
8'd43: Instruction <= 32'b00100100000011011111111110110000;
8'd44: Instruction <= 32'b10101101111011010000000000000000;
8'd45: Instruction <= 32'b00100100000011011111111111111111;
8'd46: Instruction <= 32'b10101101111011010000000000000100;
8'd47: Instruction <= 32'b00100000000011010000000000000011;
8'd48: Instruction <= 32'b10101101111011010000000000001000;
8'd49: Instruction <= 32'b00000000000000000000000000000000;
8'd50: Instruction <= 32'b00100000000100000000000000000001;
8'd51: Instruction <= 32'b00001000000000000000000000000011;
8'd52: Instruction <= 32'b10001101111011010000000000001000;
8'd53: Instruction <= 32'b00111100000000011111111111111111;
8'd54: Instruction <= 32'b00110100001000011111111111111001;
8'd55: Instruction <= 32'b00000001101000010110100000100100;
8'd56: Instruction <= 32'b10101101111011010000000000001000;
8'd57: Instruction <= 32'b00000000000000000000000000000000;
8'd58: Instruction <= 32'b00100011101111010000000001100100;
8'd59: Instruction <= 32'b10101111101000010000000000000000;
8'd60: Instruction <= 32'b10101111101010000000000000000100;
8'd61: Instruction <= 32'b00100011101111010000000000001000;
8'd62: Instruction <= 32'b00000000000000000000000000000000;
8'd63: Instruction <= 32'b00000000000100011001100100000010;
8'd64: Instruction <= 32'b00000000000100101010100100000010;
8'd65: Instruction <= 32'b00110010001101000000000000001111;
8'd66: Instruction <= 32'b00110010010101100000000000001111;
8'd67: Instruction <= 32'b00100000000101110000000001000000;
8'd68: Instruction <= 32'b10101100000101110000000000000000;
8'd69: Instruction <= 32'b00100000000101110000000001111001;
8'd70: Instruction <= 32'b10101100000101110000000000000100;
8'd71: Instruction <= 32'b00100000000101110000000000100100;
8'd72: Instruction <= 32'b10101100000101110000000000001000;
8'd73: Instruction <= 32'b00100000000101110000000000110000;
8'd74: Instruction <= 32'b10101100000101110000000000001100;
8'd75: Instruction <= 32'b00100000000101110000000000011001;
8'd76: Instruction <= 32'b10101100000101110000000000010000;
8'd77: Instruction <= 32'b00100000000101110000000000010010;
8'd78: Instruction <= 32'b10101100000101110000000000010100;
8'd79: Instruction <= 32'b00100000000101110000000000000010;
8'd80: Instruction <= 32'b10101100000101110000000000011000;
8'd81: Instruction <= 32'b00100000000101110000000001111000;
8'd82: Instruction <= 32'b10101100000101110000000000011100;
8'd83: Instruction <= 32'b00100000000101110000000000000000;
8'd84: Instruction <= 32'b10101100000101110000000000100000;
8'd85: Instruction <= 32'b00100000000101110000000000010000;
8'd86: Instruction <= 32'b10101100000101110000000000100100;
8'd87: Instruction <= 32'b00100000000101110000000000001000;
8'd88: Instruction <= 32'b10101100000101110000000000101000;
8'd89: Instruction <= 32'b00100000000101110000000000000011;
8'd90: Instruction <= 32'b10101100000101110000000000101100;
8'd91: Instruction <= 32'b00100000000101110000000010000110;
8'd92: Instruction <= 32'b10101100000101110000000000110000;
8'd93: Instruction <= 32'b00100000000101110000000000100001;
8'd94: Instruction <= 32'b10101100000101110000000000110100;
8'd95: Instruction <= 32'b00100000000101110000000000000110;
8'd96: Instruction <= 32'b10101100000101110000000000111000;
8'd97: Instruction <= 32'b00100000000101110000000000001110;
8'd98: Instruction <= 32'b10101100000101110000000000111100;
8'd99: Instruction <= 32'b00111100000000010100000000000000;
8'd100: Instruction <= 32'b00110100001010000000000000010100;
8'd101: Instruction <= 32'b00000000000000000000000000000000;
8'd102: Instruction <= 32'b00000000000100111011100010000000;
8'd103: Instruction <= 32'b10001110111101110000000000000000;
8'd104: Instruction <= 32'b00100000000111010000000000000001;
8'd105: Instruction <= 32'b00000000000111011110101000000000;
8'd106: Instruction <= 32'b00000011101101111011100000100000;
8'd107: Instruction <= 32'b10101101000101110000000000000000;
8'd108: Instruction <= 32'b00000000000101001011100010000000;
8'd109: Instruction <= 32'b10001110111101110000000000000000;
8'd110: Instruction <= 32'b00100000000111010000000000000010;
8'd111: Instruction <= 32'b00000000000111011110101000000000;
8'd112: Instruction <= 32'b00000011101101111011100000100000;
8'd113: Instruction <= 32'b10101101000101110000000000000000;
8'd114: Instruction <= 32'b00000000000101011011100010000000;
8'd115: Instruction <= 32'b10001110111101110000000000000000;
8'd116: Instruction <= 32'b00100000000111010000000000000100;
8'd117: Instruction <= 32'b00000000000111011110101000000000;
8'd118: Instruction <= 32'b00000011101101111011100000100000;
8'd119: Instruction <= 32'b10101101000101110000000000000000;
8'd120: Instruction <= 32'b00000000000101101011100010000000;
8'd121: Instruction <= 32'b10001110111101110000000000000000;
8'd122: Instruction <= 32'b00100000000111010000000000001000;
8'd123: Instruction <= 32'b00000000000111011110101000000000;
8'd124: Instruction <= 32'b00000011101101111011100000100000;
8'd125: Instruction <= 32'b10101101000101110000000000000000;
8'd126: Instruction <= 32'b00100000000111010000000000000011;
8'd127: Instruction <= 32'b00000000000111011110101000000000;
8'd128: Instruction <= 32'b00100011101101110000000000000011;
8'd129: Instruction <= 32'b10101101000101110000000000000000;
8'd130: Instruction <= 32'b00000000000000000000000000000000;
8'd131: Instruction <= 32'b00100011101111011111111111111000;
8'd132: Instruction <= 32'b10001111101000010000000000000000;
8'd133: Instruction <= 32'b10001111101010000000000000000100;
8'd134: Instruction <= 32'b00100000000111010000000000000000;
8'd135: Instruction <= 32'b00000000000000000000000000000000;
8'd136: Instruction <= 32'b00110101101011010000000000000010;
8'd137: Instruction <= 32'b10101101111011010000000000001000;
8'd138: Instruction <= 32'b00000011010000000000000000001000;
8'd139: Instruction <= 32'b00000000010000000001000000100000;
8'd140: Instruction <= 32'b00111100000000010100000000000000;
8'd141: Instruction <= 32'b00110100001000010000000000011000;
8'd142: Instruction <= 32'b00000000000000010011000000100000;
8'd143: Instruction <= 32'b10101100110000100000000000000000;
8'd144: Instruction <= 32'b10101101111000100000000000001100;
8'd145: Instruction <= 32'b00001000000000000000000010010001;8'd0: Instruction <= 32'b00001000000000000000000000001110;
8'd1: Instruction <= 32'b00001000000000000000000000110100;
8'd2: Instruction <= 32'b00001000000000000000000010001011;
8'd3: Instruction <= 32'b00010000100001010000000000000011;
8'd4: Instruction <= 32'b00000000100001010100000000101010;
8'd5: Instruction <= 32'b00010001000100000000000000000011;
8'd6: Instruction <= 32'b00001000000000000000000000001011;
8'd7: Instruction <= 32'b00000000100000000001000000100000;
8'd8: Instruction <= 32'b00001000000000000000000010001011;
8'd9: Instruction <= 32'b00000000101001000010100000100010;
8'd10: Instruction <= 32'b00001000000000000000000000000011;
8'd11: Instruction <= 32'b00000000100001010010000000100010;
8'd12: Instruction <= 32'b00000000000000000000000000000000;
8'd13: Instruction <= 32'b00001000000000000000000000000011;
8'd14: Instruction <= 32'b00111100000000010100000000000000;
8'd15: Instruction <= 32'b00110100001000010000000000100000;
8'd16: Instruction <= 32'b00000000000000010100000000100000;
8'd17: Instruction <= 32'b10001101000010010000000000000000;
8'd18: Instruction <= 32'b00110001001010010000000000001000;
8'd19: Instruction <= 32'b00010001001000001111111111111101;
8'd20: Instruction <= 32'b00000000000000000000000000000000;
8'd21: Instruction <= 32'b00111100000000010100000000000000;
8'd22: Instruction <= 32'b00110100001000010000000000011100;
8'd23: Instruction <= 32'b00000000000000010010000000100000;
8'd24: Instruction <= 32'b10001100100001000000000000000000;
8'd25: Instruction <= 32'b00000000100000001000100000100000;
8'd26: Instruction <= 32'b00000000000000000000000000000000;
8'd27: Instruction <= 32'b00111100000000010100000000000000;
8'd28: Instruction <= 32'b00110100001000010000000000100000;
8'd29: Instruction <= 32'b00000000000000010100000000100000;
8'd30: Instruction <= 32'b10001101000010010000000000000000;
8'd31: Instruction <= 32'b00110001001010010000000000001000;
8'd32: Instruction <= 32'b00010001001000001111111111111101;
8'd33: Instruction <= 32'b00000000000000000000000000000000;
8'd34: Instruction <= 32'b00111100000000010100000000000000;
8'd35: Instruction <= 32'b00110100001000010000000000011100;
8'd36: Instruction <= 32'b00000000000000010010100000100000;
8'd37: Instruction <= 32'b10001100101001010000000000000000;
8'd38: Instruction <= 32'b00000000101000001001000000100000;
8'd39: Instruction <= 32'b00000000000000000000000000000000;
8'd40: Instruction <= 32'b00111100000000010100000000000000;
8'd41: Instruction <= 32'b00110100001011110000000000000000;
8'd42: Instruction <= 32'b10101101111000000000000000001000;
8'd43: Instruction <= 32'b00100100000011011111111110110000;
8'd44: Instruction <= 32'b10101101111011010000000000000000;
8'd45: Instruction <= 32'b00100100000011011111111111111111;
8'd46: Instruction <= 32'b10101101111011010000000000000100;
8'd47: Instruction <= 32'b00100000000011010000000000000011;
8'd48: Instruction <= 32'b10101101111011010000000000001000;
8'd49: Instruction <= 32'b00000000000000000000000000000000;
8'd50: Instruction <= 32'b00100000000100000000000000000001;
8'd51: Instruction <= 32'b00001000000000000000000000000011;
8'd52: Instruction <= 32'b10001101111011010000000000001000;
8'd53: Instruction <= 32'b00111100000000011111111111111111;
8'd54: Instruction <= 32'b00110100001000011111111111111001;
8'd55: Instruction <= 32'b00000001101000010110100000100100;
8'd56: Instruction <= 32'b10101101111011010000000000001000;
8'd57: Instruction <= 32'b00000000000000000000000000000000;
8'd58: Instruction <= 32'b00100011101111010000000001100100;
8'd59: Instruction <= 32'b10101111101000010000000000000000;
8'd60: Instruction <= 32'b10101111101010000000000000000100;
8'd61: Instruction <= 32'b00100011101111010000000000001000;
8'd62: Instruction <= 32'b00000000000000000000000000000000;
8'd63: Instruction <= 32'b00000000000100011001100100000010;
8'd64: Instruction <= 32'b00000000000100101010100100000010;
8'd65: Instruction <= 32'b00110010001101000000000000001111;
8'd66: Instruction <= 32'b00110010010101100000000000001111;
8'd67: Instruction <= 32'b00100000000101110000000001000000;
8'd68: Instruction <= 32'b10101100000101110000000000000000;
8'd69: Instruction <= 32'b00100000000101110000000001111001;
8'd70: Instruction <= 32'b10101100000101110000000000000100;
8'd71: Instruction <= 32'b00100000000101110000000000100100;
8'd72: Instruction <= 32'b10101100000101110000000000001000;
8'd73: Instruction <= 32'b00100000000101110000000000110000;
8'd74: Instruction <= 32'b10101100000101110000000000001100;
8'd75: Instruction <= 32'b00100000000101110000000000011001;
8'd76: Instruction <= 32'b10101100000101110000000000010000;
8'd77: Instruction <= 32'b00100000000101110000000000010010;
8'd78: Instruction <= 32'b10101100000101110000000000010100;
8'd79: Instruction <= 32'b00100000000101110000000000000010;
8'd80: Instruction <= 32'b10101100000101110000000000011000;
8'd81: Instruction <= 32'b00100000000101110000000001111000;
8'd82: Instruction <= 32'b10101100000101110000000000011100;
8'd83: Instruction <= 32'b00100000000101110000000000000000;
8'd84: Instruction <= 32'b10101100000101110000000000100000;
8'd85: Instruction <= 32'b00100000000101110000000000010000;
8'd86: Instruction <= 32'b10101100000101110000000000100100;
8'd87: Instruction <= 32'b00100000000101110000000000001000;
8'd88: Instruction <= 32'b10101100000101110000000000101000;
8'd89: Instruction <= 32'b00100000000101110000000000000011;
8'd90: Instruction <= 32'b10101100000101110000000000101100;
8'd91: Instruction <= 32'b00100000000101110000000001000110;
8'd92: Instruction <= 32'b10101100000101110000000000110000;
8'd93: Instruction <= 32'b00100000000101110000000000100001;
8'd94: Instruction <= 32'b10101100000101110000000000110100;
8'd95: Instruction <= 32'b00100000000101110000000000000110;
8'd96: Instruction <= 32'b10101100000101110000000000111000;
8'd97: Instruction <= 32'b00100000000101110000000000001110;
8'd98: Instruction <= 32'b10101100000101110000000000111100;
8'd99: Instruction <= 32'b00111100000000010100000000000000;
8'd100: Instruction <= 32'b00110100001010000000000000010100;
8'd101: Instruction <= 32'b00000000000000000000000000000000;
8'd102: Instruction <= 32'b00000000000100111011100010000000;
8'd103: Instruction <= 32'b10001110111101110000000000000000;
8'd104: Instruction <= 32'b00100000000111010000000000000001;
8'd105: Instruction <= 32'b00000000000111011110101000000000;
8'd106: Instruction <= 32'b00000011101101111011100000100000;
8'd107: Instruction <= 32'b10101101000101110000000000000000;
8'd108: Instruction <= 32'b00000000000101001011100010000000;
8'd109: Instruction <= 32'b10001110111101110000000000000000;
8'd110: Instruction <= 32'b00100000000111010000000000000010;
8'd111: Instruction <= 32'b00000000000111011110101000000000;
8'd112: Instruction <= 32'b00000011101101111011100000100000;
8'd113: Instruction <= 32'b10101101000101110000000000000000;
8'd114: Instruction <= 32'b00000000000101011011100010000000;
8'd115: Instruction <= 32'b10001110111101110000000000000000;
8'd116: Instruction <= 32'b00100000000111010000000000000100;
8'd117: Instruction <= 32'b00000000000111011110101000000000;
8'd118: Instruction <= 32'b00000011101101111011100000100000;
8'd119: Instruction <= 32'b10101101000101110000000000000000;
8'd120: Instruction <= 32'b00000000000101101011100010000000;
8'd121: Instruction <= 32'b10001110111101110000000000000000;
8'd122: Instruction <= 32'b00100000000111010000000000001000;
8'd123: Instruction <= 32'b00000000000111011110101000000000;
8'd124: Instruction <= 32'b00000011101101111011100000100000;
8'd125: Instruction <= 32'b10101101000101110000000000000000;
8'd126: Instruction <= 32'b00100000000111010000000000000011;
8'd127: Instruction <= 32'b00000000000111011110101000000000;
8'd128: Instruction <= 32'b00100011101101110000000000000011;
8'd129: Instruction <= 32'b10101101000101110000000000000000;
8'd130: Instruction <= 32'b00000000000000000000000000000000;
8'd131: Instruction <= 32'b00100011101111011111111111111000;
8'd132: Instruction <= 32'b10001111101000010000000000000000;
8'd133: Instruction <= 32'b10001111101010000000000000000100;
8'd134: Instruction <= 32'b00100000000111010000000000000000;
8'd135: Instruction <= 32'b00000000000000000000000000000000;
8'd136: Instruction <= 32'b00110101101011010000000000000010;
8'd137: Instruction <= 32'b10101101111011010000000000001000;
8'd138: Instruction <= 32'b00000011010000000000000000001000;
8'd139: Instruction <= 32'b00000000010000000001000000100000;
8'd140: Instruction <= 32'b00111100000000010100000000000000;
8'd141: Instruction <= 32'b00110100001000010000000000011000;
8'd142: Instruction <= 32'b00000000000000010011000000100000;
8'd143: Instruction <= 32'b10101100110000100000000000000000;
8'd144: Instruction <= 32'b10101101111000100000000000001100;
8'd145: Instruction <= 32'b00001000000000000000000010010001;
*/
8'd0: Instruction <= 32'b00001000000000000000000000001110;
8'd1: Instruction <= 32'b00001000000000000000000000111001;
8'd2: Instruction <= 32'b00001000000000000000000010011011;
8'd3: Instruction <= 32'b00010000100001010000000000000011;
8'd4: Instruction <= 32'b00000000100001010100000000101010;
8'd5: Instruction <= 32'b00010001000100000000000000000011;
8'd6: Instruction <= 32'b00001000000000000000000000001011;
8'd7: Instruction <= 32'b00000000100000000001000000100000;
8'd8: Instruction <= 32'b00001000000000000000000010011011;
8'd9: Instruction <= 32'b00000000101001000010100000100010;
8'd10: Instruction <= 32'b00001000000000000000000000000011;
8'd11: Instruction <= 32'b00000000100001010010000000100010;
8'd12: Instruction <= 32'b00000000000000000000000000000000;
8'd13: Instruction <= 32'b00001000000000000000000000000011;
8'd14: Instruction <= 32'b00111100000000010100000000000000;
8'd15: Instruction <= 32'b00110100001010000000000000010100;
8'd16: Instruction <= 32'b00100000000000010000000000000000;
8'd17: Instruction <= 32'b00000000000000000000000000000000;
8'd18: Instruction <= 32'b10101101000000010000000000000000;
8'd19: Instruction <= 32'b00111100000000010100000000000000;
8'd20: Instruction <= 32'b00110100001000010000000000100000;
8'd21: Instruction <= 32'b00000000000000010100000000100000;
8'd22: Instruction <= 32'b10001101000010010000000000000000;
8'd23: Instruction <= 32'b00110001001010010000000000001000;
8'd24: Instruction <= 32'b00010001001000001111111111111101;
8'd25: Instruction <= 32'b00000000000000000000000000000000;
8'd26: Instruction <= 32'b00111100000000010100000000000000;
8'd27: Instruction <= 32'b00110100001000010000000000011100;
8'd28: Instruction <= 32'b00000000000000010010000000100000;
8'd29: Instruction <= 32'b10001100100001000000000000000000;
8'd30: Instruction <= 32'b00000000100000001000100000100000;
8'd31: Instruction <= 32'b00000000000000000000000000000000;
8'd32: Instruction <= 32'b00111100000000010100000000000000;
8'd33: Instruction <= 32'b00110100001000010000000000100000;
8'd34: Instruction <= 32'b00000000000000010100000000100000;
8'd35: Instruction <= 32'b10001101000010010000000000000000;
8'd36: Instruction <= 32'b00110001001010010000000000001000;
8'd37: Instruction <= 32'b00010001001000001111111111111101;
8'd38: Instruction <= 32'b00000000000000000000000000000000;
8'd39: Instruction <= 32'b00111100000000010100000000000000;
8'd40: Instruction <= 32'b00110100001000010000000000011100;
8'd41: Instruction <= 32'b00000000000000010010100000100000;
8'd42: Instruction <= 32'b10001100101001010000000000000000;
8'd43: Instruction <= 32'b00000000101000001001000000100000;
8'd44: Instruction <= 32'b00000000000000000000000000000000;
8'd45: Instruction <= 32'b00111100000000010100000000000000;
8'd46: Instruction <= 32'b00110100001011110000000000000000;
8'd47: Instruction <= 32'b10101101111000000000000000001000;
8'd48: Instruction <= 32'b00100100000011011111111110110000;
8'd49: Instruction <= 32'b10101101111011010000000000000000;
8'd50: Instruction <= 32'b00100100000011011111111111111111;
8'd51: Instruction <= 32'b10101101111011010000000000000100;
8'd52: Instruction <= 32'b00100000000011010000000000000011;
8'd53: Instruction <= 32'b10101101111011010000000000001000;
8'd54: Instruction <= 32'b00000000000000000000000000000000;
8'd55: Instruction <= 32'b00100000000100000000000000000001;
8'd56: Instruction <= 32'b00001000000000000000000000000011;
8'd57: Instruction <= 32'b10001101111011010000000000001000;
8'd58: Instruction <= 32'b00111100000000011111111111111111;
8'd59: Instruction <= 32'b00110100001000011111111111111001;
8'd60: Instruction <= 32'b00000001101000010110100000100100;
8'd61: Instruction <= 32'b10101101111011010000000000001000;
8'd62: Instruction <= 32'b00000000000000000000000000000000;
8'd63: Instruction <= 32'b00100011101111010000000001100100;
8'd64: Instruction <= 32'b10101111101000010000000000000000;
8'd65: Instruction <= 32'b10101111101010000000000000000100;
8'd66: Instruction <= 32'b00100011101111010000000000001000;
8'd67: Instruction <= 32'b00000000000000000000000000000000;
8'd68: Instruction <= 32'b00000000000100011001100100000010;
8'd69: Instruction <= 32'b00000000000100101010100100000010;
8'd70: Instruction <= 32'b00110010001101000000000000001111;
8'd71: Instruction <= 32'b00110010010101100000000000001111;
8'd72: Instruction <= 32'b00100000000101110000000001000000;
8'd73: Instruction <= 32'b10101100000101110000000000000000;
8'd74: Instruction <= 32'b00100000000101110000000001111001;
8'd75: Instruction <= 32'b10101100000101110000000000000100;
8'd76: Instruction <= 32'b00100000000101110000000000100100;
8'd77: Instruction <= 32'b10101100000101110000000000001000;
8'd78: Instruction <= 32'b00100000000101110000000000110000;
8'd79: Instruction <= 32'b10101100000101110000000000001100;
8'd80: Instruction <= 32'b00100000000101110000000000011001;
8'd81: Instruction <= 32'b10101100000101110000000000010000;
8'd82: Instruction <= 32'b00100000000101110000000000010010;
8'd83: Instruction <= 32'b10101100000101110000000000010100;
8'd84: Instruction <= 32'b00100000000101110000000000000010;
8'd85: Instruction <= 32'b10101100000101110000000000011000;
8'd86: Instruction <= 32'b00100000000101110000000001111000;
8'd87: Instruction <= 32'b10101100000101110000000000011100;
8'd88: Instruction <= 32'b00100000000101110000000000000000;
8'd89: Instruction <= 32'b10101100000101110000000000100000;
8'd90: Instruction <= 32'b00100000000101110000000000010000;
8'd91: Instruction <= 32'b10101100000101110000000000100100;
8'd92: Instruction <= 32'b00100000000101110000000000001000;
8'd93: Instruction <= 32'b10101100000101110000000000101000;
8'd94: Instruction <= 32'b00100000000101110000000000000011;
8'd95: Instruction <= 32'b10101100000101110000000000101100;
8'd96: Instruction <= 32'b00100000000101110000000001000110;
8'd97: Instruction <= 32'b10101100000101110000000000110000;
8'd98: Instruction <= 32'b00100000000101110000000000100001;
8'd99: Instruction <= 32'b10101100000101110000000000110100;
8'd100: Instruction <= 32'b00100000000101110000000000000110;
8'd101: Instruction <= 32'b10101100000101110000000000111000;
8'd102: Instruction <= 32'b00100000000101110000000000001110;
8'd103: Instruction <= 32'b10101100000101110000000000111100;
8'd104: Instruction <= 32'b00111100000000010100000000000000;
8'd105: Instruction <= 32'b00110100001010000000000000010100;
8'd106: Instruction <= 32'b00000000000000000000000000000000;
8'd107: Instruction <= 32'b10001101000000010000000000000000;
8'd108: Instruction <= 32'b00110000001000010000111100000000;
8'd109: Instruction <= 32'b00000000000000010000101000000010;
8'd110: Instruction <= 32'b00010000001000000000000000010000;
8'd111: Instruction <= 32'b00100000000010100000000000000001;
8'd112: Instruction <= 32'b00010000001010100000000000010101;
8'd113: Instruction <= 32'b00000000000010100101000001000000;
8'd114: Instruction <= 32'b00010000001010100000000000011010;
8'd115: Instruction <= 32'b00000000000010100101000001000000;
8'd116: Instruction <= 32'b00010000001010100000000000011111;
8'd117: Instruction <= 32'b00000000000010100101000001000000;
8'd118: Instruction <= 32'b00010000001010100000000000001000;
8'd119: Instruction <= 32'b00100011101111011111111111111000;
8'd120: Instruction <= 32'b10001111101000010000000000000000;
8'd121: Instruction <= 32'b10001111101010000000000000000100;
8'd122: Instruction <= 32'b00100000000111010000000000000000;
8'd123: Instruction <= 32'b00000000000000000000000000000000;
8'd124: Instruction <= 32'b00110101101011010000000000000010;
8'd125: Instruction <= 32'b10101101111011010000000000001000;
8'd126: Instruction <= 32'b00000011010000000000000000001000;
8'd127: Instruction <= 32'b00000000000100111011100010000000;
8'd128: Instruction <= 32'b10001110111101110000000000000000;
8'd129: Instruction <= 32'b00100000000111010000000000000001;
8'd130: Instruction <= 32'b00000000000111011110101000000000;
8'd131: Instruction <= 32'b00000011101101111011100000100000;
8'd132: Instruction <= 32'b10101101000101110000000000000000;
8'd133: Instruction <= 32'b00001000000000000000000001110111;
8'd134: Instruction <= 32'b00000000000101001011100010000000;
8'd135: Instruction <= 32'b10001110111101110000000000000000;
8'd136: Instruction <= 32'b00100000000111010000000000000010;
8'd137: Instruction <= 32'b00000000000111011110101000000000;
8'd138: Instruction <= 32'b00000011101101111011100000100000;
8'd139: Instruction <= 32'b10101101000101110000000000000000;
8'd140: Instruction <= 32'b00001000000000000000000001110111;
8'd141: Instruction <= 32'b00000000000101011011100010000000;
8'd142: Instruction <= 32'b10001110111101110000000000000000;
8'd143: Instruction <= 32'b00100000000111010000000000000100;
8'd144: Instruction <= 32'b00000000000111011110101000000000;
8'd145: Instruction <= 32'b00000011101101111011100000100000;
8'd146: Instruction <= 32'b10101101000101110000000000000000;
8'd147: Instruction <= 32'b00001000000000000000000001110111;
8'd148: Instruction <= 32'b00000000000101101011100010000000;
8'd149: Instruction <= 32'b10001110111101110000000000000000;
8'd150: Instruction <= 32'b00100000000111010000000000001000;
8'd151: Instruction <= 32'b00000000000111011110101000000000;
8'd152: Instruction <= 32'b00000011101101111011100000100000;
8'd153: Instruction <= 32'b10101101000101110000000000000000;
8'd154: Instruction <= 32'b00001000000000000000000001110111;
8'd155: Instruction <= 32'b00000000010000000001000000100000;
8'd156: Instruction <= 32'b00111100000000010100000000000000;
8'd157: Instruction <= 32'b00110100001000010000000000011000;
8'd158: Instruction <= 32'b00000000000000010011000000100000;
8'd159: Instruction <= 32'b10101100110000100000000000000000;
8'd160: Instruction <= 32'b10101101111000100000000000001100;
8'd161: Instruction <= 32'b00001000000000000000000010100001;


			default: Instruction <= 32'h00000000;
		endcase
		
endmodule