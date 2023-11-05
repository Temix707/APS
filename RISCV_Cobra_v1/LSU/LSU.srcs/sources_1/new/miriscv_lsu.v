module miriscv_lsu( 
    input clk_i, // синхронизация 
    input arstn_i, // сброс внутренних регистров
 
    // core protocol
    input [31:0] lsu_addr_i, // (A) адрес, по которому хотим обратиться
    input lsu_we_i,          // (WE) 1 - если нужно записать в память
    input [2:0] lsu_size_i,  // (S) размер обрабатываемых данных
    input [31:0] lsu_data_i, // (RD2) данные для записи в память
    input lsu_req_i,         // (I) 1 - обратиться к памяти
    output lsu_stall_req_o,  // () используется как !enable pc 
    output [31:0] lsu_data_o, // (RD) данные считанные из памяти
 
    // memory protocol 
    input [31:0] data_rdata_i, // запрошенные данные
    output data_req_o,         // 1 - обратиться к памяти
    output data_we_o,          // 1 - это запрос на запись
    output [3:0] data_be_o,    // к каким байтам слова идет обращение
    output [31:0] data_addr_o, // адрес, по которому идет обращение
    output [31:0] data_wdata_o // данные, которые требуется записать
);
    
    
endmodule


