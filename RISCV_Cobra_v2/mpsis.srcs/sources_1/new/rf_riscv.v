`timescale 1ns / 1ps

module rf_riscv(
  input clk,
  input WE,
  
  input [4:0] A1,
  input [4:0] A2,
  input [4:0] A3,
  
  input [31:0] WD3,
  output [31:0] RD1,
  output [31:0] RD2
);
    reg [31:0] RAM [0:31];
    initial RAM[0] = 0;
    
    assign RD1 = RAM[A1];
    assign RD2 = RAM[A2];
   
    
    always @ (posedge clk) begin
        if (WE) begin
            if (A3 != 0) begin
                RAM [A3] = WD3;
            end
        end
    end
endmodule
