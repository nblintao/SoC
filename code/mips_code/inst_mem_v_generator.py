print '''module inst_mem_v (a,inst,ram_a,d_f_ram,wram,d_t_ram);
    input  [31:0] a;
    output [31:0] inst; 
    input [31:0] ram_a;
    output [31:0] d_f_ram;
    input wram;
    input [31:0] d_t_ram;

    reg   [31:0] ram [0:63];
    assign inst = ram[a[7:2]];
    assign d_f_ram = ram[ram_a[7:2]];    
'''

data = ''
datain = raw_input()
while datain!='':
    data += datain
    datain = raw_input()

print '    initial begin'

data = data.split(',')


for x in xrange(0,64):
    st = "        ram[6'h"
    st += hex(x)[2:]
    st += "] = 32'b"
    if(x<len(data)):
        st += data[x]
    else:
        st += '00000000000000000000000000000000'
    st+=';'
    print st

print '    end'
print 'endmodule'