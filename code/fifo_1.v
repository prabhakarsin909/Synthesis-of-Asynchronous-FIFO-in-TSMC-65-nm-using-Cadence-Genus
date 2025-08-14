module async_fifo #(parameter DSIZE = 8, parameter ASIZE = 4)
					(output [DSIZE-1:0] rdata,
					output wfull,
					output rempty,
					input [DSIZE-1:0] wdata,
					input winc, wclk, wrst_n,
					input rinc, rclk, rrst_n);


wire [ASIZE-1:0] waddr, raddr;
wire [ASIZE:0] wptr, rptr, wq2_rptr, rq2_wptr;



r2w sync_r2w (.wq2_rptr(wq2_rptr), .rptr(rptr), .wclk(wclk), .wrst_n(wrst_n));


w2r sync_w2r (.rq2_wptr(rq2_wptr), .wptr(wptr), .rclk(rclk), .rrst_n(rrst_n));


fifomem #(DSIZE, ASIZE) fifomem
(.rdata(rdata), .wdata(wdata), .waddr(waddr), .raddr(raddr), .wclken(winc), .wfull(wfull), .wclk(wclk));


rptr_empty #(ASIZE) rptr_empty
(.rempty(rempty), .raddr(raddr), .rptr(rptr), .rq2_wptr(rq2_wptr), .rinc(rinc), .rclk(rclk), .rrst_n(rrst_n));


wptr_full #(ASIZE) wptr_full
(.wfull(wfull), .waddr(waddr), .wptr(wptr), .wq2_rptr(wq2_rptr), .winc(winc), .wclk(wclk), .wrst_n(wrst_n));

endmodule 


module empty(
input [4:0] w2r_wptr,
input rinc,rclk,rrst_n,

output reg rempty,
output [3:0] raddr,
output reg [4:0] rptr
);

reg [4:0] rbin;
wire [4:0] rgraynext, rbinnext;
wire rempty_val;

always @(posedge rclk or negedge rrst_n) begin
  if(!rrst_n) {rbin,rptr}<=0;
  else {rbin,rptr}<={rbinnext,rgraynext};
end
  
  assign raddr = rbin[3:0];
  assign rbinnext= rbin+ (rinc & ~rempty);
  assign rgraynext= (rbinnext>>1) ^ rbinnext;
  
  assign rempty_val= (rgraynext == w2r_wptr);
  
  always @(posedge rclk or negedge rrst_n)
  begin
  if(!rrst_n) rempty<=1'b1;
  else rempty<=rempty_val; 
  end
 
 endmodule
  

module fifo_mem(
input [7:0] wdata,
input wclken,wclk,wfull,
input [3:0] waddr,raddr,
output [7:0]rdata);

reg [7:0] mem [0:15];

always@(posedge wclk)
begin

if(wclken && !wfull) 
mem[waddr] <=wdata;

end

assign rdata= mem[raddr];

endmodule


module fifo1 
 (output [7:0] rdata,
 output full,
 output empty,
 input [7:0] wdata,
 input w_en, wclk, wrst_n,
 input r_en, rclk, rrst_n);
 
 wire [3:0] waddr, raddr;
 wire [4:0] wptr, rptr, r2w_rptr, w2r_wptr;
 
 r2w r1(.r2w_rptr(r2w_rptr), .rptr(rptr),.wclk(wclk), .wrst_n(wrst_n));
 
 w2r w1(.w2r_wptr(w2r_wptr), .wptr(wptr),.rclk(rclk), .rrst_n(rrst_n));
 
 fifo_mem f1(.rdata(rdata), .wdata(wdata),.waddr(waddr), .raddr(raddr),.wclken(w_en), .wfull(full),.wclk(wclk));
						  
 empty e1(.rempty(empty),.raddr(raddr),.rptr(rptr), .w2r_wptr(w2r_wptr),.rinc(r_en), .rclk(rclk),.rrst_n(rrst_n));
 
 full f2(.wfull(full), .waddr(waddr),.wptr(wptr), .r2w_rptr(r2w_rptr),.winc(w_en), .wclk(wclk),.wrst_n(wrst_n));
 
endmodule


module full(
input [4:0] r2w_rptr,
input winc,wclk,wrst_n,
output reg wfull,
output [3:0] waddr,
output reg [4:0] wptr);

reg [4:0] wbin;
wire [4:0] wgraynext, wbinnext;
wire wfull_val;

always @(posedge wclk or negedge wrst_n)
begin

if(!wrst_n) {wbin, wptr}<=0;
else {wbin, wptr}<={wbinnext,wgraynext};

end

assign waddr=wbin[3:0];
assign wbinnext=wbin+(winc & ~wfull);
assign wgraynext = (wbinnext >> 1) ^ wbinnext;


assign wfull_val=((wgraynext[4] !=r2w_rptr[4] ) &&
 (wgraynext[3] !=r2w_rptr[3]) &&
  (wgraynext[2:0]==r2w_rptr[2:0]));
  
always @(posedge wclk or negedge wrst_n)
begin
if(!wrst_n) wfull<=1'b0;
else wfull<=wfull_val;

end
endmodule




module r2w(
input [4:0] rptr,
input wclk, wrst_n,
output reg [4:0] r2w_rptr);

reg [4:0] r2w_temp;

always@(posedge wclk) begin

if(!wrst_n) {r2w_rptr,r2w_temp} <=0;
else {r2w_rptr,r2w_temp}<={r2w_temp,rptr};
end 
endmodule


module w2r(
input [4:0] wptr,
input rclk, rrst_n,
output reg [4:0] w2r_wptr);

reg [4:0] w2r_temp;

always@(posedge rclk) begin

if(!rrst_n) {w2r_wptr,w2r_temp} <=0;
else {w2r_wptr,w2r_temp}<={w2r_temp,wptr};
end 
endmodule

