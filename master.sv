module master(
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

    enum logic [2:0] {IDLE, REQ , ADDR , WRITE, READ} state, next_state;

    //registers
    reg [15:0] addr_reg;
    reg [7:0] wdata_reg;
    reg [7:0] rdata_reg;
    reg valid_reg;
    reg mode_reg;
    reg breq_reg;
    reg [3:0] count_reg;

    always_comb begin :NEXT_LOGIC_STATE
        case(state)
            IDLE: next_state = U_start ? REQ : IDLE;
            REQ: next_state = bgrant ? ADDR : REQ;
            ADDR: next_state = mode_reg ? WRITE : READ;
            WRITE: next_state = ready ? IDLE : WRITE;
            READ: next_state = ready ? IDLE : READ;
            default: next_state = IDLE;

        endcase
        
    end

    always_ff @(posedge clk ) begin : STATE_SEQUENCER
        state <= !rst_n ? IDLE : next_state;
        
    end

    always_ff @(posedge clk ) begin : REG_LOGIC
        if(!rst_n) begin
            addr_reg <= 0;
            wdata_reg <= 0;
            valid_reg <= 0;
            mode_reg <= 0;
            breq_reg <= 0;
        end
        else begin
            case(state)
                IDLE: begin
                    addr_reg <= 0;
                    wdata_reg <= 0;
                    valid_reg <= 0;
                    mode_reg <= 0;
                    breq_reg <= 0;
                    state_show <= 3'b000;
                end
                REQ: begin
                    addr_reg <= U_addr;
                    wdata_reg <= U_wdata;
                    valid_reg <= 0;
                    mode_reg <= U_mode;
                    breq_reg <= 1;
                    state_show <= 3'b001;
                end
                ADDR: begin
                    valid_reg <= 1;
                    state_show <= 3'b010;
                    
                end
                WRITE: begin
                    state_show <= 3'b011;
                    
                end
                READ: begin
                    state_show <= 3'b100;
                    rdata_reg <= rdata;
                    
                end
                default: begin
                    addr_reg <= 0;
                    wdata_reg <= 0;
                    valid_reg <= 0;
                    mode_reg <= 0;
                    breq_reg <= 0;
                end
                
            endcase
        end
    end


    assign addr = addr_reg;
    assign wdata = wdata_reg;
    assign valid = valid_reg;
    assign mode = mode_reg;
    assign breq = breq_reg;
    assign U_rdata = rdata_reg;



endmodule