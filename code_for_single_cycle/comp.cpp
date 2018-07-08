#include<iostream>
#include<fstream>
#include<sstream>
#include<vector>
#include<string>
using namespace std;

#define NumOfIns 31
string Ins[NumOfIns] = {
	"lw", "sw", "lui", "add", "addu",
	"sub", "subu", "addi", "addiu", "and",
	"or", "xor", "nor", "andi", "sll",
	"srl", "sra", "slt", "slti", "sltiu",
	"beq", "bne", "blez", "bgtz", "bltz",
	"j", "jal", "jr", "jalr", "ori", "nop"
};

//十进制数转换为二进制比特串
string dec2bin( int dec , int bits ){
	char *initial = new char[bits+1];
	for (int i = 0; i < bits; i++)
		initial[i] = '0';
	initial[bits]='\0';
	string str = initial;
	for( int i = bits - 1; i >= 0; i-- )
	{
		str[i] = abs( dec % 2 ) + 48;
		dec >>= 1;
	}
	return str;
};

//寄存器符号转换为二进制比特串
string reg2str( string reg )
{
	int reg_num = 0;
	if ( reg == "$zero" || reg == "$zero," || reg == "$0" || reg == "$0,")
		reg_num = 0;
	else if ( reg[1] == 'a' )
	{
		if ( reg[2] - 48 <= 3)
			reg_num = reg[2] - 48 + 4;
		else
			reg_num = 1;
	}
	else if ( reg[1] == 'v' )
		reg_num = reg[2] -48 + 2;
	else if ( reg[1] == 't' )
	{
		if ( reg[2] - 48 <= 7 )
			reg_num = reg[2] - 48 + 8;
		else
			reg_num = reg[2] - 48 + 16;
	}
	else if ( reg[1] == 's' )
	{
		if ( reg[2] - 48 <= 7 )
			reg_num = reg[2] -48 +16;
		else
			reg_num = 29;
	}
	else if ( reg[1] == 'k' )
		reg_num = reg[2] -48 + 26;
	else if ( reg[1] == 'g')
		reg_num = 28;
	else if ( reg[1] == 'f' )
		reg_num = 30;
	else if ( reg[1] == 'r' )
		reg_num = 31;
	return dec2bin( reg_num , 5 );
};


//指令转换为Opcode
string ins2Opcode( string ins )
{
	int Opcode = 0;
	if( ins == "lw" )
		Opcode = 35;
	else if( ins == "sw" )
		Opcode = 43;
	else if( ins == "lui" )
		Opcode = 15;
	else if( ins == "addi" )
		Opcode = 8;
	else if( ins == "addiu" )
		Opcode = 9;
	else if( ins == "andi" )
		Opcode = 12;
	else if( ins == "slti" )
		Opcode = 10;
	else if( ins == "sltiu" )
		Opcode = 11;
	else if( ins == "beq" )
		Opcode = 4;
	else if( ins == "bne" )
		Opcode = 5;
	else if( ins == "blez" )
		Opcode = 6;
	else if( ins == "bgtz" )
		Opcode = 7;
	else if( ins == "bltz" )
		Opcode = 1;
	else if( ins == "j" )
		Opcode = 2;
	else if( ins == "jal" )
		Opcode = 3;
	else if( ins == "ori" )
		Opcode = 13;
	return dec2bin( Opcode , 6 );
}
//指令转换为Func
string ins2Func( string ins )
{
	int Func = 0;
	if( ins == "add" )
		Func = 32;
	else if( ins == "addu" )
		Func = 33;
	else if( ins == "sub" )
		Func = 34;
	else if( ins == "subu" )
		Func = 35;
	else if( ins == "and" )
		Func = 36;
	else if( ins == "or" )
		Func = 37;
	else if( ins == "xor" )
		Func = 38;
	else if( ins == "nor" )
		Func = 39;
	else if( ins == "sll" )
		Func = 0;
	else if( ins == "srl" )
		Func = 2;
	else if( ins == "sra" )
		Func = 3;
	else if( ins == "slt" )
		Func = 42;
	else if( ins == "jr" )
		Func = 8;
	else if( ins == "jalr" )
		Func = 9;
	return dec2bin( Func , 6 );
}




int main()
{
	ifstream inFile( "d:\\MIPS.txt" );
	ofstream outFile( "d:\\Machine_code.txt" );

	//label-address
	vector< pair<string,int> > label_list;
	string buffer;
	getline( inFile, buffer );
	while(buffer.size()==0||buffer.size()==1) 
	{
		buffer.clear();
		buffer="";
		getline(inFile, buffer );
	}
	stringstream sstrm;
	sstrm<<buffer;
	int addr=0;
	while(!inFile.eof())
	{
		string label;
		string label2;
		sstrm>>label;

		if(label[label.size()-1]==':')
		{
			label.pop_back();
			sstrm>>label2;
			if(sstrm.eof())
			{
				label_list.push_back( make_pair( label, addr ) );
				addr=addr-1;
			}
			else
				label_list.push_back( make_pair( label, addr ) );
		}


		buffer.clear();
		buffer="";
		getline( inFile, buffer );
		while(buffer.size()==0||buffer.size()==1) 
		{
			buffer.clear();
			buffer="";
			getline(inFile, buffer );
			if(inFile.eof())
				break;
		}
		
		sstrm.clear();
		sstrm.str("");
		sstrm<<buffer;
		addr=addr+1;
	}

	for(int i=0;i<label_list.size();i++)
		cout<<label_list[i].first<<" "<<label_list[i].second<<endl;

	inFile.clear();
	inFile.seekg(0,ios::beg);
	buffer.clear();
	sstrm.clear();
	sstrm.str("");
	getline(inFile,buffer);
	while(buffer.size()==0||buffer.size()==1) 
	{
		buffer.clear();
		buffer="";
		getline(inFile, buffer );
	}
	sstrm<<buffer;

	int num=0;
	while ( !inFile.eof() )
	{
		string ins;
		sstrm >> ins;
	    if(ins[ins.size()-1]==':') 
		{
			sstrm>>ins;
			if(sstrm.eof())
			{
				buffer.clear();
				getline( inFile, buffer );
				while(buffer.size()==1||buffer.size()==0) 
				{
					buffer.clear();
					getline( inFile, buffer );
				}
		
				sstrm.clear();
				sstrm.str("");
				sstrm<<buffer;
				continue;
			}
		}
		if( ins == "add" || ins == "addu" || ins== "sub" || ins== "subu" || 
				ins == "and" || ins== "or" || ins== "xor" || ins== "nor" || ins== "slt" )
		{
			string rd,rs,rt;
			sstrm >> rd >> rs >> rt;
			outFile << "ROMDATA["<<num<<"] <= 32'b" << ins2Opcode( ins ) << reg2str( rs ) << reg2str( rt ) << reg2str( rd ) << "00000" << ins2Func( ins ) << ';' << endl;
		}
		else if ( ins == "lw" || ins == "sw" )
		{
			string rs,rt,offset_rs,off_set;
			int offset = 0;
			sstrm >> rt >> offset_rs;
			int index = 0;
			while( offset_rs[index] != '(' )
			{
				off_set.push_back( offset_rs[index] );
				index++;
			}
			index++;
			while( offset_rs[index] != ')' )
			{
				rs.push_back( offset_rs[index] );
				index++;
			}
			stringstream temp;
			temp << off_set;
			temp >> offset;
			outFile << "ROMDATA["<<num<<"] <= 32'b" << ins2Opcode( ins ) << reg2str( rs ) << reg2str( rt ) << dec2bin( offset , 16 ) << ';' << endl;
		}
		else if ( ins == "lui")
		{
			string rt;
			int imm;
			sstrm >> rt >> imm;
			outFile << "ROMDATA["<<num<<"] <= 32'b" << ins2Opcode( ins ) << "00000" << reg2str(rt) << dec2bin( imm , 16 ) << ';' << endl;
		}
		else if ( ins == "addi" | ins == "addiu" | ins == "andi" | ins == "slti" | ins == "sltiu" | ins == "ori" )
		{
			string rs,rt;
			int imm;
			sstrm >> rt >> rs >> imm;
			outFile << "ROMDATA["<<num<<"] <= 32'b" << ins2Opcode( ins ) << reg2str( rs ) << reg2str( rt ) << dec2bin( imm , 16 ) << ';' << endl;
		}
		else if ( ins == "sll" | ins == "srl" | ins == "sra" )
		{
			string rt,rd;
			int shamt;
			sstrm >> rd >> rt >> shamt;
			outFile << "ROMDATA["<<num<<"] <= 32'b" << ins2Opcode( ins ) << "00000" << reg2str( rt ) << reg2str( rd ) << dec2bin( shamt , 5 ) << ins2Func( ins )<<  ';' <<endl;
		}
		else if ( ins == "beq" | ins == "bne" )
		{
			string rs,rt,label;
			sstrm >> rs >> rt >> label;
			int offset = 0;
			for( int i = 0; i < label_list.size(); i++ )
			{
				if( label == label_list[i].first )
				{
					offset = label_list[i].second - num - 1;
					break;
				}
			}
			stringstream temp;
			temp << label;
			temp >> offset;
			outFile << "ROMDATA["<<num<<"] <= 32'b" << ins2Opcode( ins ) << reg2str( rs ) << reg2str( rt ) << dec2bin( offset , 16 ) << ';' << endl;
		}
		else if ( ins == "blez" | ins == "bgtz" | ins == "bltz" )
		{
			string rs,label;
			int offset = 0;
			sstrm >> rs >> label;
			for( int i = 0; i < label_list.size(); i++ )
			{
				if( label == label_list[i].first )
				{
					offset = label_list[i].second - num - 1;
					break;;
				}
			}
			stringstream temp;
			temp << label;
			temp >> offset;
			outFile << "ROMDATA["<<num<<"] <= 32'b" << ins2Opcode( ins ) << reg2str( rs ) << "00000" << dec2bin( offset , 16 ) <<  ';' <<endl;
		}
		else if ( ins == "j" | ins == "jal" )
		{
			string Target;
			int target = 0;
			sstrm >> Target;
			for( int i = 0; i < label_list.size(); i++ )
			{
				if( Target == label_list[i].first )
				{
					target = label_list[i].second;
					break;
				}
			}
			stringstream temp;
			temp << Target;
			temp >> target;
			outFile << "ROMDATA["<<num<<"] <= 32'b" << ins2Opcode( ins ) << dec2bin( target , 26 ) << ';' <<endl;
		}
		else if ( ins == "jr" )
		{
			string rs;
			sstrm >> rs;
			outFile << "ROMDATA["<<num<<"] <= 32'b" << ins2Opcode( ins ) << reg2str( rs ) << "00000" << "00000" << "00000" << ins2Func( ins ) << ';' <<endl;
		}
		else if ( ins == "jalr" )
		{
			string rs,rd;
			sstrm >> rd >>rs;
			outFile << "ROMDATA["<<num<<"] <= 32'b" << ins2Opcode( ins ) << reg2str( rs ) << "00000" << reg2str( rd ) << "00000" << ins2Func( ins ) << ';' <<endl;
		}
		else if ( ins == "nop" )
		{
			outFile << "ROMDATA["<<num<<"] <= 32'b" << "00000000000000000000000000000000" << ';'<<endl;
		}


		num++;
		buffer.clear();
		getline( inFile, buffer );
		while(buffer.size()==1||buffer.size()==0) 
		{
			buffer.clear();
			getline( inFile, buffer );
			if(inFile.eof())
				break;
		}
		
		sstrm.clear();
		sstrm.str("");
		sstrm<<buffer;
	}
		

	  
}
