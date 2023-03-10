`timescale 1ns/1ps

module MEM_WB_gate (
    input wire clk,
    input wire [31:0] MEM_inst,
    input wire [31:0] MEM_i_data,
    input wire MEM_reg_wen,
    output reg [31:0] WB_inst,
    output reg [31:0] WB_i_data,
    output reg WB_reg_wen
);
  always @(posedge clk) begin
    WB_inst     <= MEM_inst;
    WB_i_data   <= MEM_i_data;
    WB_reg_wen  <= MEM_reg_wen;
  end

endmodule //MEM_WB_gate