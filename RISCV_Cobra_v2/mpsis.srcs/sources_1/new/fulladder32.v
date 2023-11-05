`timescale 1ns / 1ps

module fulladder32(
    input [31:0] A,
    input [31:0] B,
    input       Pin,
    output[31:0] S,
    output      Pout
);

    wire [6:0] P;     // Обратите внимание на то, как подключены
                      // входы и выходы Pin/Pout во всех модулях!
   fulladder4 a0(
        .a(A[3:0]),
        .b(B[3:0]),
        .Pin(Pin),
        .S(S[3:0]),
        .Pout(P[0])
    );

    fulladder4 a1(
        .a(A[7:4]),
        .b(B[7:4]),
        .Pin(P[0]),
        .S(S[7:4]),
        .Pout(P[1])
    );

    fulladder4 a2(
        .a(A[11:8]),
        .b(B[11:8]),
        .Pin(P[1]),
        .S(S[11:8]),
        .Pout(P[2])
    );

    fulladder4 a3(
        .a(A[15:12]),
        .b(B[15:12]),
        .Pin(P[2]),
        .S(S[15:12]),
        .Pout(P[3])
    );
    
    fulladder4 a4(
        .a(A[19:16]),
        .b(B[19:16]),
        .Pin(P[3]),
        .S(S[19:16]),
        .Pout(P[4])
    );
    
    fulladder4 a5(
        .a(A[23:20]),
        .b(B[23:20]),
        .Pin(P[4]),
        .S(S[23:20]),
        .Pout(P[5])
    );
    
    fulladder4 a6(
        .a(A[27:24]),
        .b(B[27:24]),
        .Pin(P[5]),
        .S(S[27:24]),
        .Pout(P[6])
    );
    
    fulladder4 a7(
        .a(A[31:28]),
        .b(B[31:28]),
        .Pin(P[6]),
        .S(S[31:28]),
        .Pout(Pout)
    );
endmodule
