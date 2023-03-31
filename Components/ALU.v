`timescale 1ns / 1ps
`include "Defines.vh"
`include "Comparator.v"

module Alu(
    input [31:0] a_val,
    input [31:0] b_val,
    input [3:0] ctrl,
    output [31:0] result
);

reg [31:0] alu_out;
reg [2:0] comp_ctrl;
wire comp_res;

wire [4:0] shift_val;
assign shift_val = b_val[4:0];
Comparator alu_comp(
    .a_val(a_val),
    .b_val(b_val),
    .ctrl(comp_ctrl),
    .result(comp_res)
);

always @(*) begin
    case(ctrl)
    `ALU_ADD: alu_out = a_val + b_val;
    `ALU_SUB: alu_out = a_val + 1'b1 + ~(b_val);
    `ALU_AND: alu_out = a_val & b_val;
    `ALU_OR : alu_out = a_val | b_val;
    `ALU_XOR: alu_out = a_val ^ b_val;
    `ALU_SLT: begin
      comp_ctrl = `CMP_LT;
      alu_out = {31'b0, comp_res};
    end
    `ALU_SLTU: begin
      comp_ctrl = `CMP_LTU;
      alu_out = {31'b0, comp_res};
    end
    `ALU_SLL: alu_out = a_val << shift_val;
    `ALU_SRL: alu_out = a_val >> shift_val;
    `ALU_SRA: alu_out = $signed(a_val) >>> shift_val;
    default: alu_out = 32'd0;
    endcase
    
end

assign result = alu_out;

endmodule
