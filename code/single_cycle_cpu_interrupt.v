module single_cycle_cpu_interrupt (clock, resetn, inst, d_f_mem, pc, m_addr, d_t_mem, wmem, rmem,intr0, intr1);
    input  clock, resetn;  // clock and reset (active low)
    input  [31:0] inst;    // instruction from instruction memory
    input  [31:0] d_f_mem; // data from data memory
    output [31:0] pc;      // program counter to instruction memory
    output [31:0] m_addr;  // data memory address
    output [31:0] d_t_mem; // data to data memory
    output wmem;
    output rmem;
    input  intr0;          // interrupt request for timer
    input  intr1;          // interrupt request for keyboard

    // internal signals (instruction format)
    wire [05:00] opcode = inst[31:26];
    wire [04:00] rs     = inst[25:21];
    wire [04:00] rt     = inst[20:16];
    wire [04:00] rd     = inst[15:11];
    wire [04:00] sa     = inst[10:06];
    wire [05:00] func   = inst[05:00];
    wire [15:00] imm    = inst[15:00];
    wire [25:00] addr   = inst[25:00];
    wire         sign   = inst[15];

    // instruction decode
    wire i_add  = (opcode == 6'h00) & (func == 6'h20);
    wire i_sub  = (opcode == 6'h00) & (func == 6'h22);
    wire i_and  = (opcode == 6'h00) & (func == 6'h24);
    wire i_or   = (opcode == 6'h00) & (func == 6'h25);
    wire i_xor  = (opcode == 6'h00) & (func == 6'h26);
    wire i_slt  = (opcode == 6'h00) & (func == 6'h2a);
    wire i_sll  = (opcode == 6'h00) & (func == 6'h00);
    wire i_srl  = (opcode == 6'h00) & (func == 6'h02);
    wire i_sra  = (opcode == 6'h00) & (func == 6'h03);
    wire i_jr   = (opcode == 6'h00) & (func == 6'h08);
    wire i_addi = (opcode == 6'h08);
    wire i_andi = (opcode == 6'h0c);
    wire i_ori  = (opcode == 6'h0d);
    wire i_xori = (opcode == 6'h0e);
    wire i_slti = (opcode == 6'h0a);
    wire i_lw   = (opcode == 6'h23);
    wire i_sw   = (opcode == 6'h2b);
    wire i_beq  = (opcode == 6'h04);
    wire i_bne  = (opcode == 6'h05);
    wire i_lui  = (opcode == 6'h0f);
    wire i_j    = (opcode == 6'h02);
    wire i_jal  = (opcode == 6'h03);
    wire i_eret = (opcode == 6'h10) & inst[25] & (func == 6'h18); // interrupt return

    // pc, epc, and ie (interrupt enable) register
    // 0x0000_0000:       j   my_program     # jump to my proram
    // 0x0000_0004:       nop                # delay slot for pipelined cpu
    // 0x0000_0008: int0: j   timer_handler  # deal with timer interrupt
    // 0x0000_000c:       nop                # delay slot for pipelined cpu
    // 0x0000_0010: int1: j   kbd_handler    # deal with keyboard interrupt
    // 0x0000_0014:       nop                # delay slot for pipelined cpu
    reg [31:0] pc, epc;
    reg ie = 1;
    always @ (posedge clock or negedge resetn) begin
        if (!resetn) begin 
            pc  <= 32'h00;
            ie  <= 1'b1;                 // interrupt enable
        end else if (i_eret) begin
            pc  <= epc;                  // interrupt return
            ie  <= 1'b1;                 // interrupt enable
        end else if (intr0 && ie) begin
            epc <= next_pc;              // return address
            pc  <= 32'h08;               // interrupt0 exc_base
            ie  <= 1'b0;                 // interrupt disable
        end else if (intr1 && ie) begin
            epc <= next_pc;              // return address
            pc  <= 32'h10;               // interrupt1 exc_base
            ie  <= 1'b0;                 // interrupt disable
        end else pc  <= next_pc;
    end

    // data written to register file
    wire [31:0] data_2_rf = i_lw ? d_f_mem : ALU_out;

    // register file
    reg  [31:0] regfile [1:31];
    wire [31:0] a = (rs==0) ? 0 : regfile[rs];
    wire [31:0] b = (rt==0) ? 0 : regfile[rt];
    always @ (posedge clock) begin
        if (wreg && (dest_rn != 0)) begin
            regfile[dest_rn] <= data_2_rf;
        end
    end

    // pc + 4
    wire [31:0] pc_plus_4 = pc + 4;
    
    assign d_t_mem =   b;
    assign m_addr  =   ALU_out;
   
    // control signals and ALU output
    // will be combinational circuit
    reg wreg, wmem, rmem;
    reg [31:0] ALU_out;
    reg [4:0]  dest_rn;
    reg [31:0] next_pc;
    always @(*) begin
        ALU_out = 0;
        dest_rn = rd;
        wreg    = 0;
        wmem    = 0;
        rmem    = 0;
        next_pc = pc_plus_4;

        case (1'b1)
            i_add: begin // add
                ALU_out = a + b;
                wreg    = 1; end
            i_sub: begin // sub
                ALU_out = a - b;
                wreg    = 1; end
            i_and: begin // and
                ALU_out = a & b;
                wreg    = 1; end
            i_or: begin // or
                ALU_out = a | b;
                wreg    = 1; end
            i_xor: begin // xor
                ALU_out = a ^ b;
                wreg    = 1; end
            i_slt: begin // slt
                ALU_out = a < b;
                wreg    = 1; end            
            i_sll: begin // sll
                ALU_out = b << sa;
                wreg    = 1; end
            i_srl: begin // srl
                ALU_out = b >> sa;
                wreg    = 1; end
            i_sra: begin // sra
                ALU_out = $signed(b) >>> sa;
                wreg    = 1; end
            i_jr: begin // jr
                next_pc = a; end
            i_addi: begin // addi
                ALU_out = a + {{16{sign}},imm};
                dest_rn = rt;
                wreg    = 1; end
            i_andi: begin // andi
                ALU_out = a & {16'h0,imm};
                dest_rn = rt;
                wreg    = 1; end
            i_ori: begin // ori
                ALU_out = a | {16'h0,imm};
                dest_rn = rt;
                wreg    = 1; end
            i_xori: begin // xori
                ALU_out = a ^ {16'h0,imm};
                dest_rn = rt;
                wreg    = 1; end
            i_slti: begin // slti
                ALU_out = a < {16'h0,imm};
                dest_rn = rt;
                wreg    = 1; end                
            i_lw: begin // lw
                ALU_out = a + {{16{sign}},imm};
                dest_rn = rt;
                rmem    = 1;
                wreg    = 1; end
            i_sw: begin // sw
                ALU_out = a + {{16{sign}},imm};
                wmem    = 1; end
            i_beq: begin // beq
                if (a == b) 
                  next_pc = pc_plus_4 + {{14{sign}},imm,2'b00}; end
            i_bne: begin // bne
                if (a != b) 
                  next_pc = pc_plus_4 + {{14{sign}},imm,2'b00}; end
            i_lui: begin // lui
                ALU_out = {imm,16'h0};
                dest_rn = rt;
                wreg    = 1; end
            i_j: begin // j
                next_pc = {pc_plus_4[31:28],addr,2'b00}; end
            i_jal: begin // jal
                ALU_out = pc_plus_4;
                wreg    = 1;
                dest_rn = 5'd31;
                next_pc = {pc_plus_4[31:28],addr,2'b00}; end
            default: ;
        endcase
    end
endmodule
