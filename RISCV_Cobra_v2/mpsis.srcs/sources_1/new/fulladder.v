`timescale 1ns / 1ps

module fulladder(
  input      a,   // Входные сигналы
  input      b,
  input     Pin,

  output     S,    // Выходной сигнал
  output     Pout

  );
  
  assign S = (a ^ b)^Pin;
  assign Pout = (a&b) | (a&Pin) | (b&Pin);

  endmodule
