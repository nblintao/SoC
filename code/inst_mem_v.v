module mio_ram (clk,a,inst,ram_a,d_f_ram,wram,d_t_ram);
    input clk;
    input  [31:0] a;
    output [31:0] inst; 
    input  [31:0] ram_a;
    output [31:0] d_f_ram;
    input         wram;
    input  [31:0] d_t_ram;

    reg   [31:0] ram [0:255];
    assign inst = ram[a[9:2]];
    assign d_f_ram = ram[ram_a[9:2]];

    always @(negedge clk)begin
        if(wram)begin
            ram[ram_a[9:2]] <= d_t_ram;
        end
    end

    initial begin
        ram[8'h00] = 32'b00100000000111010000001000000000;
        ram[8'h01] = 32'b00111100000010001010000000000000;
        ram[8'h02] = 32'b00110101000010000000000000000000;
        ram[8'h03] = 32'b10001101000100000000000000000000;
        ram[8'h04] = 32'b00110010000010000000000100000000;
        ram[8'h05] = 32'b00010001000000001111111111111011;
        ram[8'h06] = 32'b00000000000100000010000000000000;
        ram[8'h07] = 32'b00001100000000000000000000001001;
        ram[8'h08] = 32'b00001000000000000000000000000001;
        ram[8'h09] = 32'b00100011101111011111111111111100;
        ram[8'h0a] = 32'b10101111101111110000000000000000;
        ram[8'h0b] = 32'b00111100000010000000000000000000;
        ram[8'h0c] = 32'b00110101000010000000001000000000;
        ram[8'h0d] = 32'b10001101000010010000000000000000;
        ram[8'h0e] = 32'b00010101001000000000000001010000;
        ram[8'h0f] = 32'b00111100000010010000000000000000;
        ram[8'h10] = 32'b00110101001010010000000111110000;
        ram[8'h11] = 32'b00010001001001000000000001001011;
        ram[8'h12] = 32'b00110000100001000000000011111111;
        ram[8'h13] = 32'b00111100000010000000000000000000;
        ram[8'h14] = 32'b00110101000010000000001000000100;
        ram[8'h15] = 32'b00000000000010000100100000000000;
        ram[8'h16] = 32'b00111100000010100000000000000000;
        ram[8'h17] = 32'b00110101010010100000001000110000;
        ram[8'h18] = 32'b00010001010010010000000001000111;
        ram[8'h19] = 32'b10001101001010100000000000000000;
        ram[8'h1a] = 32'b00000000000000000101100000100000;
        ram[8'h1b] = 32'b00000000000010110110000011000000;
        ram[8'h1c] = 32'b00000001100010100110000000000100;
        ram[8'h1d] = 32'b00000000000011000110011000000010;
        ram[8'h1e] = 32'b00010000100011000000000000000110;
        ram[8'h1f] = 32'b00101001011011010000000000000011;
        ram[8'h20] = 32'b00010001101000000000000000000010;
        ram[8'h21] = 32'b00100001011010110000000000000001;
        ram[8'h22] = 32'b00001000000000000000000000011011;
        ram[8'h23] = 32'b00100001001010010000000000000100;
        ram[8'h24] = 32'b00001000000000000000000000010110;
        ram[8'h25] = 32'b00000001001010000100000000100010;
        ram[8'h26] = 32'b00000001000010110100000000100000;
        ram[8'h27] = 32'b00101001000010010000000000011010;
        ram[8'h28] = 32'b00010101001000000000000000010010;
        ram[8'h29] = 32'b00101001000010010000000000100100;
        ram[8'h2a] = 32'b00010101001000000000000000010010;
        ram[8'h2b] = 32'b00101001000010010000000000100101;
        ram[8'h2c] = 32'b00010101001000000000000000010010;
        ram[8'h2d] = 32'b00101001000010010000000000100110;
        ram[8'h2e] = 32'b00010101001000000000000000010010;
        ram[8'h2f] = 32'b00101001000010010000000000100111;
        ram[8'h30] = 32'b00010101001000000000000000100100;
        ram[8'h31] = 32'b00101001000010010000000000101000;
        ram[8'h32] = 32'b00010101001000000000000000100011;
        ram[8'h33] = 32'b00101001000010010000000000101001;
        ram[8'h34] = 32'b00010101001000000000000000100010;
        ram[8'h35] = 32'b00101001000010010000000000101001;
        ram[8'h36] = 32'b00010101001000000000000000100001;
        ram[8'h37] = 32'b00101001000010010000000000101011;
        ram[8'h38] = 32'b00010101001000000000000000100000;
        ram[8'h39] = 32'b00101001000010010000000000101100;
        ram[8'h3a] = 32'b00010101001000000000000000011111;
        ram[8'h3b] = 32'b00100001000001000000000001100001;
        ram[8'h3c] = 32'b00001000000000000000000001011011;
        ram[8'h3d] = 32'b00100001000001000000000000010110;
        ram[8'h3e] = 32'b00001000000000000000000001011011;
        ram[8'h3f] = 32'b00100000000001000000000000100000;
        ram[8'h40] = 32'b00001000000000000000000001011011;
        ram[8'h41] = 32'b10001100000010000001000000000001;
        ram[8'h42] = 32'b10001100000010010001000000000000;
        ram[8'h43] = 32'b00010101000000000000000000000100;
        ram[8'h44] = 32'b00010001001000000000000000011011;
        ram[8'h45] = 32'b00100001001010011111111111111111;
        ram[8'h46] = 32'b10101100000010010001000000000000;
        ram[8'h47] = 32'b00100000000010000000000001010000;
        ram[8'h48] = 32'b00100001000010001111111111111100;
        ram[8'h49] = 32'b10101100000010000001000000000001;
        ram[8'h4a] = 32'b00000000000010010101000110000000;
        ram[8'h4b] = 32'b00000001000010100100000000100000;
        ram[8'h4c] = 32'b00000000000010010101000100000000;
        ram[8'h4d] = 32'b00000001000010100100000000100000;
        ram[8'h4e] = 32'b00000000000010000100000010000000;
        ram[8'h4f] = 32'b00111100000010011100000000000000;
        ram[8'h50] = 32'b00110101001010010000000000000000;
        ram[8'h51] = 32'b00000001000010010100000000100000;
        ram[8'h52] = 32'b00000000000000000010000000100000;
        ram[8'h53] = 32'b10101101000001000000000000000000;
        ram[8'h54] = 32'b00001000000000000000000001100000;
        ram[8'h55] = 32'b00001000000000000000000001100000;
        ram[8'h56] = 32'b00001000000000000000000001100000;
        ram[8'h57] = 32'b00001000000000000000000001100000;
        ram[8'h58] = 32'b00001000000000000000000001100000;
        ram[8'h59] = 32'b00001000000000000000000001100000;
        ram[8'h5a] = 32'b00001000000000000000000001100000;
        ram[8'h5b] = 32'b00001100000000000000000001100011;
        ram[8'h5c] = 32'b00001000000000000000000001100000;
        ram[8'h5d] = 32'b10101101000010010000000000000000;
        ram[8'h5e] = 32'b00001000000000000000000001100000;
        ram[8'h5f] = 32'b10101101000000000000000000000000;
        ram[8'h60] = 32'b10001111101111110000000000000000;
        ram[8'h61] = 32'b00100011101111010000000000000100;
        ram[8'h62] = 32'b00000011111000000000000000001000;
        ram[8'h63] = 32'b10001100000010000001000000000001;
        ram[8'h64] = 32'b10001100000010010001000000000000;
        ram[8'h65] = 32'b00000000000010010101000110000000;
        ram[8'h66] = 32'b00000000000010100101100000000000;
        ram[8'h67] = 32'b00000000000010010101000100000000;
        ram[8'h68] = 32'b00000001011010100101100000100000;
        ram[8'h69] = 32'b00000001011010000101100000100000;
        ram[8'h6a] = 32'b00000000000010110101100010000000;
        ram[8'h6b] = 32'b00111100000011001100000000000000;
        ram[8'h6c] = 32'b00110101100011000000000000000000;
        ram[8'h6d] = 32'b00000001011011000101100000100000;
        ram[8'h6e] = 32'b10101101011001000000000000000000;
        ram[8'h6f] = 32'b00101001000010100000000001001111;
        ram[8'h70] = 32'b00010101010000000000000000000110;
        ram[8'h71] = 32'b00101001001010100000000000111011;
        ram[8'h72] = 32'b00010001010000000000000000000101;
        ram[8'h73] = 32'b00100001001010010000000000000001;
        ram[8'h74] = 32'b10101100000010010001000000000000;
        ram[8'h75] = 32'b00100000000010000000000000000000;
        ram[8'h76] = 32'b00001000000000000000000001111000;
        ram[8'h77] = 32'b00100001000010000000000000000100;
        ram[8'h78] = 32'b10101100000010000001000000000001;
        ram[8'h79] = 32'b00000011111000000000000000001000;
        ram[8'h7a] = 32'b00001000000000000000000001111010;
        ram[8'h7b] = 32'b00000000000000000000000000000000;
        ram[8'h7c] = 32'b00000000000000000000000000000000;
        ram[8'h7d] = 32'b00000000000000000000000000000000;
        ram[8'h7e] = 32'b00000000000000000000000000000000;
        ram[8'h7f] = 32'b00000000000000000000000000000000;
        ram[8'h80] = 32'b00000000000000000000000000000000;
        ram[8'h81] = 32'b00011100001100100010000100100011;
        ram[8'h82] = 32'b00100100001010110011010000110011;
        ram[8'h83] = 32'b01000011001110110100001001001011;
        ram[8'h84] = 32'b00111010001100010100010001001101;
        ram[8'h85] = 32'b00010101001011010001101100101100;
        ram[8'h86] = 32'b00111100001010100001110100100010;
        ram[8'h87] = 32'b00110101000110100100010100010110;
        ram[8'h88] = 32'b00011110001001100010010100101110;
        ram[8'h89] = 32'b00110110001111010011111001000110;
        ram[8'h8a] = 32'b00101001011001100101101001011001;
        ram[8'h8b] = 32'b01110101011010110111001001110100;
        ram[8'h8c] = 32'b00000000000000000000000000000000;
        ram[8'h8d] = 32'b00000000000000000000000000000000;
        ram[8'h8e] = 32'b00000000000000000000000000000000;
        ram[8'h8f] = 32'b00000000000000000000000000000000;
        ram[8'h90] = 32'b00000000000000000000000000000000;
        ram[8'h91] = 32'b00000000000000000000000000000000;
        ram[8'h92] = 32'b00000000000000000000000000000000;
        ram[8'h93] = 32'b00000000000000000000000000000000;
        ram[8'h94] = 32'b00000000000000000000000000000000;
        ram[8'h95] = 32'b00000000000000000000000000000000;
        ram[8'h96] = 32'b00000000000000000000000000000000;
        ram[8'h97] = 32'b00000000000000000000000000000000;
        ram[8'h98] = 32'b00000000000000000000000000000000;
        ram[8'h99] = 32'b00000000000000000000000000000000;
        ram[8'h9a] = 32'b00000000000000000000000000000000;
        ram[8'h9b] = 32'b00000000000000000000000000000000;
        ram[8'h9c] = 32'b00000000000000000000000000000000;
        ram[8'h9d] = 32'b00000000000000000000000000000000;
        ram[8'h9e] = 32'b00000000000000000000000000000000;
        ram[8'h9f] = 32'b00000000000000000000000000000000;
        ram[8'ha0] = 32'b00000000000000000000000000000000;
        ram[8'ha1] = 32'b00000000000000000000000000000000;
        ram[8'ha2] = 32'b00000000000000000000000000000000;
        ram[8'ha3] = 32'b00000000000000000000000000000000;
        ram[8'ha4] = 32'b00000000000000000000000000000000;
        ram[8'ha5] = 32'b00000000000000000000000000000000;
        ram[8'ha6] = 32'b00000000000000000000000000000000;
        ram[8'ha7] = 32'b00000000000000000000000000000000;
        ram[8'ha8] = 32'b00000000000000000000000000000000;
        ram[8'ha9] = 32'b00000000000000000000000000000000;
        ram[8'haa] = 32'b00000000000000000000000000000000;
        ram[8'hab] = 32'b00000000000000000000000000000000;
        ram[8'hac] = 32'b00000000000000000000000000000000;
        ram[8'had] = 32'b00000000000000000000000000000000;
        ram[8'hae] = 32'b00000000000000000000000000000000;
        ram[8'haf] = 32'b00000000000000000000000000000000;
        ram[8'hb0] = 32'b00000000000000000000000000000000;
        ram[8'hb1] = 32'b00000000000000000000000000000000;
        ram[8'hb2] = 32'b00000000000000000000000000000000;
        ram[8'hb3] = 32'b00000000000000000000000000000000;
        ram[8'hb4] = 32'b00000000000000000000000000000000;
        ram[8'hb5] = 32'b00000000000000000000000000000000;
        ram[8'hb6] = 32'b00000000000000000000000000000000;
        ram[8'hb7] = 32'b00000000000000000000000000000000;
        ram[8'hb8] = 32'b00000000000000000000000000000000;
        ram[8'hb9] = 32'b00000000000000000000000000000000;
        ram[8'hba] = 32'b00000000000000000000000000000000;
        ram[8'hbb] = 32'b00000000000000000000000000000000;
        ram[8'hbc] = 32'b00000000000000000000000000000000;
        ram[8'hbd] = 32'b00000000000000000000000000000000;
        ram[8'hbe] = 32'b00000000000000000000000000000000;
        ram[8'hbf] = 32'b00000000000000000000000000000000;
        ram[8'hc0] = 32'b00000000000000000000000000000000;
        ram[8'hc1] = 32'b00000000000000000000000000000000;
        ram[8'hc2] = 32'b00000000000000000000000000000000;
        ram[8'hc3] = 32'b00000000000000000000000000000000;
        ram[8'hc4] = 32'b00000000000000000000000000000000;
        ram[8'hc5] = 32'b00000000000000000000000000000000;
        ram[8'hc6] = 32'b00000000000000000000000000000000;
        ram[8'hc7] = 32'b00000000000000000000000000000000;
        ram[8'hc8] = 32'b00000000000000000000000000000000;
        ram[8'hc9] = 32'b00000000000000000000000000000000;
        ram[8'hca] = 32'b00000000000000000000000000000000;
        ram[8'hcb] = 32'b00000000000000000000000000000000;
        ram[8'hcc] = 32'b00000000000000000000000000000000;
        ram[8'hcd] = 32'b00000000000000000000000000000000;
        ram[8'hce] = 32'b00000000000000000000000000000000;
        ram[8'hcf] = 32'b00000000000000000000000000000000;
        ram[8'hd0] = 32'b00000000000000000000000000000000;
        ram[8'hd1] = 32'b00000000000000000000000000000000;
        ram[8'hd2] = 32'b00000000000000000000000000000000;
        ram[8'hd3] = 32'b00000000000000000000000000000000;
        ram[8'hd4] = 32'b00000000000000000000000000000000;
        ram[8'hd5] = 32'b00000000000000000000000000000000;
        ram[8'hd6] = 32'b00000000000000000000000000000000;
        ram[8'hd7] = 32'b00000000000000000000000000000000;
        ram[8'hd8] = 32'b00000000000000000000000000000000;
        ram[8'hd9] = 32'b00000000000000000000000000000000;
        ram[8'hda] = 32'b00000000000000000000000000000000;
        ram[8'hdb] = 32'b00000000000000000000000000000000;
        ram[8'hdc] = 32'b00000000000000000000000000000000;
        ram[8'hdd] = 32'b00000000000000000000000000000000;
        ram[8'hde] = 32'b00000000000000000000000000000000;
        ram[8'hdf] = 32'b00000000000000000000000000000000;
        ram[8'he0] = 32'b00000000000000000000000000000000;
        ram[8'he1] = 32'b00000000000000000000000000000000;
        ram[8'he2] = 32'b00000000000000000000000000000000;
        ram[8'he3] = 32'b00000000000000000000000000000000;
        ram[8'he4] = 32'b00000000000000000000000000000000;
        ram[8'he5] = 32'b00000000000000000000000000000000;
        ram[8'he6] = 32'b00000000000000000000000000000000;
        ram[8'he7] = 32'b00000000000000000000000000000000;
        ram[8'he8] = 32'b00000000000000000000000000000000;
        ram[8'he9] = 32'b00000000000000000000000000000000;
        ram[8'hea] = 32'b00000000000000000000000000000000;
        ram[8'heb] = 32'b00000000000000000000000000000000;
        ram[8'hec] = 32'b00000000000000000000000000000000;
        ram[8'hed] = 32'b00000000000000000000000000000000;
        ram[8'hee] = 32'b00000000000000000000000000000000;
        ram[8'hef] = 32'b00000000000000000000000000000000;
        ram[8'hf0] = 32'b00000000000000000000000000000000;
        ram[8'hf1] = 32'b00000000000000000000000000000000;
        ram[8'hf2] = 32'b00000000000000000000000000000000;
        ram[8'hf3] = 32'b00000000000000000000000000000000;
        ram[8'hf4] = 32'b00000000000000000000000000000000;
        ram[8'hf5] = 32'b00000000000000000000000000000000;
        ram[8'hf6] = 32'b00000000000000000000000000000000;
        ram[8'hf7] = 32'b00000000000000000000000000000000;
        ram[8'hf8] = 32'b00000000000000000000000000000000;
        ram[8'hf9] = 32'b00000000000000000000000000000000;
        ram[8'hfa] = 32'b00000000000000000000000000000000;
        ram[8'hfb] = 32'b00000000000000000000000000000000;
        ram[8'hfc] = 32'b00000000000000000000000000000000;
        ram[8'hfd] = 32'b00000000000000000000000000000000;
        ram[8'hfe] = 32'b00000000000000000000000000000000;
        ram[8'hff] = 32'b00000000000000000000000000000000;
    end
endmodule
