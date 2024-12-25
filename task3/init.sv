module init(input logic clk, input logic rst_n,
            input logic en, output logic rdy,
            output logic [7:0] addr, output logic [7:0] wrdata, output logic wren);

// your code here
    enum {WAIT, LOOP} state;
    logic [7:0] i;

    always_ff @(posedge clk) begin
        if (~rst_n) begin
            state <= WAIT;
            rdy <= 1'b0;
            i <= 8'd0;
            addr <= 8'd0;
            wrdata <= 8'd0;
            wren <= 1'b0;
        end
        else begin
            case (state)
                WAIT: begin
                            if (en) begin
                                state <= LOOP;
                                rdy <= 1'b0;
                                i <= 8'd0;
                            end
                            else begin
                                state <= WAIT;
                                rdy <= 1'b1;
                            end
                        end
                LOOP: begin
                            if (i == 8'd255) begin
                                state <= WAIT;
                                rdy <= 1'b1;
                                wren <= 1'b0;
                            end
                            else begin
                                addr <= i;
                                wren <= 1'b1;
                                wrdata <= i;
                                i <= i + 8'b1;
                                state <= LOOP;
                            end
                        end
                default: state <= state;
            endcase
        end

    end

endmodule: init
