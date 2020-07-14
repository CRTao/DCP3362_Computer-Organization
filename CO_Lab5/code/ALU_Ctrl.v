//Subject:     CO project 2 - ALU Controller
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      Ling Yin-Tao
//----------------------------------------------
//Date:        5/2
//----------------------------------------------
//Description: 0516320
//--------------------------------------------------------------------------------

module ALU_Ctrl(
          funct_i,
          ALUOp_i,
          ALUCtrl_o
          );
          
//I/O ports 
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALUCtrl_o;    
     
//Internal Signals
reg        [4-1:0] ALUCtrl_o;

//Parameter

       
//Select exact operation

always @(funct_i,ALUOp_i)begin
	case(ALUOp_i)
	3'b011:ALUCtrl_o<=2;           // ADDi,lw,sw >> run ADD
	3'b001:ALUCtrl_o<=6;           // BEQ        >> run SUB
	3'b100:ALUCtrl_o<=7;           // I-type SLTi
	3'b101:ALUCtrl_o<=12;          // BNE
	3'b110:ALUCtrl_o<=13;          // BGE
	3'b111:ALUCtrl_o<=14;          // BGT
	3'b000:case(funct_i)
			32:ALUCtrl_o<=2;       // R-type ADD
			34:ALUCtrl_o<=6;       // R-type SUB
			36:ALUCtrl_o<=0;       // R-type AND
			37:ALUCtrl_o<=1;       // R-type OR
			42:ALUCtrl_o<=7;       // R-type SLT
			24:ALUCtrl_o<=11;       // R-type MULT
			default:ALUCtrl_o<=18;
		endcase

	endcase
end

endmodule     





                    
                    