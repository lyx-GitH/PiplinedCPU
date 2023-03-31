`timescale 1ns/1ps

module EX_MEM_gate (
    input wire clk,
    input wire [31:0] EX_pc,
    input wire [31:0] EX_alu_res,
    input wire [31:0] EX_br_alu_res,
    input wire [31:0] EX_imm,
    input wire [31:0] EX_rs2_val,
    input wire [31:0] EX_inst,
    input wire EX_cmp_res,
    input wire EX_is_jal,
    input wire EX_is_jalr,
    input wire EX_is_auipc,
    input wire EX_is_lui,
    input wire EX_is_branch,
    input wire EX_mem2reg,
    input wire EX_reg_wen,

    output reg [31:0] MEM_pc,
    output reg [31:0] MEM_alu_res,
    output reg [31:0] MEM_br_alu_res,
    output reg [31:0] MEM_imm,
    output reg [31:0] MEM_rs2_val,
    output reg [31:0] MEM_inst,
    output reg MEM_cmp_res,
    output reg MEM_is_jalr,
    output reg MEM_is_jal,
    output reg MEM_is_auipc,
    output reg MEM_is_lui,
    output reg MEM_is_branch,
    output reg MEM_mem2reg,
    output reg MME_reg_wen
);

  always @(posedge clk) begin
    MEM_pc          <= EX_pc;
    MEM_alu_res     <= EX_alu_res;
    MEM_br_alu_res  <= EX_br_alu_res;
    MEM_imm         <= EX_imm;
    MEM_rs2_val     <= EX_rs2_val;
    MEM_inst        <= EX_inst;
    MEM_cmp_res     <= EX_cmp_res;
    MEM_is_jal      <= EX_is_jal;
    MEM_is_jalr     <= EX_is_jalr;
    MEM_is_auipc    <= EX_is_auipc;
    MEM_is_lui      <= EX_is_lui;
    MEM_is_branch   <= EX_is_branch;
    MEM_mem2reg     <= EX_mem2reg;
    MEM_reg_wen     <= EX_reg_wen
  end

endmodule //EX_MEM_gate