`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:43:46 07/15/2026 
// Design Name: 
// Module Name:    moduleuart 
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
// UART Receiver
// 8 Data Bits
// No Parity
// 1 Stop Bit
//---------------------------------------------------------

module uart_receiver(

    input clk,
    input reset,
    input baud_tick,
    input rx,

    output reg [7:0] rx_data,
    output reg rx_done

);

reg [3:0] bit_count;
reg [7:0] shift_reg;

reg [1:0] state;

parameter IDLE  = 2'b00;
parameter DATA  = 2'b01;
parameter STOP  = 2'b10;

always @(posedge clk or posedge reset)
begin

    if(reset)
    begin
        state <= IDLE;
        bit_count <= 0;
        shift_reg <= 0;
        rx_done <= 0;
        rx_data <= 0;
    end

    else
    begin

        rx_done <= 0;

        if(baud_tick)
        begin

            case(state)

            //---------------------------------
            // Wait for Start Bit
            //---------------------------------

            IDLE:
            begin
                if(rx == 0)
                begin
                    bit_count <= 0;
                    state <= DATA;
                end
            end

            //---------------------------------
            // Receive 8 Data Bits
            //---------------------------------

            DATA:
            begin

                shift_reg[bit_count] <= rx;

                if(bit_count == 7)
                begin
                    state <= STOP;
                end
                else
                begin
                    bit_count <= bit_count + 1;
                end

            end

            //---------------------------------
            // Stop Bit
            //---------------------------------

            STOP:
            begin

                if(rx == 1)
                begin
                    rx_data <= shift_reg;
                    rx_done <= 1;
                end

                state <= IDLE;

            end

            default:
                state <= IDLE;

            endcase

        end

    end

end

endmodule