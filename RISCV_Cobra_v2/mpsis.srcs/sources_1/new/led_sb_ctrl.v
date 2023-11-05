module led_sb_ctrl(
  input         clk_i,
  input [31:0]  addr_i,
  input         req_i,
  input [31:0]  WD_i,
  input         WE_i,
  output reg [31:0] RD_o,

  output reg [15:0]  led_o
);

    reg [15:0]  led_val;
    reg         led_mode;
    
    
    reg [31:0] counter;
    reg counter_less;
   
    
    reg morganie;
    reg [31:0] counter_second;
    
    always @ (posedge clk_i) begin //0x24
        if ((addr_i == 32'h24) & (WE_i == 1) & (WD_i == 32'b1)) begin
            led_val <= 16'b0;
            led_mode <= 1'b0;
            counter <= 32'b0;
            counter_less <= 1'b0;
            counter_second <= 32'b0;
            morganie <= 1'b0;
        end
    end
    
    always @ (*) begin //RD_o
       case(addr_i)
        32'h0:
            if (WE_i == 0) begin
                RD_o <= {16'd0, led_val};
            end
        32'h4:
            if (WE_i == 0) begin
                RD_o <= {31'd0, led_mode};
            end
        default:
            RD_o <= 32'hZZZZZZZZ;
        endcase
    end
    
    always @ (posedge clk_i) begin //0x00
        if (addr_i == 32'h0) begin
            if (WE_i == 1) begin
                if (WD_i < 32'd65535) begin
                    led_val <= WD_i;
                end
            end
            //else begin
            //    led_o_future <= led_val;
            //end
        end
    end
    
    always @ (posedge clk_i) begin //0x04
        if (addr_i == 32'h4) begin
            if (WE_i == 1) begin
                if ((WD_i == 32'b1) | (WD_i == 32'b0)) begin
                    led_mode <= WD_i;
                end
            end
            //else begin
            //    led_mode_future <= led_mode;
            //end
        end
    end
    
    
    always @ (clk_i) begin
        counter_less <= counter < 32'd999999;
        counter <= counter_less? counter + 1'b1 : 32'd0;
        if (led_mode == 1'b1) begin 
            if (morganie != 1'b1) begin
                morganie <= 1'b1;
                counter_second <= counter;
            end
            else begin
                if (counter == counter_second) begin
                    morganie <= 1'b0;
                end
            end  
        end
        if (led_mode)
            led_o = morganie? led_val : 16'b0;
        else
            led_o = led_val;
    end

endmodule
