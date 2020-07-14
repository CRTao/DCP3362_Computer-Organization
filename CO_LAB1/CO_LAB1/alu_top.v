`timescale 1ns/1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:58:01 10/10/2013
// Design Name: 
// Module Name:    alu_top 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module alu_top(
               src1,       //1 bit source 1 (input)
               src2,       //1 bit source 2 (input)
               less,       //1 bit less     (input)
               A_invert,   //1 bit A_invert (input)
               B_invert,   //1 bit B_invert (input)
               cin,        //1 bit carry in (input)
               operation,  //operation      (input)
               result,     //1 bit result   (output)
               cout,       //1 bit carry out(output)
               );

input         src1;
input         src2;
input         less;
input         A_invert;
input         B_invert;
input         cin;
input [2-1:0] operation;

output        result;
output        cout;

reg           result;
reg           src1_temp;
reg           src2_temp;
reg           cin_temp;
wire  [1:0]   check_carryout;
assign check_carryout = {1'b0,src1_temp} + {1'b0,src2_temp} + {1'b0,cin};
assign cout = check_carryout[1];

always@ (*)
begin
    src1_temp = src1;
    src2_temp = src2;
    cin_temp = cin;
end

always@( src1_temp or src2_temp or operation )
begin
    case(operation)
        4'b0000: result = src1_temp & src2_temp;
        4'b0001: result = src1_temp | src2_temp;
        4'b0010: result = src1_temp + src2_temp;
        4'b0110: result = src1_temp - src2_temp;
        4'b1100: result = ~(src1_temp | src2_temp);
        4'b0111: result = (src1_temp < src2_temp )? 1'b1:1'b0 ;
        default: result = result;
    endcase
end

endmodule
