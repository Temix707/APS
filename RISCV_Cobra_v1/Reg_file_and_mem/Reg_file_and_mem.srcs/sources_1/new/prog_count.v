module prog_count #(parameter BIT_D = 32)
   (input            clk,
    input            rst,   
    output reg [7:0] PC,
    
    input            flag_pc,
    output           out_and,
    
    input      [7:0] const,
    output           out_or
    );
    
    alu_rf inst_pc(
        .flag(flag_pc)
    );
     reg [BIT_D-1:0] reg_name [0:BIT_D-1];
    
    initial begin
        $readmemb ("ram.txt", reg_name);
        PC = 0;
    end
    
    
    assign out_and = (flag_pc && reg_name[30][PC]) ? 1 : 0;    //reg_name[30][PC]  Обращение к 30му биту пераого элемента множества mem.
    assign out_or  = (out_and || reg_name[31][PC]) ? 1 : 0;
    
    always @(posedge clk) begin          
        if(out_or) begin
            PC <= PC + const;
        end else begin
            PC <= PC + 8'b00000001;
        end      
    end
    
endmodule
