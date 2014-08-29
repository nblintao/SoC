data = ''
datain = raw_input()
while datain!='':
    if datain[0] == '0' or datain[0] == '1':
        data += datain
    datain = raw_input()
data = data[:-1]
data = data.split(',')

# ram_depth <= 10
ram_depth = 8

print '// data length is %d'%(len(data))
if len(data) <= 8:
    ram_depth = 3
elif len(data) <= 16:
    ram_depth = 4    
elif len(data) <= 32:
    ram_depth = 5
elif len(data) <= 64:
    ram_depth = 6
elif len(data) <= 128:
    ram_depth = 7
elif len(data) <= 256:
    ram_depth = 8
elif len(data) <= 512:
    ram_depth = 9    
else :
    pass

print '// ram depth is %d'%(ram_depth)

print '''module mio_rom (a, inst, rom_a, d_f_rom);
    input  [31:0] a;
    output [31:0] inst; 
    input  [31:0] rom_a;
    output [31:0] d_f_rom;

    wire   [31:0] rom [0:%d];
    assign inst    = rom[a[%d:2]];
    assign d_f_rom = rom[rom_a[%d:2]];
'''%(2**ram_depth-1, ram_depth+1, ram_depth+1)

#print '    initial begin'

for x in xrange(0,2**ram_depth):
    st = "    assign rom[%d'h"%(ram_depth)
    st += '%02x'%(x)
    st += "] = 32'b"
    if(x<len(data)):
        st += data[x]
    else:
        st += '00000000000000000000000000000000'
    st+=';'
    print st

#print '    end'
print 'endmodule'