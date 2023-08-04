class wr_seq_item extends uvm_sequence_item;
  
  randc bit [7:0] DATAIN;
  bit wr;
  bit fifo_full;
  
  constraint c1{DATAIN inside {[1:20]};}
  
  `uvm_object_utils_begin(wr_seq_item)
  `uvm_field_int(DATAIN, UVM_ALL_ON)
  `uvm_object_utils_end
  
  function new (string name= "wr_seq_item");
    super.new(name);
  endfunction
    
endclass