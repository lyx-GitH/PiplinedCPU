`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/10 13:59:36
// Design Name: 
// Module Name: RegFile
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

module RegFile(
    `VGA_DBG_RegFile_Outputs
    input clk, rst,
    input wen,                  //write enable
    input [4:0] rs1,            //
    input [4:0] rs2,
    input [4:0] rd,
    input [31:0] i_data,
    output [31:0] rs1_val,
    output [31:0] rs2_val
    );

    

    reg [31:0] regs[0:31];

    `VGA_DBG_RegFile_Assignments

    assign rs1_val = regs[rs1];
    assign rs2_val = regs[rs2];

    integer i;

    initial begin
       for(i=0; i<32; i=i+1) begin
         regs[i] <= 32'd0;
       end
    end

    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
          for(i=0; i<32; i=i+1) begin
            regs[i] <= 32'b0;
          end
        end
        else if(wen) begin
          if(rd != 0) begin
            regs[rd] <= i_data;
          end
        end
    end



endmodule

