module master2(
    input logic clk,
    input logic rst_n,
    output logic breq,
    input logic bgrant,
    output logic mode,

    output logic [15:0] addr,
    output logic [7:0] wdata,
    input logic [7:0] rdata,

    output logic valid,
    input logic ready,

    //user inputs
    input logic [15:0] U_addr,
    input logic [7:0] U_wdata,
    output logic [7:0] U_rdata,
    input logic U_mode,
    input logic U_start,
    output logic [2:0] state_show
);

    //registers
    reg [15:0] addr_reg;
    reg [7:0] wdata_reg;
    reg [7:0] rdata_reg;
    reg valid_reg;
    reg mode_reg;
    reg breq_reg;

    reg [3:0] count_reg;
    reg [1:0] stateReg;

    localparam IDLE = 2'b00;
    localparam REQ = 2'b01;
    localparam RES = 2'b10;

    always@(posedge clk) begin
        if (!rst_n) begin
            count_reg <= 4'b0000;
        end else if (count_reg == 4'd15) begin
            count_reg <= 4'b0000;
        end else begin
            count_reg <= count_reg + 1;
        end
    end

    always@(posedge clk) begin
        if (!rst_n) begin
            stateReg <= IDLE;
            breq_reg <= 1'b0;
            addr_reg <= 16'b0;
            wdata_reg <= 8'b0;
            rdata_reg <= 8'b0;
            valid_reg <= 1'b0;
            mode_reg <= 1'b0;

        end else begin
            case(stateReg)
                IDLE: begin
                    state_show <= 3'b000;
                    if (U_start) begin
                        stateReg <= REQ;
                        breq_reg <= 1'b1;
                    end else begin
                        stateReg <= IDLE;
                    end
                end
                REQ: begin
                    state_show <= 3'b001;
                    if (bgrant) begin
                        stateReg <= RES;
                        addr_reg <= U_addr;
                        wdata_reg <= U_wdata + 8'b1;
                        valid_reg <= 1'b1;
                        mode_reg <= U_mode;

                    end else begin
                        stateReg <= REQ;
                    end
                end
                RES: begin
                    state_show <= 3'b010;
                    if (ready && bgrant) begin
                        state_show <= 3'b110;
                        stateReg <= IDLE;
                        valid_reg <= 1'b0;
                        rdata_reg <= rdata;
                        breq_reg <= 1'b0;

                    end else begin
                        stateReg <= RES;
                    end
                end

            endcase
        end
    end

    assign breq = breq_reg;
    assign addr = addr_reg;
    assign wdata = wdata_reg;
    assign valid = valid_reg;
    assign mode = mode_reg;
    assign U_rdata = rdata_reg;


endmodule
