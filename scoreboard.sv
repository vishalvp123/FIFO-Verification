`uvm_analysis_imp_decl(_wr_mon)
`uvm_analysis_imp_decl(_rd_mon)

class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)
  uvm_analysis_imp_wr_mon#(wr_seq_item,scoreboard) wr_mon_export;
  uvm_analysis_imp_rd_mon#(rd_seq_item,scoreboard) rd_mon_export;

  wr_seq_item tx[$];
  rd_seq_item rx[$];
  wr_seq_item tpkt;
  rd_seq_item rpkt;
  
   
  function new (string name= "scoreboard", uvm_component parent);
    super.new(name, parent);
  
  endfunction
  
  function void build_phase (uvm_phase phase);
    super.build_phase (phase);
    wr_mon_export= new("wr_mon_export", this);
    rd_mon_export= new("rd_mon_export", this);
  endfunction
  
  virtual function void write_wr_mon (input wr_seq_item pkt1);
   // fork
    if(pkt1.DATAIN != 40'b0 && pkt1.DATAIN != 40'bz)
    begin
      tx.push_back(pkt1);
          `uvm_info("SCBD","data from write monitor", UVM_LOW)
      `uvm_info("SCBD",$sformatf("printing from monitor \n wr_data: %p", tx),UVM_LOW) 
    end
            
  endfunction
  
  virtual function void write_rd_mon (input rd_seq_item pkt2);
    if(pkt2.DATAOUT != 40'b0 && pkt2.DATAOUT != 40'bz)
    begin
      rx.push_back(pkt2);
          `uvm_info("SCBD", "data from read monitor", UVM_LOW)
    end
  endfunction
  
  task run_phase (uvm_phase phase);
    super.run_phase(phase);
    forever
      begin
        if (rx.size !=0 && tx.size !=0)
          begin
            tpkt = tx.pop_front();
            rpkt = rx.pop_front();
            if(tpkt.DATAIN == rpkt.DATAOUT)
              `uvm_info("SCOREBOARD", "---------------DATAIN & DATAOUT MATCH---------------", UVM_LOW)
              else
                `uvm_error("SCOREBOARD", "---------------DATAIN & DATAOUT NOT MATCHING---------------")
            end
                #1ns;
          end
        endtask
        endclass
                