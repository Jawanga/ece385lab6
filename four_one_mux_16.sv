module four_one_mux_16(input 	[15:0] 	w, x, y, z,
					input		[1:0]	select,
					output	[15:0] 	out);
					reg [15:0] outp;
		always_comb
		begin: MUX
			case(select)
				2'b00 : outp = w;
				2'b01 : outp = x;
				2'b10 : outp = y;
				2'b11 : outp = z;
			endcase
		end
		assign out = outp;
endmodule
