module slave_1(
    input logic clk,
    input logic rst_n,
    input logic mode,
    input logic [15:0] addr,
    input logic [7:0] wdata,
    input logic valid,
    output logic [7:0] rdata,
    output logic ready,
    input logic sl


);

    //registers
    reg [15:0] addr_reg;
    reg [7:0] wdata_reg;
    reg [7:0] rdata_reg;
    reg ready_reg;
    reg mode_reg;
    reg [3:0] count;

    reg [7:0] STORE [0:2047];

    reg [1:0] stateReg;

    localparam IDLE = 2'b00;
    localparam GET = 2'b01;
    localparam RES = 2'b10;

    always@(posedge clk) begin
        if (!rst_n) begin
            addr_reg <= 16'b0;
            wdata_reg <= 8'b0;
            // rdata_reg <= 8'b0;
            ready_reg <= 1'b0;
            mode_reg <= 1'b0;
            stateReg <= IDLE;
            count <= 4'b0;
        end else begin
            case(stateReg)
                IDLE: begin
                    if(sl && valid) begin
                        addr_reg <= addr;
                        wdata_reg <= wdata;
                        mode_reg <= mode;
                        stateReg <= GET;
                        count <= 4'b0001;
                    end else begin
                        stateReg <= IDLE;
                    end
                end
                GET: begin
                    if (count == 4'b0011) begin
                        stateReg <= RES;
                        ready_reg <= 1'b1;
                    end else begin
                        count <= count + 1'b1;
                        stateReg <= GET;
                    end
                end
                RES: begin
                    stateReg <= IDLE;
                    ready_reg <= 1'b0;
                end
            endcase
        end
    end


    always@(posedge clk) begin
        if (!rst_n) begin
            rdata_reg <= 8'b0;
        end else if (mode_reg == 1) begin
            STORE[addr_reg[10:0]] <= wdata_reg;
        end else if(mode_reg == 0) begin
            rdata_reg <= STORE[addr_reg[10:0]];
        end
    end
    assign rdata = rdata_reg;
    assign ready = ready_reg;



endmodule