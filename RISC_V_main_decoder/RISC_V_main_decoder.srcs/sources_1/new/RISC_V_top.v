module RISC_V_top
     #(parameter ADR_8 = 8, ADR_5 = 5, BIT_D = 32)
    (
        input clk,
        input rst,
        input [BIT_D-1:0] IN,
        
        output [BIT_D-1:0] OUT
    );
    
    wire [31:0] adr;
    wire [BIT_D-1:0] instr;
    
    //  CODE
    
    /// Decoder ///
    wire [31:0] fetched_instr;
    
    wire [1:0]  ex_op_a_sel;
    wire [2:0]  ex_op_b_sel;
    wire [4:0]  alu_op;
    wire        mem_req;
    wire        mem_we;
    wire [2:0]  mem_size;
    wire        gpr_we_a;
    wire        wb_src_sel;
    wire        branch;
    wire        jal;
    wire        jalr;
    wire        illegal_instr;
    
    assign fetched_instr [31:0] = instr [31:0];
    
    
    /// SE ///
    
    wire [11:0] imm_I;
    wire [11:0] imm_S;
    wire [11:0] imm_J;
    wire [11:0] imm_B;
    
    assign imm_I [11:0] = instr [31:20];
    assign imm_S [11:0] = {instr[31:20],instr[11:7]};
    assign imm_J [11:0] = {instr[31], instr[19:12], instr[20], instr[30:21]};
    assign imm_B [11:0] = {instr[31], instr[7], instr[30:25], instr[11:8]};
    
    wire [31:0] SE_I;
    wire [31:0] SE_S;
    wire [31:0] SE_J;
    wire [31:0] SE_B;
    
    assign SE_I = {{20{imm_I[11]}}, imm_I[11:0]}; 
    assign SE_S = {{20{imm_S[11]}}, imm_S[11:0]}; 
    assign SE_J = {{19{imm_J[11]}}, imm_J[11:0], 1'b0}; 
    assign SE_B = {{19{imm_B[11]}}, imm_B[11:0], 1'b0}; 

    
    /// IM and Programm counter///
    
    /*wire branch;
    wire jal;
    wire jalr;*/
    
    wire comp_flag;
    
    wire br_comp_and;
    wire and_jal_or;
    
    wire [31:0] mux2x1_const_J_B;
    wire [31:0] mux2x1_4_imm;
    
    wire        EN;
    reg [31:0] PC;
    initial PC = 32'b0;
    
    assign  EN = 1'b1; 
    
    assign br_comp_and = branch & comp_flag;
    assign and_jal_or = jal | br_comp_and;
    
    assign mux2x1_const_J_B = branch ? SE_B : SE_J; //
    assign mux2x1_4_imm = and_jal_or ? mux2x1_const_J_B : 32'd4;
    
    wire [31:0] RD1; 
    wire [31:0] mux2x1_instr;
    wire [31:0] sum;
    assign sum = PC + mux2x1_4_imm;
           
    assign  mux2x1_instr = jalr ? (RD1 + SE_I) : sum;
    assign adr = PC;
    
    always @(posedge clk) begin
        if (rst) begin
            PC <= 32'd0;
        end
        if (EN) begin
            PC <= mux2x1_instr;
        end else begin
            PC <= PC;
        end
    end

    
    /// RF ///
    
  //wire        WE3;     
    wire [4:0]  A1;
    wire [4:0]  A2;
    wire [4:0]  A3;
    wire [31:0] WD3;
    
  //wire [31:0] RD1;      
    wire [31:0] RD2;
    
    assign A1 = instr[19:15];
    assign A2 = instr[24:20];
    assign A3 = instr[11:7];
    
    
    
    
    /// MUX 3x1  the first number for alu///
    
  //wire [1:0] ex_op_a_sel;
    wire [31:0] mux3x1_f;
    assign mux3x1_f = (ex_op_a_sel == 2'b00) ? RD1 : ((ex_op_a_sel == 2'b01) ? PC : ((ex_op_a_sel == 2'b11) ? 32'd0 : 32'd0)); 
                 
    
    /// MUX 5x1 the second number for alu///
    
  //wire [2:0] ex_op_b_sel;
    wire [31:0] mux5x1_s;
    assign mux5x1_s = (ex_op_b_sel == 3'd0) ? RD2 : ((ex_op_b_sel == 3'd1) ? SE_I : ((ex_op_b_sel == 3'd2) ? {instr[31:12], 11'd0} : ((ex_op_b_sel == 32'd3) ? SE_S : ((ex_op_b_sel == 32'd4) ? 32'd4 : 32'd0)))); 
    
    
    /// ALU ///
    
  //wire comp;
    wire [4:0] ALUOp; 
    wire [31:0]  Result;
    assign ALUOp = alu_op;
    
    
    /// Data Memory ///
    
    wire [31:0] A;
    wire [31:0] RD;
    assign A = Result;
    
    
    /// MUX 2x1///
    
  //wire wb_src_sel;
    wire [31:0] mux2x1_WD3;
    assign mux2x1_WD3 = wb_src_sel ? RD : Result;
    assign WD3 = mux2x1_WD3;
    
        
    assign OUT = PC; ////ДЛЯ ПРОВЕРКИ////    
    
    
/////////////////  Connection  /////////////////
     //.Сигн.внешн.мод(Сигн.внутр.мод)
     /// Decoder ///
     
     decoder_riscv dut_dec(
        .fetched_instr_i(fetched_instr),    // Инструкция для декодирования, считанная из памяти инструкций   
  
        .ex_op_a_sel_o(ex_op_a_sel),      // Управляющий сигнал мультиплексора для выбора первого операнда АЛУ
        .ex_op_b_sel_o(ex_op_b_sel),      // Управляющий сигнал мультиплексора для выбора второго операнда АЛУ 
        .alu_op_o(alu_op),           // Операция АЛУ
        .mem_req_o(mem_req),          // Запрос на доступ к памяти (часть интерфейса памяти), 1 - обращение к памяти - считать или записать
        .mem_we_o(mem_we),           // Сигнал разрешения записи в память. 1, если необходимо записать данные в память, и 0 - если считать из памяти
        .mem_size_o(mem_size),         // Управляющий сигнал для выбора размера слова при чтении-записи в память (часть интерфейса памяти) 
        .gpr_we_a_o(gpr_we_a),         // Сигнал разрешения записи в регистровый файл  
        .wb_src_sel_o(wb_src_sel),       // Управляющий сигнал мультиплексора для выбора данных, записываемых в регистровый фай 
        .illegal_instr_o(illegal_instr),    // Сигнал о некорректной инструкции (на схеме не отмечен)
        .branch_o(branch),           // Сигнал об инструкции условного перехода
        .jal_o(jal),              // Сигнал об инструкции безусловного перехода jal
        .jalr_o(jalr) 
     );
     
     
    /// IM and Programm counter///
    IM dut_im(
        .adr_im(adr),
        
        .instr_im(instr)
     );
    
    
    /// RF ///    
    RF dut_rf(
        .clk(clk),
        .WE3_rf(gpr_we_a),
        .A1_rf(A1),
        .A2_rf(A2),
        .A3_rf(A3),    //WA
        .WD3_rf(WD3), 
        
        .RD1_rf(RD1),
        .RD2_rf(RD2) 
     );
    
    
    /// ALU ///
    ALU dut_alu(
        .RD1_alu(mux3x1_f),
        .RD2_alu(mux5x1_s),
        .ALUOp_alu(ALUOp),
    
        .Flag(comp_flag),   
        .Result(Result) 
     );    
    
    
    /// Data Memory ///
    data_mem dut_mem(
        .clk(clk),
        .A_dm(A),
        .WD_dm(RD2),
        .WE_dm(mem_we),
        .RD_dm(RD)
        //.I_mem_req(mem_req),
        //.I_mem_size(mem_size),
        //.mem_we_dm(mem_we)
     );
    
    
endmodule    
    
    
    
    
    
    
    
    
///////////////////////////////////////////////////////////////////////////////////////////////////////////
    /*
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
    assign SE = {{10{instr[31]}}, instr[27:5]};

    /// MUX 3x1 ///
    wire [BIT_D-1:0]  Result;
    
    wire [1:0]  WS_mux;
    wire [BIT_D-1:0] WD3_mux;
    assign WS_mux = instr[29:28];
    assign WD3_mux = (WS_mux[1:0] == 2'b01) ? IN : ((WS_mux[1:0] == 2'b10) ? SE : (WS_mux[1:0] == 2'b11) ? Result : 1'd0);
  
     
     
   /// RF ///
    wire       WE3;
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
    
    /// Decoder ///
    
    wire [31:0] flech_instr;
    assign flech_instr = instr[31:0];
    
    decoder_riscv(
        .fetched_instr_i(flech_instr)
    );
    
    
    /// Data Memory ///
    
    */
    

//endmodule
