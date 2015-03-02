module reg_16 (input Clk, Reset, Load,
              input  [15:0]  D,
              output logic [15:0]  Data_Out);

    always_ff @ (posedge Clk or posedge Reset)
    begin
	 
    if (Reset) 
        Data_Out <= 16'h0000;
	 else if (Load)
        Data_Out <= D;
    end
	

endmodule
