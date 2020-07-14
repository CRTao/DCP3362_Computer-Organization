//Subject:     CO project 5 - Decoder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      Ling Yin-Tao
//----------------------------------------------
//Date:        6/13
//----------------------------------------------
//Description: 0516320
//--------------------------------------------------------------------------------

module Decoder(
    instr_op_i,
	RegWrite_o,
	ALU_op_o,
	ALUSrc_o,
	RegDst_o,
	Branch_o,
	MemRead_o,
	MemWrite_o,
	MemtoReg_o
	//jump_o
	);
     
//I/O ports
input  [6-1:0] instr_op_i;

output         RegWrite_o;
output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output         RegDst_o;
output         Branch_o;
output         MemRead_o;
output         MemWrite_o;
output         MemtoReg_o;
//output         jump_o;


 
//Internal Signals
reg    [3-1:0] ALU_op_o;
reg            ALUSrc_o;
reg            RegWrite_o;
reg            RegDst_o;
reg            Branch_o;
reg            MemRead_o;
reg            MemWrite_o;
reg            MemtoReg_o;
//reg            jump_o;

//Parameter


//Main function
always@(*)begin
	case(instr_op_i)
        6'b000000: // R-type > 0
		begin
			RegWrite_o=1;
			ALUSrc_o=0;
			RegDst_o=1;
			Branch_o=0;
			MemRead_o=0;
			MemWrite_o=0;
			MemtoReg_o=0;
			//jump_o=0;
			ALU_op_o[3-1:0]=3'b000;			
		end
		6'b001000: // I-type ADDi > 8
        begin
            RegWrite_o=1;
            ALUSrc_o=1;
            RegDst_o=0;
            Branch_o=0;
			MemRead_o=0;
			MemWrite_o=0;
			MemtoReg_o=0;
			//jump_o=0;
            ALU_op_o[3-1:0]=3'b011;
        end
        6'b000100: // BEQ > 4
        begin
            RegWrite_o=0;
            ALUSrc_o=0;
            RegDst_o=0;
            Branch_o=1;
			MemRead_o=0;
			MemWrite_o=0;
			MemtoReg_o=0;
			//jump_o=0;
            ALU_op_o[3-1:0]=3'b001;
        end
        6'b001010: // SLTi > 10
        begin
            RegWrite_o=1;
            ALUSrc_o=1;
            RegDst_o=0;
            Branch_o=0;
			MemRead_o=0;
			MemWrite_o=0;
			MemtoReg_o=0;
			//jump_o=0;
            ALU_op_o[3-1:0]=3'b100;
        end
        6'b101011: // sw > 101011
        begin
            RegWrite_o=0;
            ALUSrc_o=1;
            RegDst_o=0;
            Branch_o=0;
			MemRead_o=0;
			MemWrite_o=1;
			MemtoReg_o=0;
			//jump_o=0;
            ALU_op_o[3-1:0]=3'b011;
        end
        6'b100011: // lw > 100011
        begin
            RegWrite_o=1;
            ALUSrc_o=1;
            RegDst_o=0;
            Branch_o=0;
			MemRead_o=1;
			MemWrite_o=0;
			MemtoReg_o=1;
			//jump_o=0;
            ALU_op_o[3-1:0]=3'b011;
        end
		6'b000101: begin // BNE
            RegWrite_o=1;
            ALUSrc_o=1;
            RegDst_o=0;
            Branch_o=0;
			MemRead_o=0;
			MemWrite_o=0;
			MemtoReg_o=0;
			//jump_o=0;
            ALU_op_o[3-1:0]=3'b101;
		end
		6'b000001: begin // BGE
            RegWrite_o=1;
            ALUSrc_o=1;
            RegDst_o=0;
            Branch_o=0;
			MemRead_o=0;
			MemWrite_o=0;
			MemtoReg_o=0;
			//jump_o=0;
            ALU_op_o[3-1:0]=3'b110;
		end
		6'b000111: begin // BGT
            RegWrite_o=1;
            ALUSrc_o=1;
            RegDst_o=0;
            Branch_o=0;
			MemRead_o=0;
			MemWrite_o=0;
			MemtoReg_o=0;
			//jump_o=0;
            ALU_op_o[3-1:0]=3'b111;
		end
        default:   // Set R-type
        begin
            RegWrite_o=RegWrite_o;
            ALUSrc_o=ALUSrc_o;
            RegDst_o=RegDst_o;
            Branch_o=Branch_o;
			MemRead_o=MemRead_o;
			MemWrite_o=MemWrite_o;
			MemtoReg_o=MemtoReg_o;
			//jump_o=jump_o;
            ALU_op_o=ALU_op_o;
        end

	endcase
end

endmodule





                    
                    