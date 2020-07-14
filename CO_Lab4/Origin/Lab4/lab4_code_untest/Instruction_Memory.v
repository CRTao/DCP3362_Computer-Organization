`timescale 1ns / 1ps
//Subject:     CO project 4 - Instruction Memory
//--------------------------------------------------------------------------------
//Version:     1
//--------------------------------------------------------------------------------
//Writer:      TA
//----------------------------------------------
//Date:        
//----------------------------------------------
//Description: 
//--------------------------------------------------------------------------------
module Instruction_Memory(
    addr_i,
    instr_o
    );

// Interface
input   [31:0]  addr_i;
output  [31:0]  instr_o;

// Instruction File
reg     [31:0]  instruction_file    [0:31];

initial begin

    for ( i=0; i<32; i=i+1 )
            instruction_file[i] = 32'b0;
        
    $readmemb("CO_P4_test_1.txt", instruction_file);  //Read instruction from "CO_P4_test_1.txt"   
end

assign  instr_o = instruction_file[addr_i / 4];  

endmodule
