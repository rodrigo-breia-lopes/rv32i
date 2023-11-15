module alu (
    input wire clk,
    input wire rst,
    input wire [5:0]  op,	        // alu op 
    input wire [31:0] in_a, in_b,     // operands

    output logic [31:0] out,	// alu output
    output logic [3:0] o_flag   // CVNZ 
);

   logic z_flg = o_flag [0];
   logic n_flg = o_flag [1];
   logic v_flg = o_flag [2];
   logic c_flg = o_flag [3];

    //logic aux_n;
    //logic aux_v;
    logic [31:0] aux_out;
    logic aux_n;
    logic aux_v;

    logic [31:0] f;

    always @(posedge clk) begin
            
	    if (rst) begin

	        out <= 0;
            o_flag <= 4'b0000;

	    end else begin

	        case (op)
	            6'h00:  out <= in_a + in_b;	// add / addi
                6'h01:  begin  
                    out   <= in_a - in_b;
                    z_flg <= ((in_a-in_b) == 0) ? 1'b1 : 1'b0;
                    n_flg <= |((in_a - in_b) >> 31);
                    v_flg <= (in_a[31]^in_b[31] && !(in_b[31]^(|((in_a - in_b) >> 31))));
                    c_flg <= in_a < in_b;
                end 	// sub 
	            6'h02:  out <= in_a ^ in_b;	// xor / xori
	            6'h03:  out <= in_a | in_b;	// or  / ori
	            6'h04:  out <= in_a & in_b;	// and / andi 
	            6'h05:  out <= in_a << in_b;	// sll / slli
	            6'h06:  out <= in_a >> in_b;	// srl / srli
	            6'h07:  out <= in_a >>> in_b;  	// sra / srai
                6'h08:  begin
                    aux_n = |((in_a - in_b) >> 31);
                    aux_v = (in_a[31]^in_b[31] && !(in_b[31] ^ aux_n));
                    out  <= {{31{1'b0}},{aux_n ^ aux_v}};
                end
	            6'h09:  out <= (in_a < in_b) ? 32'h00000001 : 32'h00000000; // sltu / sltiu
	            6'h0A:  out <= in_a + 4;     // in_a: PC
                6'h0B:  out <= in_b << 12;
                6'h0C:  out <= in_a + (in_b << 12); // in_a: PC
                default : begin
                    out <= 32'hffffffff;
                    $display("error: illegal op!");
                end
        	    endcase
	    end

        o_flag <= {c_flg, v_flg, n_flg, z_flg};
    end

endmodule
