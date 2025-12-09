class monitor;

    virtual intf.monitor vif;
    mailbox #(transaction) mon2scd;
    transaction trans;
 	int i = 0;

    function new(virtual intf.monitor vif, mailbox #(transaction) m2s);
        this.vif = vif;
        this.mon2scd = m2s;
    endfunction

    task run();
        $display("[MONITOR] Starting monitor");

        forever begin
            @(vif.sample_enable);
          	i++;
            trans = new();
            trans.req = vif.req;
            trans.enc = vif.enc;
            trans.valid = vif.valid;
            mon2scd.put(trans);
          $display("--------------------------------------------------------------------------------------------------");
          $display("[MONITOR] Captured  #%0d: REQ = %b, ENC = %d, Valid = %b",i,  trans.req, trans.enc, trans.valid);
        end
    endtask
endclass