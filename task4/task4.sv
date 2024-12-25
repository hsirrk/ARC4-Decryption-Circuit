module task4(input logic CLOCK_50, input logic [3:0] KEY, input logic [9:0] SW,
             output logic [6:0] HEX0, output logic [6:0] HEX1, output logic [6:0] HEX2,
             output logic [6:0] HEX3, output logic [6:0] HEX4, output logic [6:0] HEX5,
             output logic [9:0] LEDR);


    // Internal signals
    logic [23:0] found_key;
    logic key_valid, crack_rdy;
    logic [7:0] ct_addr, ct_rddata;

    // Clock and reset
    assign reset_n = KEY[0];
    assign LEDR[0] = key_valid;    // Light up LED if key is found
    assign LEDR[1] = crack_rdy;    // Light up LED when `crack` is done

    // Instantiate crack module
    crack c(.clk(CLOCK_50), 
            .rst_n(reset_n), 
            .en(SW[0]),           // Enable cracking with SW[0]
            .rdy(crack_rdy), 
            .key(found_key), 
            .key_valid(key_valid), 
            .ct_addr(ct_addr), 
            .ct_rddata(ct_rddata));

    // Instantiate ciphertext memory (ct_mem)
    ct_mem ct(.address(ct_addr),
              .clock(CLOCK_50),
              .data(ct_rddata),
              .wren(1'b0),        // No write to ciphertext memory
              .q(ct_rddata));

    // Display the found key on HEX displays if key is valid
    always_comb begin
        if (key_valid) begin
            HEX5 = display_hex(found_key[23:20]);
            HEX4 = display_hex(found_key[19:16]);
            HEX3 = display_hex(found_key[15:12]);
            HEX2 = display_hex(found_key[11:8]);
            HEX1 = display_hex(found_key[7:4]);
            HEX0 = display_hex(found_key[3:0]);
        end else begin
            HEX5 = 7'b1111111;
            HEX4 = 7'b1111111;
            HEX3 = 7'b1111111;
            HEX2 = 7'b1111111;
            HEX1 = 7'b1111111;
            HEX0 = 7'b1111111;
        end
    end

    // Function to convert 4-bit value to 7-segment display encoding
    function logic [6:0] display_hex(input logic [3:0] digit);
        case (digit)
            4'h0: display_hex = 7'b1000000;
            4'h1: display_hex = 7'b1111001;
            4'h2: display_hex = 7'b0100100;
            4'h3: display_hex = 7'b0110000;
            4'h4: display_hex = 7'b0011001;
            4'h5: display_hex = 7'b0010010;
            4'h6: display_hex = 7'b0000010;
            4'h7: display_hex = 7'b1111000;
            4'h8: display_hex = 7'b0000000;
            4'h9: display_hex = 7'b0010000;
            4'hA: display_hex = 7'b0001000;
            4'hB: display_hex = 7'b0000011;
            4'hC: display_hex = 7'b1000110;
            4'hD: display_hex = 7'b0100001;
            4'hE: display_hex = 7'b0000110;
            4'hF: display_hex = 7'b0001110;
            default: display_hex = 7'b1111111;
        endcase
    endfunction


endmodule: task4
