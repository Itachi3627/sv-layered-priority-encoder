class scoreboard;
    parameter WIDTH = 8;
    parameter ADDR_WIDTH = $clog2(WIDTH);
    transaction trans;
    mailbox #(transaction) mon2scd;
    int passed = 0;
    int failed = 0;
    int trans_count = 0;  // Initialize to 0
    
    function new(mailbox #(transaction) m2s);
        this.mon2scd = m2s;
    endfunction
    
    task run();  // Added semicolon
        logic [ADDR_WIDTH-1:0] expected_enc;
        logic expected_valid;   
        
        forever begin
            mon2scd.get(trans);
            trans_count++;
          	expected_valid = '0;
            
            expected_valid = |trans.req;
            expected_enc = '0;
            
            // Priority encoder: LSB has highest priority (0 to WIDTH-1)
            for (int i = WIDTH-1; i >= 0; i--) begin
                if (trans.req[i]) begin
                    expected_enc = i[ADDR_WIDTH-1:0];
                    break;  
                end
            end
            
            if((trans.enc === expected_enc) & (trans.valid === expected_valid)) begin
              $display("[SCOREBOARD] PASSED #%0d: REQ = %b, ENC = %d, Valid = %b", trans_count, trans.req, trans.enc, trans.valid);
                passed++;
            end else begin
              $display("[SCOREBOARD] FAILED #%0d: REQ = 0x%b, ENC = %d (exp: %d), Valid = %0b (exp: %d)", 
                         trans_count, trans.req, trans.enc, expected_enc, trans.valid, expected_valid);
                failed++;
            end
        end
    endtask  // Added endtask
    
    function void report();
        $display("===========================================");
        $display("[SCOREBOARD] Test Results:");
        $display("  PASSED: %0d", passed);
        $display("  FAILED: %0d", failed);
        $display("  TOTAL:  %0d", passed + failed);
        $display("===========================================");
    endfunction
    
endclass