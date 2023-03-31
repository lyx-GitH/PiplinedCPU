`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/04/11 17:08:34
// Design Name: 
// Module Name: imm_gen
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
`define Ul 7'b0110111
`define Ua 7'b0010111
`define Jj 7'b1101111
`define Ij 7'b1100111
`define B  7'b1100011 
`define Il 7'b0000011
`define S  7'b0100011
`define Ia 7'b0010011
`define Cr 7'b1110011  

module ImmGen(
    input wire [31:0] inst,
    output reg [31:0] imm
    );

    // input wire [31:0] inst;
    // output reg [31:0] imm;

    always @(inst) begin
        if(inst[6:0] == `Ia || inst[6:0] == `Ij || inst[6:0] == `Il) begin
          imm[11:0]     = inst[31:20];
          imm[31:12]    = inst[31] == 1'b1 ? 20'hfffff : 20'h0;
        end else if (inst[6:0] == `B) begin
          imm[0]        = 0;  
          imm[12]       = inst[31];
          imm[10:5]     = inst[30:25];
          imm[4:1]      = inst[11:8];
          imm[11]       = inst[7];
          imm[31:12]    = inst[31] == 1'b1 ? 20'hfffff : 20'h0;
        end else if (inst[6:0] == `S) begin
          imm[11:5]     = inst[31:25];
          imm[4:0]      = inst[11:7];
          imm[31:12]    = inst[31] == 1'b1 ? 20'hfffff : 20'h0;
        end else if (inst[6:0] == `Ua || inst[6:0] == `Ul) begin
          imm[31:12]    = inst[31:12];
          imm[11:0]     = 0;  
        end else if (inst[6:0] == `Jj) begin
          imm[31:0]     = 0;
          imm[20]       = inst[31];
          imm[10:1]     = inst[30:21];
          imm[11]       = inst[20];
          imm[19:12]    = inst[19:12];
          imm[31:20]    = inst[31] == 1'b1 ? 12'hfff: 12'h0;
        end else if (inst[6:0] == `Cr) begin
          imm[4:0]      = inst[19:15];
          imm[31:4]     = inst[19] == 1'b1 ? 28'hfffffff : 28'h0;
        end else begin
          imm = 32'd4;
        end
    end
endmodule

