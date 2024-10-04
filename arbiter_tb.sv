`timescale 1ns/1ps

module arbiter_tb;

    // Testbench signals
    logic clk;
    logic rst_n;
    logic m1_req;
    logic m2_req;

    // Outputs from DUT
    logic m1_grant;
    logic m2_grant;
    logic [1:0] M_select;

    // Instantiate the arbiter DUT (Design Under Test)
    arbiter dut (
        .clk(clk),
        .rst_n(rst_n),
        .m1_req(m1_req),
        .m2_req(m2_req),
        .m1_grant(m1_grant),
        .m2_grant(m2_grant),
        .M_select(M_select)
    );

    // Clock generation
    // always #5 clk = ~clk;

    initial begin
		 clk = 0;
		 repeat(250) #5 clk = ~clk;  // 20 ns period, 50 MHz clock, finite number of cycles
	end

    // Testbench procedure
    initial begin
        // Initialize inputs
        clk = 0;
        rst_n = 0;
        m1_req = 0;
        m2_req = 0;

        // Apply reset
        #10 rst_n = 1;

        // Test scenario 1: Only m1 requests the bus
        #10;
        m1_req = 1;
        m2_req = 0;
        #20;

        // Test scenario 2: Only m2 requests the bus
        m1_req = 0;
        m2_req = 1;
        #20;

        // Test scenario 3: Both m1 and m2 request the bus (m1 has higher priority)
        m1_req = 1;
        m2_req = 1;
        #20;

        // Test scenario 4: m1 stops requesting, m2 still requests
        m1_req = 0;
        m2_req = 1;
        #20;

        // Test scenario 5: Both m1 and m2 stop requesting
        m1_req = 0;
        m2_req = 0;
        #20;

        // Test scenario 6: m1 starts requesting after both had stopped
        m1_req = 1;
        m2_req = 0;
        #20;

        // End simulation
        #50 $finish;
    end

    // Monitor signals
    initial begin
        $monitor("Time=%0t | m1_req=%b, m2_req=%b, m1_grant=%b, m2_grant=%b, M_select=%b", 
                  $time, m1_req, m2_req, m1_grant, m2_grant, M_select);
    end

endmodule
