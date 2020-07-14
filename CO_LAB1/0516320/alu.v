`timescale 1ns/1ps

//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    15:15:11 08/18/2013
// Design Name:
// Module Name:    alu
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

module alu(
           clk,           // system clock              (input)
           rst_n,         // negative reset            (input)
           src1,          // 32 bits source 1          (input)
           src2,          // 32 bits source 2          (input)
           ALU_control,   // 4 bits ALU control input  (input)
			  //bonus_control, // 3 bits bonus control input(input) 
           result,        // 32 bits result            (output)
           zero,          // 1 bit when the output is 0, zero must be set (output)
           cout,          // 1 bit carry out           (output)
           overflow       // 1 bit overflow            (output)
           );

input           clk;
input           rst_n;
input          [32-1:0] src1;
input          [32-1:0] src2;
input   [4-1:0] ALU_control;

output [32-1:0] result;
output          zero;
output          cout;
output          overflow;

reg    [32-1:0] result;
reg             zero=0;
reg             cout=0;
reg             overflow=0;
reg             plus;
reg             minus;

reg    [31:0]   out;
reg    [32:0]   oversum;
reg    signed [31:0]   sign_r1;
reg    signed [31:0]   sign_r2;
reg    signed [31:0]   out_temp;
reg             cout_temp;
reg             overflow_temp;

always@ (*)
    begin 
        sign_r1 = src1;
        sign_r2 = src2;
        case(ALU_control)
            4'b0000: begin
                out=src1&src2;
                cout_temp = 0;
                overflow_temp = 0;
                end
            4'b0001: begin
                out=src1|src2;
                cout_temp = 0;
                overflow_temp = 0;
                end
            4'b0010: begin
                out=sign_r1+sign_r2;
                {cout_temp,out_temp} = src1+src2;
                oversum = {src1[31], src1} + {src2[31], src2};
                overflow_temp = oversum[32] ^ oversum[31];
                end
                
            4'b0110: begin
                out=sign_r1-sign_r2;
                oversum = 33'h1_0000_0000-src2;
                {cout_temp,out_temp} = oversum + {1'b0,src1};
                overflow_temp = (sign_r1<0)&(sign_r2>0)&(out_temp[31]==0);
                end
            4'b1100: begin
                out= ~(src1|src2);
                cout_temp = 0;
                overflow_temp = 0;
                end
            4'b0111: begin
                out= (sign_r1<sign_r2)?32'd1:32'd0;
                cout_temp = 0;
                overflow_temp = 0;
                end
			default: out<=0;
        endcase
end




always@( posedge clk or negedge rst_n ) 
begin
	if(!rst_n) begin
		result = 0;
		zero = 0;
	end
	else begin
		result = out;
		if(result==0) zero = 1; else zero = 0; 
		cout = cout_temp;
		overflow = overflow_temp;
	end
end

endmodule
