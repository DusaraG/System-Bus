module top(
    input logic clk,
    input logic rst_n,

    // Master 1 interface
    input logic m1_U_start,
    input logic [15:0] m1_U_addr,
    input logic [7:0] m1_U_wdata,
    input logic m1_U_mode,
    output logic [2:0] m1_state_show,
    output logic [7:0]m1_U_rdata,

    // Master 2 interface
    input logic m2_U_start,
    input logic [15:0] m2_U_addr,
    input logic [7:0] m2_U_wdata,
    input logic m2_U_mode,
    output logic [2:0] m2_state_show,
    output logic [7:0]m2_U_rdata

    
    

);

    // Signals connecting arbiter and masters
    logic m1_breq, m2_breq;
    logic m2_bgrant, m1_bgrant;
    logic [15:0] m1_addr;
    logic [7:0] m1_wdata;
    logic [15:0] m2_addr;
    logic [7:0] m2_wdata;
    logic m1_mode,m2_mode;
    logic m1_valid,m2_valid;
    logic s1,s2,s3;
    logic [1:0] SELR;
    logic [7:0] s1_rdata,s2_rdata,s3_rdata;
    logic s1_ready,s2_ready,s3_ready;
    logic [7:0] rdata;
    logic ready;
    logic [15:0] ADDRESS;
    logic [7:0] WDATA;
    logic MODE;
    logic VALID;
    logic M_select;
    logic split;
    logic split_req;
    logic split_grant;


    

    // Instantiate arbiter
    arbiter arb_inst (
        .clk(clk),
        .rst_n(rst_n),
        .m1_req(m1_breq),
        .m2_req(m2_breq),
        .m1_grant(m1_bgrant),
        .m2_grant(m2_bgrant),
        .M_select(M_select),
        .split(split),
        .split_req(split_req),
        .split_grant(split_grant)
    );

    // Instantiate master 1
    master2 m1_inst (
        .clk(clk),
        .rst_n(rst_n),
        .breq(m1_breq),
        .bgrant(m1_bgrant),
        .mode(m1_mode),
        .addr(m1_addr),
        .wdata(m1_wdata),
        .rdata(rdata),
        .valid(m1_valid),
        .ready(ready),
        .U_addr(m1_U_addr),
        .U_wdata(m1_U_wdata),
        .U_rdata(m1_U_rdata),
        .U_mode(m1_U_mode),
        .U_start(m1_U_start),
        .state_show(m1_state_show)  
    );

    // Instantiate master 2
    master2 m2_inst (
        .clk(clk),
        .rst_n(rst_n),
        .breq(m2_breq),
        .bgrant(m2_bgrant),
        .mode(m2_mode),
        .addr(m2_addr),
        .wdata(m2_wdata),
        .rdata(rdata),
        .valid(m2_valid),
        .ready(ready),
        .U_addr(m2_U_addr),
        .U_wdata(m2_U_wdata),
        .U_rdata(m2_U_rdata),
        .U_mode(m2_U_mode),
        .U_start(m2_U_start),
        .state_show(m2_state_show)  
    );

    //slave1
    slave_1 slave1_inst (
        .clk(clk),
        .rst_n(rst_n),
        .addr(ADDRESS),
        .wdata(WDATA),
        .mode(MODE),
        .valid(VALID),
        .rdata(s1_rdata),
        .ready(s1_ready),
        .sl(s1)
    );

    //slave2
    slave_2 slave2_inst (
        .clk(clk),
        .rst_n(rst_n),
        .addr(ADDRESS),
        .wdata(WDATA),
        .mode(MODE),
        .valid(VALID),
        .rdata(s2_rdata),
        .ready(s2_ready),
        .sl(s2)
    );

    //slave3
    slave_3_sp slave3_inst (
        .clk(clk),
        .rst_n(rst_n),
        .addr(ADDRESS),
        .wdata(WDATA),
        .mode(MODE),
        .valid(VALID),
        .rdata(s3_rdata),
        .ready(s3_ready),
        .sl(s3),
        .split(split),
        .arbiter_req(split_req),
        .arbiter_grant(split_grant)
    );

    //decoder
    decoder dec_inst (
        .clk(clk),
        .rst_n(rst_n),
        .addr(ADDRESS),
        .slave1_sel(s1),
        .slave2_sel(s2),
        .slave3_sel(s3),
        .SELR(SELR)

    );

    //read data mux
    read_MUX read_inst (
        .clk(clk),
        .rst_n(rst_n),
        .HRDATA_1(s1_rdata),
        .HRDATA_2(s2_rdata),
        .HRDATA_3(s3_rdata),
        .select(SELR),
        .HRDATA(rdata)

    );

    //ready mux
    ready ready_mux_inst (
        .clk(clk),
        .rst_n(rst_n),
        .s1_ready(s1_ready),
        .s2_ready(s2_ready),
        .s3_ready(s3_ready),
        .select(SELR),
        .ready(ready)

    );

    //ready signal

    

    assign ADDRESS = M_select ? m1_addr : m2_addr;
    assign WDATA = M_select ? m1_wdata : m2_wdata;
    assign MODE = M_select ? m1_mode : m2_mode;
    assign VALID = M_select ? m1_valid : m2_valid;
    // assign ready = (SELR == 2'b11)? s3_ready : ((SELR == 2'b10)? s2_ready : ((SELR == 2'b01)? s1_ready : 1'bx));


endmodule
