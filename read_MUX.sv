module read_MUX(
    input logic clk,
    input logic rst_n,
    input logic[7:0] HRDATA_1,   // Should be 8-bit
    input logic[7:0] HRDATA_2,   // Should be 8-bit
    input logic[7:0] HRDATA_3,   // Should be 8-bit
    input logic[1:0] select,

    output logic[7:0] HRDATA

);

always@(posedge clk) begin
    if(!rst_n) begin
        HRDATA <= 8'bx;  // It's better to reset to known values
    end else begin
        case(select)
            2'b01: HRDATA <= HRDATA_1;  // 8-bit wide assignment
            2'b10: HRDATA <= HRDATA_2;  // 8-bit wide assignment
            2'b11: HRDATA <= HRDATA_3;  // 8-bit wide assignment
            default: HRDATA <= 8'bx; // Replace 'x' with known value
        endcase
    end

end


endmodule