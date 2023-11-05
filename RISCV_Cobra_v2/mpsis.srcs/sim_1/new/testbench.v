`timescale 1ns / 1ps

module testbench();                // <- Не имеет ни входов, ни выходов!
  reg clk_i, rst_i, sw_i;
  wire out_o;

  CYBERcobra DUT(                  // <- Подключаем проверяемый модуль
    .clk_i (clk_i),
    .rst_i (rst_i),
    .sw_i (sw_i),
    .out_o (out_o)
);

  initial begin
    clk_i = 0;
    rst_i = 1'b1;
    sw_i = 15'b1000010000000000;
    #32;
  end
endmodule