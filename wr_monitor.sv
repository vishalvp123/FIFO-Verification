class wr_monitor extends uvm_monitor;
  `uvm_component_utils (wr_monitor)
  
  virtual intf.wr_mon_mp vif;
  wr_seq_item tr1;
  uvm_analysis_port#(wr_seq_item)item_collected_port;
   
  function new (string name= "wr_monitor", uvm_component parent);
    super.new (name, parent);
    item_collected_port= new("item_collected_port", this);
    
  endfunction
  
  function void build_phase (uvm_phase phase);
    super.build_phase (phase);
    if(!uvm_config_db#(virtual intf)::get(this, "", "vif", vif))
       `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
  endfunction
  
 task run_phase (uvm_phase phase);
    forever 
      @(vif.wr_mon_cb)
      begin
        collect_data();
      end
  endtask
  
  task collect_data();
   tr1= wr_seq_item::type_id::create("tr1");
      @(vif.wr_mon_cb)
    // `uvm_info("WR_MON","WRITE MON TRANSACTIONS",UVM_NONE);
     wait(vif.wr_mon_cb.wr && !vif.wr_mon_cb.fifo_full && vif.wr_mon_cb.rst_n)         begin 
       $display("printing write monitor.............");
        tr1.DATAIN = vif.wr_mon_cb.DATAIN;
		//intf.cg1.sample();
       `uvm_info("WR_MONITOR",$sformatf("printing from monitor \n wr_data: %h", tr1.DATAIN),UVM_LOW) 
      
      end
    
  endtask
  
endclass
      