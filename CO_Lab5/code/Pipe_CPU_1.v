//Subject:     CO project 4 - Pipe CPU 1
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:
//----------------------------------------------
//Date:
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
wire [31:0] IF_pc_i;
wire [31:0] IF_pc_o;
wire [31:0] IF_pc_add;
wire [31:0] IF_instr_o;
wire [31:0] FD_pc_o;
wire [31:0] FD_instr_o;

/**** ID stage ****/
wire [31:0] ID_RSdata_o;
wire [31:0] ID_RTdata_o;
wire [31:0] ID_se_o;
wire [31:0] DX_pc_o;
wire [31:0] DX_RSdata_o;
wire [ 4:0] DX_RS_addr_o;
wire [31:0] DX_RTdata_o;
wire [ 4:0] DX_RT_addr_o;
wire [ 4:0] DX_Rd_addr_o;
wire [31:0] DX_se_o;
wire [ 2:0] ID_AluOp;
wire        ID_AluSrc;
wire        ID_RegDst;
wire        ID_MemRead;
wire        ID_MemWrite;
wire        ID_Branch;
wire        ID_RegWrite;
wire        ID_MemToReg;

//control signal
wire        MW_RegWrite;

/**** EX stage ****/
wire [ 3:0] EX_ctrl_i;
wire [31:0] EX_m2m_i;
wire [31:0] EX_Addsft_o;
wire        EX_zero_o;
wire [31:0] EX_ALUresult_o;
wire        XM_zero_o;
wire [31:0] XM_pc_shift_o;
wire [ 4:0] EX_dst_addr_o;
wire [ 4:0] XM_dst_addr_o;
wire [31:0] XM_ALUresult_o;
wire [31:0] XM_write_data_o;
wire        DX_MemRead;
wire        DX_MemWrite;
wire        DX_Branch;
wire        DX_RegWrite;
wire        DX_MemToReg;
wire [ 1:0] Forward_A;
wire [ 1:0] Forward_B;
wire [31:0] EX_ALU_in_1;
wire [31:0] EX_ALU_in_2;

//control signal
wire [ 2:0] DX_AluOp;
wire        DX_AluSrc;
wire        DX_RegDst;

/**** MEM stage ****/
wire [31:0] ME_read_data_o;
wire [31:0] MW_read_data_o;
wire [ 4:0] MW_dst_addr_o;
wire [31:0] MW_result_o;
wire [31:0] ME_write_data_o;
wire        XM_RegWrite;
wire        XM_MemToReg;

//control signal
wire        XM_MemRead;
wire        XM_MemWrite;
wire        XM_Branch;

/**** WB stage ****/

//control signal
wire        MW_MemToReg;

wire        PCSrc;

// Hazard Unit signal
wire        PC_Write;
wire        IF_Write;
wire        IF_Flush;
wire        ID_Flush;
wire        EX_Flush;

/****************************************
Instnatiate modules
****************************************/
//Instantiate the components in IF stage

MUX_2to1 #(.size(32)) Mux0(
      .data0_i(IF_pc_add),
      .data1_i(XM_pc_shift_o),
      .select_i(PCSrc), 
      .data_o(IF_pc_i)
    );

ProgramCounter PC(
      .clk_i(clk_i),
      .rst_i(rst_i),
	  .PC_Write_i(PC_Write),
      .pc_in_i(IF_pc_i),
      .pc_out_o(IF_pc_o)
    );

Instruction_Memory IM(
      .addr_i(IF_pc_o),
      .instr_o(IF_instr_o)
    );

Adder Add_pc(
      .src1_i(IF_pc_o),
      .src2_i(32'd4),
      .sum_o(IF_pc_add)
	);


Pipe_Reg #(.size(64)) IF_ID(       //N is the total length of input/output
		.clk_i(clk_i),  
		.rst_i(rst_i),
        .flush_i(IF_Flush),
        .write_i(IF_Write),
		.data_i({IF_pc_add, IF_instr_o}),
		.data_o({FD_pc_o, FD_instr_o})
		);
		

//Instantiate the components in ID stage
Reg_File RF(
      .clk_i(clk_i),
      .rst_i(rst_i),
      .RSaddr_i(FD_instr_o[25:21]),
      .RTaddr_i(FD_instr_o[20:16]),
      .RDaddr_i(MW_dst_addr_o),
      .RDdata_i(ME_write_data_o) ,
      .RegWrite_i(MW_RegWrite),
      .RSdata_o(ID_RSdata_o),
      .RTdata_o(ID_RTdata_o)
		);

Decoder Control(
      .instr_op_i(FD_instr_o[31:26]),
      .ALU_op_o(ID_AluOp),
      .ALUSrc_o(ID_AluSrc),
      .RegDst_o(ID_RegDst),
      .MemRead_o(ID_MemRead),
      .MemWrite_o(ID_MemWrite),
      .Branch_o(ID_Branch),
      .RegWrite_o(ID_RegWrite),
      .MemtoReg_o(ID_MemToReg)
		);

Sign_Extend SE(
      .data_i(FD_instr_o[15:0]),
      .data_o(ID_se_o)
		);

Pipe_Reg #(.size(153)) ID_EX(
		.clk_i(clk_i),  
		.rst_i(rst_i),
        .flush_i(ID_Flush),
        .write_i(1'b1),
		.data_i({ID_AluOp, ID_AluSrc, ID_RegDst, 
				ID_MemRead, ID_MemWrite, ID_Branch,
				ID_RegWrite,ID_MemToReg,
				FD_pc_o, ID_RSdata_o,FD_instr_o[25:21],ID_RTdata_o,
				FD_instr_o[20:16],FD_instr_o[15:11],ID_se_o}),
		.data_o({DX_AluOp, DX_AluSrc, DX_RegDst,
				DX_MemRead, DX_MemWrite, DX_Branch,
				DX_RegWrite,DX_MemToReg,
				DX_pc_o, DX_RSdata_o,  DX_RS_addr_o,   DX_RTdata_o,
				DX_RT_addr_o     ,DX_Rd_addr_o     ,DX_se_o})
		);

//Instantiate the components in EX stage


Adder  Add_pc_branch(
      .src1_i(DX_pc_o),
      .src2_i({DX_se_o[29:0], 2'b00}),
      .sum_o(EX_Addsft_o)
		);

ALU ALU(
      .src1_i(EX_ALU_in_1),
      .src2_i(EX_ALU_in_2),
      .ctrl_i(EX_ctrl_i),
      .result_o(EX_ALUresult_o),
      .zero_o(EX_zero_o)
		);

ALU_Ctrl ALU_Control(
      .funct_i(DX_se_o[5:0]),
      .ALUOp_i(DX_AluOp),
      .ALUCtrl_o(EX_ctrl_i)
		);

MUX_2to1 #(.size(32)) Mux1(
      .data0_i(EX_m2m_i),
      .data1_i(DX_se_o),
      .select_i(DX_AluSrc),
      .data_o(EX_ALU_in_2)
    );

MUX_2to1 #(.size(5)) Mux2(
      .data0_i(DX_RT_addr_o),
      .data1_i(DX_Rd_addr_o),
      .select_i(DX_RegDst),
      .data_o(EX_dst_addr_o)
    );

Mux_4to1 #(.size(32)) Mux4(
      .data0_i(DX_RSdata_o),
      .data1_i(XM_ALUresult_o),
      .data2_i(ME_write_data_o),
      .data3_i(32'b0),
      .select_i(Forward_A),
      .data_o(EX_ALU_in_1)
    );

Mux_4to1 #(.size(32)) Mux5(
      .data0_i(DX_RTdata_o),
      .data1_i(XM_ALUresult_o),
      .data2_i(ME_write_data_o),
      .data3_i(32'b0),
      .select_i(Forward_B),
      .data_o(EX_m2m_i)
    );

ForwardUnit Forwarding(
      .DX_RS_addr_i(DX_RS_addr_o),
      .DX_RT_addr_i(DX_RT_addr_o),
      .XM_RD_addr_i(XM_dst_addr_o),
      .XM_RegWrite_i(XM_RegWrite),
      .MW_RD_addr_i(MW_dst_addr_o),
      .MW_RegWrite_i(MW_RegWrite),
      .Forward_A(Forward_A),
      .Forward_B(Forward_B)
    );

HazardDetectUnit Hazard(
      .PC_Select(PCSrc),
      .FD_RS_addr_i(FD_instr_o[25:21]),
      .FD_RT_addr_i(FD_instr_o[20:16]),
      .DX_RT_addr_i(DX_RT_addr_o),
      .DX_MemRead_i(DX_MemRead),
      .PC_Write(PC_Write),
      .IF_Write(IF_Write),
      .IF_Flush(IF_Flush),
      .ID_Flush(ID_Flush),
      .EX_Flush(EX_Flush)
);

Pipe_Reg #(.size(107)) EX_MEM(
		.clk_i(clk_i),  
		.rst_i(rst_i), 
        .flush_i(EX_Flush),
        .write_i(1'b1),
		.data_i({DX_Branch,DX_MemRead,DX_MemWrite,DX_RegWrite,DX_MemToReg,EX_Addsft_o,
				EX_zero_o,EX_dst_addr_o,EX_ALUresult_o,EX_m2m_i}),
		.data_o({XM_Branch,XM_MemRead,XM_MemWrite,XM_RegWrite,XM_MemToReg,XM_pc_shift_o,
				XM_zero_o,XM_dst_addr_o,XM_ALUresult_o,XM_write_data_o})
		);


//Instantiate the components in MEM stage
Data_Memory DM(
      .clk_i(clk_i),
      .addr_i(XM_ALUresult_o),
      .data_i(XM_write_data_o),
      .MemRead_i(XM_MemRead),
      .MemWrite_i(XM_MemWrite),
      .data_o(ME_read_data_o)
    );
	
	
Pipe_Reg #(.size(71)) MEM_WB(
        .clk_i(clk_i),
		.rst_i (rst_i),
        .flush_i(1'b0),
        .write_i(1'b1),
		.data_i({XM_MemToReg, XM_RegWrite, ME_read_data_o, XM_dst_addr_o, XM_ALUresult_o}),
		.data_o({MW_MemToReg, MW_RegWrite, MW_read_data_o, MW_dst_addr_o, MW_result_o})
		);


//Instantiate the components in WB stage
MUX_2to1 #(.size(32)) Mux3(
      .data0_i(MW_result_o),
      .data1_i(MW_read_data_o),
      .select_i(MW_MemToReg),
      .data_o(ME_write_data_o)
    );
	
and (PCSrc, XM_Branch , XM_zero_o);

	
/****************************************
signal assignment
****************************************/
endmodule
