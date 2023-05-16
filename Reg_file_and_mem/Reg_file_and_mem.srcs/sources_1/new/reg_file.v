module reg_file     #(parameter ADR = 5, BIT_D = 32)
   (input                    clk,          
    input       [ADR-1:0]    A1,   //5-битный адрес одного из 32-х адресуемых регистров (подается на RD1), 1ый порт чтения рф (rd = reg_name[adr])
    input       [ADR-1:0]    A2,   //5-битный адрес одного из 32-х адресуемых регистров (подается на RD2), 2ый порт чтения рф
    input       [ADR-1:0]    A3,   //5-битный адрес одного из 32-х адресуемых регистров (подается на WD3), порт записи ((we) reg_name[adr] <= wd)
    input       [1:0]        WE3,
    
    input      [ADR-1:0]    ALUop,
    
    input       [BIT_D-1:0]  IN,
  //output  reg [7:0]        const,
  //input       [BIT_D-1:0]  instr,
  //input       [1:0]  WS,
    
    output  reg [BIT_D-1:0]  WD3,
    output  reg [BIT_D-1:0]  SE,
  //output  reg [BIT_D-1:0]  WA,
  //input       [ADR-1:0]    ALUop,
    output  reg [BIT_D-1:0]  RD1,        
    output  reg [BIT_D-1:0]  RD2
    );
   
    wire [BIT_D-1:0]  instr;
    
    wire [4:0] RA1;
    wire [4:0] RA2;
    reg [4:0] WA;
    reg [1:0] WS;
    reg  [7:0] const;
  //reg [BIT_D-1:0] instr; 
    
    ram_32_32 inst_rf(
        .clk(clk),
        .rd(instr),
        .rd(RA1[22:18]),
        .rd(RA2[17:13]),
        .rd(WA[4:0])
    );
 
    assign ALUop = instr [27:23];    
    assign WE3 = (instr [29] || instr [28]);
    assign RA1 = A1;
    assign RA2 = A2;
   // assign WA  = instr [4:0];
    
    //assign RA3 [4:0]= instr [4:0];
    
    always @(posedge clk) begin 
        WA  <= instr [4:0];
        const  [7:0] <= instr [12:5];
        SE [BIT_D:0] <= {{24{const[7]}}, const[7:0]};
        case (WS == WE3)
            2'b01: WD3[WA] <= IN;
            
            2'b10: WD3[WA] <= const; 
            
            2'b11: WD3[WA] <= ; 
        
        endcase
        /*if (WE3 == (instr [29] || instr [28])) begin
            
            RD1 <= (instr[RA1] == instr [22:18]);
            RD2 <= (instr[RA2] == instr [17:13]);
            instr[RA3] <= WD3;
        end*/
    end
    
    //RD1 = reg_name[A1]
    //RD2 = reg_name[A2]
    //reg_name[A3] <= WD3
endmodule



// bit depth