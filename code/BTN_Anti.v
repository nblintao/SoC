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
    
    assign keybutton=|button;//只要button中有一个为1，keybutton就为1�

    always@(posedge clk)
        //没有按时keydirection�
        if (!keybutton)begin
            keydirection<=0;
            direct[9:5]<=button;
        end
        //按下并当clkdiv[22:20]�00时，可以keydirection变为1
        else if(keybutton && clkdiv[num]&& clkdiv[num-1]==0 && clkdiv[num-2]==0)
            keydirection<=1;
    
    always@(negedge clk)
        //按下并当clkdiv[22:20]�11，且keydirection�时按照实际检测情况输�
        if (button!=5'b00000 && clkdiv[num]==0 && clkdiv[num-1] && clkdiv[num-2] && keydirection==1)
        begin
            button_out<=button;
            direct[4:0]<=button;
        end
        //当keydirection�时认为无按键按动
        else if(!keydirection)
            button_out<=0;

endmodule
