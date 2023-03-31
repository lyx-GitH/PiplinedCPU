`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/11 13:06:45
// Design Name: 
// Module Name: CPU_Ctrl
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`define BR      7'b1100011
`define LOAD    7'b0000011
`define SAVE    7'b0100011
`define AR      7'b0110011
`define AI      7'b0010011 
`define J       7'b1101111
`define Jr      7'b1100111
`define Lui     7'b0110111
`define Au      7'b0010111
`define Csr     7'b1110011  

module CPU_Ctrl(
    inst_opt,
    is_branch,
    mem_read,
    mem2reg,
    ALU_op,
    mem_wen,
    ALU_src,
    reg_wen,
    is_jal,
    is_jalr,
    is_lui,
    is_auipc
    );


    input [6:0] inst_opt;
    output is_branch; //
    output mem_read; //
    output mem2reg; 
    output ALU_op;
    output mem_wen; //
    output ALU_src;
    output reg_wen;
    output is_jal;
    output is_jalr;
    output is_lui;
    output is_auipc;
  

    assign ALU_op       = (inst_opt == `AR) | (inst_opt == `AI) | (inst_opt == `LOAD) | (inst_opt == `SAVE);
    assign ALU_src      = (inst_opt == `AR) | (inst_opt == `BR);
    
    assign mem_read     = inst_opt == `LOAD;
    assign mem_wen      = inst_opt == `SAVE;
    assign mem2reg      = inst_opt == `LOAD;

    assign reg_wen      = (inst_opt == `AR | inst_opt == `AI | inst_opt == `LOAD | inst_opt == 7'b1101111 | inst_opt == 7'b1100111 | inst_opt == `Csr | inst_opt == `Au | inst_opt == `Lui);

    assign is_branch    = inst_opt == `BR;
    assign is_jal       = inst_opt == 7'b1101111;
    assign is_jalr      = inst_opt == 7'b1100111;
    assign is_lui       = inst_opt == `Lui;
    assign is_auipc     = inst_opt == `Au;
    

    
    


endmodule

