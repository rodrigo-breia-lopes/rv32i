module program_counter (
    input wire clk,
    input wire rst,
    input wire [1:0] pc_src,
    input wire [31:0] imm,
    input wire [31:0] alu_out,
    output reg [31:0] pc_out
);

    always @(posedge clk) begin
        if (rst) begin
            pc_out <= 32'h00000000;
        end else begin
            case (pc_src)
                2'b00: pc_out <= pc_out + 4;
                2'b01: pc_out <= pc_out + imm;
                2'b10: pc_out <= alu_out;
                default: pc_out <= pc_out;
            endcase
        end
    end 

   
endmodule
