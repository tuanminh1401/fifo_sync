class transaction;

    bit                  rst_n = 1'b1; 
    bit                  wr_en;
    bit                  rd_en;
    bit [DATA_WIDTH-1:0] din;

    bit                  full;
    bit                  empty;
    bit [DATA_WIDTH-1:0] dout;

endclass