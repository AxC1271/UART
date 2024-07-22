module uart_tb;
    reg clk;
    reg reset;
    reg [7:0] data_in;
    reg start;
    wire tx;
    wire [7:0] data_out;
    wire valid;
    wire busy;

    uart_tx uart_transmitter (
        .clk(clk),
        .reset(reset),
        .data(data_in),
        .start(start),
        .tx(tx),
        .busy(busy)
    );

    uart_rx uart_receiver (
        .clk(clk),
        .reset(reset),
        .rx(tx),
        .data(data_out),
        .valid(valid)
    );

    initial begin
        $dumpfile("uart_tb.vcd");
        $dumpvars(0, uart_tb);
        clk = 0;
        reset = 1;
        data_in = 8'b10101010;
        start = 0;
        #100 reset = 0;
        #100 start = 1;
        #100 start = 0;  // Increased time for start signal

        #2000000; // Increased wait time
        $stop;
    end

    always #10 clk = ~clk; // 50 MHz clock

    // Debugging outputs
    always @(posedge clk) begin
        $display("Time: %t | tx: %b, busy: %b, data_in: %b, data_out: %b, valid: %b", $time, tx, busy, data_in, data_out, valid);
        $display("Time: %t | tx shift_reg: %b, bit_index: %d", $time, uart_transmitter.shift_reg, uart_transmitter.bit_index);
        $display("Time: %t | rx shift_reg: %b, bit_index: %d", $time, uart_receiver.shift_reg, uart_receiver.bit_index);
    end
endmodule



