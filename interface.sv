interface intf (input bit clk);
  logic wr;
  logic rd;
  logic rst_n;
  logic [7:0] DATAIN;
  logic [7:0] DATAOUT;
  logic fifo_full;
  logic fifo_empty;
  
  clocking wr_drv_cb @(posedge clk);
    default input #1 output #1;
    output DATAIN;
    output wr;
    input fifo_full;
    input rst_n;
  endclocking
  
  clocking wr_mon_cb @(posedge clk);
    default input #1 output #1;
    input DATAIN;
    input wr;
    input fifo_full;
    input rst_n;
  endclocking
  
  clocking rd_drv_cb @(posedge clk);
    default input #1 output #1;
    output rd;
    input fifo_empty;
    input rst_n;
  endclocking
  
  clocking rd_mon_cb @(posedge clk);
    default input #1 output #1;
    input rd;
    input DATAOUT;
    input fifo_empty;
    input rst_n;
  endclocking 
  
   modport wr_drv_mp (clocking wr_drv_cb);
   modport wr_mon_mp (clocking wr_mon_cb);
   modport rd_drv_mp (clocking rd_drv_cb);
   modport rd_mon_mp (clocking rd_mon_cb);


   
   covergroup cg @(posedge clk);
   fifo_rst     : coverpoint rst_n;
   fifo_wr	: coverpoint wr;
   fifo_rd	: coverpoint rd;
   fifo_full	: coverpoint fifo_full;
   fifo_empty	: coverpoint fifo_empty;
   //fifo_data_in : coverpoint DATAIN;
   //fifo_data_out: coverpoint DATAOUT;
   endgroup : cg
   
   cg cg1 =new(); 
   
initial
begin
 cg1.sample();
end 

endinterface