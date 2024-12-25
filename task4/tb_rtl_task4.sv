`timescale 1ps / 1ps

module tb_rtl_task4();
	logic CLOCK_50 = 1'b1;
	logic [3:0] KEY;
	logic [9:0] SW;
   logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
   logic [9:0] LEDR;
	
	//logic [7:0] mem [0:36];

// Your testbench goes here.
	task4 dut(.*);
	
	always #5 CLOCK_50 = ~CLOCK_50;
	
	initial begin
		#10;
		$readmemh("test1.memh", dut.ct.altsyncram_component.m_default.altsyncram_inst.mem_data);
		//$readmemh("test2.memh", mem);
		
		#5;
		SW = 10'h018;
		KEY[3] = 1'b1;
		#10;
		KEY[3] = 1'b0;
		#10;
		KEY[3] = 1'b1;
		
		//wait(dut.a4.state == dut.a4.WAIT_INIT);
		//wait(dut.a4.INIT_rdy == 1'b1);
		//$stop;
		
		//wait(dut.c.a4.KSA_en == 1'b1);
		//$stop;
		
		//wait(dut.c.a4.PRGA_en == 1'b1);
		//$stop;
		
		//wait(dut.c.a4.state == dut.c.a4.FINISH);
		//$stop;
		
		wait(dut.state == dut.FINISH);
		
		#100;
		
		$stop;
		
	end


endmodule: tb_rtl_task4