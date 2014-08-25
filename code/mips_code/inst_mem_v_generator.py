print '''module inst_mem_v (a,inst);   // instruction memory, rom
    input  [31:0] a;                        // address
    output [31:0] inst;                     // instruction
    wire   [31:0] rom [0:63];               // rom cells: 64 words * 32 bits
    assign inst = rom[a[7:2]];              // use word address to read rom
    // rom[word_addr] = instruction'''

data = ''
datain = raw_input()
while datain!='':
    data += datain
    datain = raw_input()

# print data
# data = '''00111100000000111100000000000000,
# 00100000000001010000000000100001,
# 00001100000000000000000000000111,
# 00100000101001010000000000000001,
# 00101000101000100000000000101000,
# 00010100010000001111111111111100,
# 00001000000000000000000000000110,
# 10101100011001010000000000000000,
# 00100000011000110000000000000100,
# 00000011111000000000000000001000,
# 00000000000000000000000000000000,
# 00000000000000000000000000000000,
# 00000000000000000000000000000000,
# 00000000000000000000000000000000,
# 00000000000000000000000000000000,
# 00000000000000000000000000000000'''


data = data.split(',')


for x in xrange(0,64):
    st = "    assign rom[6'h"
    st += hex(x)[2:]
    st += "] = 32'b"
    if(x<len(data)):
        st += data[x]
    else:
        st += '00000000000000000000000000000000'
    st+=';'
    print st

print 'endmodule'