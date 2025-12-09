class generator;
    transaction trans;
    mailbox #(transaction) gen2drv;
    int num_transactions = 0;

    function new(mailbox #(transaction) g2d, int num = 20);
        this.gen2drv = g2d;
        this.num_transactions = num;
    endfunction

    task run();
        $display("[GENERATOR] Starting generation of %0d transactions", num_transactions);

        for(int i = 1; i <= num_transactions; i++)begin
            trans = new();
            if(!trans.randomize())begin
                $display("[GENERATOR] ERROR: Randomization failed for transaction #%0d", i);
            end

            gen2drv.put(trans);
          $display("[GENERATOR] Generated Trans #%0d: REQ = %b", i, trans.req);

        end

        $display("[GENERATOR] Generation complete");
    endtask
endclass