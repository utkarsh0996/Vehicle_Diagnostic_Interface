`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:56:42 07/15/2026 
// Design Name: 
// Module Name:    led_controller 
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
// LED Controller
//---------------------------------------------------------

module led_controller(

    input stored_fault,
    input [1:0] stored_level,

    output reg green_led,
    output reg yellow_led,
    output reg red_led

);

always @(*)
begin

    // Default OFF
    green_led = 1'b0;
    yellow_led = 1'b0;
    red_led = 1'b0;

    if(stored_fault == 1'b0)
    begin
        // No Fault
        green_led = 1'b1;
    end
    else
    begin

        case(stored_level)

        2'b01:
        begin
            // Minor Fault
            yellow_led = 1'b1;
        end

        2'b10:
        begin
            // Major Fault
            red_led = 1'b1;
        end

        2'b11:
        begin
            // Critical Fault
            red_led = 1'b1;
        end

        default:
        begin
            green_led = 1'b1;
        end

        endcase

    end

end

endmodule