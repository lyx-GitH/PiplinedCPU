`timescale 1ns / 1ps
`include "Defines.vh"

`define Itype 7'b0010011
`define Rtype 7'b0110011 

`define op_ADD  3'b000 // inst[30] ? SUB : ADD
`define op_SLL  3'b001
`define op_SLT  3'b010
`define op_SLTU 3'b011
`define op_XOR  3'b100
`define op_SRL  3'b101 // inst[30] ? SRA : SRL
`define op_OR   3'b110
`define op_AND  3'b111

`define alu_CTRL_BITS 4
`define alu_ADD  `alu_CTRL_BITS'd0
`define alu_SUB  `alu_CTRL_BITS'd1
`define alu_SLL  `alu_CTRL_BITS'd2
`define alu_SLT  `alu_CTRL_BITS'd3
`define alu_SLTU `alu_CTRL_BITS'd4
`define alu_XOR  `alu_CTRL_BITS'd5
`define alu_SRL  `alu_CTRL_BITS'd6
`define alu_SRA  `alu_CTRL_BITS'd7
`define alu_OR   `alu_CTRL_BITS'd8
`define alu_AND  `alu_CTRL_BITS'd9


module ALU_Ctrl(
    inst,
    alu_op,
    alu_ctrl
);

    input [31:0] inst;
    input alu_op;
    output reg [3:0] alu_ctrl;

    always @(inst or alu_op) begin
        if(alu_op) begin
            //save or load
            if (inst[6:0] == 7'b0000011 || inst[6:0] == 7'b0100011) begin
              alu_ctrl = `alu_ADD;
            //R type or I type    
            end else begin
              case(inst[14:12])
              `op_ADD: begin
                if(inst[6:0] == `Rtype) begin
                  alu_ctrl = inst[30] == 1'b1 ? `alu_SUB : `alu_ADD;
                end else begin
                  alu_ctrl = `alu_ADD;
                end
              end
              `op_SRL: alu_ctrl = inst[30] ? `alu_SRA : `alu_SRL; 
              `op_SLL: alu_ctrl = `alu_SLL;
              `op_SLT: alu_ctrl = `alu_SLT;
              `op_SLTU: alu_ctrl =`alu_SLTU;
              `op_XOR: alu_ctrl = `alu_XOR;
              `op_OR: alu_ctrl = `alu_OR;
              `op_AND: alu_ctrl = `alu_AND;  
              endcase
            end
        end else begin
          alu_ctrl = `alu_ADD;
        end
    end
endmodule

