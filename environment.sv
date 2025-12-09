`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"

class environment;
    generator gen;
    driver drv;
    monitor mon;
    scoreboard scb;
  
    mailbox #(transaction) gen2drv;
    mailbox #(transaction) mon2scb;
    
    virtual intf vif;
    int num_transactions;

  function new(virtual intf vif, int num = 20);
        this.vif = vif;
        this.num_transactions = num;
        
        gen2drv = new();
        mon2scb = new();
        
        gen = new(gen2drv, num);
        drv = new(vif.driver, gen2drv);
        mon = new(vif.monitor, mon2scb);
        scb = new(mon2scb);
  endfunction

  task run();
    fork
      gen.run();
      drv.run();
      mon.run();
      scb.run();
    join_any
    
    // Wait for all transactions to be processed
    wait(scb.passed + scb.failed == num_transactions);
    #50; // Extra settling time
    
    scb.report();
  endtask
endclass
