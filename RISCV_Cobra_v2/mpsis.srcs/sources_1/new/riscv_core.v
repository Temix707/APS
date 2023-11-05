`timescale 1ns / 1ps

module riscv_core(
    input clk_i,
    input rst_i,
    input [31:0] instr_i,
    input [31:0] RD_i,
    
    output [31:0] WD_o,
    output [31:0] instr_addr_o,
    output [31:0] data_addr_o,
    output [2:0] mem_size_o,
    output mem_req_o,
    output  WE_o
    );
    wire [31:0] imm_I;
    wire [31:0] imm_U;
    wire [31:0] imm_S;
    wire [31:0] imm_B;
    wire [31:0] imm_J;
    
    wire [31:0] WD;
    wire [31:0] RD1;
    wire [31:0] RD2;
    
    wire flag;
    
    reg [31:0] PC;
    
    wire [1:0] ex_op_a_sel_o;
    wire [2:0] ex_op_b_sel_o;
    wire [4:0] alu_op_o;
    wire gpr_we_a_o;
    wire wb_src_sel_o;
    wire illegal_instr_o;
    wire branch_o;
    wire jal_o;
    wire jalr_o;
    
   decoder_riscv decoder_riscv1(
    .fetched_instr_i(instr_i),
    .ex_op_a_sel_o(ex_op_a_sel_o),
    .ex_op_b_sel_o(ex_op_b_sel_o),
    .alu_op_o(alu_op_o),
    .mem_req_o(mem_req_o),
    .mem_we_o(WE_o),
    .mem_size_o(mem_size_o),
    .gpr_we_a_o(gpr_we_a_o),
    .wb_src_sel_o(wb_src_sel_o),
    .illegal_instr_o(illegal_instr_o),
    .branch_o(branch_o),
    .jal_o(jal_o),
    .jalr_o(jalr_o)
    );
    
    rf_riscv register_file(
    .clk(clk_i),
    .WE(gpr_we_a_o),
  
    .A1(instr_i[19:15]),
    .A2(instr_i[24:20]),
    .A3(instr_i[11:7]),
  
    .WD3(WD),
    .RD1(RD1),
    .RD2(RD2)
    );
    
    reg [31:0] alu1;
    reg [31:0] alu2;
    
    always @ (*) begin
        case(ex_op_a_sel_o)
        2'b0: alu1 = RD1;
        2'b01: alu1 = PC;
        2'b10: alu1 = 0;
        default: alu1 = 0;
        endcase
    end
    
    assign imm_I = {{20{instr_i[31]}},instr_i[31:20]};
    assign imm_U = {instr_i[31:12], 12'h000};
    assign imm_S = {{20{instr_i[31]}},instr_i[31:25],instr_i[11:7]};
    assign imm_B = {{19{instr_i[31]}},instr_i[31],instr_i[7],instr_i[30:25],instr_i[11:8],1'b0};
    assign imm_J = {{10{instr_i[31]}},instr_i[31],instr_i[19:12],instr_i[20],instr_i[31:21],1'b0};
    
    always @ (*) begin
        case(ex_op_b_sel_o)
        3'b0: alu2 = RD2;
        3'b001: alu2 = imm_I;
        3'b010: alu2 = imm_U;
        3'b011: alu2 = imm_S;
        3'b100: alu2 = 3'd4;
        default: alu2 = 0;
        endcase
    end
    
    assign WD_o = RD2;
    
    wire [31:0] alu_result;
    
    alu_riscv alu(
    .ALUOp(alu_op_o),
    .A(alu1),
    .B(alu2),
    .Flag(flag),
    .Result(alu_result)
    );
    
    assign data_addr_o = alu_result;
    
    assign WD = wb_src_sel_o ? RD_i : alu_result;
    
    //lower blocks
    wire branch_and_flag;
    
    assign branch_and_flag = flag & branch_o;
    
    wire branch_o_jal;
    
    assign branch_o_jal = branch_and_flag | jal_o;
    
    wire [31:0] imm_B_J;
    
    assign imm_B_J = branch_o ? imm_B : imm_J;
    
    wire [31:0] imm_BJ_4;
    
    assign imm_BJ_4 = branch_o_jal ? imm_B_J : 3'd4;
    
    wire [31:0] sum1;
    wire [31:0] sum2;
    
    fulladder32 summator1(
    .A(PC), 
    .B(imm_BJ_4), 
    .Pin(1'b0), 
    .S(sum1)
    );     
    
    fulladder32 summator2(
    .A(RD1), 
    .B(imm_I), 
    .Pin(1'b0), 
    .S(sum2)
    ); 
    
    wire [31:0] imm_final;
    
    assign imm_final = jalr_o ? sum2 : sum1;
    
    // Programm counter
    always @ (posedge clk_i) begin
        if(rst_i) begin
            PC[31:0] <= 32'b0;
        end
        else begin
            PC[31:0] <= imm_final;
        end
    end  
    
    initial PC = 0;
    assign instr_addr_o = PC;
    
endmodule
