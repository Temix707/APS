module RISC_V_top
     #(parameter ADR_8 = 8, ADR_5 = 5, BIT_D = 32)
    (
        input clk,
        input rst,
        input [BIT_D-1:0] IN,
        
        output [BIT_D-1:0] OUT
    );
    
    initial begin
        
    end
    
    /// IM and Programm counter///
    wire [ADR_8-1:0] adr;
    wire [BIT_D-1:0] instr;
    
    wire        MUX_PC;
    wire        MUX_PC_flag;
    wire        EN;
    reg [7:0] PC = 8'b00000000; 
    
    wire        Flag; 
    
    assign  EN = 1'd1;
    assign  MUX_PC_flag = (Flag && instr[30]) || instr[31];
    assign  MUX_PC = MUX_PC_flag ? instr[12:5] : 8'b00000001;  // либо прибавляет какое то число, либо единицу
    
    assign adr = PC;
    
    always  @(posedge clk) begin
        if(EN) begin
            PC <= PC + MUX_PC;
        end else begin
            PC <= PC;
        end
    end
    
    IM dut1(
        .adr_im(adr), 
        .instr_im(instr)
    );
          //.Сигн.внешн.мод(Сигн.внутр.мод)
    
    
   /// SE ///
    wire [7:0] const;
    assign const = instr [12:5];
    wire [31:0] SE;   
    assign SE = {{10{instr[31]}}, instr[27:5]}; ///

    /// MUX 3x1 ///
    wire [BIT_D-1:0]  Result;
    
    wire [1:0]  WS_mux;
    wire [BIT_D-1:0] WD3_mux;
    assign WS_mux = instr[29:28];
    assign WD3_mux = (WS_mux[1:0] == 2'b01) ? IN : ((WS_mux[1:0] == 2'b10) ? SE : (WS_mux[1:0] == 2'b11) ? Result : 1'd0);
  
     
     
   /// RF ///
    wire             WE3;
    wire [4:0] A1;
    wire [4:0] A2;
    wire [4:0] A3_WA;
        
    assign WE3 = instr[29] || instr[28];
    assign A1 = instr[22:18];
    assign A2 = instr[17:13];
    assign A3_WA = instr[4:0];
    
    wire [BIT_D-1:0] RD1;      
    wire [BIT_D-1:0] RD2;
    assign OUT = RD1;
     
    RF dut2(
        .clk(clk),
        .WE3_rf(WE3), 
        .A1_rf(A1), 
        .A2_rf(A2), 
        .A3_rf(A3_WA),     //WA 
        .WD3_rf(WD3_mux), 
            
        .RD1_rf(RD1), 
        .RD2_rf(RD2)
    );


   
   /// ALU ///
    wire [4:0] ALUOp; 
    assign ALUOp = instr[27:23];
    
    ALU dut3(
        //.clk(clk),
        .RD1_alu(RD1),
        .RD2_alu(RD2),
        .ALUOp_alu(ALUOp),
        
        .Flag(Flag),
        .Result(Result)
    );
     
    
    
    
    
    /*
    /// SE ///
    wire [31:0] SE;
    SE dut4(
        .SE_i(instr[27:5]),
        
        .SE_o(SE)
    );
    
   /// MUX 3x1 ///
    mux3x1 dut5(
        .WS_mux(instr[29:28]),
        .IN_mux(IN),
        .const(SE),
        .Res_alu(Result),
        
        .WD3_mux(WD3)     
    );
    */
endmodule
