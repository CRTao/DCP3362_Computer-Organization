//Subject:     CO project 2 - MUX 221
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      Ling Yin-Tao
//----------------------------------------------
//Date:        5/2
//----------------------------------------------
//Description: 0516320
//--------------------------------------------------------------------------------
     
module MUX_2to1(
               data0_i,
               data1_i,
               select_i,
               data_o
               );

parameter size = 0;			   
			
//I/O ports               
input   [size-1:0] data0_i;          
input   [size-1:0] data1_i;
input              select_i;
output  [size-1:0] data_o; 

//Internal Signals
reg     [size-1:0] data_o;

//Main function

always @(*)
	case(select_i)
		0:data_o <= data0_i;
		1:data_o <= data1_i;
		default: data_o <= data_o;
	endcase


endmodule      
          
          