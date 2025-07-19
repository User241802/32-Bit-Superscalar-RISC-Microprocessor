`timescale 1ns / 1ps

module imm_data(
    input [31:0] instruction,
    output reg [31:0] imm_data
);

  always @(*)
    begin
      case (instruction[6:5])
        2'b00: // I-type/Load
          begin
            imm_data = {{20{instruction[31]}}, instruction[31:20]}; 
          end
        2'b01: // S-type
          begin
            imm_data = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]}; 
          end
        2'b11: // B-type
          begin
            imm_data = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]}; 
          end
        2'b10: // not used values
          begin
            imm_data = 32'b0; 
          end
        default:
          begin
            imm_data = 32'b0; 
          end
      endcase
    end  

endmodule
