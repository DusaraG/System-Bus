module ready(
    input logic clk,
    input logic rst_n,
    input logic s1_ready,   // Should be 8-bit
    input logic s2_ready,   // Should be 8-bit
    input logic s3_ready,   // Should be 8-bit
    input logic[1:0] select,

    output logic ready

);

always@(posedge clk) begin
    if(!rst_n) begin
        ready <= 1'bx;  // It's better to reset to known values
    end else begin
        case(select)
            2'b01: ready <= s1_ready;  // 8-bit wide assignment
            2'b10: ready <= s2_ready;  // 8-bit wide assignment
            2'b11: ready <= s3_ready;  // 8-bit wide assignment
            default: ready <= 1'bx; // Replace 'x' with known value
        endcase
    end

end


endmodule