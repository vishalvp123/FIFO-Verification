module fifo(clk,rst_n,wr,rd,data_in,data_out,fifo_full,fifo_empty);
parameter FIFO_WIDTH=8;
parameter FIFO_DEPTH = 16;
input clk,rst_n,wr,rd;
input [FIFO_WIDTH-1:0]data_in;
output fifo_full,fifo_empty;
output [FIFO_WIDTH-1:0] data_out ;
reg [FIFO_WIDTH-1:0] data_out;
reg [FIFO_WIDTH-1:0]mem[FIFO_DEPTH-1:0]; // Memory Dec
reg [3:0]wr_ptr,rd_ptr,wr_rd_ptr_diff;
integer i;
//reg [3:0]count,count1;
wire fifo_full = (wr_ptr == 4'd0 & wr_rd_ptr_diff == 4'd14) ? 1 : 0;
wire fifo_empty = (rd_ptr== 4'd0 & wr_rd_ptr_diff == 4'd0) ? 1 : 0;
always @ (posedge clk or negedge rst_n)
begin
if(!rst_n)
begin
for(i=0;i<=15;i=i+1)
mem[i]<=8'd0;
end
//WRITE PORTION
else if(wr)
mem[wr_ptr]<=data_in;
end
//Write Ptr
always @ (posedge clk or negedge rst_n)
begin
if(!rst_n)
wr_ptr <= 4'd0;
else if(wr)
wr_ptr <= wr_ptr + 4'd1;
end
//READ OPERATION
always @ (posedge clk or negedge rst_n)
begin
if(!rst_n)
data_out <= 8'd0;
else if(rd)
data_out <= mem[rd_ptr];
end
//Read Ptr
always @ (posedge clk or negedge rst_n)
begin
if(!rst_n) 
rd_ptr <= 4'd0;
else if(rd)
rd_ptr <= rd_ptr + 4'd1;
end
//FIFO EMPTY and FULL Logic
always @ (posedge clk or negedge rst_n)
begin
if(!rst_n)
wr_rd_ptr_diff <= 4'd0;
else if(wr & wr_rd_ptr_diff !=4'd15)
wr_rd_ptr_diff <= wr_rd_ptr_diff + 4'd1;
else if(rd & wr_rd_ptr_diff != 4'd0)
wr_rd_ptr_diff <= wr_rd_ptr_diff - 4'd1;
end
endmodule