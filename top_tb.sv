module top_tb;

    // Inputs to DUT (Device Under Test)
    logic clk;
    logic rst_n;



    logic m1_U_start;
    logic [15:0] m1_U_addr;
    logic [7:0] m1_U_wdata;
    logic m1_U_mode; // 0 for read, 1 for write
    logic [2:0] m1_state_show;
    logic [7:0] m1_U_rdata;


    logic m2_U_start;
    logic [15:0] m2_U_addr;
    logic [7:0] m2_U_wdata;
    logic m2_U_mode; // 0 for read, 1 for write
    logic [2:0] m2_state_show;
    logic [7:0] m2_U_rdata;


    // Instantiate the DUT (top module)
    top uut (
        .clk(clk),
        .rst_n(rst_n),
        .m1_U_start(m1_U_start),
        .m1_U_addr(m1_U_addr),
        .m1_U_wdata(m1_U_wdata),
        .m1_U_mode(m1_U_mode),
        .m1_state_show(m1_state_show),
        .m1_U_rdata(m1_U_rdata),
        .m2_U_start(m2_U_start),
        .m2_U_addr(m2_U_addr),
        .m2_U_wdata(m2_U_wdata),
        .m2_U_mode(m2_U_mode),
        .m2_state_show(m2_state_show),
        .m2_U_rdata(m2_U_rdata)
        

    );

    // Clock generation
    initial begin
        clk = 0;
        repeat(250) #5 clk = ~clk; // 100MHz clock
    end

    // Test stimulus
    initial begin
        // Initialize signals
        rst_n = 0;
        m1_U_start = 0;
        m1_U_addr = 16'h0000;
        m1_U_wdata = 8'h00;
        m1_U_mode = 1'b0; // Master 1 in read mode by default
        // ready = 1'b1;     // Slave is ready
        // rdata = 8'hAA;    // Data to be read by Master 1 from slave

        // Reset sequence
        #10 rst_n = 1;

        // Test 1: Master 1 read operation
        #10;
        // m1_U_start = 1;       // Start read operation
        // m1_U_addr = 16'h1234; // Set read address
        // m1_U_mode = 0;        // Set Master 1 in read mode

        // #60;
        // rst_n = 0; // Reset
        #15;
        rst_n = 1; // Release reset
        #20;
        m1_U_start = 0; // End read operation

        // Test 2: Master 1 write operation
        #20;
        m1_U_start = 1;        // Start write operation
        m1_U_addr = 16'h1001;  // Set write address
        m1_U_wdata = 8'h55;    // Write data
        m1_U_mode = 1;         // Set Master 1 in write mode
        #10;
        // m2_U_mode = 1;         // Set Master 2 in write mode
        // m2_U_start = 1;        // Start write operation
        // m2_U_addr = 16'h2001;  // Set write address
        // m2_U_wdata = 8'hAA;    // Write data
        #50;
        m1_U_start = 0; // End write operation
        // #10;
        // m2_U_start = 0; // End write operation
        #80;

        //read operation
        m1_U_start = 1;   
        m1_U_addr = 16'h1001;
        m1_U_mode = 0;
        #70;
        m1_U_start = 0;
        #80;
        rst_n = 0; // Reset
        // m1_U_start = 0; // End write operation

        // Observe results
        #50;
        $display("Read data from master:");
        #10;
        $finish;
    end

    // Monitor signals
    
    

endmodule
