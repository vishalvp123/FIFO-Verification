class rd_seq_item extends uvm_sequence_item;
  
  function new (string name= "rd_seq_item");
    super.new (name);
  endfunction
  
  bit [7:0] DATAOUT;
  
  `uvm_object_utils_begin(rd_seq_item)
  `uvm_field_int(DATAOUT, UVM_ALL_ON)
  `uvm_object_utils_end
  
endclass