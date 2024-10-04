module slave_tb;
    logic clk;
    logic rst_n;
    logic mode;
    logic [15:0] addr;
    logic [7:0] wdata;
    logic valid;
    logic [7:0] rdata;
    logic ready;
    logic s1;



    slave_1 uut (
        .clk(clk),
        .rst_n(rst_n),
        .mode(mode),
        .addr(addr),
        .wdata(wdata),
        .valid(valid),
        .rdata(rdata),
        .ready(ready),
        .s1(s1)
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
        s1 = 0;

        #10;
        rst_n = 1;

        #10;
        mode = 1;
        addr = 16'h0001;
        wdata = 8'hFF;
        #10;
        valid = 1;
        #10;
        s1 = 1;

        #50;
        s1 = 0;
        mode = 0;
        addr = 16'h0001;
        #10;
        valid = 1;
        s1 = 1;
        


        #50;
        $display("Read data from master:");
        #10;
        $finish;
    end




endmodule