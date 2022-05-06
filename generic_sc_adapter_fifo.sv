module generic_sc_adapter_fifo #(
  parameter WR_ADDR_W   = 10,
  parameter WR_DATA_W   = 256,
  parameter RD_DATA_W   = 32,
  parameter DATA_RATIO  = WR_DATA_W/RD_DATA_W,
  parameter EXTEND_W    = $clog2( DATA_RATIO ),
  parameter RD_ADDR_W   = WR_ADDR_W+EXTEND_W
)(
  input                   rst_i,
  input                   clk_i,

  input                   wr_en_i,
  input  [WR_DATA_W-1:0]  wr_data_i,

  output [WR_ADDR_W:0]    wr_usedw_o,
  output                  wr_empty_o,
  output                  wr_full_o,

  input                   rd_en_i,
  output [RD_DATA_W-1:0]  rd_data_o,

  output [RD_ADDR_W:0]    rd_usedw_o,
  output                  rd_empty_o,
  output                  rd_full_o
);

//******************************************************************************
// Variables declaration
//******************************************************************************

// FIFO memory array
logic [WR_DATA_W-1:0] mem [2**WR_ADDR_W-1:0];

// WR and RD pointers
logic [WR_ADDR_W-1:0] wr_addr;
logic [RD_ADDR_W-1:0] rd_addr;

logic               wr_empty;
logic               wr_full;
logic [WR_ADDR_W:0] wr_usedw;

logic               empty;
logic               full;
logic [WR_ADDR_W:0] usedw;

logic               rd_empty;
logic               rd_full;
logic [RD_ADDR_W:0] rd_usedw;

logic               rd_en;

logic [DATA_RATIO-1:0][RD_DATA_W-1:0] rd_data;
logic [EXTEND_W-1:0]                  rd_low_word_addr;
logic [RD_ADDR_W-EXTEND_W-1:0]        rd_wide_word_addr;

//******************************************************************************
// WR logic
//******************************************************************************

always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    wr_addr <= '0;
  else
    if( wr_en_i )
      wr_addr <= wr_addr + 1'b1;

always_ff @( posedge clk_i )
  if( wr_en_i )
    mem[wr_addr] <= wr_data_i;

//******************************************************************************
// RD logic
//******************************************************************************

always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    rd_addr <= '0;
  else
    if( rd_en_i )
      rd_addr <= rd_addr + 1'b1;

assign rd_wide_word_addr = rd_addr[RD_ADDR_W-1:EXTEND_W];
assign rd_low_word_addr  = rd_addr[EXTEND_W-1:0];

assign rd_data   = mem[rd_wide_word_addr];
assign rd_data_o = rd_data[rd_low_word_addr];

assign rd_en = rd_en_i && ( rd_low_word_addr == DATA_RATIO-1 );

//******************************************************************************
// Common status logic
//******************************************************************************

// FIFO is empty
always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    empty <= 1'b1;
  else
    if( wr_en_i )
      empty <= 1'b0;
    else
      if( rd_en && usedw == 1 )
        empty <= 1'b1;

// FIFO is full
always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    full <= 1'b0;
  else
    if( rd_en )
      full <= 1'b0;
    else
      if( wr_en_i && usedw == 2**WR_ADDR_W-1 )
        full <= 1'b1;

always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    usedw <= '0;
  else
    case( { wr_en_i, rd_en } )
      2'b10: usedw <= usedw + 1'b1;
      2'b01: usedw <= usedw - 1'b1;
    endcase

//******************************************************************************
// Output assignments
//******************************************************************************

assign wr_full_o  = full;
assign wr_empty_o = empty;
assign wr_usedw_o = usedw;

assign rd_full_o  = full;
assign rd_empty_o = empty;
assign rd_usedw_o = ( usedw << EXTEND_W ) - rd_low_word_addr;

endmodule

/*

generic_sc_fifo #(
  .WR_ADDR_W  ( ),
  .WR_DATA_W  ( ),
  .RD_DATA_W  ( )
) generic_sc_fifo (
  .rst_i      ( ),
  .clk_i      ( ),

  .wr_en_i    ( ),
  .wr_data_i  ( ),

  .wr_usedw_o ( ),
  .wr_empty_o ( ),
  .wr_full_o  ( )

  .rd_en_i    ( ),
  .rd_data_o  ( ),

  .rd_usedw_o ( ),
  .rd_empty_o ( ),
  .rd_full_o  ( )
);

*/
