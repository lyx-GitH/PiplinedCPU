`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/15 10:17:53
// Design Name: 
// Module Name: Rd_Ctrl
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


module Rd_Ctrl(
    mem2reg,
    is_jal,
    is_jalr,
    is_auipc,
    is_lui,
    alu_res,
    imm,
    dmem_o_data,
    pc,
    reg_i_data

    );

    input wire mem2reg;
    input wire is_jal;
    input wire is_jalr;
    input wire is_lui;
    input wire is_auipc;
    input wire [31:0] pc;
    input wire [31:0] alu_res;
    input wire [31:0] imm;
    input wire [31:0] dmem_o_data;
    output reg [31:0] reg_i_data;
  

    always @(*) begin
        if(mem2reg) begin
          reg_i_data = dmem_o_data;
        end else begin
          if(is_lui) begin
            reg_i_data = imm;
          end else if(is_jal ||is_jalr) begin
            reg_i_data = pc + 32'd4;
          end else if(is_auipc) begin
            reg_i_data = pc + imm;
          end else begin
            reg_i_data = alu_res;
          end
        end
    end

endmodule

