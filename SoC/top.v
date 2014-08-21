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
module top(clk,seg,an,Led,sw,btn);
    input clk;
    output [7:0] seg;
    output [3:0] an;
    output [7:0] Led;
    input [7:0] sw;
    input [4:0] btn;

    assign Led[7:0] = sw[7:0];
    assign seg = 0;
    assign an = 0;
endmodule
