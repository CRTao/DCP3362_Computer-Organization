//Subject:     CO project 2 - Decoder
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      Ling Yin-Tao
//----------------------------------------------
//Date:        5/2
//----------------------------------------------
//Description: 0516320
//--------------------------------------------------------------------------------

module Decoder(
    instr_op_i,
	RegWrite_o,
	ALU_op_o,
	ALUSrc_o,
	RegDst_o,
	Branch_o
	);
     
//I/O ports
input  [6-1:0] instr_op_i;

output         RegWrite_o;
output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output         RegDst_o;
output         Branch_o;
 
//Internal Signals
reg    [3-1:0] ALU_op_o;
reg            ALUSrc_o;
reg            RegWrite_o;
reg            RegDst_o;
reg            Branch_o;

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
            ALU_op_o[3-1:0]=3'b000;
        end
        6'b001000: // I-type ADDi > 8
        begin
            RegWrite_o=1;
            ALUSrc_o=1;
            RegDst_o=0;
            Branch_o=0;
            ALU_op_o[3-1:0]=3'b011;
        end
        6'b000100: // BEQ > 4
        begin
            RegWrite_o=0;
            ALUSrc_o=0;
            RegDst_o=0;
            Branch_o=1;
            ALU_op_o[3-1:0]=3'b001;
        end
        6'b001010: // SLTi > 10
        begin
            RegWrite_o=1;
            ALUSrc_o=1;
            RegDst_o=0;
            Branch_o=0;
            ALU_op_o[3-1:0]=3'b100;
        end
        default:   // Set R-type
        begin
            RegWrite_o=1;
            ALUSrc_o=0;
            RegDst_o=1;
            Branch_o=0;
            ALU_op_o[3-1:0]=3'b000;
        end
	// NO lw ,sw, j, jal;
	endcase
end

endmodule





                    
                    