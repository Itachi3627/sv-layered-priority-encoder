class transaction;
    randc logic [7:0] req;      // Request inputs
    logic [7:0] enc; // Encoded output
    logic valid;

    constraint valid_req {
        req dist {
            8'b00       := 1,     // No request
            [8'b00000001:8'b11111110] := 8,   // Valid requests
            8'b11111111       := 1      // All requests
        };
    }
endclass
