module wrapper_alu(
    //input           clk,
    input   [15:0]      SW,
    output  [15:0]      LED,
    output reg [6:0]    HEX,
    output reg [7:0]    AN
    
);

    initial begin
            AN [0] = 1'b1;
            AN [7:1] = 7'b0000000;
    end

      // 0 - on, 1 - off
    always @(*) begin
        case(LED)
            0:  HEX = 7'b1000000;
            1:  HEX = 7'b1111001;
            2:  HEX = 7'b0100100;
            3:  HEX = 7'b0110000;
            4:  HEX = 7'b0011001;
            5:	HEX = 7'b0010010;
            6:	HEX = 7'b0000010;
            7:	HEX = 7'b1111000;
            8:	HEX = 7'b0000000;
            9:	HEX = 7'b0010000;
        endcase
    end

top_alu inst(
    //.clk(clk),
    .A(SW[4:0]),
    .B(SW[9:5]),
    .ALUOp(SW[14:10]),
    .Result(LED[4:0]),
    .Flag(LED[15])
);


endmodule





  