`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Diagnostic Decoder
//////////////////////////////////////////////////////////////////////////////////

module diagnostic_decoder(

    input clk,
    input reset,

    input frame_done,

    input [7:0] dtc0,
    input [7:0] dtc1,
    input [7:0] dtc2,
    input [7:0] dtc3,
    input [7:0] dtc4,

    output reg fault_detected,
    output reg [3:0] fault_code,
    output reg [1:0] fault_level

);

always @(posedge clk or posedge reset)
begin

    if(reset)
    begin

        fault_detected <= 1'b0;
        fault_code     <= 4'd0;
        fault_level    <= 2'b00;

    end

    else if(frame_done)
    begin

        // Default Unknown Fault

        fault_detected <= 1'b1;
        fault_code     <= 4'd15;
        fault_level    <= 2'b01;

        //-------------------------
        // P0000
        //-------------------------

        if( dtc0=="P" &&
            dtc1=="0" &&
            dtc2=="0" &&
            dtc3=="0" &&
            dtc4=="0")
        begin

            fault_detected <= 1'b0;
            fault_code     <= 4'd0;
            fault_level    <= 2'b00;

        end

        //-------------------------
        // P0100
        //-------------------------

        else if(
            dtc0=="P" &&
            dtc1=="0" &&
            dtc2=="1" &&
            dtc3=="0" &&
            dtc4=="0")
        begin

            fault_detected <= 1'b1;
            fault_code     <= 4'd1;
            fault_level    <= 2'b01;

        end

        //-------------------------
        // P0171
        //-------------------------

        else if(
            dtc0=="P" &&
            dtc1=="0" &&
            dtc2=="1" &&
            dtc3=="7" &&
            dtc4=="1")
        begin

            fault_detected <= 1'b1;
            fault_code     <= 4'd2;
            fault_level    <= 2'b10;

        end

        //-------------------------
        // P0301
        //-------------------------

        else if(
            dtc0=="P" &&
            dtc1=="0" &&
            dtc2=="3" &&
            dtc3=="0" &&
            dtc4=="1")
        begin

            fault_detected <= 1'b1;
            fault_code     <= 4'd3;
            fault_level    <= 2'b11;

        end

    end

end

endmodule