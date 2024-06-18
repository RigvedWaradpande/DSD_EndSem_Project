`timescale 1ns/1ns
`include "three_layer_encryption.v"
`include "three_layer_decryption.v"

module three_layer_encryption_decryption_tb;

reg clk;
reg rst_n;
reg [7:0] in_data;
reg select;

wire [7:0] encrypted_data;
wire [7:0] decrypted_data;

// Instantiate encryption and decryption modules
three_layer_encryption u_encryptor (
    in_data,
    clk,
    rst_n,
    encrypted_data
);

three_layer_decryption u_decryptor (
    encrypted_data,
    clk,
    rst_n,
    decrypted_data
);

// Clock generation
initial begin
    $dumpfile("waveforms.vcd");
    $dumpvars(0, three_layer_encryption_decryption_tb.u_encryptor, three_layer_encryption_decryption_tb.u_decryptor);

    clk = 0;
    forever #5 clk = ~clk;
end

// Stimulus generation
initial begin
    rst_n = 0;
    in_data = 8'b11000101;
    select = 0;

    // Apply reset and wait for a few cycles
    #10 rst_n = 1;

    // Perform encryption and decryption with select input control
    #50 select = 0; // Display encrypted waveform only
    #100 select = 1; // Display both encrypted and decrypted waveforms
    #50 $finish;
end

// Multiplexer to select waveform for display
always @(posedge clk) begin
    if (select == 0) begin
        $display("Encrypted Data: %b", encrypted_data);
    end else begin
        $display("Encrypted Data: %b, Decrypted Data: %b", encrypted_data, decrypted_data);
    end
end

endmodule

