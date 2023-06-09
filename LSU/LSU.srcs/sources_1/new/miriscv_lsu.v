module miriscv_lsu( 
    input clk_i, // ������������� 
    input arstn_i, // ����� ���������� ���������
 
    // core protocol
    input [31:0] lsu_addr_i, // (A) �����, �� �������� ����� ����������
    input lsu_we_i,          // (WE) 1 - ���� ����� �������� � ������
    input [2:0] lsu_size_i,  // (S) ������ �������������� ������
    input [31:0] lsu_data_i, // (RD2) ������ ��� ������ � ������
    input lsu_req_i,         // (I) 1 - ���������� � ������
    output lsu_stall_req_o,  // () ������������ ��� !enable pc 
    output [31:0] lsu_data_o, // (RD) ������ ��������� �� ������
 
    // memory protocol 
    input [31:0] data_rdata_i, // ����������� ������
    output data_req_o,         // 1 - ���������� � ������
    output data_we_o,          // 1 - ��� ������ �� ������
    output [3:0] data_be_o,    // � ����� ������ ����� ���� ���������
    output [31:0] data_addr_o, // �����, �� �������� ���� ���������
    output [31:0] data_wdata_o // ������, ������� ��������� ��������
);
    
    
endmodule


