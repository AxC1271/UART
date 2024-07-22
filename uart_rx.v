module uart_rx (
    input clk,
    input reset,
    input rx,
    output reg [7:0] data,
    output reg valid
);

    reg [9:0] shift_reg; // Including start, data, and stop bits
    reg [3:0] bit_index;
    reg [15:0] baud_counter;
    reg sample;
    parameter BAUD_COUNT = 9600; // Example for 9600 baud with 50 MHz clock

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shift_reg <= 10'b1111111111;
            bit_index <= 0;
            baud_counter <= 0;
            valid <= 0;
            sample <= 0;
        end else begin
            if (baud_counter == BAUD_COUNT) begin
                baud_counter <= 0;
                sample <= ~sample;
                if (sample) begin
                    shift_reg <= {rx, shift_reg[9:1]};
                    bit_index <= bit_index + 1;
                    if (bit_index == 9) begin
                        data <= shift_reg[8:1];
                        valid <= 1;
                        bit_index <= 0;
                    end else begin
                        valid <= 0;
                    end
                end
            end else begin
                baud_counter <= baud_counter + 1;
            end
        end
    end
endmodule


