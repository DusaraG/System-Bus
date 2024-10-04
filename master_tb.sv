`timescale 1ns/1ps

module master_tb;

    // Testbench signals
    logic clk;
    logic rst_n;
    logic bgrant;
    logic ready;

    logic [15:0] U_addr;
    logic [7:0] U_wdata;
    logic [7:0] rdata;
    logic U_mode;
    logic U_start;

    // Outputs from DUT
    logic breq;
    logic mode;
    logic [15:0] addr;
    logic [7:0] wdata;
    logic [7:0] U_rdata;
    logic valid;
    logic [2:0] state_show;

    // Instantiate the master DUT (Design Under Test)
    master2 dut (
        .clk(clk),
        .rst_n(rst_n),
        .breq(breq),
        .bgrant(bgrant),
        .mode(mode),
        .addr(addr),
        .wdata(wdata),
        .rdata(rdata),
        .valid(valid),
        .ready(ready),
        .U_addr(U_addr),
        .U_wdata(U_wdata),
        .U_rdata(U_rdata),
        .U_mode(U_mode),
        .U_start(U_start),
        .state_show(state_show)
    );

    // Clock generation
    initial begin
		 clk = 0;
		 repeat(250) #5 clk = ~clk;  // 20 ns period, 50 MHz clock, finite number of cycles
	end

    // Testbench procedure
    initial begin
        // Initialize inputs
        rst_n = 0;
        bgrant = 0;
        ready = 0;
        U_addr = 16'h0000;
        U_wdata = 8'h00;
        U_mode = 0; // Read mode
        U_start = 0;

        // Apply reset
        #10 rst_n = 1;
        
        // Test write operation

        #10;
        U_addr = 16'h1234;
        U_mode = 0; 
        U_start = 1;
        #40
        bgrant = 1;
        #10 ready = 1;
        rdata = 8'hCD;

        // #10 ready = 0;

        // #10;

        // U_addr = 16'h5678;
        // U_mode = 1;
        // U_wdata = 8'hAB;
        // U_start = 1;

        // #10
        // bgrant = 1;
        // #10 ready = 1;

        // #20 ready = 0;

        
        // Observe the read data from the master
        #10;
        $display("Read data from master: %h", U_rdata);
        
        // End simulation
        #50 $finish;
    end

endmodule
