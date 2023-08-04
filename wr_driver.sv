class wr_driver extends uvm_driver #(wr_seq_item);
  `uvm_component_utils(wr_driver)
  
  virtual intf.wr_drv_mp vif;
  
  function new (string name= "wr_driver", uvm_component parent);
    super.new (name, parent);
  endfunction
  
  function void build_phase (uvm_phase phase);
    super.build_phase (phase);
    if(!uvm_config_db#(virtual intf)::get(this, "", "vif", vif))
    `uvm_fatal("NO_VIF",{"virtual interface must be set for:", get_full_name(), ".vif"});
  endfunction
  
  virtual task run_phase (uvm_phase phase);
    forever begin
   // repeat(10) begin
      @(vif.wr_drv_cb)
      vif.wr_drv_cb.wr <= 0;
     // vif.wr_drv_cb.DATAIN <= 8'b0;
      wait(vif.wr_drv_cb.rst_n)
      seq_item_port.get_next_item(req);
   // `uvm_info("DRIVER", $sformatf("printing from driver\n %s", req.sprint()), UVM_LOW)

      drive(req);
      seq_item_port.item_done();
    end
  endtask
  
  task drive(wr_seq_item req);
    @(vif.wr_drv_cb)
    wait(!vif.wr_drv_cb.fifo_full && vif.wr_drv_cb.rst_n) begin
      vif.wr_drv_cb.wr <= 1;
      vif.wr_drv_cb.DATAIN <= req.DATAIN;
      //`uvm_info("WR-DRIVER", $sformatf("printing from driver\n %s", req.sprint()), UVM_LOW)

    end
  endtask
    
endclass