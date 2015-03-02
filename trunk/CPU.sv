module CPU (input logic		[15:0]	S,
				input							Clk, Reset, Run, Continue,
				output logic	[11:0]	LED,
				output logic				CE, UB, LB, OE, WE,
				output logic	[19:0]	ADDR,
				//output logic	[6:0]		HEX0, HEX1, HEX2, HEX3,
				inout wire		[15:0]	Data);
		
		logic					Reset_h, Continue_h, Run_h;
		logic					LD_MAR, LD_MDR, LD_IR, LD_BEN, LD_CC, LD_REG, LD_PC;
		logic		[1:0]		PCMUXselect;
		logic		[15:0]	PC_w, PC_x, PC_y;
		logic		[15:0]	PCd_in, PCd_out;
		logic		[15:0]	MDR_out;
		logic					GatePC, GateMDR, GateALU, GateMARMUX;
		logic		[15:0]	IR_out;
		logic		[2:0]	DR_out, SR1_out, SR2_out;
		
		//assign	PC_w = Data;
		
		always_comb
		begin
			  Reset_h = ~Reset;  // The push buttons are active low, but active-high logic is easier
			  Continue_h = ~Continue;  // to work with
			  Run_h = ~Run;

		end
		
		/*
		module ISDU ( 	input	Clk, 
                        Reset,
						Run,
						Continue,
						ContinueIR,
									
				input [3:0]  Opcode, 
				input        IR_5,
				  
				output logic 	LD_MAR,
								LD_MDR,
								LD_IR,
								LD_BEN,
								LD_CC,
								LD_REG,
								LD_PC,
									
				output logic 	GatePC,
								GateMDR,
								GateALU,
								GateMARMUX,
									
				output logic [1:0] 	PCMUX,
				                    DRMUX,
									SR1MUX,
				output logic 		SR2MUX,
									ADDR1MUX,
				output logic [1:0] 	ADDR2MUX,
				output logic 		MARMUX,
				  
				output logic [1:0] 	ALUK,
				  
				output logic 		Mem_CE,
									Mem_UB,
									Mem_LB,
									Mem_OE,
									Mem_WE
				)
		*/
		
		ISDU		isdu(.Clk, .Reset(Reset_h), .Run(Run_h), .Continue(), .ContinueIR(Continue_h), .Opcode(S[15:12]), .IR_5(S[4]), .LD_MAR, .LD_MDR, .LD_IR,
						  .LD_BEN, .LD_CC, .LD_REG, .LD_PC, .GatePC, .GateMDR, .GateALU, .GateMARMUX, .PCMUX(PCMUXselect), .DRMUX(), .SR1MUX(), .SR2MUX(), .ADDR1MUX(), .ADDR2MUX(),
						  .MARMUX(), .ALUK(), .Mem_CE(CE), .Mem_UB(UB), .Mem_LB(LB), .Mem_OE(OE), .Mem_WE(WE));
		/*
		module reg_16 (input Clk, Reset, Load,
              input  [15:0]  D,
              output logic [15:0]  Data_Out);
		*/
		
		reg_16		MAR(.Clk, .Reset(Reset_h), .Load(LD_MAR), .D(Data), .Data_Out(ADDR[15:0]));
		reg_16		MDR(.Clk, .Reset(Reset_h), .Load(LD_MDR), .D(Data), .Data_Out(MDR_out));
		reg_16		PC(.Clk, .Reset(Reset_h), .Load(LD_PC), .D(PCd_in), .Data_Out(PCd_out));
		reg_16		IR(.Clk, .Reset(Reset_h), .Load(LD_IR), .D(Data), .Data_Out(IR_out));
		reg_16		DR(.Clk, .Reset(Reset_h), .Load(LD_REG), .D(Data[11:9]), .Data_Out(DR_out));

		
		/*
		module plus1(input logic	[15:0]	PC_in,
				 output logic	[15:0]	PC_out
		*/
		plus1		increment(.PC_in(PCd_out), .PC_out(PCd_in));
		/*
		module four_one_mux_16(input 	[15:0] 	w, x, y, z,
					input		[1:0]	select,
					output	[15:0] 	out);
		*/
		
		//four_one_mux_16	PCMUX(.w(PC_w), .x(PC_x), .y(PC_y), .z(), .select(PCMUXselect), .out(PCd_in));
		//two_one_mux_16	MARMUX()
		
		/*
		module tristate_buffer(input logic	[15:0]	tri_in,
							  input						gate,
							  output logic	[15:0]	tri_out);
		*/
		tristate_buffer	PC_tri(.tri_in(PCd_out), .gate(GatePC), .tri_out(Data));
		//tristate_buffer	MARMUX_tri(.tri_in(PCd_out), .gate(GateMARMUX), .tri_out(Data));
		tristate_buffer	MDR_tri(.tri_in(MDR_out), .gate(GateMDR), .tri_out(Data));
		//tristate_buffer	ALU_tri(.tri_in(PCd_out), .gate(GatePC), .tri_out(Data));
		
		/*
		HexDriver        Hex0 (
                        .In0(IR_out[3:0]),
                        .Out0(HEX0) );
		HexDriver        Hex1 (
                        .In0(IR_out[7:4]),
                        .Out0(HEX1) );
		HexDriver        Hex2 (
                        .In0(IR_out[11:8]),
                        .Out0(HEX2) );
		HexDriver        Hex3 (
                        .In0(IR_out[15:12]),
                        .Out0(HEX3) );
        */
		
		assign LED = IR_out[11:0];
		assign SR1_out = S[8:6];
		assign SR2_out = S[2:0];

endmodule
