`timescale 1ns / 1ps

    
module lab1(
  input      A,   // ������� �������
  input      B,
  input      Pin,

  output     S,    // �������� ������
  output     Pout

  );
  
  assign S = (A ^ B)^Pin;
  assign Pout = (A&B) | (A&Pin) | (B&Pin);

  endmodule
