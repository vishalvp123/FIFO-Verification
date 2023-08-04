class wr_sequence extends uvm_sequence #(wr_seq_item);
  `uvm_object_utils(wr_sequence)
  int no_of_bytes;
  
  function new (string name= "wr_sequence");
    super.new (name);
  endfunction
  
  task body();
    repeat (no_of_bytes) begin
    `uvm_do(req)
    req.print;
    end
  endtask
  
endclass