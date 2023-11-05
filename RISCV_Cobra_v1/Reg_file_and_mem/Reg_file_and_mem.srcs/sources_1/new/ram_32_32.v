module ram_32_32    #(parameter ADR = 5, BIT_D = 32)
   (input                   clk, 
    input   [ADR-1:0]       adr,    // address
    input   [BIT_D-1:0]     wd,     // Write Data
    input                   we,     // Write Enable 
    input                   we,
    output reg [BIT_D-1:0]  rd      // Read Data
    ); 

    prog_count inst_ram(
        .clk(clk),
        .PC(adr)
    );
    
    initial begin 
        $readmemb ("ram.txt", reg_name);
    end
    
    reg [BIT_D-1:0] reg_name [0:BIT_D-1];   // создать пам€ть из 32-ти 32-битных €чеек 
    
    always @(posedge clk) begin
        rd [BIT_D-1:0] = reg_name[adr];   // подключение выхода rd к €чейке пам€ти с адресом adr 
    end
    
    
    
    /*always @ (posedge clk) begin // запись данных wd
        if (we) reg_name[adr] <= wd; //входные данные дл€ записи в €чейку по адресу adr
    end*/

endmodule