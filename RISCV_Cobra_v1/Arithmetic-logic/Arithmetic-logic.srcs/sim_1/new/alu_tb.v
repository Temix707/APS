`timescale 1ns / 1ps
module alu_tb();
    reg clk;
    always #10 clk = ~clk;
    reg  [4:0]  A;
    reg  [4:0]  B;
    reg  [4:0]  ALUOp;
    wire        Flag;
    wire [4:0]  Result;
    wire [6:0]  HEX;
    wire [7:0]  AN;

    top_alu dut(
        .A(A),
        .B(B),
        .ALUOp(ALUOp),
        .Result(Result),
        .Flag(Flag)
      //.—игналы внешнего мод-л€(—игналы внутреннего мод-л€)
    );
      
    task add_op;
      input [4:0] a_op, b_op;
      begin
        A = a_op;
        B = b_op; 
        ALUOp = 5'b00000;
        #100;               // выждать 100 ns чтобы сигнальчики разбежались и сумматор успел посчитать
        $display("1");
        if (Result == (a_op + b_op))
          $display("GOOD %d + %d = %d...%d", A, B, Result,Flag);	
        else
          $display("BAD %d + %d = %d", A, B, Result); 
      end
    endtask
    
    task sub_op;
        input [4:0] a_op, b_op;
        begin
            A = a_op;
            B = b_op;
            ALUOp = 5'b01000;
            #100;
            $display("2");
            if (Result == (a_op - b_op))
                $display("GOOD %d - %d = %d...%d", A, B, Result,Flag);	
            else
                $display("BAD %d - %d = %d", A, B, Result); 
        end
    endtask
      
    task sltu_op;            
        input [4:0] a_op, b_op;
        begin
            A = a_op;
            B = b_op;
            ALUOp = 5'b00011;
            #100;
            $display("3");
            if (Result == 1 && (a_op < b_op))         //(A < B);
                $display("GOOD %d < %d,  Result: %d, Flag: %d", A, B, Result, Flag);	
            else
                $display("BAD %d < %d,  Result: %d, Flag: %d", A, B, Result, Flag);
        end
    endtask
    
    task srl_op;            
        input [4:0] a_op, b_op;
        begin
            A = a_op;
            B = b_op;
            ALUOp = 5'b00101;
            #100;
            $display("4");
            $display("Decimal: %d >> %d,  Result: %d, Flag: %d", A, B, Result, Flag);
            $display("Binary: %b >> %b,  Result: %b, Flag: %b", A, B, Result, Flag);
        end
    endtask
    
    task and_op;            
        input [4:0] a_op, b_op;
        begin
            A = a_op;
            B = b_op;
            ALUOp = 5'b00111;
            #100;
            $display("5");
            $display("Decimal: %d & %d,  Result: %d, Flag: %d", A, B, Result, Flag);
            $display("Binary: %b & %b,  Result: %b, Flag: %b", A, B, Result, Flag);
        end
    endtask    
    initial begin
        add_op(6, 3);  //? запустить задачу task add_op с параметрами 6 и 3
        sub_op(4, 3);
        sltu_op(5, 3);
        srl_op(12, 2);
        and_op(7, 4);
        $stop;         // остановить симул€цию
    end
    
endmodule
