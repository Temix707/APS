module fulladder4(
    input [3:0] a,
    input [3:0] b,
    input       Pin,
    output[3:0] S,
    output      Pout
);

    wire [2:0] P;     // Обратите внимание на то, как подключены
                      // входы и выходы Pin/Pout во всех модулях!
   fulladder a0(
        .a(a[0]),
        .b(b[0]),
        .Pin(Pin),
        .S(S[0]),
        .Pout(P[0])
    );

    fulladder a1(
        .a(a[1]),
        .b(b[1]),
        .Pin(P[0]),
        .S(S[1]),
        .Pout(P[1])
    );

    fulladder a2(
        .a(a[2]),
        .b(b[2]),
        .Pin(P[1]),
        .S(S[2]),
        .Pout(P[2])
    );

    fulladder a3(
        .a(a[3]),
        .b(b[3]),
        .Pin(P[2]),
        .S(S[3]),
        .Pout(Pout)
    );

endmodule