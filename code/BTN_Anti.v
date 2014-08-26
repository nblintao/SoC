`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:38:30 08/21/2014 
// Design Name: 
// Module Name:    BTN_Anti 
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
module BTN_Anti (   input wire clk, // system clock
                    input wire [31:0] clkdiv, 
                    input wire [4:0] button, // button input
                    input wire [7:0] SW,  // switch input
                    output reg [4:0] button_out,  // button output
                    output reg [7:0] SW_OK );  // switch output

    parameter COUNTER=32;
    parameter num=22;
    
    reg [9:0] direct;
    reg keydirection;
    
    assign keybutton=|button;

    always@(posedge clk)
        if (!keybutton)begin
            keydirection<=0;
            direct[9:5]<=button;
        end
        else if(keybutton && clkdiv[num]&& clkdiv[num-1]==0 && clkdiv[num-2]==0)
            keydirection<=1;
    
    always@(negedge clk)
        if (button!=5'b00000 && clkdiv[num]==0 && clkdiv[num-1] && clkdiv[num-2] && keydirection==1)
        begin
            button_out<=button;
            direct[4:0]<=button;
        end
        else if(!keydirection)
            button_out<=0;

endmodule
