module init(input logic clk, input logic rst_n,
            input logic en, output logic rdy,
            output logic [7:0] addr, output logic [7:0] wrdata, output logic wren);


    typedef enum logic [1:0] {IDLE, START} state_t;
    state_t ps;  // Current state (ps) and next state (ns)
    logic [7:0] counter;

    // Sequential block: State transition, register updates, and output logic
    always_ff @(posedge clk) begin
        if (!rst_n) begin
            ps <= IDLE;       // Reset state to IDLE
            counter <= 8'b0;  
        end else begin
            case (ps)
                IDLE: begin
                    if (en == 1) begin
                        counter <= 8'b0;
                        ps <= START;       // Transition to START if enabled
                    end else begin
                        ps <= IDLE;
                    end
                end

                START: begin
                    if (addr == 8'd255) begin
                        ps <= IDLE;        // Transition to IDLE if addr reaches 255
                    end else begin
                        counter <= counter + 1;      // Increment address
                        ps <= START;
                    end
                end
            endcase
        end
    end


    // Combinational block: Next state logic and outputs
    always_comb begin
        // Default values
        addr = counter;    
        wrdata = counter;  
        rdy = 1'b1;   
        wren = 1'b0;   

        case (ps)
            IDLE: begin 
                rdy = 1'b1;   
                wren = 1'b0; 
                addr = counter;    
                wrdata = counter; 
            end

            START: begin 
                rdy = 1'b0;   
                wren = 1'b1; 
                addr = counter;    
                wrdata = counter; 
                    end
        endcase
    end
endmodule: init
