`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/10 13:45:40
// Design Name: 
// Module Name: Comparator
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
`include "Defines.vh"



module Comparator(
    input [31:0] a_val,
    input [31:0] b_val,
    input [2:0] ctrl,
    output result
    );
    
    reg cmp_res;
    wire [31:0] minus;
    assign minus = a_val + ~b_val+1;
    

    always @(*) begin
        case(ctrl)
        `CMP_EQ :  cmp_res = a_val == b_val ? 1'b1 : 1'b0;
        `CMP_NE :  cmp_res = a_val == b_val ? 1'b0 : 1'b1;
        `CMP_LT :  cmp_res = $signed(a_val) < $signed(b_val);
        `CMP_LTU:  cmp_res = a_val <b_val ? 1'b1 : 1'b0;
        `CMP_GEU:  cmp_res = a_val >= b_val ? 1'b1 : 1'b0;
        `CMP_GE :  cmp_res = $signed(a_val) >= $signed(b_val) ? 1'b1 : 1'b0;
        default :  cmp_res = 1'b0;
        endcase
    end

    assign result = cmp_res;
endmodule
