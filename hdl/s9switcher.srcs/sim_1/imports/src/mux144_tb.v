`timescale 1ns/1ps
module mux144_tb;

   //Inputs in the module enable_sr. Need to use register type
   reg clk = 0;
   reg rst = 0;
   reg ptt = 1;
   reg [2:0] bd = 3'b0;

	//Outputs in the module enable_sr. Need to use net type
   wire lna144;
   wire pa144;
   wire a144;
   wire lna430;
   wire pa430;
   wire a430;

	// Instantiate the Unit Under Test (UUT) for module enable_sr
	mux144 uut (
		.clk(clk),
		.reset(rst),
		.ptt(ptt),
		.band(bd),
		.lna144(lna144),
		.pa144(pa144),
		.a144(a144),
		.lna430(lna430),
		.pa430(pa430),
		.a430(a430)
	);

   // Generate the continuous clock signal. Wait for 10ns. Period is 20ns
   always #10 clk = ~clk;

   //Generate error checking and have pass or fail condition	
   //always @ (*)
   //begin
	   
	   //If 4'b1110,4'b1101,4'b1011 and 4'b0111, no error shows as only one digit is active
	   //Otherise, error shows that more than one enable is active
	 //  if (enable_D1 == 1 && enable_D2 == 1 && enable_D3 == 1 && enable_D4 == 0) begin 
	  // end else if (enable_D1 == 1 && enable_D2 == 1 && enable_D3 == 0 && enable_D4== 1) begin 
	   //end else if(enable_D1 == 1 && enable_D2 == 0 && enable_D3 == 1 && enable_D4 == 1) begin
	   //end else if(enable_D1 == 0 && enable_D2 == 1 && enable_D3 == 1 && enable_D4 == 1) begin
	   //end else
	   //$display ("Error, more than one enable is active. Enable_D1=%b, Enable_D2=%b, Enable_D3=%b, Enable_D4=%b", enable_D1,enable_D2,enable_D3,enable_D4);
	
	   // Wait 100 ns for global reset to finish
     
	//end
	
	// Need initial whenever we run finish or we need to include it in the begin end 
	initial
	begin
	   rst = 1;
	   #40
	   rst = 0;
	   #40
	   bd = 3'b110;	
	   #20
	   ptt = 0;
	   #200
	   ptt = 1;
	   #200
	   ptt = 0;
	   bd = 3'b000;	
	   #500
	   $finish();
	end
        
endmodule

