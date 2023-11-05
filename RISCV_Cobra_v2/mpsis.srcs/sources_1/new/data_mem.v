`timescale 1ns / 1ps

module data_mem(  
  input clk,
  input WE,
  input [31:0] addr,
  input [31:0] write_data,
  input req_i,
  output[31:0] read_data

);
    reg [7:0] RAM [0:1023];
    
    assign read_data = {RAM[addr+2'b11], RAM[addr+2'b10], RAM[addr+2'b01], RAM[addr]};
    
    always @ (posedge clk) begin
        if (WE & req_i) begin
            {RAM[addr+2'b11], RAM[addr+2'b10], RAM[addr+2'b01], RAM[addr]} = write_data;
        end
    end
endmodule
