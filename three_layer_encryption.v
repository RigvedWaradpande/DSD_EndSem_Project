module three_layer_encryption(
    input [7:0] in_data,
    input wire clk,
    input wire rst_n,
    output reg [7:0] encrypted_data
);

reg [7:0] circular_shifted;
reg [7:0] grey_code;
reg [7:0] inverted_bits;

// First layer: Circular right shift
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        circular_shifted <= 8'b00000000; // Reset to zero on active-low reset
    end else begin
        circular_shifted <= {in_data[0], in_data[7:1]}; // Right circular shift
    end
end

// Second layer: Conversion to Grey code
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        grey_code <= 8'b00000000; // Reset to zero on active-low reset
    end else begin
        grey_code[0] <= circular_shifted[0];
        grey_code[1] <= circular_shifted[1] ^ circular_shifted[0];
        grey_code[2] <= circular_shifted[2] ^ circular_shifted[1];
        grey_code[3] <= circular_shifted[3] ^ circular_shifted[2];
        grey_code[4] <= circular_shifted[4] ^ circular_shifted[3];
        grey_code[5] <= circular_shifted[5] ^ circular_shifted[4];
        grey_code[6] <= circular_shifted[6] ^ circular_shifted[5];
        grey_code[7] <= circular_shifted[7] ^ circular_shifted[6];
    end
end

// Third layer: Inverting all the bits
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        inverted_bits <= 8'b00000000; // Reset to zero on active-low reset
    end else begin
        inverted_bits <= ~grey_code;
    end
end

// Output the result of the three layers
always @* begin
    encrypted_data = inverted_bits;
end

endmodule

