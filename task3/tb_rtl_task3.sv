`timescale 1ps / 1ps;
module tb_rtl_task3();
    logic CLOCK_50;
    logic [3:0] KEY;
    logic [9:0] SW;
        logic [6:0] HEX0;
    logic [6:0] HEX1;
    logic [6:0] HEX2;
        logic [6:0] HEX3;
    logic [6:0] HEX4;
    logic [6:0] HEX5;
        logic [9:0] LEDR;
    task3 dut (.*);
    initial begin
        CLOCK_50 = 0;
            forever #5 CLOCK_50 = ~CLOCK_50; 
    end
    initial begin 
        #10;
            KEY[3] = 0; // Activate reset
            #10;
            KEY[3] = 1; // Deactivate reset
            #10;
        $readmemh("test2.memh", dut.ct.altsyncram_component.m_default.altsyncram_inst.mem_data);
        #100000;
        $stop;
    end

endmodule: tb_rtl_task3