`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/12 10:24:47
// Design Name: 
// Module Name: Cmp_Ctrl
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

module Cmp_Ctrl(
    input wire [31:0] inst,
    input wire is_branch,
    output reg [2:0] cmp_ctrl
    );

    always @(inst) begin
        if(is_branch) begin
          case (inst[14:12])
            3'b000: cmp_ctrl    = `CMP_EQ;
            3'b001: cmp_ctrl    = `CMP_NE;
            3'b100: cmp_ctrl    = `CMP_LT;
            3'b101: cmp_ctrl    = `CMP_GE;
            3'b110: cmp_ctrl    = `CMP_LTU;
            3'b111: cmp_ctrl    = `CMP_GEU;
            default: cmp_ctrl = 0;
        endcase
        end else begin
          cmp_ctrl = 0;
        end
    end
endmodule

