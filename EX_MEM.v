`timescale 1ns / 1ps
module EX_MEM(
  input clk,
  input reset,
  input [31:0] Result_in_alu_1,  // Changed to 32-bit
  input [31:0] Result_in_alu_2,  // Changed to 32-bit
  input [31:0] writedata_in_1,   // Changed to 32-bit
  input [31:0] writedata_in_2,   // Changed to 32-bit
  input [4:0] Rd_in_1,           // 5-bit, remains unchanged
  input [4:0] Rd_in_2,           // 5-bit, remains unchanged
  input memread_in1,
  input memtoreg_in1,
  input memwrite_in1,
  input regwrite_in1,
  input memread_in2,
  input memtoreg_in2,
  input memwrite_in2,
  input regwrite_in2,

  output reg [31:0] result_out_alu_1,  // Changed to 32-bit
  output reg [31:0] writedata_out_1,   // Changed to 32-bit
  output reg [4:0] rd_1,               // 5-bit, remains unchanged
  output reg Memread1,
  output reg Memtoreg1,
  output reg Memwrite1,
  output reg Regwrite1,
  output reg [31:0] result_out_alu_2,  // Changed to 32-bit
  output reg [31:0] writedata_out_2,   // Changed to 32-bit
  output reg [4:0] rd_2,               // 5-bit, remains unchanged
  output reg Memread2,
  output reg Memtoreg2,
  output reg Memwrite2,
  output reg Regwrite2
);

  always @ (posedge clk) begin
    if (reset == 1'b1) begin
      result_out_alu_1 <= 32'b0;        // 32-bit reset
      writedata_out_1 <= 32'b0;         // 32-bit reset
      rd_1 <= 5'b0;                     // 5-bit reset

      Memread1 <= 1'b0;
      Memtoreg1 <= 1'b0;
      Memwrite1 <= 1'b0;
      Regwrite1 <= 1'b0;
      
      result_out_alu_2 <= 32'b0;        // 32-bit reset
      writedata_out_2 <= 32'b0;         // 32-bit reset
      rd_2 <= 5'b0;                     // 5-bit reset

      Memread2 <= 1'b0;
      Memtoreg2 <= 1'b0;
      Memwrite2 <= 1'b0;
      Regwrite2 <= 1'b0;
    end else begin
      result_out_alu_1 <= Result_in_alu_1;  // 32-bit
      writedata_out_1 <= writedata_in_1;    // 32-bit
      rd_1 <= Rd_in_1;                      // 5-bit
      Memread1 <= memread_in1;
      Memtoreg1 <= memtoreg_in1;
      Memwrite1 <= memwrite_in1;
      Regwrite1 <= regwrite_in1;
      
      result_out_alu_2 <= Result_in_alu_2;  // 32-bit
      writedata_out_2 <= writedata_in_2;    // 32-bit
      rd_2 <= Rd_in_2;                      // 5-bit
      Memread2 <= memread_in2;
      Memtoreg2 <= memtoreg_in2;
      Memwrite2 <= memwrite_in2;
      Regwrite2 <= regwrite_in2;
    end
  end
endmodule
