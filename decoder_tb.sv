`timescale 1ns/1ps

module decoder_tb;

    logic clk;
    logic rst_n;
    logic [15:0] addr;
    logic slave1_sel;
    logic slave2_sel;
    logic slave3_sel;
    logic [1:0] SELR;

    decoder dec_inst (
        .clk(clk),
        .rst_n(rst_n),
        .addr(addr),
        .slave1_sel(slave1_sel),
        .slave2_sel(slave2_sel),
        .slave3_sel(slave3_sel),
        .SELR(SELR)
    );

    initial begin
        clk = 0;
        repeat(250) #5 clk = ~clk; // 100MHz clock
    end

    initial begin
        rst_n = 0;
        addr = 16'h0000;
        #10 rst_n = 1;
        addr = 16'h0000;
        #10 addr = 16'h0001;
        #10 addr = 16'h1002;
        #10 addr = 16'h2003;

        

        #50 $finish;
    end







endmodule



