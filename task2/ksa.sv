module ksa(input logic clk, input logic rst_n,
           input logic en, output logic rdy,
           input logic [23:0] key,
           output logic [7:0] addr, input logic [7:0] rddata, output logic [7:0] wrdata, output logic wren);

    // Local variables
    logic [7:0] i;
    logic [7:0] j;
    logic [7:0] keyval;
    logic [7:0] temp1;
    logic [7:0] temp2;

    typedef enum logic [2:0] {IDLE, FIND_S, STALL_S, CALC_J, FIND_J, WRITE_I, STALL_W_I} state_t;
    state_t ps;

    // Default keyval assignment to avoid latches
    always_comb begin
        case (i % 3)
            8'd0: keyval = key[23:16];
            8'd1: keyval = key[15:8];
            8'd2: keyval = key[7:0];
            default: keyval = 8'b0; // Default case
        endcase
    end

    // State machine with sequential logic
    always_ff @(posedge clk) begin
        if (!rst_n) begin
            // Reset logic
            i <= 0;
            j <= 0;
            temp1 <= 0;
            temp2 <= 0;
            rdy <= 1;
            addr <= 0;
            wrdata <= 0;
            wren <= 0;
            ps <= IDLE;
        end else begin
            case (ps)
                IDLE: begin
                    // Wait for enable signal
                    if (en) begin
                        i <= 0;
                        j <= 0;
                        temp1 <= 0;
                        temp2 <= 0;
                        addr <= 0;
                        wrdata <= 0;
                        wren <= 0;
                        rdy <= 0;
                        ps <= FIND_S;
                    end
                end

                FIND_S: begin
                    // Read address s[i]
                    addr <= i;
                    wren <= 0; // Ensure no write enable
                    ps <= STALL_S;
                end

                STALL_S: begin
                    // Wait one cycle to fetch s[i]
                    temp1 <= rddata; // Store s[i]
                    ps <= CALC_J;
                end

                CALC_J: begin
                    // Calculate j and prepare to access s[j]
                    j <= (j + temp1 + keyval) % 256;
                    addr <= j;
                    temp2 <= rddata;
                    ps <= FIND_J;
                end

                FIND_J: begin
                    // Write s[i] to s[j]
                    addr <= j;
                    wrdata <= temp1; // Store s[i] into s[j]
                    wren <= 1;       // Enable write
                    ps <= WRITE_I;
                end

                WRITE_I: begin
                    // Write s[j] back to s[i]
                    addr <= i;
                    wrdata <= temp2; // Write s[j] to s[i]
                    wren <= 1;       // Enable write
                    ps <= STALL_W_I;
                end

                STALL_W_I: begin
                    // Increment i and check if done
                    wren <= 0; // Disable write
                    i <= i + 1;
                    if (i == 8'd255) begin
                        ps <= IDLE;
                    end else begin
                        ps <= FIND_S; // Loop again
                    end
                end

                default: ps <= IDLE; // Safe fallback state
            endcase
        end
    end
endmodule
