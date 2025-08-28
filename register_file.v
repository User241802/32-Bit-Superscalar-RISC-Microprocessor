`timescale 1ns / 1ps

module registerFile(
    input clk,
    input reset,
    // First set of inputs
    input [4:0] rs1_1,
    input [4:0] rs2_1,
    input [4:0] rd_1,
    input [31:0] writedata_1,
    input reg_write_1,
    output reg [31:0] readdata1_1,
    output reg [31:0] readdata2_1,
    output reg [4:0] rd_out_1,
    output reg [31:0] writedata_out_1,
    output reg reg_write_out_1,
    // Second set of inputs
    input [4:0] rs1_2,
    input [4:0] rs2_2,
    input [4:0] rd_2,
    input [31:0] writedata_2,
    input reg_write_2,
    output reg [31:0] readdata1_2,
    output reg [31:0] readdata2_2,
    output reg [4:0] rd_out_2,
    output reg [31:0] writedata_out_2,
    output reg reg_write_out_2
);
    reg [31:0] registers [0:31];
    
    integer i;

    // Read Data Logic
    always @(*) begin
        if (reset) begin
            readdata1_1 = 32'd0;
            readdata2_1 = 32'd0;
            readdata1_2 = 32'd0;
            readdata2_2 = 32'd0;
        end else begin
            readdata1_1 = registers[rs1_1];
            readdata2_1 = registers[rs2_1];
            readdata1_2 = registers[rs1_2];
            readdata2_2 = registers[rs2_2];
        end
    end

    // Write Data Logic
    always @(posedge clk) begin
        if (reset) begin
            // Reset registers to default state if reset is asserted
            for (i = 1; i < 32; i = i + 1) begin
                registers[i] <= 32'd0;  // Set to 32-bit width
            end
            rd_out_1 <= 5'd0;
            writedata_out_1 <= 32'd0;
            reg_write_out_1 <= 1'b0;
            rd_out_2 <= 5'd0;
            writedata_out_2 <= 32'd0;
            reg_write_out_2 <= 1'b0;
        end else begin
            // Write handling with priority to the second write
            if (reg_write_2 && rd_2 != 0) begin
                registers[rd_2] <= writedata_2;
                rd_out_2 <= rd_2;
                writedata_out_2 <= writedata_2;
                reg_write_out_2 <= reg_write_2;
            end
            if (reg_write_1 && rd_1 != 0 && rd_1 != rd_2) begin
                registers[rd_1] <= writedata_1;
                rd_out_1 <= rd_1;
                writedata_out_1 <= writedata_1;
                reg_write_out_1 <= reg_write_1;
            end
        end
    end

endmodule
