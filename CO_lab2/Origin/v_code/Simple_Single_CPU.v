//Subject:     CO project 2 - Simple Single CPU
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Simple_Single_CPU(
        clk_i,
		rst_i
		);
		
//I/O port
input         clk_i;
input         rst_i;

//Internal Signles

//********************PC signals
wire [31:0]PC_in;
wire [31:0]PC_out;
wire [31:0]PC_p4;
//********************Instr_Memory
wire [31:0]instr_out;
//********************Register signals
wire [ 4:0]RegWri_Reg1;
wire [31:0]RegWri_data;
wire [31:0]RegRed_data1;
wire [31:0]RegRed_data2;
//********************Decoder signals
wire RegDst, Jump, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite;
wire [ 2:0]ALUOP;
//********************ALU signals
wire [31:0]ALU_MUXin;
wire [ 3:0]ALUcout;
//********************Adder signals
wire [31:0]ADD1_ans;
wire [31:0]ADD2_ans;
//********************sign_extend signals
wire [31:0]sign_out;
//********************Shift signals
wire [31:0]shift_out;
//********************Zero AND reg
wire       Zero;
wire       AND_out;



//Greate componentes
ProgramCounter PC(
        .clk_i(clk_i),      
	    .rst_i (rst_i),     
	    .pc_in_i(PC_in) ,   
	    .pc_out_o(PC_out) 
	    );
	
Adder Adder1(
        .src1_i(32'd4),     
	    .src2_i(PC_out),     
	    .sum_o(ADD1_ans)    
	    );
	
Instr_Memory IM(
        .pc_addr_i(PC_out),  
	    .instr_o(instr_out)    
	    );

MUX_2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(instr_out[20:16]),
        .data1_i(instr_out[15:11]),
        .select_i(RegDst),
        .data_o(RegWri_Reg1)
        );	
		
Reg_File RF(
        .clk_i(clk_i),      
	    .rst_i(rst_i) ,     
        .RSaddr_i(instr_out[25:21]) ,  
        .RTaddr_i(instr_out[20:16]) ,  
        .RDaddr_i(RegWri_Reg1) ,  
        .RDdata_i(RegWri_data)  , 
        .RegWrite_i (RegWrite),
        .RSdata_o(RegRed_data1) ,  
        .RTdata_o(RegRed_data2)   
        );
	
Decoder Decoder(
        .instr_op_i(instr_out[31:26]), 
	    .RegWrite_o(RegWrite), 
	    .ALU_op_o(ALUOP),   
	    .ALUSrc_o(ALUSrc),   
	    .RegDst_o(RegDst),   
		.Branch_o(Branch)   
	    );

ALU_Ctrl AC(
        .funct_i(instr_out[5:0]),   
        .ALUOp_i(ALUOP),   
        .ALUCtrl_o(ALUcout) 
        );
	
Sign_Extend SE(
        .data_i(instr_out[15:0]),
        .data_o(sign_out)
        );

MUX_2to1 #(.size(32)) Mux_ALUSrc(
        .data0_i(RegRed_data2),
        .data1_i(sign_out),
        .select_i(ALUSrc),
        .data_o(ALU_MUXin)
        );	
		
ALU ALU(
        .src1_i(RegRed_data1),
	    .src2_i(ALU_MUXin),
	    .ctrl_i(ALUcout),
	    .result_o(RegWri_data),
		.zero_o(Zero)
	    );
		
Adder Adder2(
        .src1_i(ADD1_ans),     
	    .src2_i(shift_out),     
	    .sum_o(ADD2_ans)      
	    );
		
Shift_Left_Two_32 Shifter(
        .data_i(sign_out),
        .data_o(shift_out)
        ); 		
		
MUX_2to1 #(.size(32)) Mux_PC_Source(
        .data0_i(ADD1_ans),
        .data1_i(ADD2_ans),
        .select_i(AND_out),
        .data_o(PC_in)
        );	
		
and (AND_out, Branch, Zero);

endmodule
		  


