`timescale 1ns / 1ps

    
module lab1(
  input      A,   // Входные сигналы
  input      B,
  input      Pin,

  output     S,    // Выходной сигнал
  output     Pout

  );
  
  assign S = (A ^ B)^Pin;
  assign Pout = (A&B) | (A&Pin) | (B&Pin);

  endmodule
