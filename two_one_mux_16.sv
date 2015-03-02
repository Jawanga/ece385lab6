module two_one_mux_16(input 	[15:0] 	x, y,
					input			select,
					output	[15:0] 	out);
					reg [15:0] outp;
		always @ (select or x or y)
		begin: MUX
			case(select)
				1'b0 : outp = x;
				1'b1 : outp = y;
			endcase
		end
		assign out = outp;
endmodule
