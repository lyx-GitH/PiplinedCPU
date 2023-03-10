`timescale 1ns/1ps

`include "Defines.vh"

module IF_ID_gate(
    clk,
    is_stall,
    IF_inst,
    IF_pc,
    ID_inst,
    ID_pc
);
    input  wire clk;
    input wire  is_stall;
    input wire [31:0] IF_inst;
    input wire [31:0] IF_pc;
    output reg [31:0] ID_inst;
    output reg [31:0] ID_pc;
    initial begin
        ID_inst = `NOP_INST;
        ID_pc  = 32'd0;
    end

    always @(posedge clk) begin
        ID_inst <= IF_inst;
        ID_pc   <= IF_pc;
    end
endmodule