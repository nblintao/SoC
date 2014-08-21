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

    // assign Led[7:0] = sw[7:0];
    assign seg = 0;
    assign an = 0;

    wire [31:0] clkdiv;
    wire [4:0] btn_out;
    wire [31:0] m_addr;
    wire [31:0] d_f_mem;
    wire [31:0] d_t_mem;
    wire [2:0] state; 

    BTN_Anti M1 (clk, clkdiv, btn, , btn_out, );
    clk_div M2 (clk, 0, sw[2], clkdiv, cpu_clk);
    multiple_cycle_cpu M3 (cpu_clk, 1, m_addr, d_f_mem, d_t_mem, w_d_mem, wr_vram, rd_vram, io_rdn, state);

    reg [7:0] num;
    always @(posedge btn_out[0]) begin
        num = num + 1;
    end

    assign Led = num;

endmodule
