module uart_tx (
    input clk,
    input reset,
    input [7:0] data,
    input start,
    output reg tx,
    output reg busy
);

    reg [9:0] shift_reg; // Including start, data, and stop bits
    reg [3:0] bit_index;
    reg [15:0] baud_counter;
    parameter BAUD_COUNT = 9600; // Example for 9600 baud with 50 MHz clock

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            tx <= 1;
            busy <= 0;
            bit_index <= 0;
            baud_counter <= 0;
            shift_reg <= 10'b1111111111; // Idle state with stop bits
        end else begin
            if (start && !busy) begin
                busy <= 1;
                shift_reg <= {1'b1, data, 1'b0}; // Start bit, data, stop bit
                bit_index <= 0;
            end else if (busy) begin
                if (baud_counter == BAUD_COUNT) begin
                    baud_counter <= 0;
                    tx <= shift_reg[0];
                    shift_reg <= shift_reg >> 1;
                    bit_index <= bit_index + 1;
                    if (bit_index == 9) begin
                        busy <= 0;
                    end
                end else begin
                    baud_counter <= baud_counter + 1;
                end
            end
        end
    end
endmodule


