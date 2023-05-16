module IM
    #(parameter ADR_8 = 8, ADR_5 = 5, BIT_D = 32)
    (
        input   [ADR_8-1:0]     adr_im,
        
        output [BIT_D-1:0]  instr_im   
    );
    
    // IM
    //     разряд       кол-во слов
    reg [BIT_D-1:0] RAM [0:BIT_D-1];    // создать память из 32-ти 32-битных ячеек
    initial $readmemb("ram.txt", RAM);
    
    assign instr_im = RAM[adr_im];   // реализация порта на чтение (передает 32-х битное слово (инструкцию))
     
     
endmodule














    
   /* wire        MUX_PC;
    wire        MUX_PC_flag;
    wire        Flag_im;
    reg [7:0]   PC;
    wire        EN;
    
    //assign EN = 1'd1; 
     
    //Programm counter
    ALU inst_im( .Flag(Flag_im));
    
    initial begin
        PC [7:0] = 8'd00000000;
    end
    
    assign  MUX_PC_flag = (Flag_im && instr_im[30]) || instr_im[31];
    assign  MUX_PC = MUX_PC_flag ? instr_im[12:5] : 8'b00000001;  // либо прибавляет какое то число, либо единицу
    
    assign adr_im = PC;
    
    always  @(posedge clk) begin
        if(EN) begin
            PC <= PC + MUX_PC;
        end else begin
            PC <= PC;
        end
    end
    */