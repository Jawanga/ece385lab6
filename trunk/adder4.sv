module ADDER4 (input 	[3:0] A, B,
					input 			c_in,
					output 	[3:0] S,
					output 			c_out);
logic c1, c2, c3;

full_adder FA0(.x(A[0]), .y(B[0]), .z(c_in), .s(S[0]), .c(c1));
full_adder FA1(.x(A[1]), .y(B[1]), .z(c1), .s(S[1]), .c(c2));
full_adder FA2(.x(A[2]), .y(B[2]), .z(c2), .s(S[2]), .c(c3));
full_adder FA3(.x(A[3]), .y(B[3]), .z(c3), .s(S[3]), .c(c_out));

endmodule
