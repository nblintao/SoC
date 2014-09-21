`timescale 1ns / 1ps
module mio_vga(sys_clk,clrn,r,g,b,hs,vs,vga_clk,blankn,syncn,d_t_mem,cpu_mem_a,d_f_vga,wvram);
    input        sys_clk, clrn;     // sys_clk: 50MHz
    output [7:0] r, g, b;           // vga red,green,blue colors
    output       hs, vs;            // vga h and v synchronization
    output       vga_clk;           // for ADV7123 VGA DAC
    output       blankn;            // for ADV7123 VGA DAC
    output       syncn;             // for ADV7123 VGA DAC
    input [31:0] d_t_mem;
    input [31:0] cpu_mem_a;
    output [6:0] d_f_vga;
    input wvram;
    wire [6:0] ascii;
    wire         font_dot;          // font dot

    // vga_clk
    reg          vga_clk = 1;
    always @(posedge sys_clk) begin
        vga_clk <= ~vga_clk;        // vga_clk: 25MHz
    end
    // vgac
    assign blankn = 1;
    assign syncn  = 0;
    wire   [8:0] row_addr;          // pixel ram row addr, 480 (512) lines
    wire   [9:0] col_addr;          // pixel ram col addr, 640 (1024) pixels
    wire         vga_rdn;           // in vgac, rd_a = {row[8:0],col[9:0]}
    // wire  [23:0] vga_pixel = font_dot? 24'hffffff : 24'h0000ff; //white/blue
    // wire  [23:0] vga_pixel = font_dot? 24'hffffff : 24'h000000; //white/black
    wire  [23:0] vga_pixel = (char_row == 59) ?(font_dot? 24'hffff00 : 24'h000000): // green/black
                                               (font_dot? 24'hffffff : 24'h000000); // white/black

    vgac vga_24 (vga_clk,clrn,vga_pixel,row_addr,col_addr,vga_rdn,
                 r,g,b,hs,vs);
    wire   [5:0] char_row = row_addr[8:3];                 // char row
    wire   [2:0] font_row = row_addr[2:0];                 // font row
    wire   [6:0] char_col = col_addr[9:3];                 // char col
    wire   [2:0] font_col = col_addr[2:0];                 // font col
    // char ram, 640/8 = 80 = 64 + 16; 480/8 = 60;
    wire  [12:0] vga_cram_addr = (char_row<<6) + (char_row<<4) + char_col;
    wire  [12:0] char_ram_addr = wvram? cpu_mem_a[14:2] : vga_cram_addr;
    reg    [6:0] char_ram [0:4799];                        // 80 * 60 = 4800
    assign ascii = char_ram[vga_cram_addr];
    // assign ascii = char_ram[char_ram_addr];
    assign d_f_vga = char_ram[cpu_mem_a[14:2]];
    always @(posedge sys_clk) begin
        if (wvram) begin
            char_ram[char_ram_addr] <= d_t_mem[6:0];
        end
    end
    // font_table 128 x 8 x 8 x 1
    wire [12:0] ft_a = {ascii,font_row,font_col};          // ascii,row,col
    font_table ft (ft_a,font_dot);

endmodule