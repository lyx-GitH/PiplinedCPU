`timescale 1ns/1ps

module Stall_Ctrl(
    input wire [4:0] ID_rs1,
    input wire [4:0] ID_rs2,
    input wire [4:0] EX_rd,
    input wire [4:0] MEM_rd,

    input wire EX_reg_wen,
    input wire MEM_reg_wen,

    input wire EX_is_branch,
    input wire EX_is_jal,
    input wire EX_is_jalr,

    input wire MEM_is_branch,
    input wire MEM_is_jal,
    input wire MEM_is_jalr,

    
    output reg is_stall
);
    initial begin
        is_stall = 1'b0;
    end

  always @(*) begin
      if(EX_is_jal || EX_is_jalr || EX_is_branch 
      || MEM_is_jal || MEM_is_jalr || MEM_is_branch) begin
          is_stall = 1'b1;
      end else if(EX_reg_wen == 1'b1 && (EX_rd == ID_rs1 || EX_rd == ID_rs2)) begin
          is_stall = 1'b1;
      end else if(MEM_reg_wen == 1'b1 && (MEM_rd == ID_rs1 || MEM_rd == ID_rs2)) begin
          is_stall = 1'b1;
      end else begin
          is_stall = 1'b0;
      end

  end


endmodule