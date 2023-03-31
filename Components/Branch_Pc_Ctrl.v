`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/15 10:37:21
// Design Name: 
// Module Name: Branch_Pc_Ctrl
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


module Branch_Pc_Ctrl(
    alu_res,
    br_alu_res,
    is_jalr,
    br_pc
    );

    input wire [31:0] alu_res;
    input wire [31:0] br_alu_res;
    input wire is_jalr;
    output reg [31:0] br_pc;

    always @(*) begin
        if (is_jalr) begin
          br_pc = alu_res & 32'hfffffffe;
        end else begin
          br_pc = br_alu_res;
        end
    end


endmodule

