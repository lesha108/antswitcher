`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.05.2025 18:49:25
// Design Name: 
// Module Name: khz_gen
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module khz_gen
#(
    parameter   CNT_MAX = 16'd49_999   // Parameter definition parameters (macro definition)
)
(
    input   wire    sys_clk,
    input   wire    sys_rst_n,
    
    output  reg    buzzer_out
);

reg     [15:0]  cnt; // 16 -bit width counter 

/* Counter CNT */
always@ (posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)  // When the reset signal is valid (when reset), CNT clear zero
        cnt <= 16'd0;
    else if (cnt == CNT_MAX)   // Count the maximum value, CNT clearing zero
        cnt <= 16'd0;
    else
        cnt <= cnt + 16'd1;    // Self -increase every clock rising along CNT 1
        
/* Buzzer device controlled by counter */
always@ (posedge sys_clk or negedge sys_rst_n)
    if(sys_rst_n == 1'b0)   // Initial state
        buzzer_out = 1'b0;
    else if (cnt == CNT_MAX)  // CNT is remembered once, the output level reverses once
        buzzer_out = ~buzzer_out;
    else     // CNT is not full, buzzer level is maintained
        buzzer_out = buzzer_out;

endmodule
