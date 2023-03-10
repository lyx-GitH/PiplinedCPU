`include "Defines.vh"

module Top(
    input clk_100mhz,
    input rstn,
    input [15:0] sw_in,
    input [4:0] key_col,

    output [4:0] key_row,
    output hs,
    output vs,
    output [3:0] vga_r,
    output [3:0] vga_g,
    output [3:0] vga_b,
    output [7:0] LED_o
);

    wire rst;
    wire [15:0] sw;
    wire [31:0] clk_div;
    wire [4:0] key_x;
    wire [4:0] key_y;

    ClockDividor clock_dividor(
        .clk(clk_100mhz),
        .rst(rst),
        .step_en(sw[0]),
        .clk_step(key_x[0]),
        .clk_div(clk_div),
        .clk_cpu(clk_cpu)
    );

    InputAntiJitter inputter(
        .clk(clk_100mhz),
        .rstn(rstn),
        .key_col(key_col),
        .sw_in(sw_in),
        .rst(rst),
        .key_row(key_row),
        .key_x(key_x),
        .key_y(key_y),
        .sw(sw)
    );
    
    wire [31:0 ] imem_addr;
    wire [31:0] imem_o_data;

    wire [31:0] dmem_addr;
    wire [31:0] dmem_o_data;
    wire [31:0] dmem_i_data;
    wire dmem_wen;

    wire dr1_wen;
    wire [31:0] dr1_o_data;
    wire [31:0] dr1_i_data;    

    
    
    `VGA_DBG_Core_Declaration
    `VGA_DBG_RegFile_Declaration
    //static
    Core core(
        `VGA_DBG_Core_Arguments
        .clk(clk_cpu),
        .rst(rst),

        .imem_addr(imem_addr),       //out
        .imem_o_data(imem_o_data),  //in

        .dmem_addr(dmem_addr),      //out
        .dmem_i_data(dmem_i_data),  //out
        .dmem_wen(dmem_wen),        //out

        .dmem_o_data(dmem_o_data)  //in
    );

    wire ac_dr1_wen;
    wire ac_dmem_wen;

    wire [31:0] ac_imem_addr;
    wire [31:0] ac_imem_o_data;

    wire [31:0] ac_dmem_addr;
    wire [31:0] ac_dmem_i_data;
    wire [31:0] ac_dmem_o_data;

    wire [31:0] ac_dr1_i_data;
    wire [31:0] ac_dr1_o_data;

    
    MACtrl memacc(
        //facing core
        .i_iaddr(imem_addr),
        .o_idata(imem_o_data),

        .i_dwen(dmem_wen),
        .i_daddr(dmem_addr),
        .i_d_idata(dmem_i_data), //dmem write input
        .o_d_odata(dmem_o_data),//dmem data output

        //facing IMem
        .o_iaddr(ac_imem_addr),
        .i_idata(ac_imem_o_data),

        //facing DMem
        .o_dwen(ac_dmem_wen),
        .o_daddr(ac_dmem_addr),
        .o_d_idata(ac_dmem_i_data),
        .i_d_odata(ac_dmem_o_data),

        //facing DR1
        .o_dr1wen(ac_dr1_wen),
        .o_dr1_idata(ac_dr1_i_data),
        .i_dr1_odata(ac_dr1_o_data)
    );

    LEDCtrl dr1(
    .wen(ac_dr1_wen), //in
    .i_data(ac_dr1_i_data), //in
    .o_data(ac_dr1_o_data), //out
    .o_led_ctrl(LED_o)  //out
    );


    Mem mem(
        .i_addr(ac_imem_addr), //in
        .i_data(ac_imem_o_data),//out
        .clk(~clk_100mhz),
        .d_wen(ac_dmem_wen),//in
        .d_addr(ac_dmem_addr),//in
        .d_i_data(ac_dmem_i_data),//in
        .d_o_data(ac_dmem_o_data)//out
    );

   

    VGA vga(
        `VGA_DBG_VgaDebugger_Arguments
        .rst(rst),
        .clk_div(clk_div),
        .hs(hs),
        .vs(vs),
        .vga_r(vga_r),
        .vga_g(vga_g),
        .vga_b(vga_b)
    );

    

    

endmodule