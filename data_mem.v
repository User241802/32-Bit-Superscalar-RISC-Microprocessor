`timescale 1ns / 1ps

module data_mem(
  input [31:0] write_data_1,
  input [31:0] address_1, // Changed to 32-bit
  input memwrite_1, 
  input clk,
  input memread_1,
  output reg [31:0] read_data_1,

  input [31:0] write_data_2,
  input [31:0] address_2, // Changed to 32-bit
  input memwrite_2, 
  input memread_2,
  output reg [31:0] read_data_2
);

  reg [31:0] mem [0:255]; // Memory array, 256 rows of 32-bit data

  // Read Data Logic for both datapaths
  always @(posedge clk) begin

    // Handle reads with priority for writes
    if (memread_1) begin
      
        // Otherwise read from memory
        read_data_1 <= mem[address_1[7:0]]; // Use lower 8 bits of the address
     
    end
    
    if (memread_2) begin
    
        read_data_2 <= mem[address_2[7:0]]; // Use lower 8 bits of the address
    end
  end

  // Write Data Logic for both datapaths
  always @(posedge clk) begin
    // Handle writes
    if (memwrite_1) begin
      mem[address_1[7:0]] <= write_data_1; // Use lower 8 bits of the address
    end
    
    if (memwrite_2) begin
      mem[address_2[7:0]] <= write_data_2; // Use lower 8 bits of the address
    end
  end
//  integer i;
//  integer file; // File handle for writing

//  // Initialize memory
//  initial begin
//    for (i = 0; i < 256; i = i + 1) begin
//      mem[i] = i;
//    end

//    // Open a file for writing
//    file = $fopen("datamemory.txt", "w");
//    if (file == 0) begin
//      $display("Error: Could not open file for writing.");
//      $finish;
//    end
//  end

//  // Write memory contents to file at the end of simulation
//  initial begin
//    #1000; 
//    for (i = 0; i < 256; i = i + 1) begin
//      $fdisplay(file, "mem[%0d] = %0d", i, mem[i]);
//    end
//    $fclose(file);
//    $finish; 
//  end

endmodule
