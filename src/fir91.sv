module fir9( 
input logic clk, rst, [3:0]x, [10:0]thresh, [3:0] c [8:0],
output logic y
); 

logic [3:0] x_reg [0:8];
logic [3:0] c_reg [0:8];
logic [10:0] sum_reg;
logic [10:0] thresh_reg

	always_ff@(posedge clk) begin

	for (int tap = 0; tap < 9; tap++) begin

		if(rst)

			x_reg[tap] <= 0;
			c_reg[tap] <= 0;
			sum_reg <= 0;
			thresh_reg <= 0;

		else if (tap == 0)

                	x_reg[0] <= x;
			c_reg[0] <= c[0];

		else

			x_reg[tap] <= x_reg[tap-1];
			c_reg[tap] <= c[tap];

		end

		thresh_reg <= thresh;
		y <= y_reg;

	end

	always_comb begin

		sum_reg = 0;

		for (int tap =0; tap < 9; tap++) begin

		sum_reg = sum_reg + x_reg[tap]*c_reg[tap];

		end


	if(sum_reg > thresh_reg)
		y = 1;
	else
		y = 0;


	end
		
endmodule
