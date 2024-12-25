module crack(input logic clk, input logic rst_n,
             input logic en, output logic rdy,
             output logic [23:0] key, output logic key_valid,
             output logic [7:0] ct_addr, input logic [7:0] ct_rddata);

    typedef enum logic [2:0] {
        IDLE,
        CHECK_BYTE,
        NEXT_BYTE,
        SUCCESS,
        FAILURE
    } state_t;

    state_t state, next_state;

    // Internal signals
    logic [23:0] current_key;
    logic [7:0] pt_addr_internal, pt_rddata, pt_wrdata;
    logic pt_wren, arc4_rdy, pt_readable;
    logic en_a4;
    logic [7:0] byte_count;
    logic byte_valid;

    // Mux control signal to select `pt_addr` source
    logic use_arc4_addr;

    // ASCII readable range constants
    localparam logic [7:0] ASCII_MIN = 8'h20;
    localparam logic [7:0] ASCII_MAX = 8'h7E;

    assign rdy = arc4_rdy;
    assign key = current_key;

    // `pt_addr` output is determined by the state
    assign ct_addr = (use_arc4_addr) ? arc4_pt_addr : pt_addr_internal;

    // Increment key if arc4 is ready and enabled
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            current_key <= 24'h000000;
        else if (arc4_rdy && en)
            current_key <= current_key + 1;
    end

    // State transition logic
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end
always_comb begin
    use_arc4_addr = 1'b0;
    case (state)
        IDLE: 
            if (en && arc4_rdy) 
                next_state = CHECK_BYTE;
            else 
                next_state = IDLE;

        CHECK_BYTE: begin
            use_arc4_addr = 1'b1;  // Use arc4 address for checking bytes
            if (!byte_valid) 
                next_state = FAILURE;
            else if (byte_count >= ct_rddata) 
                next_state = SUCCESS;
            else 
                next_state = NEXT_BYTE;
        end

        NEXT_BYTE: begin
            use_arc4_addr = 1'b0;  // Use pt_addr_internal for the next byte
            next_state = CHECK_BYTE;
        end

        SUCCESS: 
            next_state = IDLE;

        FAILURE: 
            next_state = IDLE;

        default: 
            next_state = IDLE;
    endcase
end


    // Output logic and byte count control
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pt_readable <= 1'b0;
            key_valid <= 1'b0;
            byte_count <= 8'h00;
            pt_addr_internal <= 8'h00;
        end else begin
            case (state)
                IDLE: begin
                    pt_readable <= 1'b0;
                    key_valid <= 1'b0;
                    byte_count <= 8'h00;
                    pt_addr_internal <= 8'h00;
                end

                CHECK_BYTE: begin
                    if (ct_rddata >= ASCII_MIN && ct_rddata <= ASCII_MAX) begin
                        pt_addr_internal <= pt_addr_internal + 1;
                        byte_count <= byte_count + 1;
                    end
                end

                NEXT_BYTE: begin
                    pt_addr_internal <= pt_addr_internal + 1;
                end

                SUCCESS: begin
                    pt_readable <= 1'b1;
                    key_valid <= 1'b1;
                end

                FAILURE: begin
                    pt_readable <= 1'b0;
                    key_valid <= 1'b0;
                end
            endcase
        end
    end

    // Instantiate arc4 for decryption
    arc4 a4(
        .clk(clk),
        .rst_n(rst_n),
        .en(en_a4),
        .rdy(arc4_rdy),
        .key(current_key),
        .ct_addr(ct_addr),
        .ct_rddata(ct_rddata),
        .pt_addr(arc4_pt_addr),
        .pt_rddata(pt_rddata),
        .pt_wrdata(pt_wrdata), 
        .pt_wren(pt_wren)
    );

    // Instantiate pt_mem to hold decrypted plaintext
    pt_mem pt(
        .address(pt_addr_internal),
        .clock(clk),
        .data(pt_wrdata),
        .wren(pt_wren),
        .q(pt_rddata)
    );


endmodule: crack
