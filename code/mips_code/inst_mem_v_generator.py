data = ''
datain = raw_input()
while datain!='':
    if datain[0] == '0' or datain[0] == '1':
        data += datain
    datain = raw_input()
data = data[:-1]
data = data.split(',')

# ram_depth <= 10
ram_depth = 7

print '''module mio_ram (clk,a,inst,ram_a,d_f_ram,wram,d_t_ram);
    input clk;
    input  [31:0] a;
    output [31:0] inst; 
    input  [31:0] ram_a;
    output [31:0] d_f_ram;
    input         wram;
    input  [31:0] d_t_ram;

    reg   [31:0] ram [0:%d];
    assign inst = ram[a[%d:2]];
    assign d_f_ram = ram[ram_a[%d:2]];

    always @(negedge clk)begin
        if(wram)begin
            ram[ram_a[%d:2]] <= d_t_ram;
        end
    end
'''%(2**ram_depth-1, ram_depth+1, ram_depth+1, ram_depth+1)

print '    initial begin'

for x in xrange(0,2**ram_depth):
    st = "        ram[%d'h"%(ram_depth)
    st += '%02x'%(x)
    st += "] = 32'b"
    if(x<len(data)):
        st += data[x]
    else:
        st += '00000000000000000000000000000000'
    st+=';'
    print st

print '    end'
print 'endmodule'