module op_decoder(
     input wire [31:0] instr,
     output logic [4:0] op
);

    wire [6:0] opcode;
    wire [2:0] funct3;
    wire [6:0] funct7;
    wire [6:0] imtest;
    wire ebreak_t;

    // Extracting instruction fields
    assign opcode = instr[6:0];
    assign funct3 = instr[14:12];
    assign funct7 = instr[31:25];
    assign immtest= instr[11:5];
    assign ebreak_t = instr[20];

    // r-r and r-imm arithmetic/logic operations are identical (except for sub) from the alu's
    // perspective so add/addi op will be the same

    always_comb begin
    case (opcode)
            7'b0110011:  // R-type
                case ({funct7, funct3})
                    {7'b0000000, 3'b000}: op = 5'h00; // add
                    {7'b0100000, 3'b000}: op = 5'h01; // sub
                    {7'b0000000, 3'b100}: op = 5'h02; // xor
                    {7'b0000000, 3'b110}: op = 5'h03; // or
                    {7'b0000000, 3'b111}: op = 5'h04; // and
                    {7'b0000000, 3'b001}: op = 5'h05; // sll
                    {7'b0000000, 3'b101}: op = 5'h06; // srl
                    {7'b0100000, 3'b101}: op = 5'h07; // sra
                    {7'b0000000, 3'b010}: op = 5'h08; // slt
                    {7'b0000000, 3'b011}: op = 5'h09; // sltu
                    default: op = 5'h1F; // invalid R-type instruction
                endcase
            7'b0010011: // I-type
                case (funct3)
                    3'b000: op = 5'h00; // addi
                    3'b100: op = 5'h02; // xori
                    3'b110: op = 5'h03; // ori
                    3'b111: op = 5'h04; // andi
                    3'b001: op = 5'h05; // slli
                    3'b101: op = (immtest != 7'h20) ? 5'h06: 5'h07; // srli / srai
                    3'b010: op = 5'h08; // slti
                    3'b011: op = 5'h09; // sltiu
                    default: op = 5'h1F; // invalid I-type instruction
                endcase
            7'b0000011: // Load instructions (also I-type)
                case (funct3)
                    3'b000: op = 5'h00; // lb
                    3'b001: op = 5'h00; // lh
                    3'b010: op = 5'h00; // lw
                    3'b100: op = 5'h00; // lbu
                    3'b101: op = 5'h00; // lhu
                    default: op = 5'h1F; // invalid Load instruction
                endcase
            7'b0100011: // S-type
                case (funct3)
                    3'b000: op = 5'h00; // sb
                    3'b001: op = 5'h00; // sh
                    3'b010: op = 5'h00; // sw
                    default: op = 5'h00; // invalid S-type instruction
                endcase
            7'b1100011: // B-type
                case (funct3)
                    3'b000: op = 5'h01; // beq  // register sub
                    3'b001: op = 5'h01; // bne  // ''
                    3'b100: op = 5'h01; // blt
                    3'b101: op = 5'h01; // bge
                    3'b110: op = 5'h01; // bltu
                    3'b111: op = 5'h01; // bgeu
                    default: op = 5'h1F; // invalid B-type instruction
                endcase
            7'b1101111: op = 5'h0A; // jal (J-type) // nop?
            7'b1100111: op = 5'h00; // jalr (I-type)
            7'b0110111: op = 5'h0B; // lui (U-type)
            7'b0010111: op = 5'h0C; // auipc (U-type)
            7'b1110011:	op = (~ebreak_t) ? 5'h1C : 5'h1D; // ecall ebreak // Environment (I-type)
                    default: op = 5'h1F; // invalid Environment instruction
            default: op = 5'h1F; // invalid opcode
        endcase
    end

endmodule
