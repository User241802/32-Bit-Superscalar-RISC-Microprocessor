`timescale 1ns / 1ps

module eight_by_one_mux(input [31:0] a,
                        input [31:0] b,
                        input [31:0] c,
                        input [31:0] d,
                        input [31:0] e,
                        input [31:0] f,
                        input [31:0] g,
                        
                        input [2:0] s,
                        
                        output reg [31:0] o
                        );
                        
always @ (*)
 begin
  case (s)
   3'b000: o=a;
   3'b001: o=b;
   3'b010: o=c;
   3'b011: o=d;
   3'b100: o=e;
   3'b101: o=f;
   3'b110: o=g;
  default: o=32'b0;
  endcase

 end
endmodule
