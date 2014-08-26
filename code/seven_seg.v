module mio_seg(     input wire clk, // system clock
                    output [31:0] d_f_seg,
                    input [31:0] d_t_seg,
                    input wseg,
                    input  wire [1:0] SW,  // head/tail 16 bits , text/graph swtich
                    input wire [1:0] Scanning,  // scaning command
                    output reg [7:0] SEGMENT,  // seven segment output
                    output reg [3:0] AN);  // 4 digits select

    reg [31:0] disp_num = 0;
    assign d_f_seg = disp_num;
    always @(negedge wseg) begin
        if (wseg) begin
            disp_num <= d_t_seg;
        end
    end

    wire [15:0] half_disp_num;
    wire [19:0] disp_code;
    reg [4:0] code;

    assign half_disp_num = SW[1] ? disp_num[31:16] : disp_num[15:0];
    assign disp_code = {1'b0, half_disp_num[15:12], 1'b0, half_disp_num[11:8], 1'b0, half_disp_num[7:4], 1'b0, half_disp_num[3:0]};

    always @(posedge clk) begin
        case (Scanning)
            2'b00 : begin
                AN <= 4'b1110; //1st element
                code <= disp_code[4:0];
            end
            2'b01 : begin
                AN <= 4'b1101; //2nd element
                code <= disp_code[9:5];
            end
            2'b10 : begin
                AN <= 4'b1011; // 3rd element
                code <= disp_code[14:10];
            end
            default : begin //2'b11
                AN <= 4'b0111; // 4th element
                code <= disp_code[19:15];
            end
        endcase
        
        case (code)
            5'b00000 : SEGMENT <= 8'b11000000; // 0
            5'b00001 : SEGMENT <= 8'b11111001; // 1
            5'b00010 : SEGMENT <= 8'b10100100; // 2
            5'b00011 : SEGMENT <= 8'b10110000; // 3
            5'b00100 : SEGMENT <= 8'b10011001; // 4
            5'b00101 : SEGMENT <= 8'b10010010; // 5
            5'b00110 : SEGMENT <= 8'b10000010; // 6
            5'b00111 : SEGMENT <= 8'b11111000; // 7
            5'b01000 : SEGMENT <= 8'b10000000; // 8
            5'b01001 : SEGMENT <= 8'b10010000; // 9
            5'b01010 : SEGMENT <= 8'b10001000; // A
            5'b01011 : SEGMENT <= 8'b10000011; // b
            5'b01100 : SEGMENT <= 8'b11000110; // C
            5'b01101 : SEGMENT <= 8'b10100001; // d
            5'b01110 : SEGMENT <= 8'b10000110; // E
            5'b01111 : SEGMENT <= 8'b10001110; // F
            5'b10000 : SEGMENT <= 8'b11000010; // G
            5'b10001 : SEGMENT <= 8'b10001011; // h
            5'b10010 : SEGMENT <= 8'b10001001; // H
            5'b10011 : SEGMENT <= 8'b11000111; // L
            5'b10100 : SEGMENT <= 8'b10101011; // n
            5'b10101 : SEGMENT <= 8'b10100011; // o
            5'b10110 : SEGMENT <= 8'b10001100; // P
            5'b10111 : SEGMENT <= 8'b10011000; // q
            5'b11000 : SEGMENT <= 8'b10101111; // r
            5'b11001 : SEGMENT <= 8'b10000111; // t
            5'b11010 : SEGMENT <= 8'b11000001; // U
            5'b11011 : SEGMENT <= 8'b10010001; // y
            5'b11100 : SEGMENT <= 8'b10111111; // -
            5'b11101 : SEGMENT <= 8'b10111110; // =
            5'b11110 : SEGMENT <= 8'b10011011; // S
            //5'b11111 : SEGMENT <= 8'b11110001; // J
            5'b11111 : SEGMENT <= 8'b11111111; // blank!!!
            default : SEGMENT <= 8'b11111111;
        endcase
    end


endmodule
