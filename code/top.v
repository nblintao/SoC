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

    reg sys_clk = 1;
    always @(posedge clk) begin
        sys_clk <= ~sys_clk;
    end

    BTN_Anti M1 (clk, clkdiv, btn, , btn_out, );
    clk_div M2 (clk, 1'b0, sw[2], clkdiv, cpu_clk);    

    wire clrn;
    assign clrn = ~btn_out[0];

    wire [7:0] r,g,b;
    assign vgaRed = r[7:5];
    assign vgaGreen = g[7:5];
    assign vgaBlue[2:1] = b[7:6];

    wire [31:0] inst,pc,d_t_mem,mem_a,d_f_mem;
    wire  write,read,io_rdn,io_wrn,wvram,rvram,ready,overflow;
    wire [7:0] key_data; 

    // cpu
    single_cycle_cpu_interrupt M0 (sys_clk, clrn, inst, d_f_mem, pc, mem_a, d_t_mem, wmem,rmem, 1'b0, 1'b0);

    wire [31:0] d_t_vga;
    wire [6:0] d_f_vga;
    wire [31:0] vga_a;
    wire [31:0] d_f_seg,d_t_seg;
    wire [31:0] ram_a,d_f_ram, d_t_ram;

    mio_bus MIO0(   clk, mem_a, d_t_mem, d_f_mem, wmem, rmem,
                    vga_a ,d_t_vga, d_f_vga, wvram,rvram,
                    io_rdn, ready, key_data,
                    d_f_seg, d_t_seg, wseg,
                    ram_a,d_f_ram,wram,d_t_ram
                    );

    mio_vga MIO1 (sys_clk,clrn,r,g,b,Hsync,Vsync,vga_clk,blankn,syncn,d_t_vga,vga_a,d_f_vga,wvram);

    mio_ps2 MIO2 (sys_clk,clrn,PS2KeyboardClk,PS2KeyboardData,io_rdn,key_data,ready,overflow);

    mio_seg MIO3 (clk, d_f_seg, d_t_seg, wseg, sw[1:0], clkdiv[18:17], seg, an);

    mio_ram MIO4 (clk, pc,inst, ram_a,d_f_ram,wram,d_t_ram);


endmodule