//WMA Calculator

//Authors: Kate Bailey, Reese Milhone

module tb_WMA_Calculator;
    //inputs
    reg [7:0] x;
    reg [7:0] WMA0;
    reg [7:0] T1;
    reg [7:0] T2;
    
    //output
    wire [7:0] WMA1;
    
    //calculator module instance
    WMA_Calculator uut (
        .x(x),
        .WMA0(WMA0),
        .T1(T1),
        .T2(T2),
        .WMA1(WMA1)
    );
    
    always @(*) begin
    // Check that w1 assignment is correct
    if (x < T1)
        `assert(uut.w1 == 1)
    else if (x < T2)
        `assert(uut.w1 == 3)
    else
        `assert(uut.w1 == 1)
    end
    
    
    initial begin
        //test cases below!
        T1 = 8'd75;  
        T2 = 8'd85;
    
        $display("\nThresholds: T1 = %d, T2 = %d", T1, T2);
        //column headers
        $display(" x  |  WMA0 |W1 | W0| num | denom | WMA1");
    
        //printed values
        $monitor("%d | %d   | %d | %d | %d |  %d  | %d", x, WMA0, uut.w1, uut.w0, uut.num, uut.denom, WMA1);

        #10 x = 8'd50;  WMA0 = 8'd60;   // case: x < T1, W1 = 1, W0 = 1
        #10 x = 8'd80;  WMA0 = 8'd70;   // case: T1 < x < T2, W1 = 3, W0 = 3
        #10 x = 8'd90;  WMA0 = 8'd100;  // case: x > T2, W1 = 1, W0 = 1
        #10 x = 8'd75;  WMA0 = 8'd85;   // edge case: x == T1, W1 = 3
        #10 x = 8'd85;  WMA0 = 8'd75;   // edge case: x == T2, W1 = 1
        #10 x = 8'd100; WMA0 = 8'd50;   // case: x > T2, WMA0 < T1
    
        #10 x = 8'd0;   WMA0 = 8'd0;    // edge case: extreme low values
        #10 x = 8'd255; WMA0 = 8'd255;  // edge case: extreme high values
        #10 x = 8'd76;  WMA0 = 8'd76;   // case: just over T1
        #10 x = 8'd84;  WMA0 = 8'd84;   // case: just under T2
        #10 x = 8'd74;  WMA0 = 8'd74;   // case: just under T1
        #10 x = 8'd86;  WMA0 = 8'd86;   // case: just over T2
        #10 x = 8'd80;  WMA0 = 8'd200;  // case: mixed range: mid x, high WMA0
        #10 x = 8'd200; WMA0 = 8'd80;   // case: mixed range: high x, mid WMA0
        #10 x = 8'd10;  WMA0 = 8'd200;  // case: large diff, x low
        #10 x = 8'd200; WMA0 = 8'd10;   // case: large diff, x high
    end
    
    
        // new thresholds
    initial begin
        #200; // wait, don't overlap previous tests
        T1 = 8'd60;  
        T2 = 8'd120;

        $display("\nNew Thresholds: T1 = %d, T2 = %d", T1, T2);
        $display(" x  |  WMA0 |W1 | W0| num | denom | WMA1");
        $monitor("%d | %d   | %d | %d | %d |  %d  | %d", x, WMA0, uut.w1, uut.w0, uut.num, uut.denom, WMA1);

        #10 x = 8'd50;  WMA0 = 8'd50;   // x < T1, W1 = 1, W0 = 1
        #10 x = 8'd70;  WMA0 = 8'd70;   // T1 < x < T2, W1 = 3, W0 = 3
        #10 x = 8'd130; WMA0 = 8'd130;  // x > T2, W1 = 1, W0 = 1
        #10 x = 8'd60;  WMA0 = 8'd60;   // x == T1, edge case
        #10 x = 8'd120; WMA0 = 8'd120;  // x == T2, edge case
        #10 x = 8'd90;  WMA0 = 8'd100;  // middle value between T1 and T2
        #10 x = 8'd119; WMA0 = 8'd119;  // just under T2

        #10 $finish;
    end
    
endmodule