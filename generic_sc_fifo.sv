module generic_sc_fifo #(
  parameter ADDR_W   = 10,
  parameter DATA_W   = 256
)(
  input                rst_i,
  input                clk_i,

  input                wr_en_i,
  input  [DATA_W-1:0]  data_i,

  input                rd_en_i,
  output [DATA_W-1:0]  data_o,

  output [ADDR_W:0]    usedw_o,
  output               empty_o,
  output               full_o
);

//******************************************************************************
// Variables declaration
//******************************************************************************

// FIFO memory array
logic [DATA_W-1:0] mem [2**ADDR_W-1:0];

// WR and RD pointers
logic [ADDR_W-1:0] wr_addr;
logic [ADDR_W-1:0] rd_addr;

logic [DATA_W-1:0] rd_data;

logic             prefetch_data;

logic             empty;
logic             full;
logic [ADDR_W:0]  usedw;
logic             rd_en;

//******************************************************************************
// WR logic
//******************************************************************************

always_ff @( posedge clk_i )
  if( wr_en_i )
    mem[wr_addr] <= data_i;

always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    wr_addr <= '0;
  else
    if( wr_en_i )
      wr_addr <= wr_addr + 1'b1;

//******************************************************************************
// Status logic
//******************************************************************************

// FIFO is empty
always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    empty <= 1'b1;
  else
    if( prefetch_data )
      empty <= 1'b0;
    else
      if( rd_en_i && usedw == 1 && !wr_en_i )
        empty <= 1'b1;

// FIFO is full
always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    full <= 1'b0;
  else
    if( rd_en_i )
      full <= 1'b0;
    else
      if( wr_en_i && usedw == 2**ADDR_W-2 )
        full <= 1'b1;

always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    usedw <= '0;
  else
    usedw <= usedw + ( wr_en_i == 1'b1 ) - ( rd_en_i == 1'b1 );
    //case( { wr_en_i, rd_en } )
    //  2'b10: wr_usedw <= wr_usedw + 1'b1;
    //  2'b01: wr_usedw <= wr_usedw - 1'b1;
    //endcase

//******************************************************************************
// RD logic
//******************************************************************************

always_ff @( posedge clk_i )
  prefetch_data <= wr_en_i && empty && !prefetch_data;

assign rd_en = prefetch_data || rd_en_i;

always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    rd_addr <= '0;
  else
    if( rd_en )
      rd_addr <= rd_addr + 1'b1;

always_ff @( posedge clk_i )
  if( rd_en )
    rd_data <= mem[rd_addr];

assign data_o = rd_data;

//******************************************************************************
// Output assignments
//******************************************************************************

assign full_o  = full;
assign empty_o = empty;
assign usedw_o = usedw;

endmodule

/*

generic_sc_fifo #(
  .ADDR_W  ( ),
  .DATA_W  ( )
) generic_sc_fifo (
  .rst_i   ( ),
  .clk_i   ( ),

  .wr_en_i ( ),
  .data_i  ( ),

  .rd_en_i ( ),
  .data_o  ( ),

  .usedw_o ( ),
  .empty_o ( ),
  .full_o  ( )
);

*/
