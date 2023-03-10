`timescale 1ns/1ps
`include "Dmem.v"
`include "LED.v"

module memory(
    input wire clk,
    input wire wen,
    input wire [31:0] addr,
    input wire [31:0] i_data,
    output wire [31:0] o_data,
    output wire [7:0] led_out
);

    wire dMemWen;
    wire LedWen;
    wire [31:0] LED_o_data;
    wire [31:0] dMem_o_data;
    
    assign dMemWen = addr == 32'hfe000000 ? 1'b0 : 1'b1;
    assign LedWen = addr == 32'hfe00_0000 ? 1'b1 : 1'b0;


    DMem d_mem(
        .clk(clk),
        .wen(dMemWen),
        .addr(addr),
        .i_data(i_data),
        .o_data(dMem_o_data)
    );

    LEDCtrl led_ctrl(
        .clk(clk),
        .wen(LedWen),
        .i_data(i_data),
        .o_data(dMem_o_data),
        .o_led_ctrl(led_out)
    );

    assign o_data = addr == 32'hfe00_0000 ? LED_o_data : dMem_o_data;


endmodule