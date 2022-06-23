`timescale 1 ns / 1 ns

module top_tb;

parameter CLK_T = 10;

parameter WR_ADDR_W   = 5;
parameter WR_DATA_W   = 32;
parameter RD_DATA_W   = 16;
parameter DATA_RATIO  = WR_DATA_W/RD_DATA_W;
parameter EXTEND_W    = $clog2( DATA_RATIO );
parameter RD_ADDR_W   = WR_ADDR_W+EXTEND_W;

bit rst;
bit clk;

always #(CLK_T/2) clk = ~clk;

//******************************************************************************
// DUT
//******************************************************************************

logic                 wr_en;
logic [WR_DATA_W-1:0] wr_data;
logic [WR_ADDR_W:0]   wr_usedw;
logic                 wr_empty;
logic                 wr_full;

logic                 rd_en;
logic [RD_DATA_W-1:0] rd_data;
logic [RD_ADDR_W:0]   rd_usedw;
logic                 rd_empty;
logic                 rd_full;

generic_sc_adapter_fifo #(
  .WR_ADDR_W  ( 5         ),
  .WR_DATA_W  ( 32        ),
  .RD_DATA_W  ( 16        )
) generic_sc_fifo (
  .rst_i      ( rst       ),
  .clk_i      ( clk       ),

  .wr_en_i    ( wr_en     ),
  .wr_data_i  ( wr_data   ),

  .wr_usedw_o ( wr_usedw  ),
  .wr_empty_o ( wr_empty  ),
  .wr_full_o  ( wr_full   ),

  .rd_en_i    ( rd_en     ),
  .rd_data_o  ( rd_data   ),

  .rd_usedw_o ( rd_usedw  ),
  .rd_empty_o ( rd_empty  ),
  .rd_full_o  ( rd_full   )
);

//******************************************************************************
// Test
//******************************************************************************

initial
  begin
    bit [WR_DATA_W-1:0] wr_data_reg;
    bit [RD_DATA_W-1:0] rd_data_reg;

    bit [7:0] wr_q [$];
    bit [7:0] rd_q [$];

    rd_en = 1'b0;
    wr_en = 1'b0;

    rst <= 1'b1;
    @( posedge clk );
    rst <= 1'b0;

    //******************************************************************************
    // Test 1
    //******************************************************************************

    while( wr_usedw < 2**WR_ADDR_W-1 )
      begin
        wr_en   <= 1'b1;
        repeat( WR_DATA_W/8 )
          begin
            bit [7:0] ref_data;
            ref_data = $urandom_range( 2**8-1, 0 );
            wr_q.push_back( ref_data );
            wr_data_reg = { ref_data, wr_data_reg[WR_DATA_W-1:8] };
          end
        wr_data <= wr_data_reg;
        @( posedge clk );
        wr_en   <= 1'b0;
      end
    
    while( rd_usedw > 2 )
      begin
        rd_en   <= 1'b1;
        @( posedge clk );
        rd_data_reg = rd_data;
        repeat( RD_DATA_W/8 )
          begin
            rd_q.push_back( rd_data_reg[7:0] );
            rd_data_reg = rd_data_reg >> 8;
          end
        rd_en   <= 1'b0;
      end

    while( wr_usedw < 2**WR_ADDR_W-1 )
      begin
        wr_en   <= 1'b1;
        repeat( WR_DATA_W/8 )
          begin
            bit [7:0] ref_data;
            ref_data = $urandom_range( 2**8-1, 0 );
            wr_q.push_back( ref_data );
            wr_data_reg = { ref_data, wr_data_reg[WR_DATA_W-1:8] };
          end
        wr_data <= wr_data_reg;
        @( posedge clk );
        wr_en   <= 1'b0;
      end

    while( rd_usedw > 1 )
      begin
        rd_en   <= 1'b1;
        @( posedge clk );
        rd_data_reg = rd_data;
        repeat( RD_DATA_W/8 )
          begin
            rd_q.push_back( rd_data_reg[7:0] );
            rd_data_reg = rd_data_reg >> 8;
          end
        rd_en   <= 1'b0;
      end

    if( wr_q.size() != rd_q.size() )
      begin
        $error("Ref queue size mismatch. Expected: %0d. Observed: %0d.", wr_q.size(), rd_q.size() );
        $stop();
      end

    repeat( wr_q.size() )
      begin 
        bit [7:0] wr_data;
        bit [7:0] rd_data;

        wr_data = wr_q.pop_front();
        rd_data = rd_q.pop_front();
        if( wr_data != rd_data )
          begin
            $error("Data mismatch. Expected: %h. Observed: %h.", wr_data, rd_data );
            $stop();
          end
      end

    $display("Everything is OK");
    $stop();

  end

endmodule
