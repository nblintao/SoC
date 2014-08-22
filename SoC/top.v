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
            input wire [4:0] btn);

    assign Led[7:0] = sw[7:0];

    wire [31:0] clkdiv;
    wire [4:0] btn_out;
    wire [31:0] m_addr;
    wire [31:0] d_f_mem;
    wire [31:0] d_t_mem;
    wire [2:0] state;
    wire [31:0] disp_num;

    // Infomation about switch
    // sw[0]: text/graph swtich
    // sw[1]: head/tail 16 bits
    // sw[2]: slow/quick CPU

    BTN_Anti M1 (clk, clkdiv, btn, , btn_out, );
    clk_div M2 (clk, 0, sw[2], clkdiv, cpu_clk);
    multiple_cycle_cpu M3 (cpu_clk, 1, m_addr, d_f_mem, d_t_mem, w_d_mem, wr_vram, rd_vram, io_rdn, state);
    seven_seg M4 (clk, disp_num, sw[1:0], clkdiv[18:17], seg, an);

    assign disp_num = num;

    reg [31:0] num;
    // always @(posedge btn_out[0]) begin
    //     num = num + 1;
    // end

    // always @(posedge btn_out[1]) begin
    //     num = num + 10; 
    // end
    // always @(posedge btn_out[2]) begin num = num + 100; end
    always @(posedge btn_out[3]) begin num = num + 1000; end
    // always @(posedge btn_out[4]) begin num = num + 10000; end


endmodule
