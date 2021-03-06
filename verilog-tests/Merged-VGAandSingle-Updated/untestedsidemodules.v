//Counts to 100, then resets. Used for loading from Ram Tracks to shiftbits
module counter_4bit(INPUTCLOCK, reset_n, counter,shouldLoad);
	input INPUTCLOCK;
	input reset_n;
	output shouldLoad;
	output reg [2:0] counter;
	
	assign shouldLoad = ~counter[2] & ~counter[1] & ~counter[0];
	
	always @(posedge INPUTCLOCK)
	begin
		if(reset_n == 1'b1)
			counter <= 0;
		else 
			begin
				if (counter == 3'b100)
					counter <= 0;
				else
					counter <= counter + 1'b1;
			end
	end

endmodule

//Counts to 127 then resets. Used for the ram location selection
module counter_7bit(INPUTCLOCK, reset_n, counter);
	input INPUTCLOCK;
	input reset_n;
	output reg [6:0] counter;
	
	always @(posedge INPUTCLOCK)
	begin
		if(reset_n == 1'b1)
			counter <= 0;
		else 
			begin
				if (counter == 7'b1111111)
					counter <= 0;
				else
					counter <= counter + 1'b1;
			end
	end

endmodule

//Used to count to 9999 in binary, which is then displayed on the screen
module counter_scoreboard(counter1, INPUTCLOCK, reset_n, counter2, counter3, counter4);
	input INPUTCLOCK;
	input reset_n;
	input [3:0] counter1;
	output reg [3:0] counter2, counter3, counter4;
	
	always @(posedge INPUTCLOCK)
	begin
		if(reset_n == 1'b1) begin
			counter2 <= 0;
			counter3 <= 0;
			counter4 <= 0;
			end
		else 
			begin
				
				if (counter1 >= 4'b1001) begin
						counter2 <= counter2 + 1'b1;
					if(counter2 == 4'b1001) begin
						counter2 <= 0;
						counter3 <= counter3 + 1'b1;
					if(counter3 == 4'b1001) begin
						counter3 <= 0;
						counter4 <= counter4 + 1'b1;
					end
				   end
					end
			end
	end

endmodule

//A bit shifter without the option of loading from a source
module shifterbitNL(OUT, IN, SHIFT, CLK, RESET_N);
	input IN, SHIFT, CLK, RESET_N;
	output OUT;
	
	wire muxconnector, toDflip;
	
	mux2to1 M1(
		.x(OUT),
		.y(IN),
		.s(SHIFT),
		.m(toDflip)
	);
	
	
	flipflop F1(
		.d(toDflip),
		.q(OUT),
		.clk(CLK),
		.reset_n(RESET_N)
	);
		
endmodule

//TAKEN FROM BRIAN-CHIM - Rate_divider_fast
module RDF(enable, clkin, clkout);
	input [0:0] enable;
	input clkin;
	output reg [0:0]clkout;
	reg [24:0] count;

	initial begin
		count = 0;
		clkout = 0;
	end

	always @(posedge clkin) begin
		if (enable == 1'b1) begin
			if (count < 6000000)
				count <= count + 1;
			else begin
				count <= 0;
				clkout <= ~clkout;
			end
		end
	end
endmodule

