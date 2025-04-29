//WMA Calculator

//Authors: Kate Bailey, Reese Milhone

module WMA_Calculator (
	input wire [7:0] x,        	// current temp input
    input wire [7:0] WMA0,     		// previous WMA value
	input wire [7:0] T1,       	// low threshold
	input wire [7:0] T2,       	// high threshold
	output reg [7:0] WMA1      	// new WMA output
);

    	// internal registers for weights
	reg [1:0] w1, w0;
	
	// internal registers for numerator and denominator
	reg [7:0] num, denom;

	always @(*) begin           	// updates when input change
    	// determine weight w1 based on temperature range
    	if (x < T1) 
        	w1 = 1;
    	else if (x < T2) 
        	w1 = 3;
    	else 
        	w1 = 1;		        // default case

        w0 = w1;                	// always the same since no variables differ in calculation


    	//numerator without multiplication
    	if (w1 == 3) begin
        	num = (x << 1) + x + (WMA0 << 1) + WMA0;  // (3*x) + (3*WMA0)
    	end else begin
        	num = x + WMA0;
    	end

    	//denominator
		denom = w1 + w0;

		case (denom)
			2:	WMA1 = num >> 1;			//divide by 2
			6:	WMA1 = (num >> 3) + (num >> 4);	    	//divide by ~6
			default: WMA1 = num >> 1;			//default case divides by 2		
		endcase
	end
endmodule
