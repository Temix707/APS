module RF
    #(parameter ADR_8 = 8, ADR_5 = 5, BIT_D = 32)
    (
        input                     clk,
        input                     WE3_rf,
        input       [ADR_5-1:0]   A1_rf,
        input       [ADR_5-1:0]   A2_rf,
        input       [ADR_5-1:0]   A3_rf,    //WA
        input       [BIT_D-1:0]   WD3_rf,
        
        output  [BIT_D-1:0]   RD1_rf, RD2_rf     
    );

    reg [BIT_D-1:0] ram_rf [0:BIT_D-1];
    initial $readmemb("rf.txt", ram_rf);
    
    // Читает
    assign RD1_rf = ram_rf[A1_rf];          // ~ 3 = ram_rf[1]
    assign RD2_rf = ram_rf[A2_rf];
    
    // Записывает
    always @ (posedge clk) begin
        ram_rf[0] = 32'd0;
        if(WE3_rf) begin
            ram_rf[A3_rf] <= WD3_rf;
        end
    end
    
endmodule



//* Обращение к 1 элементу множества mem. Подобное обращение вернет 32-битный вектор типа reg.