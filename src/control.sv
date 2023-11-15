module control (
    input wire [6:0] opcode,
    input wire [2:0] funct3,
    output logic [7:0] branch_jump_type, // beq/bne/blt/bge/bltu/bgeu/jal/jalr
    output logic alu_src_a,         // rs1/PC
    output logic alu_src_b,         // rs2/imm
    output logic [1:0] rd_src,      // alu_out/data_mem_read/link/
    output logic mem_read,
    output logic mem_write,
    output logic reg_write
);
    parameter BEQ  = 8'b00000001;
    parameter BNE  = 8'b00000010;
    parameter BLT  = 8'b00000100;
    parameter BGE  = 8'b00001000;
    parameter BLTU = 8'b00010000;
    parameter BGEU = 8'b00100000;
    parameter JAL  = 8'b01000000;
    parameter JALR = 8'b10000000;

    always_comb begin

        case (opcode)
            7'b0110011:begin    // r-type
                branch_jump_type = 8'b00000000;
                alu_src_a = 1'b0;
                alu_src_b = 1'b0;
                rd_src = 2'b00;
                mem_read = 1'b0;
                mem_write = 1'b0;
                reg_write = 1'b1;
            end
            7'b0010011:begin    // i-type arithmetic/logic
                branch_jump_type = 8'b00000000;
                alu_src_a = 1'b0;
                alu_src_b = 1'b1;
                rd_src = 2'b00;
                mem_read = 1'b0;
                mem_write = 1'b0;
                reg_write = 1'b1;
            end
            7'b0000011:begin    // i-type load from mem
                branch_jump_type = 8'b00000000;
                alu_src_a = 1'b0;
                alu_src_b = 1'b1;
                rd_src = 1'b01;
                mem_read = 1'b1;
                mem_write = 1'b0;
                reg_write = 1'b1;
            end
            7'b0100011:begin    // s-type (store)
                branch_jump_type = 8'b00000000;
                alu_src_a = 1'b0;
                alu_src_b = 1'b1;
                rd_src = 2'bxx;
                mem_read = 1'b0;
                mem_write = 1'b1;
                reg_write = 1'b0;
            end
            7'b1100011:begin    // b-type (branch)
                case(funct3) 
                    3'h0: branch_jump_type = BEQ;
                    3'h1: branch_jump_type = BNE;
                    3'h4: branch_jump_type = BLT;
                    3'h5: branch_jump_type = BGE;
                    3'h6: branch_jump_type = BLTU;
                    3'h7: branch_jump_type = BGEU;
                    default: branch_jump_type = 8'b00000000;
                endcase
                alu_src_a = 1'b0;
                alu_src_b = 1'b0;
                rd_src = 2'bxx;            
                mem_read = 1'b0;
                mem_write = 1'b0;
                reg_write = 1'b0;
            end
            7'b1101111:begin    // jal
                branch_jump_type = JAL;
                alu_src_a = 1'bx;
                alu_src_b = 1'bx;
                rd_src = 2'b10; 
                mem_read = 1'b0;
                mem_write = 1'b0;
                reg_write = 1'b1;
            end
            7'b1100111:begin // jalr
                branch_jump_type = JALR;
                alu_src_a = 1'b1;
                alu_src_b = 1'b1;
                rd_src = 2'b10;
                mem_read = 1'b0;
                mem_write = 1'b0;
                reg_write = 1'b1;
            end
            default : begin
                branch_jump_type = 8'bzzzzzzzz;
                alu_src_a = 1'bz;
                alu_src_b = 1'bz;
                rd_src = 2'bzz;
                mem_read = 1'bz;
                mem_write = 1'bz;
                reg_write = 1'bz;
                $display("error: illegal opcode!");
            end
        endcase
    end
    
endmodule
