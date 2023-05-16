`timescale 1ns / 1ps

module wrapper_RISC_V(
    input   [15:0]      SW,
    output  [15:0]      LED
    );
    
    wire [31:0] IN_w;
    assign IN_w [31:0]  = {{16{SW[15]}}, SW[15:0]};
    
    wire [31:0] OUT_w;
    assign OUT_w [31:0] =  {16'h0000, LED[15:0]};
    
    RISC_V inst_w(
        .IN(IN_w),
        .OUT(OUT_w)
    );
    
    
    
endmodule
