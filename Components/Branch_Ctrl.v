`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/15 09:47:18
// Design Name: 
// Module Name: Branch_Ctrl
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


module Branch_Ctrl(
    cmp_res,
    is_branch,
    is_jal,
    is_jalr, 
    do_branch
    );


    input cmp_res;
    input is_branch;
    input is_jal;
    input is_jalr;
    output do_branch;

    assign do_branch = (is_branch & cmp_res) | is_jal | is_jalr;

    
endmodule

