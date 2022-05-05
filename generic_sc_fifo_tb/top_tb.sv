`timescale 1 ns / 1 ns

module top_tb;

parameter CLK_T = 10;

bit rst;
bit clk;

always #(CLK_T/2) clk = ~clk;

//******************************************************************************
// DUT
//******************************************************************************

logic wr_en;
logic rd_en;
logic empty;
logic full;

logic [5:0] usedw;
logic [7:0] wr_data;
logic [7:0] rd_data;

generic_sc_fifo #(
  .ADDR_W  ( 5        ),
  .DATA_W  ( 8        )
) generic_sc_fifo (
  .rst_i   ( rst      ),
  .clk_i   ( clk      ),

  .wr_en_i ( wr_en    ),
  .data_i  ( wr_data  ),

  .rd_en_i ( rd_en    ),
  .data_o  ( rd_data  ),

  .usedw_o ( usedw    ),
  .empty_o ( empty    ),
  .full_o  ( full     )
);

//******************************************************************************
// Test
//******************************************************************************

initial
  begin
    bit [7:0] ref_data;

    bit [7:0] wr_q [$];
    bit [7:0] rd_q [$];

    rd_en = 1'b0;
    wr_en = 1'b0;

    rst <= 1'b1;
    @( posedge clk );
    rst <= 1'b0;

    while( !full )
      begin
        wr_en   <= 1'b1;
        ref_data = $urandom_range( 2**8-1, 0 );
        wr_q.push_back( ref_data );
        wr_data <= ref_data;
        @( posedge clk );
        wr_en   <= 1'b0;
      end
    
    while( usedw > 1 )//!empty )
      begin
        rd_en   <= 1'b1;
        @( posedge clk );
        rd_q.push_back( rd_data );
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
