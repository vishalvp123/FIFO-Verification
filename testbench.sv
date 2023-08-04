`include "uvm_macros.svh"
import uvm_pkg::*;
`include "interface.sv"

module top();
  
  `include "fifo.sv"
  `include "wr_seq_item.sv"
  `include "wr_sequence.sv"
  `include "wr_sequencer.sv"
  `include "wr_driver.sv"
  `include "wr_monitor.sv"
  `include "wr_agent.sv"
  `include "rd_seq_item.sv"
  `include "rd_sequence.sv"
  `include "rd_sequencer.sv"
  `include "rd_driver.sv"
  `include "rd_monitor.sv"
  `include "rd_agent.sv"

  `include "scoreboard.sv"
  `include "environment.sv"
  `include "test.sv"  
  
  bit clk;  
  
  always #2 clk= ~clk;
  
  initial begin
    #2;
    intf.rst_n= 0;
    #5;
    intf.rst_n = 1;
  end
  
  intf intf (clk);
  
  fifo DUV (.clk (clk),
            .rst_n (intf.rst_n),
            .wr (intf.wr),
            .rd (intf.rd),
            .data_in (intf.DATAIN),
            .data_out (intf.DATAOUT),
            .fifo_full (intf.fifo_full),
            .fifo_empty (intf.fifo_empty)
           );
  
  
  initial begin
    uvm_config_db #(virtual intf):: set(null,"*","vif", intf);
  `uvm_info("top","uvm_config_db set for uvm_test_top",UVM_LOW)

  end
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars();
  end
  
  
  initial begin
    run_test ("base_test");
    run_test ("fifo_empty_test");
    run_test ("fifo_full_test");
    run_test("fifo_random_rd_wr_test");
  end 
  
endmodule