`timescale 1ns / 1ps

module riscv_unit(
    input clk_i,
    input resetn,
    
      // Входы и выходы периферии
      input [15:0] sw_i,    // Переключатели
      output[15:0] led_o,   // Светодиоды
      input        kclk,    // Тактирующий сигнал клавиатуры
      input        kdata,   // Сигнал данных клавиатуры
      output [6:0] hex_led, // Вывод семисегментных индикаторов
      output [7:0] hex_sel, // Селектор семисегментных индикаторов
      input        rx_i,    // Линия приема по UART
      output       tx_o     // Линия передачи по UART  
    );
    wire sysclk, rst;
    sys_clk_rst_gen divider(.ex_clk_i(clk_i),.ex_areset_n_i(resetn),.div_i(10),.sys_clk_o(sysclk), .sys_reset_o(rst));
    
    wire rst_i = ~resetn;
    
    wire [31:0] instr;
    reg [31:0] RD_i;
    
    wire [31:0] WD_o;
    wire [31:0] instr_addr;
    wire [31:0] data_addr_o;
    wire [2:0] mem_size_o;
    wire mem_req_o;
    wire  WE_o;
    
    //OneHotEncoder
    wire [255:0] one_hot;
    assign one_hot = 256'd1 << data_addr_o[31:24];
    wire [31:0] new_data_addr;
    assign new_data_addr = {8'd0, data_addr_o[23:0]};
    
    riscv_core riscv_core1(
    .clk_i(sysclk),
    .rst_i(rst_i),
    .instr_i(instr),
    .RD_i(RD_i),
    
    .WD_o(WD_o),
    .instr_addr_o(instr_addr),
    .data_addr_o(data_addr_o),
    .mem_size_o(mem_size_o),
    .mem_req_o(mem_req_o),
    .WE_o(WE_o)
    );
    
    instr_mem instr_mem1(
    .addr(instr_addr),
    .read_data(instr)
    );
    
    wire [31:0] data_rd;
    
    data_mem data_mem1(  
    .clk(sysclk),
    .WE(WE_o),
    .addr(new_data_addr),
    .write_data(WD_o),
    .read_data(data_rd),
    .req_i(mem_req_o & one_hot[0])
    );

    wire [31:0] perek_rd;

    sw_sb_ctrl perek(
    .addr_i(new_data_addr),
    .req_i(mem_req_o & one_hot[1]),
  
    .WD_i(WD_o),
    .clk_i(sysclk),
    .WE_i(WE_o),
  
    .RD_o(perek_rd),
    .sw_i(sw_i)
    );
    
    wire [31:0] svet_rd;
    
    led_sb_ctrl svet(
      .clk_i(sysclk),
      .addr_i(new_data_addr),
      .req_i(mem_req_o & one_hot[2]),
      .WD_i(WD_o),
      .WE_i(WE_o),
      .RD_o(svet_rd),
    
      .led_o(led_o)
    );
    
    always @ (*) begin
        case(data_addr_o[31:24])
        8'd0 : RD_i <=  data_rd;
        8'd1 : RD_i <=  perek_rd;
        8'd2 : RD_i <=  svet_rd; 
        default: RD_i <= 32'hZZZZZZZZ;
        endcase
    end

endmodule
