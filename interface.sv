interface intf #(parameter WIDTH = 8, parameter ADDR_WIDTH = $clog2(WIDTH));

  logic [WIDTH-1:0] req;      // Request inputs
  logic [ADDR_WIDTH-1:0] enc; // Encoded output
  logic valid;

    event sample_enable;


modport driver(
    input enc, valid,
    output req
    );

modport dut(
    output enc, valid,
    input req
    );

modport monitor(
    input enc, valid,
    input req
    );

endinterface 