// immediate generator
// func:
// - decode immediate
// - extend (zero/msb) 
//
//
// imm_fields bits:31-7 + opcode (full instr)

module imm_gen(
    input wire [31:0] instr,
    output logic [31:0] imm 
);
    //parameter FIVE_MASK	  = 32'h0000_001F; // five bits mask
    //parameter BYTE_MASK   = 32'h0000_00FF; // byte mask
    //parameter WORD_MASK   = 32'h0000_FFFF; // word mask
    
    wire [6:0] opcode;	    // opcode field
    wire [2:0] funct3;	    // 3-bit function field, if applicable

    //wire [2:0] instr_type;  // instruction type flag

    logic [31:0] s_imm; //  sorted imm (before extensions if applicable)
    //logic [31:0] m_imm; //  (masked imm)

    assign opcode = instr[6:0];
    assign funct3 = instr[14:12];

    always_comb begin
	s_imm = 32'h00000000;
	// type decoder
	case(opcode) 

	    // I-type
	    7'b0010011,7'b0000011,7'b1100111,7'b1110011: begin
		s_imm[11:0] = instr[31:20];

	    	case (funct3)
	    	    3'h1,3'h5: imm = {26'b0,s_imm[5:0]};	// masked imm[4:0]
	    	    default :  imm = {{20{s_imm[11]}},s_imm[11:0]}; // sign-extended imm[11:0]
	    	endcase
	    end

	    // S-type ( imm[11:5] ccat imm[4:0] )
	    7'b0100011: begin
		s_imm[4:0]	= instr[11:7];
	    	s_imm[11:5]	= instr[31:25];

	    	imm = {{20{s_imm[11]}},s_imm[11:0]};
	    end

	    // B-type
	    7'b1100011: begin
		//s_imm[31:13]= 19'b000000000000000000; // acabar o padding
		s_imm[12]	= instr[31];
	    	s_imm[11]	= instr[7];
	    	s_imm[10:5]	= instr[30:25];
	    	s_imm[4:1]	= instr[11:8];

	    	imm = {{19{s_imm[12]}},s_imm[12:1],1'b0};
	    end
	    
	    // U-type
	    7'b0110111,7'b0010111: begin
		s_imm[31:12] = instr[31:12];	
	    	imm = {s_imm[31:12],12'b000000000000};	// padding
	    end

	    // J-type
	    7'b1101111: begin
		s_imm[20]	= instr[31];
	    	s_imm[10:1]	= instr[30:21];
	    	s_imm[11]	= instr[20];
	    	s_imm[19:12]= instr[19:12];

		imm = {{11{s_imm[20]}},s_imm[20:1],1'b0};
	    end

	    default: imm[31:0] = 32'h0000_0000;

	endcase
    end
 
endmodule
