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
    input [7:0] key_data
    );
    
    wire io_space, vr_space;

    // assign write   =   wmem & ~io_space & ~vr_space; // not io not vr


    // vram space: c000_0000 - dfff_ffff
    assign vr_space = mem_a[31] & mem_a[30] & ~mem_a[29];
    assign wvram   =   wmem & vr_space;  // char ram write
    assign rvram   =   rmem & vr_space;  // char ram read
    assign d_t_vga = d_t_mem;
    assign vga_a = mem_a;

    // i/o  space: a000_0000 - bfff_ffff
    assign io_space = mem_a[31] & ~mem_a[30] & mem_a[29]; 
    assign io_rdn  = ~(rmem & io_space); // i/o read, active low    

    assign d_f_mem = io_rdn? {25'h0,d_f_vga} : {23'h0,ready,key_data};

endmodule