class driver;

    mailbox mbx;
    event   done;

    transaction t;

    virtual tb_fifo_sync_inf vif;

    // Constructor accepts BOTH vif and mailbox
    function new(virtual tb_fifo_sync_inf vif, mailbox mbx);
        this.vif = vif;
        this.mbx = mbx;
    endfunction

    task run();
        forever begin
            mbx.get(t);

            // Drive signals at falling edge
            @(negedge vif.clk);
            vif.rst_n = t.rst_n;
            vif.wr_en = t.wr_en;
            vif.rd_en = t.rd_en;
            vif.din   = t.din;

            @(posedge vif.clk);
            -> done;
        end
    endtask

endclass