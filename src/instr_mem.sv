// instruction memory access
module instr_mem (
    input wire [31:0] addr,
    input wire clk,
    input wire rst,
    output logic [31:0]	data
    );

    logic [7:0] memory [16000:0];

//    logic [7:0] memory [249:0];
   
    always @(posedge clk) begin
        if(rst) begin
           $readmemh("./test/output_byte_file.hex", memory); 
        end else begin
            data <= {memory[addr+3],memory[addr+2],memory[addr+1],memory[addr]};
        end
    end


endmodule
