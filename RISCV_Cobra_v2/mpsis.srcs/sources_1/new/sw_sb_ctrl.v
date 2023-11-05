module sw_sb_ctrl(
  input [31:0]  addr_i,
  input         req_i,
  
  input [31:0]  WD_i, // \
  input         clk_i,//  - эти сигналы не используются и добавлены для совместимости с системной шиной
  input         WE_i, // /
  
  output [31:0] RD_o,
  input [15:0]  sw_i
    );
    wire flag;
    assign flag = (addr_i == 32'd0) & (req_i == 1'b1);
    assign RD_o = flag ? {16'd0, sw_i} : 32'hZZZZZZZZ;
    
endmodule
