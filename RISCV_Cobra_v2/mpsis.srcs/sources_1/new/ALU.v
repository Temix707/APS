`timescale 1ns / 1ps
`include "defines_riscv.vh"

module alu_riscv(
    input [4:0] ALUOp,
    input [31:0] B,
    input [31:0] A,
    output reg Flag,
    output reg [31:0] Result
    );
    wire [31:0] sum; 
    wire [31:0] sub; 
    fulladder32 summator(
    .A(A), 
    .B(B), 
    .Pin(1'b0), 
    .S(sum)
    );
    
     fulladder32 subtor(
    .A(A), 
    .B(~B+1'b1), 
    .Pin(1'b0), 
    .S(sub)
    );
    
    always @(*) begin
        case(ALUOp)
            `ALU_ADD: Result = sum;
            `ALU_SUB: Result = sub;
            `ALU_SLL: Result = A << B[4:0];
            `ALU_SLTS: Result = $signed(A) < $signed(B);
            `ALU_SLTU: Result = A < B;
            `ALU_XOR: Result = A ^ B;
            `ALU_SRL: Result = A >> B[4:0];
            `ALU_SRA: Result = $signed(A) >>> B[4:0];
            `ALU_OR: Result = A | B;
            `ALU_AND: Result = A & B;
            default: Result = 32'b0;
        endcase
        case(ALUOp)
            `ALU_EQ: Flag = (A==B);
            `ALU_NE: Flag = (A!=B);
            `ALU_LTS: Flag = $signed(A) < $signed(B);
            `ALU_GES: Flag = $signed(A) >= $signed(B);
            `ALU_LTU: Flag = A < B;
            `ALU_GEU: Flag = A >= B;
            default: Flag = 32'b0;
        endcase
    end
endmodule
