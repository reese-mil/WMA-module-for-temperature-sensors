`timescale 1ns/1ps

//WMA Calculator

//Authors: Kate Bailey, Reese Milhone


module tb_WMA_Calculator;
	// inputs
	reg [7:0] x;
	reg [7:0] WMA0;
	reg [1:0] threshold_select;

	// outputs
	wire [7:0] T1;
	wire [7:0] T2;
	wire [7:0] WMA1;
    
    	//calculator module instance
	WMA_Calculator uut (
		.x(x),
		.WMA0(WMA0),
		.threshold_select(threshold_select),
		.T1(T1),
		.T2(T2),
		.WMA1(WMA1)
	);
    
	initial begin
		// column names
		$display("Time | x  | WMA0 | T1 | T2 | WMA1 | threshold_select");
		$monitor("%4t | %3d | %4d | %3d | %3d | %4d | %2b", $time, x, WMA0, T1, T2, WMA1, threshold_select);

		// test cases
		threshold_select = 2'b00; // P = 32
		x = 8'd50; WMA0 = 8'd60; #10;
		x = 8'd80; WMA0 = 8'd70; #10;
		x = 8'd90; WMA0 = 8'd100; #10;

		threshold_select = 2'b01; // P = 64
		x = 8'd75; WMA0 = 8'd85; #10;
		x = 8'd85; WMA0 = 8'd75; #10;

		threshold_select = 2'b10; // P = 128
		x = 8'd100; WMA0 = 8'd50; #10;
		
		// edge case: both inputs zero, lowest possible delta (P=32)
	        threshold_select = 2'b00;
	        x = 8'd0; WMA0 = 8'd0; #10;
	
	        // edge case: both inputs maxed
	        threshold_select = 2'b00;
	        x = 8'd255; WMA0 = 8'd255; #10;
	
	        // identical mid values
	        threshold_select = 2'b01;
	        x = 8'd128; WMA0 = 8'd128; #10;
	
	        // sharp increase
	        threshold_select = 2'b01;
	        x = 8'd200; WMA0 = 8'd50; #10;
	
	        // sharp decrease
	        threshold_select = 2'b10;
	        x = 8'd30; WMA0 = 8'd200; #10;
	
	        // alternating around threshold range
	        threshold_select = 2'b10;
	        x = 8'd100; WMA0 = 8'd120; #10;
	        x = 8'd130; WMA0 = 8'd110; #10;
	        x = 8'd110; WMA0 = 8'd130; #10;
	        x = 8'd120; WMA0 = 8'd100; #10;
	
	        // just below and just above threshold boundaries
	        threshold_select = 2'b00;
	        x = 8'd127; WMA0 = 8'd128; #10;
	        x = 8'd129; WMA0 = 8'd128; #10;
	
	        // very small difference (testing low delta sensitivity)
	        threshold_select = 2'b10;
	        x = 8'd100; WMA0 = 8'd101; #10;
        
		// test with threshold_select = 2'b11 (should default to P=32)
		threshold_select = 2'b11;
		x = 8'd60; WMA0 = 8'd60; #10;
		x = 8'd62; WMA0 = 8'd60; #10;
		x = 8'd58; WMA0 = 8'd60; #10;

		$finish;
	end
endmodule
