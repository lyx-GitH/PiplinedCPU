`timescale 1ns/1ps
`include "Defines.vh"

module ID_EX_gate (
    input wire clk,
    input wire is_stall,

    input wire [31:0] ID_pc,
    input wire [31:0] ID_rs1_val,
    input wire [31:0] ID_rs2_val,
    input wire [31:0] ID_imm,
    input wire [31:0] ID_inst,
    input wire [4:0] ID_reg_addr,
    input wire ID_is_branch,
    input wire ID_mem2reg,
    input wire ID_ALU_op,
    input wire ID_mem_wen,
    input wire ID_mem_read,
    input wire ID_ALU_src,
    input wire ID_reg_wen,
    input wire ID_is_jal,
    input wire ID_is_jalr,
    input wire ID_is_auipc,
    input wire ID_is_lui,

    output reg EX_is_lui,
    output reg EX_is_branch,
    output reg EX_mem2reg,
    output reg EX_mem_read,
    output reg EX_ALU_src,
    output reg EX_mem_wen,
    output reg EX_ALU_op,
    output reg EX_reg_wen,
    output reg EX_is_jal,
    output reg EX_is_jalr,
    output reg EX_is_auipc,
    output reg [4:0] EX_reg_addr,
    output reg [31:0] EX_pc,
    output reg [31:0] EX_rs1_val,
    output reg [31:0] EX_rs2_val,
    output reg [31:0] EX_imm,
    output reg [31:0] EX_inst
);  
    initial begin
            EX_is_branch <= 0;
            EX_mem2reg <= 0;
            EX_mem_read <= 0;
            EX_ALU_src <= 0;
            EX_reg_wen <= 0;
            EX_is_lui <= 0;
            EX_is_jal <= 0;
            EX_is_jalr <= 0;
            EX_is_auipc <= 0;
            EX_reg_addr <= 0;
            EX_pc <= 0;
            EX_ALU_op <= 0;
            EX_rs1_val <= 0;
            EX_rs2_val <= 0;
            EX_imm <= 0;
            EX_inst <= `NOP_INST;    
    end

    always @(posedge clk) begin
        if(is_stall == 1'b0) begin
            EX_is_branch <= ID_is_branch;
            EX_mem2reg <= ID_mem2reg;
            EX_mem_read <= ID_mem_read;
            EX_ALU_src <= ID_ALU_src;
            EX_reg_wen <= ID_reg_wen;
            EX_is_lui  <= ID_is_lui;
            EX_is_jal <= ID_is_jal;
            EX_is_jalr <= ID_is_jalr;
            EX_is_auipc <= EX_is_auipc;
            EX_reg_addr <= ID_reg_addr;
            EX_pc <= ID_pc;
            EX_ALU_op <= ID_ALU_op;
            EX_rs1_val <= ID_rs1_val;
            EX_rs2_val <= ID_rs2_val;
            EX_imm <= ID_imm;
            EX_inst <= ID_inst;
        end else begin
            EX_is_branch <= 0;
            EX_mem2reg <= 0;
            EX_mem_read <= 0;
            EX_ALU_src <= 0;
            EX_reg_wen <= 0;
            EX_is_lui <= 0;
            EX_is_jal <= 0;
            EX_is_jalr <= 0;
            EX_is_auipc <= 0;
            EX_reg_addr <= 0;
            EX_pc <= 0;
            EX_ALU_op <= 0;
            EX_rs1_val <= 0;
            EX_rs2_val <= 0;
            EX_imm <= 0;
            EX_inst <= `NOP_INST;
        end
       
    end

endmodule //ID_EX_gate