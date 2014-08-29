module mio_bus(
    input clk,
    input [31:0] mem_a,
    input [31:0] d_t_mem,
    output [31:0] d_f_mem,
    input wmem,
    input rmem,

    output [31:0] vga_a,
    output [31:0] d_t_vga,
    input [6:0] d_f_vga,
    output wvram,
    output rvram,

    output io_rdn,
    input ready,
    input [7:0] key_data,

    input [31:0] d_f_seg,
    output [31:0] d_t_seg,
    output wseg,

    output  [31:0]  rom_a,
    input   [31:0]  d_f_rom,

    output  [5:0]   ram_a,
    input   [31:0]  d_f_ram,
    output  wram,
    output  [31:0]  d_t_ram
    );

    // assign write   =   wmem & ~io_space & ~vr_space; // not io not vr

    //****************************************
    // vram       space: c000_0000 - dfff_ffff
    wire vr_space = mem_a[31] & mem_a[30] & ~mem_a[29];
    assign vga_a = mem_a;
    assign d_t_vga = d_t_mem;
    assign wvram   =   wmem & vr_space;  // char ram write
    assign rvram   =   rmem & vr_space;  // char ram read


    //****************************************
    // i/o        space: a000_0000 - bfff_ffff
    wire io_space = mem_a[31] & ~mem_a[30] & mem_a[29];
    assign io_rdn  = ~(rmem & io_space); // i/o read, active low  


    //****************************************
    // led        space: 0000_7f00 - 0000_7f0f


    //****************************************
    // segment    space: 0000_7f10 - 0000_7f1f
    wire segment_space = (mem_a[31:4] == 28'h00007f1);
    assign d_t_seg = d_t_mem;
    assign wseg = wmem & segment_space;


    //****************************************
    // rom        space: 0000_0000 - 0000_07ff
    wire rom_space = (mem_a[31:11] == 21'h0);
    assign rom_a = mem_a;

    //****************************************
    // ram        space: 0000_0800 - 0000_0fff
    wire ram_space = (mem_a[31:11] == 21'h1);
    assign ram_a = mem_a[7:2];
    assign wram = wmem & ram_space;
    assign d_t_ram = d_t_mem;

    //****************************************
    // cursor     space: 0000_1000 - 0000_1001
    wire cursor_row_space       = (mem_a[31:0] == 32'h00001000);
    reg [31:0] cursor_row = 0; 
    always @(negedge clk) begin
        if (wmem & cursor_row_space)
            cursor_row    <= d_t_mem;
    end
    wire cursor_column_space    = (mem_a[31:0] == 32'h00001001);
    reg [31:0] cursor_column = 0; 
    always @(negedge clk) begin
        if (wmem & cursor_column_space)
            cursor_column    <= d_t_mem;
    end

    //****************************************
    // keyboard   space: 0000_1002 - 0000_1007
    wire keyboard_f0_space      = (mem_a[31:0] == 32'h00001002);
    reg [31:0] keyboard_f0 = 0; 
    always @(negedge clk) begin
        if (wmem & keyboard_f0_space)
            keyboard_f0    <= d_t_mem;
    end

    //****************************************
    // timer      space: 0000_1008 - 0000_100f
    wire timer_25Hz_space       = (mem_a[31:0] == 32'h00001008);
    reg [31:0] timer_25Hz = 0;
    always @(posedge clk)begin // 100MHz/25Hz = 4M
        // if (timer_25Hz == 32'd4000000) begin
        // if (timer_25Hz == 32'd100000) begin
        // if (timer_25Hz == 32'd62500) begin
        // if (timer_25Hz == 32'd625000) begin
        // if (timer_25Hz == 32'd125000) begin
            timer_25Hz <= 0;
        end
        else begin
            timer_25Hz <= timer_25Hz + 1;
        end
    end
    
    assign d_f_mem = 
        vr_space ? {25'h0,d_f_vga} :
        io_space ? {23'h0,ready,key_data} :
        segment_space ? d_f_seg:
        rom_space ? d_f_rom:
        ram_space ? d_f_ram:
        cursor_row_space ? cursor_row:
        cursor_column_space ? cursor_column:
        keyboard_f0_space ? keyboard_f0:
        timer_25Hz_space ? timer_25Hz:
        32'h0 ;


endmodule