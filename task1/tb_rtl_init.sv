`timescale 1ps / 1ps;
module tb_rtl_init();
    logic clk;
    logic rst_n;
        logic en;
    logic rdy;
        logic [7:0] addr;
    logic [7:0] wrdata;
    logic wren;
    init dut (.*);

    initial begin
        clk = 0;
            forever #5 clk = ~clk; 
    end
    initial begin 
        #10;
            rst_n = 0; // Activate reset
            #10;
            rst_n = 1; // Deactivate reset
            #10;
        en=1'b0;
        #10;
        en=1'b1;
        #10000;
        $stop;
    end


endmodule: tb_rtl_init