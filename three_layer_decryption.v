module three_layer_decryption(
    input [7:0] encrypted_data,
    input wire clk,
    input wire rst_n,
    output wire [7:0] decrypted_data
);

reg [7:0] inverted_bits;
reg [7:0] grey_code;
reg [7:0] circular_shifted;

// First layer: Inverting all the bits
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        inverted_bits <= 8'b00000000; // Reset to zero on active-low reset
    end else begin
        inverted_bits <= ~encrypted_data;
    end
end

// Second layer: Conversion from Grey code
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        grey_code <= 8'b00000000; // Reset to zero on active-low reset
    end else begin
        grey_code[0] <= inverted_bits[0];
        grey_code[1] <= inverted_bits[1] ^ grey_code[0];
        grey_code[2] <= inverted_bits[2] ^ grey_code[1];
        grey_code[3] <= inverted_bits[3] ^ grey_code[2];
        grey_code[4] <= inverted_bits[4] ^ grey_code[3];
        grey_code[5] <= inverted_bits[5] ^ grey_code[4];
        grey_code[6] <= inverted_bits[6] ^ grey_code[5];
        grey_code[7] <= inverted_bits[7] ^ grey_code[6];
    end
end

// Third layer: Circular right shift
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        circular_shifted <= 8'b00000000; // Reset to zero on active-low reset
    end else begin
        circular_shifted <= {grey_code[0], grey_code[7:1]}; // Right circular shift
    end
end

// Output the result of the three layers
assign decrypted_data = circular_shifted;

endmodule

