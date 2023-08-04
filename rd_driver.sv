class rd_driver extends uvm_driver #(rd_seq_item);
  `uvm_component_utils(rd_driver)
  
  virtual intf.rd_drv_mp vif;
  
  function new (string name= "rd_driver", uvm_component parent);
    super.new (name, parent);
  endfunction
  
  function void build_phase (uvm_phase phase);
    super.build_phase (phase);
    if(!uvm_config_db#(virtual intf)::get(this, "", "vif", vif))
    `uvm_fatal("NO_VIF",{"virtual interface must be set for:", get_full_name(), ".vif"});
  endfunction
  
  virtual task run_phase (uvm_phase phase);
    forever begin
    
      @(vif.rd_drv_cb)
      vif.rd_drv_cb.rd <= 0;
      wait(vif.rd_drv_cb.rst_n)
      seq_item_port.get_next_item(req);
   `uvm_info("DRIVER", $sformatf("printing from read driver\n %s", req.sprint()), UVM_LOW)

      drive(req);
      seq_item_port.item_done();
    end
  endtask
  
  task drive(rd_seq_item req);
    @(vif.rd_drv_cb);
    wait(!vif.rd_drv_cb.fifo_empty && vif.rd_drv_cb.rst_n) 
    begin
      vif.rd_drv_cb.rd <= 1;
      `uvm_info("READ-DRIVER", $sformatf("printing from read driver\n %s", req.sprint()), UVM_LOW)

    end
  endtask
    
endclass

