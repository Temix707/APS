`timescale 1ns / 1ps
`include "defines_riscv.vh"


module decoder_riscv(
    input [31:0] fetched_instr_i,
    output reg[1:0] ex_op_a_sel_o,
    output reg[2:0] ex_op_b_sel_o,
    output reg[4:0] alu_op_o,
    output reg mem_req_o,
    output reg mem_we_o,
    output reg[2:0] mem_size_o,
    output reg gpr_we_a_o,
    output reg wb_src_sel_o,
    output reg illegal_instr_o,
    output reg branch_o,
    output reg jal_o,
    output reg jalr_o
);
    reg[1:0] last_bits;
    reg[4:0] opcode;
    reg[2:0] funct3;
    reg[6:0] funct7;
    reg[4:0] rd;
    reg[4:0] rs1;
    reg[4:0] rs2;
    reg[4:0] imm5;
    reg[6:0] imm7;
    reg[19:0] imm20;
    
    always @ * begin
        ex_op_a_sel_o <= 0;
        ex_op_b_sel_o <= 0;
        alu_op_o <= 0;
        mem_req_o <= 0;
        mem_we_o <= 0;
        mem_size_o <= 0;
        gpr_we_a_o <= 0;
        wb_src_sel_o <= 0;
        illegal_instr_o <= 0;
        branch_o <= 0;
        jal_o <= 0;
        jalr_o <= 0;
        
        last_bits = fetched_instr_i[1:0];
        if (last_bits == 2'b11) begin
            opcode <= fetched_instr_i[6:2];
            if (
                opcode != `JAL_OPCODE & opcode != `AUIPC_OPCODE
            ) begin
                funct3 <= fetched_instr_i[14:12];
            end
            
            case(opcode)
                `OP_OPCODE: //01100 R-type add-sltu
                    begin
                        funct7 <= fetched_instr_i[31:25];
                        if ((funct7 == 7'd32 & (funct3 == 3'b000 | funct3 == 3'b101)) | (funct7 == 7'd0)) begin
                            alu_op_o <= {funct7[6:5], funct3};
                            ex_op_a_sel_o <= 2'b00;
                            ex_op_b_sel_o <= 3'b000;
                            wb_src_sel_o <= 0;
                            gpr_we_a_o <= 1;
                        end else begin
                            illegal_instr_o <= 1;
                        end
                    end
                `OP_IMM_OPCODE: //00100 I-type addi-sltui
                    begin
                        funct7 <= fetched_instr_i[31:25];
                        if ((funct3 == 1 & funct7 != 0) | (funct3 == 5 & funct7 != 0 & funct7 != 32)) begin
                            illegal_instr_o <= 1;
                        end else begin
                            gpr_we_a_o <= 1;
                            wb_src_sel_o <= 0;
                            ex_op_a_sel_o <= 2'b00;
                            ex_op_b_sel_o <= 3'b001;
                            if (funct3 == 1 | funct3 == 5) begin
                                alu_op_o <= {funct7[6:5], funct3};
                            end else begin
                                alu_op_o <= { 2'b00, funct3};
                            end
                        end
                    end
                `LUI_OPCODE: //01101 U-type lui
                    begin
                        gpr_we_a_o <= 1;
                        ex_op_a_sel_o <= 2'b10;
                        ex_op_b_sel_o <= 3'b010;
                        alu_op_o <= 5'b0;
                    end
                `LOAD_OPCODE: //00000 I-type lb-lhu
                    if (funct3 == 3'b000 | funct3 == 3'b001 | funct3 == 3'b010 | funct3 == 3'b100 | funct3 == 3'b101) begin
                        gpr_we_a_o <= 1;
                        ex_op_a_sel_o <= 2'b00;
                        ex_op_b_sel_o <= 3'b001;
                        alu_op_o <= 5'b0;
                        mem_we_o <= 0;
                        mem_req_o <= 1;
                        mem_size_o <= funct3;
                        wb_src_sel_o <= 1; 
                    end else begin
                        illegal_instr_o <= 1;
                    end 
                `STORE_OPCODE: //01000 S-type sb-sw
                    if (funct3 <= 3'b010) begin
                        ex_op_a_sel_o <= 2'b00;
                        ex_op_b_sel_o <= 3'b011;
                        alu_op_o <= 5'b0;
                        mem_we_o <= 1; 
                        mem_req_o <= 1;
                        mem_size_o <= funct3;
                        wb_src_sel_o <= 0;
                    end else begin
                        illegal_instr_o <= 1;
                    end   
                `BRANCH_OPCODE: //11000 B-type beq-bgeu
                    if (funct3 == 2 | funct3 == 3) begin
                        illegal_instr_o <= 1;
                    end else begin
                        ex_op_a_sel_o <= 2'b00;
                        ex_op_b_sel_o <= 3'b000;
                        alu_op_o <= {2'b11, funct3};
                        wb_src_sel_o <= 0;
                        branch_o <= 1;
                    end
                `JAL_OPCODE: //11011 J-type jal
                    begin
                        gpr_we_a_o <= 1;
                        ex_op_a_sel_o <= 2'b01;
                        ex_op_b_sel_o <= 3'b100;
                        alu_op_o <= 5'b0;
                        wb_src_sel_o <= 0;
                        jal_o <= 1;
                        branch_o <= 0;
                    end
                `JALR_OPCODE: //11001 I-type jalr
                    if (funct3 == 3'b000) begin
                        gpr_we_a_o <= 1;
                        ex_op_a_sel_o <= 2'b01;
                        ex_op_b_sel_o <= 3'b100;
                        alu_op_o <= 5'b0;
                        wb_src_sel_o <= 0;
                        jalr_o <= 1;
                    end else begin
                        illegal_instr_o <= 1;
                    end
                `AUIPC_OPCODE: //00101 U-type auipc
                    begin
                        gpr_we_a_o <= 1;
                        ex_op_a_sel_o <= 2'b01;
                        ex_op_b_sel_o <= 3'b010;
                        alu_op_o <= 5'b0;
                        wb_src_sel_o <= 0;
                    end
                `MISC_MEM_OPCODE: //00011 I-type fence
                    if (funct3 != 3'b000) begin
                        illegal_instr_o <= 1;
                    end
                `SYSTEM_OPCODE: //11100 I-type ecall-ebreak
                    if (
                        fetched_instr_i != 32'b0000000_00000_00000_000_00000_1110011 &
                        fetched_instr_i != 32'b0000001_00000_00000_000_00000_1110011
                    ) begin
                        illegal_instr_o <= 1;
                    end
                default:      
                    illegal_instr_o <= 1;
            endcase
            
        end else begin
            illegal_instr_o <= 1;
        end
    end
endmodule