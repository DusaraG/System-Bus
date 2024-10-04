module slave_split_tb;

    logic clk;
    logic rst_n;

    logic mode;
    logic [15:0] addr;
    logic [7:0] wdata;
    logic valid;
    logic [7:0] rdata;
    logic ready;
    logic sl;
    logic split;
    // logic arbiter_req;
    logic arbiter_grant;

    slave_3_sp uut (
        .clk(clk),
        .rst_n(rst_n),
        .mode(mode),
        .addr(addr),
        .wdata(wdata),
        .valid(valid),
        .rdata(rdata),
        .ready(ready),
        .sl(sl),
        .split(split),
        // .arbiter_req(arbiter_req),
        .arbiter_grant(arbiter_grant)
    );

    initial begin
        clk = 0;
        repeat(250) #5 clk = ~clk; // 100MHz clock
    end

    initial begin
        // Initialize inputs
        rst_n = 0;
        mode = 0;
        addr = 16'h0000;
        wdata = 8'h00;
        valid = 0;
        sl = 0;
        split = 0;
        // arbiter_req = 0;
        arbiter_grant = 0;

        #10;
        rst_n = 1;
        #10;
        mode = 1;
        addr = 16'h0001;
        wdata = 8'hFF;
        #20;
        valid = 1;
        sl = 1;
        #100;
        arbiter_grant = 1;
        #20;

        #50;
        $display("Read data from master:");
        #10;
        $finish;

        
    end



endmodule