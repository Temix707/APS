`timescale 1ns / 1ps

module instr_mem(
  input [31:0] addr,
  output[31:0] read_data
);
    reg [7:0] RAM [0:1023];
    initial $readmemh("my_program.mem", RAM);
    
    assign read_data = {RAM[addr+2'b11], RAM[addr+2'b10], RAM[addr+2'b01], RAM[addr]};
endmodule
