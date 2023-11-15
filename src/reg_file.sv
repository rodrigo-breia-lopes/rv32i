module reg_file (
    // exec. signals
    input wire clk,		// clock signal ( 
    input wire rst,		// rst @ 1
    input wire we3,	    	// write enable (write at 1)

    // read
    input wire [4:0] add1,	// address input 1
    input wire [4:0] add2,  	// address input 2

    // write
    input wire [4:0] add3,	// address input 3, write port
    input wire [31:0] wd3,	// write data

    // alu out
    output logic [31:0] rd1,	// register data
    output logic [31:0] rd2,	// register data

    output logic [31:0] xreg [0:31] // register file
);

    integer i;

    // colocou-se no port para testbenching
    //reg [31:0] xreg [0:31]; // register file
    
    always @(posedge clk) begin
	// reset 
	if (rst) begin
	    for (i=0;i<32;i=i+1) begin
		xreg[i] <= 32'b0;
	    end

	// normal op
	end else begin
	    
	    rd1 <= xreg[add1];
	    rd2 <= xreg[add2];

	    if (we3) begin
		if (add3 == 5'h00) begin // x0 is short circuited to the value '0'
		    xreg[add3] <= 0;
		end else begin
		    xreg[add3] <= wd3;
		end
	    end
	end
    end

endmodule
