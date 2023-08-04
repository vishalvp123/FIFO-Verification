class rd_sequence extends uvm_sequence #(rd_seq_item);
  `uvm_object_utils(rd_sequence)
  int no_of_bytes;
  function new (string name= "rd_sequence");
    super.new (name);
  endfunction
  
  task body();
   
    repeat(no_of_bytes) begin
      `uvm_do(req);
    req.print();
    end
  endtask
  
endclass