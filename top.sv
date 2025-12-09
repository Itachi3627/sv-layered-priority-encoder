// Code your testbench here
// or browse Examples
// Code your testbench here
// or browse Examples
`include "interface.sv"
`include "environment.sv"

module tb_top;
  intf inf();
  environment env;
  
  // Instantiate DUT
  priority_encoder dut (
    .req(inf.req),
    .enc(inf.enc),
    .valid(inf.valid)
  );
  
  initial begin
    $display("===========================================");
    $display("Starting comparator Testbench");
    $display("===========================================");
    
    env = new(inf, 25); 
    env.run();
    
    $display("===========================================");
    $display("Testbench Complete");
    $display("===========================================");
    $finish;
  end
  
endmodule