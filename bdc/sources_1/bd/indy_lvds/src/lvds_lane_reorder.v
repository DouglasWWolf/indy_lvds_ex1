//====================================================================================
//                        ------->  Revision History  <------
//====================================================================================
//
//   Date     Who   Ver  Changes
//====================================================================================
// 12-May-26  DWW     1  Initial creation
//====================================================================================

/*
    Fetches 256 bytes in from a single lane and outputs a 256 byte buffer
    with the bytes in cell-number order
*/

module lvds_lane_reorder
(
    input clk,
    input resetn,

    // Input stream is 1 byte wide
    input[7:0] in_data,
    input      in_valid,

    // This is the 256 bytes of data, in the correct order
    output reg[8*256-1:0] reordered,
    output reg            reordered_valid_stb
);

genvar i;

// We are going to buffer 256 bytes of data
reg[7:0] buffer[0:255];

// A counter that counts from 0 to 255, then rolls over to 0
reg[7:0] counter;

// Here we map the 8 bits of "counter" into an array index
wire[7:0] index = {counter[4:0], counter[7:5]};

//=============================================================================
// Every time a byte arrives on the input, store it into the correct slot of
// the buffer. 
//=============================================================================
always @(posedge clk) begin

    if (resetn == 0)
        counter <= 0;
    
    else if (in_valid) begin
        buffer[index]       <= in_data;
        counter             <= counter + 1;
    end

end
//=============================================================================


//=============================================================================
// We strobe "reordered_valid_stb" high for one clock-cycle at the end of every
// 256-byte sequence.
//=============================================================================
always @(posedge clk) begin
    reordered_valid_stb <= (in_valid && counter == 8'hFF);
end
//=============================================================================



//=============================================================================
// When we see the 256th byte of input data (byte numbering starts at 0), we
// copy our buffer to "reordered".
//=============================================================================
for (i=0; i<256; i=i+1) begin
    always @(posedge clk) begin
        if (in_valid && counter == 8'hFF) begin
            if (i == 255)
                reordered[i*8 +: 8] <= in_data;            
            else
                reordered[i*8 +: 8] <= buffer[i];                        
        end
    end
end
//=============================================================================



endmodule