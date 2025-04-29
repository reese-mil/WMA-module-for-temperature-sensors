`timescale 1ns/1ps

//WMA Calculator

//Authors: Kate Bailey, Reese Milhone


module WMA_Calculator (
	input wire [7:0] x,        	// current temp input
    input wire [7:0] WMA0,     	// prev WMA value
    input wire [1:0] threshold_select,   //selector for P value
	output reg [7:0] WMA1,      	// current WMA output
	output reg [7:0] T1,
	output reg [7:0] T2
);

	reg [1:0] w1, w0;          	// weights for current and previous WMA values
	reg [7:0] num, denom;      	// temporary storage for numerator and denominator
    reg [7:0] delta;            //difference amount based on P

	always @(*) begin               //updates any time there's an input change
    	// determine weight w1 based on temperature range
    	if (x < T1) 
        	w1 = 1;
    	else if (x < T2) 
        	w1 = 3;
    	else 
        	w1 = 1;		    //default case
        w0 = w1;            // always same value since no variables differ in calculation


    	//numerator without multiplication
    	if (w1 == 3) begin
        	num = (x << 1) + x + (WMA0 << 1) + WMA0;  // (3*x) + (3*WMA0)
    	end else begin
        	num = x + WMA0;
    	end

    	//denominator
		denom = w1 + w0;

		case (denom)
			2:	WMA1 = num >> 1;			        //divide by 2
			6:	WMA1 = (num >> 3) + (num >> 4);		//divide by ~6
			default: WMA1 = num >> 1;			    //default case divides by 2		
		endcase
		
		case (threshold_select)
            2'b00: delta = WMA1 >> 5;               // P=32
            2'b01: delta = WMA1 >> 6;               // P=64
            2'b10: delta = WMA1 >> 7;               // P=128
            default: delta = WMA1 >> 5;             // default to P=32
        endcase

        // set thresholds
        T1 = WMA1 - delta;
        T2 = WMA1 + delta;
        
        
	end
endmodule
