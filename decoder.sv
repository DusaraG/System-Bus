module decoder (
    input logic clk,
    input logic rst_n,
    input logic [15:0] addr,     // 16-bit input address
    output logic slave1_sel,     // Slave 1 select signal (2K)
    output logic slave2_sel,     // Slave 2 select signal (4K)
    output logic slave3_sel,     // Slave 3 select signal (4K)
    output logic [1:0] SELR      // 2-bit output to select among slaves
);

    always@(posedge clk) begin
        if(!rst_n || (addr ==16'b0)) begin
            SELR <= 2'b00;  
            slave1_sel <=0;
            slave2_sel <=0;
            slave3_sel <=0;
        end else if (addr[15:11] == 5'b00000) begin
            SELR <= 2'b01;
            slave1_sel <=1;
            slave2_sel <=0;
            slave3_sel <=0;
        end else if (addr[15:12] == 4'b0001) begin
            SELR <= 2'b10;
            slave1_sel <=0;
            slave2_sel <=1;
            slave3_sel <=0;
        end else if (addr[15:12] == 4'b0010) begin
            SELR <= 2'b11;
            slave1_sel <=0;
            slave2_sel <=0;
            slave3_sel <=1;
        end else begin
            SELR <= 2'b00;
            slave1_sel <=0;
            slave2_sel <=0;
            slave3_sel <=0;

            
        end    

            
        end
endmodule