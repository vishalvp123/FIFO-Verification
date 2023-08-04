class rd_monitor extends uvm_monitor;
  `uvm_component_utils (rd_monitor)
  
  virtual intf.rd_mon_mp vif;
  rd_seq_item tr2;
  uvm_analysis_port #(rd_seq_item) item_collected_monitor2;
  
  function new (string name= "wr_monitor", uvm_component parent);
    super.new (name, parent);
    item_collected_monitor2= new("item_collected_monitor2", this);
  endfunction
  
  function void build_phase (uvm_phase phase);
    super.build_phase (phase);
    if(!uvm_config_db#(virtual intf)::get(this, "", "vif", vif))
       `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
  endfunction

  virtual task run_phase (uvm_phase phase);
    forever 
      begin
        collect_data();
      end
  endtask
  
  task collect_data();
    tr2= rd_seq_item::type_id::create("tr2");
    @(vif.rd_mon_cb);
    wait(vif.rd_mon_cb.rd && !vif.rd_mon_cb.fifo_empty && vif.rd_mon_cb.rst_n) 
      begin
        $display("printing read monitor---------");
        tr2.DATAOUT = vif.rd_mon_cb.DATAOUT;
        `uvm_info("READ-MONITOR",$sformatf("printing from read monitor \n data_out: %h", tr2.DATAOUT),UVM_LOW)
        
        if(tr2.DATAOUT != 8'bZ && vif.rd_mon_cb.rd)
        item_collected_monitor2.write(tr2);
      
      end
    
    
  endtask
  
endclass
