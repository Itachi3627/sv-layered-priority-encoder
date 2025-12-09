module priority_encoder #(
    parameter WIDTH = 8,
    parameter ADDR_WIDTH = $clog2(WIDTH)
) (
    input  logic [WIDTH-1:0] req,      // Request inputs
    output logic [ADDR_WIDTH-1:0] enc, // Encoded output
    output logic valid                  // Valid output (at least one input is high)
);

   always_comb begin
    valid = |req;
    enc = '0;
    
    // Priority encoding: highest index has priority
    for (int i = WIDTH-1; i >= 0; i--) begin
        if (req[i]) begin
            enc = i[ADDR_WIDTH-1:0];
            break;  // EXIT loop after finding highest bit
        end
    end
end

endmodule