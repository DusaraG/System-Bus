module Master_1(
    input        clock,
    input        reset,
    output request,     // request to arbiter
    output control,     // read or write
    output [5:0] address,   // address for write data or read data
    output valid,       // request is valid
    output [7:0] wdata, // write data
    input [7:0] rdata,      // read data
    input done,             // signal from slave if the read data is valid or write data is done (transaction has completed)
    input grant             // signal from arbiter to indicate whether shared bus access is granted
);

    // all outputs should be synchronous
    reg request_reg;
    reg rwreg; // 0 is for read, 1 is for write
    reg [5:0] address_reg;
    reg [7:0] wdata_reg;
    reg valid_reg;

    // 4-bit up counter for internal tracking
    reg [3:0] countreg;
    always @(posedge clock) begin
        if (reset) begin
            countreg <= 4'b0000;
        end else if (countreg == 4'd15) begin
            countreg <= 4'b0000;
        end else begin
            countreg <= countreg + 1;
        end
    end

    // Transaction address order
    reg [5:0] addr[0:3];
    initial begin
        addr[0] = 6'b000001;
        addr[1] = 6'b000001;
        addr[2] = 6'b001001;
        addr[3] = 6'b001001;
    end

    reg [1:0] order_index = 2'b00;

    // FSM state register
    reg [1:0] stateReg; // 00: idle, 01: request, 10: response

    always @(posedge clock) begin
        if(reset) begin
          stateReg <= 2'b00;
          request_reg <= 1'b0;
          rwreg <= 1'b1;
          address_reg <= 6'b000000;
          wdata_reg <= 8'b00000000;
          valid_reg <= 1'b0;
          order_index <= 2'b00;
        end
        else begin
          case (stateReg)
              2'b00: begin  // Idle state
                  if (countreg == 4'd2 || countreg == 4'd13) begin
                      stateReg <= 2'b01;
                      request_reg <= 1'b1;
                  end else begin
                      stateReg <= 2'b00;
                  end
              end
              2'b01: begin  // Request state
                  if (grant) begin
                      rwreg <= ~rwreg;
                      address_reg <= addr[order_index];
                      valid_reg <= 1'b1;
                      wdata_reg <= wdata_reg + 8'b1;
                      stateReg <= 2'b10;
                  end else begin
                      stateReg <= 2'b01;
                  end
              end
              2'b10: begin  // Response state
                  if (done && grant) begin
                      stateReg <= 2'b00;
                      wdata_reg <= rdata;
                      request_reg <= 1'b0;
                      valid_reg <= 1'b0;
                      order_index <= order_index + 2'b01;
                  end else begin
                      stateReg <= 2'b10;
                  end
              end
          endcase
        end
    end

    assign request = request_reg;
    assign control = rwreg;
    assign address = address_reg;
    assign wdata = wdata_reg;
    assign valid = valid_reg;

endmodule
module Master_2(
    input        clock,
    input        reset,
    output request,     // request to arbiter
    output control,     // read or write
    output [5:0] address,   // address for write data or read data
    output valid,       // request is valid
    output [7:0] wdata, // write data
    input [7:0] rdata,      // read data
    input done,             // signal from slave if the read data is valid or write data is done (transaction has completed)
    input grant             // signal from arbiter to indicate whether shared bus access is granted
);

    // all outputs should be synchronous
    reg request_reg;
    reg rwreg; // 0 is for read, 1 is for write
    reg [5:0] address_reg;
    reg [7:0] wdata_reg;
    reg valid_reg;

    // 4-bit up counter for internal tracking
    reg [3:0] countreg;
    always @(posedge clock) begin
        if (reset) begin
            countreg <= 4'b0000;
        end else if (countreg == 4'd15) begin
            countreg <= 4'b0000;
        end else begin
            countreg <= countreg + 1;
        end
    end

    // Transaction address order
    reg [5:0] addr[0:3];
    initial begin
        addr[0] = 6'b001001;
        addr[1] = 6'b001001;
        addr[2] = 6'b000001;
        addr[3] = 6'b000001;
    end

    reg [1:0] order_index = 2'b00;

    // FSM state register
    reg [1:0] stateReg; // 00: idle, 01: request, 10: response

    always @(posedge clock) begin
        if(reset) begin
          stateReg <= 2'b00;
          request_reg <= 1'b0;
          rwreg <= 1'b1;
          address_reg <= 6'b000000;
          wdata_reg <= 8'b00000000;
          valid_reg <= 1'b0;
          order_index <= 2'b00;
        end
        else begin
          case (stateReg)
              2'b00: begin  // Idle state
                  if (countreg == 4'd2 || countreg == 4'd13) begin
                      stateReg <= 2'b01;
                      request_reg <= 1'b1;
                  end else begin
                      stateReg <= 2'b00;
                  end
              end
              2'b01: begin  // Request state
                  if (grant) begin
                      rwreg <= ~rwreg;
                      address_reg <= addr[order_index];
                      valid_reg <= 1'b1;
                      wdata_reg <= wdata_reg + 8'b1;
                      stateReg <= 2'b10;
                  end else begin
                      stateReg <= 2'b01;
                  end
              end
              2'b10: begin  // Response state
                  if (done && grant) begin
                      stateReg <= 2'b00;
                      wdata_reg <= rdata;
                      request_reg <= 1'b0;
                      valid_reg <= 1'b0;
                      order_index <= order_index + 2'b01;
                  end else begin
                      stateReg <= 2'b10;
                  end
              end
          endcase
        end
    end

    assign request = request_reg;
    assign control = rwreg;
    assign address = address_reg;
    assign wdata = wdata_reg;
    assign valid = valid_reg;

endmodule
module Slave_1 (
  input  [5:0] io_addr,        // 6-bit address
  input  [7:0] io_wrData,      // 8-bit write data
  input        io_wrEnable,    // Write enable
  input        io_valid,       // Valid input
  output [7:0] io_rdData,  // 8-bit read data
  output       io_done,        // Done signal
  input        clock,         // Clock signal
  input        reset        // Reset signal
);
  //all outputs should be synchronous
  reg [7:0] rdata_reg;
  reg       done_reg;

  //Input Buffers
  reg [5:0] addr_reg;
  reg [7:0] wdata_reg;
  reg       control_reg;

  //latency genrate counter
  reg [3:0] countreg;

  reg [7:0] mem [0:7];  // 8 words of 8-bit wide memory

  reg [1:0] stateReg;   // 0: idle, 1: servicing, 2: response

  // State encoding
  localparam IDLE = 2'b00;
  localparam SERVICING = 2'b01;
  localparam RESPONSE = 2'b10;

  // Synchronous logic
  always @(posedge clock) begin
    if (reset) begin
      rdata_reg   <= 8'b0;
      done_reg    <= 1'b0;
      addr_reg    <= 6'b0;
      wdata_reg   <= 8'b0;
      control_reg <= 1'b0;
      countreg    <= 4'b0;
      stateReg    <= IDLE;
    end else begin
      case (stateReg)
        IDLE: begin
          if (io_addr[4:3] == 2'b00 && io_valid) begin
            stateReg    <= SERVICING;
            addr_reg    <= io_addr;
            wdata_reg   <= io_wrData;
            control_reg <= io_wrEnable;
            countreg    <= 4'b0001;
          end else begin
            stateReg <= IDLE;
          end
        end
        SERVICING: begin
          if (countreg == 4'b0011) begin  // Memory latency of 3 + 1 cycles
            stateReg <= RESPONSE;
            done_reg <= 1'b1;
          end else begin
            countreg <= countreg + 1'b1;
            stateReg <= SERVICING;
          end
        end
        RESPONSE: begin
          stateReg <= IDLE;
          done_reg <= 1'b0;
        end
      endcase
    end
  end


  assign io_rdData = rdata_reg;
  assign io_done   = done_reg;

  // Memory access (synchronous write and read)
  always @(posedge clock) begin
    if (control_reg) begin
      // Write operation
      mem[addr_reg[2:0]] <= wdata_reg;
    end else begin
      // Read operation
      rdata_reg <= mem[addr_reg[2:0]];
    end
  end

endmodule
module Slave_2 (
  input  [5:0] io_addr,        // 6-bit address
  input  [7:0] io_wrData,      // 8-bit write data
  input        io_wrEnable,    // Write enable
  input        io_valid,       // Valid input
  output [7:0] io_rdData,  // 8-bit read data
  output       io_done,        // Done signal
  input        clock,         // Clock signal
  input        reset        // Reset signal
);
  //all outputs should be synchronous
  reg [7:0] rdata_reg;
  reg       done_reg;

  //Input Buffers
  reg [5:0] addr_reg;
  reg [7:0] wdata_reg;
  reg       control_reg;

  //latency genrate counter
  reg [3:0] countreg;

  reg [7:0] mem [0:7];  // 8 words of 8-bit wide memory

  reg [1:0] stateReg;   // 0: idle, 1: servicing, 2: response

  // State encoding
  localparam IDLE = 2'b00;
  localparam SERVICING = 2'b01;
  localparam RESPONSE = 2'b10;

  // Synchronous logic
  always @(posedge clock) begin
    if (reset) begin
      rdata_reg   <= 8'b0;
      done_reg    <= 1'b0;
      addr_reg    <= 6'b0;
      wdata_reg   <= 8'b0;
      control_reg <= 1'b0;
      countreg    <= 4'b0;
      stateReg    <= IDLE;
    end else begin
      case (stateReg)
        IDLE: begin
          if (io_addr[4:3] == 2'b01 && io_valid) begin
            stateReg    <= SERVICING;
            addr_reg    <= io_addr;
            wdata_reg   <= io_wrData;
            control_reg <= io_wrEnable;
            countreg    <= 4'b0001;
          end else begin
            stateReg <= IDLE;
          end
        end
        SERVICING: begin
          if (countreg == 4'b0011) begin  // Memory latency of 3 + 1 cycles
            stateReg <= RESPONSE;
            done_reg <= 1'b1;
          end else begin
            countreg <= countreg + 1'b1;
            stateReg <= SERVICING;
          end
        end
        RESPONSE: begin
          stateReg <= IDLE;
          done_reg <= 1'b0;
        end
      endcase
    end
  end


  assign io_rdData = rdata_reg;
  assign io_done   = done_reg;

  // Memory access (synchronous write and read)
  always @(posedge clock) begin
    if (control_reg) begin
      // Write operation
      mem[addr_reg[2:0]] <= wdata_reg;
    end else begin
      // Read operation
      rdata_reg <= mem[addr_reg[2:0]];
    end
  end

endmodule
module Slave_3 (
  input  [5:0] io_addr,        // 6-bit address
  input  [7:0] io_wrData,      // 8-bit write data
  input        io_wrEnable,    // Write enable
  input        io_valid,       // Valid input
  output [7:0] io_rdData,      // 8-bit read data
  output       io_done,        // Done signal
  output       split,          //Split signal
  input        clock,          // Clock signal
  input        reset,          // Reset signal
  output       arb_req,            // arbiter request
  input        arb_grant           // arbiter grant
);
  //all outputs should be synchronous
  reg [7:0] rdata_reg;
  reg       done_reg;
  reg       arb_req_reg;
  reg      split_req_reg;

  //Input Buffers
  reg [5:0] addr_reg;
  reg [7:0] wdata_reg;
  reg       control_reg;

  //latency genrate counter
  reg [3:0] countreg;

  reg [7:0] mem [0:7];  // 8 words of 8-bit wide memory

  reg [2:0] stateReg;   // 0: idle, 1: servicing, 2: response

  //hard code split
  reg split_reg;

  // State encoding
  localparam IDLE = 3'b000;
  localparam SERVICING = 3'b001;
  localparam RESPONSE = 3'b010;
  localparam SPLIT = 3'b011;
  localparam ARB_REQ = 3'b100;

  // Synchronous logic
  always @(posedge clock) begin
    if (reset) begin
      rdata_reg   <= 8'b0;
      done_reg    <= 1'b0;
      addr_reg    <= 6'b0;
      wdata_reg   <= 8'b0;
      control_reg <= 1'b0;
      countreg    <= 4'b0;
      arb_req_reg <= 1'b0;
      stateReg    <= IDLE;
      split_reg   <= 1'b0; //hard code to not split support
      split_req_reg <= 1'b0;
    end else begin
      case (stateReg)
        IDLE: begin
          if (io_addr[4:3] == 2'b10 && io_valid) begin
            addr_reg    <= io_addr;
            wdata_reg   <= io_wrData;
            control_reg <= io_wrEnable;
            countreg    <= 4'b0001;
            if (split_reg) begin
              stateReg <= SPLIT;
              split_req_reg <= 1'b1;
            end else begin
              stateReg    <= SERVICING;
            end
          end else begin
            stateReg <= IDLE;
          end
        end
        SERVICING: begin
          if (countreg == 4'b0011) begin  // Memory latency of 3 + 1 cycles
            if (split_reg) begin
              stateReg <= ARB_REQ;
              arb_req_reg <= 1'b0;
            end else begin
              stateReg <= RESPONSE;
              done_reg <= 1'b1;
            end
          end else begin
            countreg <= countreg + 1'b1;
            stateReg <= SERVICING;
          end
        end
        RESPONSE: begin
          stateReg <= IDLE;
          done_reg <= 1'b0;
        end
        SPLIT: begin
          split_req_reg <= 1'b0;
          stateReg <= SERVICING;
        end
        ARB_REQ: begin
          if (arb_grant) begin
            stateReg <= RESPONSE;
            done_reg <= 1'b1;
          end else begin
            stateReg <= ARB_REQ;
          end
        end
      endcase
    end
  end


  assign io_rdData = rdata_reg;
  assign io_done   = done_reg;
  assign arb_req   = arb_req_reg;
  assign split     = split_req_reg;

  // Memory access (synchronous write and read)
  always @(posedge clock) begin
    if (control_reg) begin
      // Write operation
      mem[addr_reg[2:0]] <= wdata_reg;
    end else begin
      // Read operation
      rdata_reg <= mem[addr_reg[2:0]];
    end
  end

endmodule

module Arbiter(
    input io_req0,          // Request from master 0
    input io_req1,          // Request from master 1
    output io_grant0,   // Grant signal for master 0
    output io_grant1,   // Grant signal for master 1
    output io_masterSel, // Master selector
    input  clock,         // Clock signal
    input  reset,        // Reset signal
    input  split,
    input  split_req,
    output split_grant
);

    // Registers for grants and last grant (to remember the last request granted)
    reg grant0Reg;
    reg grant1Reg;
    reg masterSelReg;
    reg split_grant_reg;

    reg split_remember; // remeber if arbiter in middle of a split transaction.

    reg [2:0] stateReg;

    //state encoding
    localparam IDLE = 3'b000;
    localparam GRANT0 = 3'b001;
    localparam GRANT1 = 3'b010;

    // Arbiter logic with priority given to req0
    always @(posedge clock) begin
        if (reset) begin
          grant0Reg <= 1'b0;
          grant1Reg <= 1'b0;
          masterSelReg <= 1'b0;
          split_grant_reg <= 1'b0;
          split_remember <= 1'b0;
        end else begin
            case(stateReg)
                IDLE: begin
                    if (io_req0) begin
                        stateReg <= GRANT0;
                        grant0Reg <= 1'b1;
                        grant1Reg <= 1'b0;
                        masterSelReg <= 1'b0;
                    end else if (io_req1) begin
                        stateReg <= GRANT1;
                        grant0Reg <= 1'b0;
                        grant1Reg <= 1'b1;
                        masterSelReg <= 1'b1;
                    end else begin
                        stateReg <= IDLE;
                        grant0Reg <= 1'b0;
                        grant1Reg <= 1'b0;
                    end
                end
                GRANT0: begin
                    if (split) begin
                        split_remember <= 1'b1;
                        stateReg <= GRANT1;
                        grant0Reg <= 1'b0;
                        grant1Reg <= 1'b1;
                        masterSelReg <= 1'b1;
                    end else if (io_req0) begin
                        stateReg <= GRANT0;
                        split_grant_reg <= 1'b0;
                    end else if (!split_req && split_remember) begin
                        stateReg <= GRANT0;
                    end else if (split_req) begin
                        split_remember <= 1'b0;
                        split_grant_reg <= 1'b1;
                        stateReg <= GRANT1;
                        grant0Reg <= 1'b0;
                        grant1Reg <= 1'b1;
                        masterSelReg <= 1'b1;
                    end else if (io_req1) begin
                        stateReg <= GRANT1;
                        grant0Reg <= 1'b0;
                        grant1Reg <= 1'b1;
                        masterSelReg <= 1'b1;
                    end else begin
                        stateReg <= IDLE;
                        grant0Reg <= 1'b0;
                        grant1Reg <= 1'b0;
                    end
                end
                GRANT1: begin
                    if (split) begin
                        split_remember <= 1'b1;
                        stateReg <= GRANT0;
                        grant0Reg <= 1'b1;
                        grant1Reg <= 1'b0;
                        masterSelReg <= 1'b0;
                    end else if (io_req1) begin
                        stateReg <= GRANT1;
                        split_grant_reg <= 1'b0;
                    end else if (!split_req && split_remember) begin
                        stateReg <= GRANT1;
                    end else if (split_req) begin
                        split_remember <= 1'b0;
                        split_grant_reg <= 1'b1;
                        stateReg <= GRANT0;
                        grant0Reg <= 1'b1;
                        grant1Reg <= 1'b0;
                        masterSelReg <= 1'b0;
                    end else if (io_req0) begin
                        stateReg <= GRANT0;
                        grant0Reg <= 1'b1;
                        grant1Reg <= 1'b0;
                        masterSelReg <= 1'b0;
                    end else begin
                        stateReg <= IDLE;
                        grant0Reg <= 1'b0;
                        grant1Reg <= 1'b0;
                    end
                end
            endcase
        end
    end

    // Assign the register values to the outputs
    assign io_grant0 = grant0Reg;
    assign io_grant1 = grant1Reg;
    assign io_masterSel = masterSelReg;
    assign split_grant = split_grant_reg;
endmodule


module Hello(
  input        clock,
  input        reset,
  output       io_M1_request,
  output       io_M1_control,
  output [5:0] io_M1_addr,
  output [7:0] io_M1_wdata,
  output       io_M1_valid,
  output       io_M2_request,
  output       io_M2_control,
  output [5:0] io_M2_addr,
  output [7:0] io_M2_wdata,
  output       io_M2_valid,
  output       io_grant0,
  output       io_grant1,
  output       io_masterSel,
  output [7:0] io_S1_rdData,
  output       io_S1_done,
  output [7:0] io_S2_rdData,
  output       io_S2_done,
  output [7:0] io_S3_rdData,
  output       io_S3_done,
  output [5:0] io_addr,
  output [7:0] io_wdata,
  output       io_control,
  output       io_valid,
  output [7:0] io_rdata,
  output       io_done
);
  wire  M1_clock; // @[Hello.scala 53:18]
  wire  M1_reset; // @[Hello.scala 53:18]
  wire  M1_request; // @[Hello.scala 53:18]
  wire  M1_control; // @[Hello.scala 53:18]
  wire [5:0] M1_address; // @[Hello.scala 53:18]
  wire  M1_valid; // @[Hello.scala 53:18]
  wire [7:0] M1_wdata; // @[Hello.scala 53:18]
  wire [7:0] M1_rdata; // @[Hello.scala 53:18]
  wire  M1_done; // @[Hello.scala 53:18]
  wire  M1_grant; // @[Hello.scala 53:18]
  wire  M2_clock; // @[Hello.scala 54:18]
  wire  M2_reset; // @[Hello.scala 54:18]
  wire  M2_request; // @[Hello.scala 54:18]
  wire  M2_control; // @[Hello.scala 54:18]
  wire [5:0] M2_address; // @[Hello.scala 54:18]
  wire  M2_valid; // @[Hello.scala 54:18]
  wire [7:0] M2_wdata; // @[Hello.scala 54:18]
  wire [7:0] M2_rdata; // @[Hello.scala 54:18]
  wire  M2_done; // @[Hello.scala 54:18]
  wire  M2_grant; // @[Hello.scala 54:18]
  wire  S1_clock; // @[Hello.scala 56:18]
  wire  S1_reset; // @[Hello.scala 56:18]
  wire [5:0] S1_io_addr; // @[Hello.scala 56:18]
  wire [7:0] S1_io_wrData; // @[Hello.scala 56:18]
  wire  S1_io_wrEnable; // @[Hello.scala 56:18]
  wire  S1_io_valid; // @[Hello.scala 56:18]
  wire [7:0] S1_io_rdData; // @[Hello.scala 56:18]
  wire  S1_io_done; // @[Hello.scala 56:18]
  wire  S2_clock; // @[Hello.scala 57:18]
  wire  S2_reset; // @[Hello.scala 57:18]
  wire [5:0] S2_io_addr; // @[Hello.scala 57:18]
  wire [7:0] S2_io_wrData; // @[Hello.scala 57:18]
  wire  S2_io_wrEnable; // @[Hello.scala 57:18]
  wire  S2_io_valid; // @[Hello.scala 57:18]
  wire [7:0] S2_io_rdData; // @[Hello.scala 57:18]
  wire  S2_io_done; // @[Hello.scala 57:18]
  wire  S3_clock; // @[Hello.scala 58:18]
  wire  S3_reset; // @[Hello.scala 58:18]
  wire [5:0] S3_io_addr; // @[Hello.scala 58:18]
  wire [7:0] S3_io_wrData; // @[Hello.scala 58:18]
  wire  S3_io_wrEnable; // @[Hello.scala 58:18]
  wire  S3_io_valid; // @[Hello.scala 58:18]
  wire [7:0] S3_io_rdData; // @[Hello.scala 58:18]
  wire  S3_io_done; // @[Hello.scala 58:18]
  wire  arbiter_clock; // @[Hello.scala 60:23]
  wire  arbiter_reset; // @[Hello.scala 60:23]
  wire  arbiter_io_req0; // @[Hello.scala 60:23]
  wire  arbiter_io_req1; // @[Hello.scala 60:23]
  wire  arbiter_io_grant0; // @[Hello.scala 60:23]
  wire  arbiter_io_grant1; // @[Hello.scala 60:23]
  wire  arbiter_io_masterSel; // @[Hello.scala 60:23]
  wire [5:0] addr = ~arbiter_io_masterSel ? M1_address : M2_address; // @[Hello.scala 73:30 74:10 80:10]
  wire [7:0] _GEN_4 = addr[4:3] == 2'h2 ? S3_io_rdData : 8'h0; // @[Hello.scala 114:32 115:11 118:11]
  wire  _GEN_5 = addr[4:3] == 2'h2 & S3_io_done; // @[Hello.scala 114:32 116:10 119:10]
  wire [7:0] _GEN_6 = addr[4:3] == 2'h1 ? S2_io_rdData : _GEN_4; // @[Hello.scala 111:32 112:11]
  wire  _GEN_7 = addr[4:3] == 2'h1 ? S2_io_done : _GEN_5; // @[Hello.scala 111:32 113:10]

  wire split;
  wire arb_req;
  wire arb_grant;
  Master_1 M1 ( // @[Hello.scala 53:18]
    .clock(M1_clock),
    .reset(M1_reset),
    .request(M1_request),
    .control(M1_control),
    .address(M1_address),
    .valid(M1_valid),
    .wdata(M1_wdata),
    .rdata(M1_rdata),
    .done(M1_done),
    .grant(M1_grant)
  );
  Master_2 M2 ( // @[Hello.scala 54:18]
    .clock(M2_clock),
    .reset(M2_reset),
    .request(M2_request),
    .control(M2_control),
    .address(M2_address),
    .valid(M2_valid),
    .wdata(M2_wdata),
    .rdata(M2_rdata),
    .done(M2_done),
    .grant(M2_grant)
  );
  Slave_1 S1 ( // @[Hello.scala 56:18]
    .clock(S1_clock),
    .reset(S1_reset),
    .io_addr(S1_io_addr),
    .io_wrData(S1_io_wrData),
    .io_wrEnable(S1_io_wrEnable),
    .io_valid(S1_io_valid),
    .io_rdData(S1_io_rdData),
    .io_done(S1_io_done)
  );
  Slave_2 S2 ( // @[Hello.scala 57:18]
    .clock(S2_clock),
    .reset(S2_reset),
    .io_addr(S2_io_addr),
    .io_wrData(S2_io_wrData),
    .io_wrEnable(S2_io_wrEnable),
    .io_valid(S2_io_valid),
    .io_rdData(S2_io_rdData),
    .io_done(S2_io_done)
  );
  Slave_3 S3 ( // @[Hello.scala 58:18]
    .clock(S3_clock),
    .reset(S3_reset),
    .io_addr(S3_io_addr),
    .io_wrData(S3_io_wrData),
    .io_wrEnable(S3_io_wrEnable),
    .io_valid(S3_io_valid),
    .io_rdData(S3_io_rdData),
    .io_done(S3_io_done),
    .split(split),
    .arb_req(arb_req),
    .arb_grant(arb_grant)
  );
  Arbiter arbiter ( // @[Hello.scala 60:23]
    .clock(arbiter_clock),
    .reset(arbiter_reset),
    .io_req0(arbiter_io_req0),
    .io_req1(arbiter_io_req1),
    .io_grant0(arbiter_io_grant0),
    .io_grant1(arbiter_io_grant1),
    .io_masterSel(arbiter_io_masterSel),
    .split(split),
    .split_req(arb_req),
    .split_grant(arb_grant)
  );
  assign io_M1_request = M1_request; // @[Hello.scala 132:17]
  assign io_M1_control = M1_control; // @[Hello.scala 133:17]
  assign io_M1_addr = M1_address; // @[Hello.scala 134:14]
  assign io_M1_wdata = M1_wdata; // @[Hello.scala 135:15]
  assign io_M1_valid = M1_valid; // @[Hello.scala 136:15]
  assign io_M2_request = M2_request; // @[Hello.scala 139:17]
  assign io_M2_control = M2_control; // @[Hello.scala 140:17]
  assign io_M2_addr = M2_address; // @[Hello.scala 141:14]
  assign io_M2_wdata = M2_wdata; // @[Hello.scala 142:15]
  assign io_M2_valid = M2_valid; // @[Hello.scala 143:15]
  assign io_grant0 = arbiter_io_grant0; // @[Hello.scala 146:13]
  assign io_grant1 = arbiter_io_grant1; // @[Hello.scala 147:13]
  assign io_masterSel = arbiter_io_masterSel; // @[Hello.scala 148:16]
  assign io_S1_rdData = S1_io_rdData; // @[Hello.scala 151:16]
  assign io_S1_done = S1_io_done; // @[Hello.scala 152:14]
  assign io_S2_rdData = S2_io_rdData; // @[Hello.scala 155:16]
  assign io_S2_done = S2_io_done; // @[Hello.scala 156:14]
  assign io_S3_rdData = S3_io_rdData; // @[Hello.scala 159:16]
  assign io_S3_done = S3_io_done; // @[Hello.scala 160:14]
  assign io_addr = ~arbiter_io_masterSel ? M1_address : M2_address; // @[Hello.scala 73:30 74:10 80:10]
  assign io_wdata = ~arbiter_io_masterSel ? M1_wdata : M2_wdata; // @[Hello.scala 73:30 75:11 81:11]
  assign io_control = ~arbiter_io_masterSel ? M1_control : M2_control; // @[Hello.scala 73:30 76:13 82:13]
  assign io_valid = ~arbiter_io_masterSel ? M1_valid : M2_valid; // @[Hello.scala 73:30 77:11 83:11]
  assign io_rdata = addr[4:3] == 2'h0 ? S1_io_rdData : _GEN_6; // @[Hello.scala 108:26 109:11]
  assign io_done = addr[4:3] == 2'h0 ? S1_io_done : _GEN_7; // @[Hello.scala 108:26 110:10]
  assign M1_clock = clock;
  assign M1_reset = reset;
  assign M1_rdata = addr[4:3] == 2'h0 ? S1_io_rdData : _GEN_6; // @[Hello.scala 108:26 109:11]
  assign M1_done = addr[4:3] == 2'h0 ? S1_io_done : _GEN_7; // @[Hello.scala 108:26 110:10]
  assign M1_grant = arbiter_io_grant0; // @[Hello.scala 65:12]
  assign M2_clock = clock;
  assign M2_reset = reset;
  assign M2_rdata = addr[4:3] == 2'h0 ? S1_io_rdData : _GEN_6; // @[Hello.scala 108:26 109:11]
  assign M2_done = addr[4:3] == 2'h0 ? S1_io_done : _GEN_7; // @[Hello.scala 108:26 110:10]
  assign M2_grant = arbiter_io_grant1; // @[Hello.scala 66:12]
  assign S1_clock = clock;
  assign S1_reset = reset;
  assign S1_io_addr = ~arbiter_io_masterSel ? M1_address : M2_address; // @[Hello.scala 73:30 74:10 80:10]
  assign S1_io_wrData = ~arbiter_io_masterSel ? M1_wdata : M2_wdata; // @[Hello.scala 73:30 75:11 81:11]
  assign S1_io_wrEnable = ~arbiter_io_masterSel ? M1_control : M2_control; // @[Hello.scala 73:30 76:13 82:13]
  assign S1_io_valid = ~arbiter_io_masterSel ? M1_valid : M2_valid; // @[Hello.scala 73:30 77:11 83:11]
  assign S2_clock = clock;
  assign S2_reset = reset;
  assign S2_io_addr = ~arbiter_io_masterSel ? M1_address : M2_address; // @[Hello.scala 73:30 74:10 80:10]
  assign S2_io_wrData = ~arbiter_io_masterSel ? M1_wdata : M2_wdata; // @[Hello.scala 73:30 75:11 81:11]
  assign S2_io_wrEnable = ~arbiter_io_masterSel ? M1_control : M2_control; // @[Hello.scala 73:30 76:13 82:13]
  assign S2_io_valid = ~arbiter_io_masterSel ? M1_valid : M2_valid; // @[Hello.scala 73:30 77:11 83:11]
  assign S3_clock = clock;
  assign S3_reset = reset;
  assign S3_io_addr = ~arbiter_io_masterSel ? M1_address : M2_address; // @[Hello.scala 73:30 74:10 80:10]
  assign S3_io_wrData = ~arbiter_io_masterSel ? M1_wdata : M2_wdata; // @[Hello.scala 73:30 75:11 81:11]
  assign S3_io_wrEnable = ~arbiter_io_masterSel ? M1_control : M2_control; // @[Hello.scala 73:30 76:13 82:13]
  assign S3_io_valid = ~arbiter_io_masterSel ? M1_valid : M2_valid; // @[Hello.scala 73:30 77:11 83:11]
  assign arbiter_clock = clock;
  assign arbiter_reset = reset;
  assign arbiter_io_req0 = M1_request; // @[Hello.scala 62:19]
  assign arbiter_io_req1 = M2_request; // @[Hello.scala 63:19]
endmodule
