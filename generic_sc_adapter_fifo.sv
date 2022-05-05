module generic_sc_fifo #(
  parameter WR_ADDR_W   = 10,
  parameter WR_DATA_W   = 256,
  parameter RD_DATA_W   = 32,
  // Do not modify
  parameter DATA_RATIO  = WR_DATA_W/RD_DATA_W,
  parameter RD_ADDR_W   = WR_ADDR_W*$clog2( DATA_RATIO )
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
logic [WR_DATA_W-1:0] mem     [2**WR_ADDR_W-1:0];

// WR and RD pointers
logic [WR_ADDR_W-1:0] wr_addr;
logic [WR_ADDR_W-1:0] rd_addr;

// RD data cast from WIDE to NARROW
logic [WR_DATA_W/RD_DATA_W-1:0][RD_DATA_W-1:0]  rd_data;
logic [RD_DATA_W-1:0]                           rd_data_mux;

//******************************************************************************
// WR logic
//******************************************************************************

always_ff @( posedge clk_i )
  if( wr_en_i )
    mem[wr_addr] <= wr_data_i;

always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    wr_addr <= '0;
  else
    if( wr_en_i )
      wr_addr <= wr_addr + 1'b1;

// FIFO is empty
always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    wr_empty <= 1'b1;
  else
    if( wr_en_i )
      wr_empty <= 1'b0;
    else
      if( rd_en && wr_usedw == 1 )
        wr_empty <= 1'b1;

// FIFO is full
always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    wr_full <= 1'b0;
  else
    if( rd_en )
      wr_full <= 1'b0;
    else
      if( wr_en_i && wr_usedw == 2**WR_ADDR_W-2 )
        wr_full <= 1'b1;

always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    wr_usedw <= '0;
  else
    wr_usedw <= wr_usedw + ( wr_en_i == 1'b1 ) - ( rd_en == 1'b1 );
    //case( { wr_en_i, rd_en } )
    //  2'b10: wr_usedw <= wr_usedw + 1'b1;
    //  2'b01: wr_usedw <= wr_usedw - 1'b1;
    //endcase

//******************************************************************************
// RD logic
//******************************************************************************

//always_ff @( posedge clk_i )
//  rd_empty_d <= rd_empty;


//assign rd_en = ( rd_empty_d && !rd_empty ) || ( rd_en_i && is_last_word );
//assign is_last_word = rd_word_cnt == DATA_RATIO-1;
//assign rd_data_o = rd_data[word_cnt];

//always_ff @( posedge clk_i, posedge rst_i )
//  if( rd_en )
//    rd_word_cnt <= '0;
//  else
//    if( rd_en_i )
//      rd_word_cnt <= rd_word_cnt + 1'b1;

logic prefetch_rd_data;

assign prefetch_rd_data = rd_empty_d && !rd_empty;

assign rd_en = prefetch_rd_data || rd_en_i;

always_ff @( posedge clk_i )
  if( rd_en )
    rd_data <= mem[rd_addr];

always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    rd_addr <= '0;
  else
    if( rd_en )
      rd_addr <= rd_addr + 1'b1;

assign rd_data_o = rd_data; //[word_cnt];

always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    rd_usedw <= '0;
  else
    rd_usedw <= rd_usedw + ( wr_en_i == 1'b1 ) - ( rd_en == 1'b1 );

always_ff @( posedge clk_i, posedge rst_i )
  if( rst_i )
    rd_empty <= 1'b1;
  else
    if( rd_en )wr_en_i )
      rd_empty <= 1'b0;
    else
      if( rd_en && rd_used == 2**RD_ADDR_W-2 )
        rd_empty <= 1'b1;

always_ff @( posedge clk_i, posedge rst_i )

endmodule
