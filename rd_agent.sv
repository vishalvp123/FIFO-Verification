class rd_agent extends uvm_agent;
  `uvm_component_utils(rd_agent)
  
  rd_sequencer rd_seqr;
  rd_driver    rd_drive;
  rd_monitor   rd_mon;
  
  function new (string name= "rd_agent", uvm_component parent);
    super.new (name, parent);
  endfunction
  
  function void build_phase (uvm_phase phase);
    super.build_phase (phase);
    rd_seqr= rd_sequencer::type_id::create("rd_seqr", this);
    rd_drive= rd_driver::type_id::create("rd_drive", this);
    rd_mon= rd_monitor::type_id::create("rd_mon", this);
  endfunction
  
  function void connect_phase (uvm_phase phase);
    rd_drive.seq_item_port.connect(rd_seqr.seq_item_export);
  endfunction
  
endclass