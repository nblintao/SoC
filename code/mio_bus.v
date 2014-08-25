module mio_bus(
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

    output [31:0] ram_a,
    input [31:0] d_f_ram,
    output wram,
    output [31:0] d_t_ram
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
    // ram        space: 0000_0000 - 0000_0fff
    wire ram_space = (mem_a[31:12] == 20'h0);
    assign ram_a = mem_a;
    assign wram = wmem & ram_space;
    assign d_t_ram = d_t_mem;
    
    assign d_f_mem = 
        vr_space ? {25'h0,d_f_vga} :
        io_space ? {23'h0,ready,key_data} :
        segment_space ? d_f_seg:
        ram_space ? d_f_ram:
        32'h0 ;
    // assign d_f_mem = io_rdn? {25'h0,d_f_vga} : {23'h0,ready,key_data};


endmodule