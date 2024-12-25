module task1(input logic CLOCK_50, input logic [3:0] KEY, input logic [9:0] SW,
             output logic [6:0] HEX0, output logic [6:0] HEX1, output logic [6:0] HEX2,
             output logic [6:0] HEX3, output logic [6:0] HEX4, output logic [6:0] HEX5,
             output logic [9:0] LEDR);



    logic [7:0] address;
    logic [7:0] wrdata;


    logic en;
    logic rdy;
    logic wren;

    logic [7:0] q;


    init i(	.clk(CLOCK_50),
        .rst_n(KEY[3]),
        .en, 
        .rdy,
        .addr(address),
        .wrdata, 
        .wren);

    s_mem s(	.address,
        .clock(CLOCK_50),
        .data(wrdata),
        .wren,
        .q);


    always_ff @(posedge CLOCK_50) begin

        if (~KEY[3] && rdy ==1) begin
            en <= 1;
        end else begin
            en <= 0;
        end


end


endmodule: task1
