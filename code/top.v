`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:07:06 08/21/2014 
// Design Name: 
// Module Name:    top 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module top( input wire clk,
            output wire [7:0] seg,
            output wire [3:0] an,
            output wire [7:0] Led,
            input wire [7:0] sw,
            input wire [4:0] btn,
            input wire PS2KeyboardData,
            input wire PS2KeyboardClk,
            output wire [2:0] vgaRed,
            output wire [2:0] vgaGreen,
            output wire [2:0] vgaBlue,
            output wire Hsync,
            output wire Vsync
            );

    assign Led[7:0] = sw[7:0];

    wire [31:0] clkdiv;
    wire [4:0] btn_out;
    wire [31:0] disp_num;

    // Infomation about switch
    // sw[0]: text/graph swtich
    // sw[1]: head/tail 16 bits
    // sw[2]: slow/quick CPU



    assign disp_num = num;

    reg [31:0] num = 0;
    // always @(PS2KeyboardData) begin
    //     num = num + 1;
    // end

    reg sys_clk = 1;
    always @(posedge clk) begin
        sys_clk <= ~sys_clk;
    end


    BTN_Anti M1 (clk, clkdiv, btn, , btn_out, );
    clk_div M2 (clk, 1'b0, sw[2], clkdiv, cpu_clk);
    seven_seg M4 (clk, disp_num, sw[1:0], clkdiv[18:17], seg, an);

    wire clrn;
    assign clrn = ~btn_out[0];

    wire [7:0] r,g,b;
    assign vgaRed = r[7:5];
    assign vgaGreen = g[7:5];
    assign vgaBlue[2:1] = b[7:6];

    wire  [31:0] inst,pc,d_t_mem,cpu_mem_a,d_f_mem;
    wire         write,read,io_rdn,io_wrn,wvram,rvram,ready,overflow;
    wire   [7:0] key_data;          // kbd code byte
    wire [6:0] ascii;

    // cpu
    single_cycle_cpu_io M0 (sys_clk,clrn,pc,inst,cpu_mem_a,d_f_mem,
                             d_t_mem,write,io_rdn,io_wrn,rvram,wvram);
    

    // instruction memory
    scinstmem_make_code_break_code imem (pc,inst);
    
    wire [31:0] d_t_vga;
    wire [6:0] d_f_vga;
    wire [31:0] vga_a;
    // assign d_t_vga = d_t_mem;
    // assign vga_a = cpu_mem_a;

    mio_vga IO1 (sys_clk,clrn,r,g,b,Hsync,Vsync,vga_clk,blankn,syncn,d_t_vga,vga_a,d_f_vga,wvram);

    mio_ps2 kbd (sys_clk,clrn,PS2KeyboardClk,PS2KeyboardData,io_rdn,key_data,ready,overflow);

    mio_bus MIO0(   cpu_mem_a, d_t_mem, d_f_mem,
                    vga_a ,d_t_vga, d_f_vga,
                    io_rdn, ready, key_data
        );

endmodule

module mio_bus(
    input [31:0] cpu_mem_a,
    input [31:0] d_t_mem,
    output [31:0] d_f_mem,

    output [31:0] vga_a,
    output [31:0] d_t_vga,
    input [6:0] d_f_vga,

    input io_rdn,
    input ready,
    input [7:0] key_data
    );

    assign d_t_vga = d_t_mem;
    assign vga_a = cpu_mem_a;
    assign d_f_mem = io_rdn? {25'h0,d_f_vga} : {23'h0,ready,key_data};
endmodule