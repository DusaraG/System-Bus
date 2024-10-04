module slave_3_sp(
    input logic clk,
    input logic rst_n,
    input logic mode,
    input logic [15:0] addr,
    input logic [7:0] wdata,
    input logic valid,
    output logic [7:0] rdata,
    output logic ready,
    input logic sl,
    output logic split,
    output logic arbiter_req,
    input logic arbiter_grant


);

    //registers
    reg [15:0] addr_reg;
    reg [7:0] wdata_reg;
    reg [7:0] rdata_reg;
    reg ready_reg;
    reg mode_reg;
    reg [3:0] count;
    reg split_reg;
    reg arbiter_req_reg;

    reg [7:0] STORE [0:4095];

    reg [2:0] stateReg;

    localparam IDLE = 3'b000;
    localparam GET = 3'b001;
    localparam RES = 3'b010;
    localparam SPLIT = 3'b011;
    localparam ARBITER_REQ = 3'b100;

    always@(posedge clk) begin
        if (!rst_n) begin
            addr_reg <= 16'b0;
            wdata_reg <= 8'b0;
            // rdata_reg <= 8'b0;
            ready_reg <= 1'b0;
            mode_reg <= 1'b0;
            stateReg <= IDLE;
            count <= 4'b0;
            split_reg <= 1'b0;
            arbiter_req_reg <= 1'b0;
        end else begin
            case(stateReg)
                IDLE: begin
                    if(sl && valid) begin
                        addr_reg <= addr;
                        wdata_reg <= wdata;
                        mode_reg <= mode;
                        // stateReg <= GET;
                        count <= 4'b0001;
                        stateReg <= SPLIT;
                        split_reg <= 1'b1;
                    end else begin
                        stateReg <= IDLE;
                    end
                end
                GET: begin
                    if (count == 4'b0011) begin
                        // stateReg <= RES;
                        // ready_reg <= 1'b1;
                        stateReg <= ARBITER_REQ;
                        arbiter_req_reg <= 1'b1;

                    end else begin
                        count <= count + 1'b1;
                        stateReg <= GET;
                    end
                end
                RES: begin
                    stateReg <= IDLE;
                    ready_reg <= 1'b0;
                end

                SPLIT: begin
                    split_reg <= 1'b0;
                    stateReg <= GET;
                end

                ARBITER_REQ: begin
                    if(arbiter_grant) begin
                        stateReg <= RES;
                        ready_reg <= 1'b1;
                        split_reg <= 1'b0;
                        arbiter_req_reg <= 1'b0;
                    end else begin
                        stateReg <= ARBITER_REQ;
                    end
                end
            endcase
        end
    end


    always@(posedge clk) begin
        if (!rst_n) begin
            rdata_reg <= 8'b0;
        end else if (mode_reg == 1) begin
            STORE[addr_reg[11:0]] <= wdata_reg;
        end else if(mode_reg == 0) begin
            rdata_reg <= STORE[addr_reg[11:0]];
        end
    end

    assign rdata = rdata_reg;
    assign ready = ready_reg;
    assign split = split_reg;
    assign arbiter_req = arbiter_req_reg;



endmodule