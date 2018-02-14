module fir9 (				//module interface definition.
					//defining input and output signals.
	input logic clk, rst,		//defining clock and reset input bits.
	input logic [3:0] x,		//Defined an array of a 4-bit unsigned binary number.
	input logic[10:0] thresh,	//11 bits unsigned number.
	input logic[3:0] c [0:8],	//Array of nine 4-bit unsigned numbers representing filter coefficients.
	output logic y
	);		
					//Internal signal definitions.
logic [3:0] X_reg [0:8];		//Array of nine registers each storing 4 bits. 
logic [10:0] thresh_reg; 		//Unsigned number to compare with the filter output.
logic [10:0] Answer ;
logic[3:0] C_reg [0:8];			 
logic y_reg;
logic [7:0] Multiply_reg[0:8];

//ciruit description.			//sequential logic block starts.
always_ff@(posedge clk,posedge rst)	//Sensitivity list determines reset will occur immediately. It will occur on positive
					//clk edge or positive rst edge.
	if(rst) begin			//All register outputs will go to zero when thr reset signal is high.
		for(int i=0;i<9;i++)begin
			X_reg[i] <= 0;
			C_reg[i]<= 0;
			Multiply_reg[i] <= 0 ;
		end

		thresh_reg <= 0;
		y <= 0; 
	end

	else begin			//Shifting values to right.
		X_reg[0]<=x; 		//Input arriving on each rising edge of clock.
		C_reg[0]<=c[0];
		Multiply_reg[0]<=X_reg[0]*C_reg[0];

		for(int i=1;i<9;i++) begin	//For all the registers  except the first one as all the starting registers are initiated at the start.
			X_reg[i] <= X_reg[i-1];
			C_reg[i]<= c[i];
			Multiply_reg[i]<= X_reg[i]*C_reg[i];
		end
		
		thresh_reg <= thresh;	//Passing values in the registers for thresh and the output registers.
		y<=y_reg;
	end

always_comb begin 			//combinational logic block starts.
					//Pipeline is implemented to get the correct time delay.					
Answer = 0 ;

	for(int n=0;n<9;n++)
		Answer = Answer + Multiply_reg[n] ;

	if(Answer > thresh_reg)			//Comparing thefilter output with threshold value. 
		y_reg = 1;
	else 
		y_reg = 0;

end 

endmodule 