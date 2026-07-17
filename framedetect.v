`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:51:47 07/15/2026 
// Design Name: 
// Module Name:    frame_decoder 
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
// Frame Decoder
// Receives 5 ASCII Characters
// Example : P0301
//---------------------------------------------------------

module frame_decoder(

    input clk,
    input reset,

    input rx_done,
    input [7:0] rx_data,

    output reg [7:0] dtc0,
    output reg [7:0] dtc1,
    output reg [7:0] dtc2,
    output reg [7:0] dtc3,
    output reg [7:0] dtc4,

    output reg frame_done

);

reg [2:0] count;

always @(posedge clk or posedge reset)
begin

    if(reset)
    begin

        count <= 0;

        frame_done <= 0;

        dtc0 <= 0;
        dtc1 <= 0;
        dtc2 <= 0;
        dtc3 <= 0;
        dtc4 <= 0;

    end

    else
    begin

        frame_done <= 0;

        if(rx_done)
        begin

            case(count)

            3'd0:
            begin
                dtc0 <= rx_data;
                count <= 1;
            end

            3'd1:
            begin
                dtc1 <= rx_data;
                count <= 2;
            end

            3'd2:
            begin
                dtc2 <= rx_data;
                count <= 3;
            end

            3'd3:
            begin
                dtc3 <= rx_data;
                count <= 4;
            end

            3'd4:
            begin
                dtc4 <= rx_data;
                frame_done <= 1;
                count <= 0;
            end

            default:
                count <= 0;

            endcase

        end

    end

end

endmodule