`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:36:39 08/21/2014 
// Design Name: 
// Module Name:    clk_div 
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
module clk_div( input wire clk,  // system clock
                input wire rst,  // system reset
                input wire SW2,  // CPU clock switch (slow/quick CPU)
                output reg [31:0] clkdiv,  // 32bits frequency splitting, system sharing
                output wire Clk_CPU);  // CPU clock

    // Spartan-6 is 100MHz, and Spartan-3 is 50MHz. Using Spartan-6 now.

    initial clkdiv <= 0;
        
    always@(posedge clk)
        if(rst)
            clkdiv = 0;
        else
            clkdiv = clkdiv + 1;

    assign Clk_CPU = SW2 ? clkdiv[25] : clkdiv[2];

endmodule
