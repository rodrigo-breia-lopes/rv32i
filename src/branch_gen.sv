/* verilator lint_off BLKSEQ */
module branch_gen (
    input wire [3:0] flag,          // ZNVC
    input wire [7:0] branch_type,   // beq/bne/blt/bge/bltu/bgeu/jal/jalr
    output logic [1:0] pc_src       // Prog. Ctr mux
);                                  // 0: PC + 4
                                    // 1: PC + imm
                                    // 2. PC + rs1 + imm
                                
    parameter BEQ  = 8'b00000001;
    parameter BNE  = 8'b00000010;
    parameter BLT  = 8'b00000100;
    parameter BGE  = 8'b00001000;
    parameter BLTU = 8'b00010000;
    parameter BGEU = 8'b00100000;
    parameter JAL  = 8'b01000000;
    parameter JALR = 8'b10000000;

    wire zf;
    wire nf;
    wire vf;
    wire cf;

    assign zf = flag [0];
    assign nf = flag [1];
    assign vf = flag [2];
    assign cf = flag [3];

    always_comb begin : branch_decoder
        case (branch_type)
            BEQ : pc_src = {1'b0, zf};
            BNE : pc_src = {1'b0, !zf};
            BLT : pc_src = {1'b0, nf^vf};
            BGE : pc_src = {1'b0, !(nf ^ vf)};
            BLTU: pc_src = {1'b0, cf};
            BGEU: pc_src = {1'b0, !cf};
            JAL : pc_src = 2'b01;        // unconditional
            JALR: pc_src = 2'b10;
            default : pc_src = 2'b00;
        endcase
    end
    
endmodule
