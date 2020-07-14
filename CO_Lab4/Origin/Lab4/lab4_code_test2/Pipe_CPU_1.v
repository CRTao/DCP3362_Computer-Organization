`timescale 1ns / 1ps
//Subject:     CO project 4 - Pipe CPU 1
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      Ling Yin-Tao
//----------------------------------------------
//Date:        5/31
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Pipe_CPU_1(
    clk_i,
    rst_i
    );
    
/****************************************
I/O ports
****************************************/
input clk_i;
input rst_i;

/****************************************
Internal signal
****************************************/

/**** IF stage ****/
wire [31:0]IF_mux_o;
wire [31:0]IF_pc_o;
wire [31:0]IF_im_o;
wire [31:0]IF_add_o;
wire PCSrc;


wire [31:0]FD_add_o;
wire [31:0]FD_instr_o;

/**** ID stage ****/
wire [31:0]ID_rf_o1;
wire [31:0]ID_rf_o2;
wire [31:0]ID_se_o;
wire [ 2:0] ID_ALUOP;
wire        ID_branch_o;
wire        ID_ALUSrc_o;
wire        ID_RegWrite_o;
wire        ID_RegDst_o;
wire        ID_Jump_o;
wire        ID_MemRead_o;
wire        ID_MemWrite_o;
wire        ID_MemtoReg_o;



wire [ 2:0] DX_ALUOP;
wire        DX_branch_o;
wire        DX_ALUSrc_o;
wire        DX_RegWrite_o;
wire        DX_RegDst_o;
wire        DX_Jump_o;
wire        DX_MemRead_o;
wire        DX_MemWrite_o;
wire        DX_MemtoReg_o;
wire [31:0]DX_Add_o;
wire [31:0]DX_rf_o1;
wire [31:0]DX_rf_o2;
wire [31:0]DX_se_o;
wire [ 4:0]DX_im_o0;
wire [ 4:0]DX_im_o1;

/**** EX stage ****/
wire [31:0]EX_Sft2_o;
wire [31:0]EX_Add_o;
wire [31:0]EX_mux1_o;
wire [ 4:0]EX_mux2_o;
wire [ 3:0]EX_ALUctrl_o;
wire [31:0]EX_ALUresult_o;
wire       EX_ALUzero_o;


wire        XM_RegWrite_o;
wire        XM_Jump_o;
wire        XM_MemRead_o;
wire        XM_MemWrite_o;
wire        XM_MemtoReg_o;
wire        XM_branch_o;
wire [31:0]XM_ALUresult_o;
wire       XM_ALUzero_o;
wire [31:0]XM_Add_o;
wire [31:0]XM_rf_o2;
wire [ 4:0]XM_mux2_o;

/**** MEM stage ****/
wire [31:0]MM_dm_o;


wire [ 4:0]MW_mux2_o;
wire        MW_RegWrite_o;
wire        MW_MemtoReg_o;
wire [31:0]MW_ALUresult_o;
wire [31:0]MW_dm_o;

/**** WB stage ****/
wire [31:0]WB_mux_o;

/**** Harzard ****/
wire PC_Write;
wire IF_Write;
wire IF_Flush;
wire ID_Flush;
wire EX_Flush;
wire [31:0]ALU_in1;
wire [31:0]MUX2MUX;
wire [2-1:0]  Forward_A;
wire [2-1:0]  Forward_B;


/****************************************
Instantiate modules
****************************************/
//Instantiate the components in IF stage
MUX_2to1 #(.size(32)) Mux0(
		.data0_i(IF_add_o),
		.data1_i(XM_Add_o),
		.select_i(PCSrc),
		.data_o(IF_mux_o)
		);

ProgramCounter PC(
        .clk_i(clk_i),      
	    .rst_i (rst_i),     
		.PC_Write_i(PC_Write),
	    .pc_in_i(IF_mux_o) ,   
	    .pc_out_o(IF_pc_o) 
	    );

Instruction_Memory IM(
        .addr_i(IF_pc_o),  
	    .instr_o(IF_im_o)    
	    );
			
Adder AdderPlus4(
        .src1_i(IF_pc_o),     
	    .src2_i(32'd4),     
	    .sum_o(IF_add_o)    
	    );

Pipe_Reg #(.size(64)) IF_ID(       //N is the total length of input/output
		.clk_i(clk_i),  
		.rst_i(rst_i),
        .flush_i(IF_Flush),
        .write_i(IF_Write),
		.data_i({IF_add_o, IF_im_o}),
		.data_o({FD_add_o, FD_instr_o})
		);

//Instantiate the components in ID stage
Reg_File RF(
        .clk_i(clk_i),      
	    .rst_i(rst_i) ,     
        .RSaddr_i(FD_instr_o[25:21]) ,  
        .RTaddr_i(FD_instr_o[20:16]) ,  
        .RDaddr_i(MW_mux2_o) ,  
        .RDdata_i(WB_mux_o)  , 
        .RegWrite_i (MW_RegWrite_o),
        .RSdata_o(ID_rf_o1) ,  
        .RTdata_o(ID_rf_o2)   
        );

Decoder Control(
        .instr_op_i(FD_instr_o[31:26]), 
	    .RegWrite_o(ID_RegWrite_o), 
	    .ALU_op_o(ID_ALUOP),   
	    .ALUSrc_o(ID_ALUSrc_o),   
	    .RegDst_o(ID_RegDst_o),   
		.Branch_o(ID_branch_o),
		.MemRead_o(ID_MemRead_o),
		.MemWrite_o(ID_MemWrite_o),
		.MemtoReg_o(ID_MemtoReg_o),
		.jump_o(ID_Jump_o)
	    );

Sign_Extend SE(
        .data_i(FD_instr_o[15:0]),
        .data_o(ID_se_o)
        );

Pipe_Reg #(.size(149)) ID_EX(
		.clk_i(clk_i),  
		.rst_i(rst_i),
        .flush_i(ID_Flush),
        .write_i(1'b1),
		.data_i({ID_RegWrite_o, ID_ALUOP, ID_ALUSrc_o, ID_RegDst_o,
				 ID_branch_o, ID_Jump_o, ID_MemRead_o, ID_MemWrite_o, ID_MemtoReg_o,
				 FD_add_o, ID_rf_o1, ID_rf_o2, ID_se_o,
				 FD_instr_o[20:16], FD_instr_o[15:11]}),
		.data_o({DX_RegWrite_o, DX_ALUOP, DX_ALUSrc_o, DX_RegDst_o,
				 DX_branch_o, DX_Jump_o, DX_MemRead_o, DX_MemWrite_o, DX_MemtoReg_o,
				 DX_Add_o, DX_rf_o1, DX_rf_o2, DX_se_o, DX_im_o0, DX_im_o1})
		);

//Instantiate the components in EX stage	   
Shift_Left_Two_32 Shifter(
        .data_i(DX_se_o),
        .data_o(EX_Sft2_o)
        ); 		

ALU ALU(
        .src1_i(ALU_in1),
	    .src2_i(EX_mux1_o),
	    .ctrl_i(EX_ALUctrl_o),
	    .result_o(EX_ALUresult_o),
		.zero_o(EX_ALUzero_o)
	    );
		
ALU_Ctrl ALU_Control(
        .funct_i(DX_se_o[5:0]),   
        .ALUOp_i(DX_ALUOP),   
        .ALUCtrl_o(EX_ALUctrl_o) 
        );

MUX_2to1 #(.size(32)) Mux1(
        .data0_i(MUX2MUX),
        .data1_i(DX_se_o),
        .select_i(DX_ALUSrc_o),
        .data_o(EX_mux1_o)
        );	
		
MUX_2to1 #(.size(5)) Mux2(
        .data0_i(DX_im_o0),
        .data1_i(DX_im_o1),
        .select_i(DX_RegDst_o),
        .data_o(EX_mux2_o)
        );	

Mux_4to1 #(.size(32)) Mux4(
      .data0_i(DX_rf_o1),
      .data1_i(XM_ALUresult_o),
      .data2_i(WB_mux_o),
      .data3_i(32'b0),
      .select_i(Forward_A),
      .data_o(ALU_in1)
    );

Mux_4to1 #(.size(32)) Mux5(
      .data0_i(DX_rf_o2),
      .data1_i(XM_ALUresult_o),
      .data2_i(WB_mux_o),
      .data3_i(32'b0),
      .select_i(Forward_B),
      .data_o(MUX2MUX)
    );

ForwardUnit Forwarding(
      .DX_RS_addr_i(DX_rf_o1),
      .DX_RT_addr_i(DX_rf_o2),
      .XM_RD_addr_i(XM_mux2_o),
      .XM_RegWrite_i(XM_RegWrite_o),
      .MW_RD_addr_i(MW_mux2_o),   //****
      .MW_RegWrite_i(MW_RegWrite_o),
      .Forward_A(Forward_A),
      .Forward_B(Forward_B)
    );

HazardDetectUnit Hazard(
      .PC_Select(PCSrc),
      .FD_RS_addr_i(FD_instr_o[25:21]),
      .FD_RT_addr_i(FD_instr_o[20:16]),
      .DX_RT_addr_i(DX_rf_o2),
      .DX_MemRead_i(DX_MemRead_o),
      .PC_Write(PC_Write),
      .IF_Write(IF_Write),
      .IF_Flush(IF_Flush),
      .ID_Flush(ID_Flush),
      .EX_Flush(EX_Flush)
);
	
Adder Add_pc_branch(
        .src1_i(DX_Add_o),     
	    .src2_i(EX_Sft2_o),     
	    .sum_o(EX_Add_o)      
	    );

Pipe_Reg #(.size(108)) EX_MEM(
		.clk_i(clk_i),  
		.rst_i(rst_i), 
        .flush_i(EX_Flush),
        .write_i(1'b1),
		.data_i({DX_RegWrite_o, DX_Jump_o, DX_MemRead_o,
				 DX_MemWrite_o, DX_MemtoReg_o, DX_branch_o,
				 EX_Add_o, EX_ALUzero_o, EX_ALUresult_o,
				 DX_rf_o2, EX_mux2_o}),
		.data_o({XM_RegWrite_o, XM_Jump_o, XM_MemRead_o, 
				 XM_MemWrite_o, XM_MemtoReg_o, XM_branch_o,
				 XM_Add_o, XM_ALUzero_o, XM_ALUresult_o,
				 XM_rf_o2, XM_mux2_o})
		);


//Instantiate the components in MEM stage
Data_Memory DM(
		.clk_i(clk_i),
		.addr_i(XM_ALUresult_o),
		.data_i(XM_rf_o2),
		.MemRead_i(XM_MemRead_o),
		.MemWrite_i(XM_MemWrite_o),
		.data_o(MM_dm_o)
		);

Pipe_Reg #(.size(71)) MEM_WB(
        .clk_i(clk_i),
		.rst_i (rst_i),
        .flush_i(1'b0),
        .write_i(1'b1),
		.data_i({XM_RegWrite_o, XM_MemtoReg_o, MM_dm_o, XM_ALUresult_o, XM_mux2_o}),
		.data_o({MW_RegWrite_o, MW_MemtoReg_o, MW_dm_o, MW_ALUresult_o, MW_mux2_o})
		);


//Instantiate the components in WB stage
MUX_2to1 #(.size(32)) Mux3(
        .data0_i(MW_ALUresult_o),
		.data1_i(MW_dm_o),
        .select_i(MW_MemtoReg_o),
        .data_o(WB_mux_o)
        );

/****************************************
signal assignment
****************************************/

and (PCSrc, XM_branch_o, XM_ALUzero_o);

endmodule

