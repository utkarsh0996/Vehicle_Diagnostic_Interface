`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:25:08 07/15/2026 
// Design Name: 
// Module Name:    vehical_interface 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
//---------------------------------------------------------
// Baud Rate Generator
// Clock  : 50 MHz
// Baud   : 9600 bps
// Output : baud_tick
//---------------------------------------------------------

module baud_generator
#(
    parameter CLK_FREQ = 50000000,
    parameter BAUD_RATE = 9600
)
(
    input clk,
    input reset,

    output reg baud_tick
);

localparam DIVISOR = CLK_FREQ / BAUD_RATE;

reg [15:0] counter;

always @(posedge clk or posedge reset)
begin
    if(reset)
    begin
        counter   <= 16'd0;
        baud_tick <= 1'b0;
    end
    else
    begin
        if(counter == DIVISOR-1)
        begin
            counter   <= 16'd0;
            baud_tick <= 1'b1;
        end
        else
        begin
            counter   <= counter + 1'b1;
            baud_tick <= 1'b0;
        end
    end
end

endmodule