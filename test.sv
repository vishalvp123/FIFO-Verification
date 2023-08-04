class base_test extends uvm_test;
  `uvm_component_utils(base_test)
  
  environment env;
  wr_sequence wr_seq;
  rd_sequence rd_seq;
  
  uvm_report_server svr;
  int no_of_error;
  
  function new (string name= "base_test", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase (uvm_phase phase);
    super.build_phase (phase);
    env= environment::type_id::create("env", this);
    wr_seq= wr_sequence::type_id::create("wr_seq");
    rd_seq= rd_sequence::type_id::create("rd_seq");
    svr= uvm_report_server::get_server();
  endfunction
     
 task run_phase (uvm_phase phase); 
  phase.raise_objection(this);
    wr_seq.no_of_bytes = 16;
    rd_seq.no_of_bytes = 16;
    fork 
        wr_seq.start(env.wr_agnt.wr_seqr);
        rd_seq.start(env.rd_agnt.rd_seqr);
    join
    phase.phase_done.set_drain_time(this, 10);
    phase.drop_objection(this);
  endtask 
  
    function void extract_phase(uvm_phase phase);
    no_of_error= svr.get_severity_count(UVM_ERROR);
  endfunction
  
  function void report_phase(uvm_phase phase);
    if(no_of_error!=0)
      `uvm_info("TEST", "TEST FAILED", UVM_LOW)
    else
      `uvm_info("TEST", "TEST PASSED", UVM_LOW)
      endfunction

endclass

      
class fifo_full_test extends base_test;
  `uvm_component_utils(fifo_full_test)

  function new (string name= "fifo_full_test", uvm_component parent);
    super.new(name, parent);
  endfunction
 
  task run_phase (uvm_phase phase);
    phase.raise_objection(this);
    wr_seq.no_of_bytes = 20; //repeat no. of times in write sequence
    rd_seq.no_of_bytes = 2;  //repeat no. of times in read sequence
    fork 
        wr_seq.start(env.wr_agnt.wr_seqr);
        rd_seq.start(env.rd_agnt.rd_seqr);
    join
    phase.phase_done.set_drain_time(this, 10);
    phase.drop_objection(this);
  endtask

endclass

class fifo_empty_test extends base_test;
  `uvm_component_utils(fifo_empty_test)

  function new (string name= "fifo_empty_test", uvm_component parent);
    super.new(name, parent);
  endfunction
 
  task run_phase (uvm_phase phase);
    phase.raise_objection(this);
    wr_seq.no_of_bytes = 2;
    rd_seq.no_of_bytes = 10;
    fork 
        wr_seq.start(env.wr_agnt.wr_seqr);
        rd_seq.start(env.rd_agnt.rd_seqr);
    join
    phase.phase_done.set_drain_time(this, 10);
    phase.drop_objection(this);
  endtask

endclass

      
class fifo_random_rd_wr_test extends base_test;
  `uvm_component_utils(fifo_random_rd_wr_test)

  function new (string name= "fifo_random_rd_wr_test", uvm_component parent);
    super.new(name, parent);
  endfunction
 
  task run_phase (uvm_phase phase);
    phase.raise_objection(this);
    wr_seq.no_of_bytes = 10;
    rd_seq.no_of_bytes = 10;
    repeat(5) begin
      wr_seq.start(env.wr_agnt.wr_seqr);
    end
    repeat(5) begin
      rd_seq.start(env.rd_agnt.rd_seqr);
    end
    phase.phase_done.set_drain_time(this, 10);
    phase.drop_objection(this);
  endtask

endclass