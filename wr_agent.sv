class wr_agent extends uvm_agent;
  `uvm_component_utils (wr_agent)
  
  wr_sequencer wr_seqr;
  wr_driver    wr_drive;
  wr_monitor   wr_mon;
  
  function new (string name = "wr_agent", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase (uvm_phase phase);
    super.build_phase (phase);
    wr_seqr= wr_sequencer::type_id::create("wr_seqr", this);
    wr_drive= wr_driver::type_id::create("wr_drive", this);
    wr_mon= wr_monitor::type_id::create("wr_mon", this);
  endfunction
  
  function void connect_phase (uvm_phase phase);
    wr_drive.seq_item_port.connect(wr_seqr.seq_item_export);
  endfunction
  
endclass