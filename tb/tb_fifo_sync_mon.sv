class monitor;

    virtual tb_fifo_sync_inf vif;
    mailbox mon2sco;
    mailbox mon2cov;

    function new(virtual tb_fifo_sync_inf vif, mailbox mon2sco, mailbox mon2cov);
        this.vif     = vif;
        this.mon2sco = mon2sco;
        this.mon2cov = mon2cov;
    endfunction

    task run();
        forever begin
            transaction t;
            
            @(posedge vif.clk);
            #1ns; 

            t = new();
            t.rst_n = vif.rst_n;
            t.wr_en = vif.wr_en;
            t.rd_en = vif.rd_en;
            t.din   = vif.din;
            t.dout  = vif.dout;
            t.full  = vif.full;
            t.empty = vif.empty;

            mon2sco.put(t);
            mon2cov.put(t);
        end
    endtask

endclass