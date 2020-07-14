//Subject:     CO project 5 - ForwardUnit
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      Ling Yin-Tao
//----------------------------------------------
//Date:        6/13
//----------------------------------------------
//Description:
//--------------------------------------------------------------------------------
module ForwardUnit(
    DX_RS_addr_i,
    DX_RT_addr_i,
    XM_RD_addr_i,
    XM_RegWrite_i,
    MW_RD_addr_i,
    MW_RegWrite_i,
    Forward_A,
    Forward_B
	);

//I/O ports
input  [5-1:0]    DX_RS_addr_i;
input  [5-1:0]    DX_RT_addr_i;
input  [5-1:0]    XM_RD_addr_i;
input             XM_RegWrite_i;
input  [5-1:0]    MW_RD_addr_i;
input             MW_RegWrite_i;
output [2-1:0]    Forward_A;
output [2-1:0]    Forward_B;

//Internal signals
wire   [2-1:0]    Forward_A;
wire   [2-1:0]    Forward_B;

assign Forward_A = (XM_RegWrite_i & (XM_RD_addr_i == DX_RS_addr_i) & (XM_RD_addr_i != 0)) ? 2'b01 : 
					(MW_RegWrite_i & (MW_RD_addr_i == DX_RS_addr_i) & (MW_RD_addr_i != 0) ? 2'b10 : 2'b00);
assign Forward_B = (XM_RegWrite_i & (XM_RD_addr_i == DX_RT_addr_i) & (XM_RD_addr_i != 0)) ? 2'b01 : 
					(MW_RegWrite_i & (MW_RD_addr_i == DX_RT_addr_i) & (MW_RD_addr_i != 0) ? 2'b10 : 2'b00);

endmodule
