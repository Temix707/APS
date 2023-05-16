`timescale 1ns / 1ps

module RISC_V_tb();

    reg  [31:0] IN_tb;
    reg         clk_tb = 1'b0;
    reg         rst_tb;
    wire [31:0] OUT_tb;

    always #10 clk_tb = ~clk_tb;

    RISC_V_top dut(
        .clk(clk_tb),
        .rst(rst_tb),
        .IN(IN_tb),
        .OUT(OUT_tb)
      //.Сигналы внешнего мод-ля(Сигналы внутреннего мод-ля)
    );

    initial begin
        rf(10, clk_tb, 1'b0);
        #40;
        $stop;
    end

    task rf;
        input [31:0] in_op;
        input        clk_op;
        input        rst_op;
    begin
        IN_tb = in_op;
        clk_tb = clk_op;
        rst_tb = rst_op;
        #100;
        
        $display("Out is %b", OUT_tb);
    end
    endtask
endmodule




















/*module RISC_V_tb();
    // reg - могу изменять/регулировать значения
    reg clk_tb;
    reg rst_tb;
    reg [31:0] IN_tb;
            
    // wire - провода, не могу изменять/регулировать
    wire [31:0] OUT_tb;
   
    RISC_V_top dut(
        .clk(clk_tb),
        .rst(rst_tb),
        .IN(IN_tb),
        .OUT(OUT_tb)
      //.Сигналы внешнего мод-ля(Сигналы внутреннего мод-ля)
    );
    
    //initial
      //  forever
        //    #10 clk_tb = ~clk_tb;
                
    task test_tb;
        input [3:0] in;
        input clk;
        input rst;
        begin
            IN_tb = in;
            clk_tb = clk;
            rst_tb = rst;
        end
    endtask 
    
    initial begin
        test_tb(4'b0000, 1'b0, 1'b0);
        #50;
        test_tb(4'b0000, 1'b1, 1'b0);
        #50;                             //////////1
        test_tb(4'b0000, 1'b0, 1'b0);
        #50;
        test_tb(4'b0000, 1'b1, 1'b0);
        #50;                             //////////2
        test_tb(4'b0000, 1'b0, 1'b0);
        #50;
        test_tb(4'b0000, 1'b1, 1'b0);
        #50;                             //////////3
        test_tb(4'b0000, 1'b0, 1'b0);
        #50;
       test_tb(4'b0000, 1'b1, 1'b0);
        #50;                             //////////4
        test_tb(4'b0000, 1'b0, 1'b0);
        #50;
        test_tb(4'b0000, 1'b1, 1'b0);
        #50;
        test_tb(4'b0000, 1'b0, 1'b0);
        #50;                             //////////5
        test_tb(4'b0000, 1'b1, 1'b0);
        #50;
        test_tb(4'b0000, 1'b0, 1'b0);
        #50; 
        end
    
endmodule*/





