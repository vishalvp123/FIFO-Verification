class environment extends uvm_env;
  `uvm_component_utils(environment)
  
  wr_agent wr_agnt;
  rd_agent rd_agnt;
  scoreboard scbd;
  
  function new (string name= "environment", uvm_component parent);
    super.new (name, parent);
  endfunction
  
  function void build_phase (uvm_phase phase);
    super.build_phase (phase);
    wr_agnt= wr_agent::type_id::create("wr_agnt", this);
    rd_agnt= rd_agent::type_id::create("rd_agnt", this);
    scbd= scoreboard::type_id::create("scbd", this);
  endfunction
  
  
  function void connect_phase (uvm_phase phase);
    wr_agnt.wr_mon.item_collected_port.connect(scbd.wr_mon_export);
    rd_agnt.rd_mon.item_collected_monitor2.connect(scbd.rd_mon_export);
  endfunction
  
endclass