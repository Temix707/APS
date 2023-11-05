`timescale 1ns / 1ps

module CYBERcobra(
    input clk_i,
    input rst_i,
    input [15:0] sw_i,
    output [31:0] out_o
    );
    
    wire [31:0] sum; 
    reg [31:0] PC;
    wire [31:0] instruction;
    wire [31:0] alu_result;
    
    reg [31:0] WD3;
    wire [31:0] RD1;
    wire [31:0] RD2;
    
    wire flag;
    
    alu_riscv alu(
    .ALUOp(instruction[27:23]),
    .B(RD2),
    .A(RD1),
    .Flag(flag),
    .Result(alu_result)
    );
    
    instr_mem instr_mem(
    .addr(PC),
    .read_data(instruction)
    );
    
    wire B = instruction[30];
    wire J = instruction[31];
    reg [31:0] PC_add;
    
    always @ (*) begin
        if(B&flag|J) begin
            PC_add <= {{22{instruction[12]}},instruction[12:5], 2'b00};
        end
        else begin
            PC_add <= 32'd4;
        end
    end
    
    fulladder32 summator(
    .A(PC[31:0]), 
    .B(PC_add), 
    .Pin(1'b0), 
    .S(sum)
    );     
    
    wire [1:0]WS = instruction[29:28];
    wire [31:0] Constant = {{9{instruction[27]}}, instruction[27:5]};
    
   
    always @ (*) begin
        case(WS)
        2'b00: WD3 = Constant;
        2'b01: WD3 = alu_result;
        2'b10: WD3 = {{16{sw_i[15]}},sw_i[15:0]};
        2'b11: WD3 = 32'd0;
        endcase
    end
    
    
    rf_riscv register_file(
    .clk(clk_i),
    .WE(~(B|J)),
  
    .A1(instruction[22:18]),
    .A2(instruction[17:13]),
    .A3(instruction[4:0]),
  
    .WD3(WD3),
    .RD1(RD1),
    .RD2(RD2)
    );
    
    // Programm counter
    always @ (posedge clk_i) begin
        if(rst_i) begin
            PC[31:0] <= 32'b0;
        end
        else begin
            PC[31:0] <= sum; //прибавили Const
        end
    end
    
    assign out_o = RD1;
    
endmodule
