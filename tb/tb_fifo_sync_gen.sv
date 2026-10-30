class generator;

    transaction t;
    mailbox mbx;
    event ended; // Event báo kết thúc gen

    function new(mailbox mbx);
        this.mbx = mbx;
    endfunction

    // Task gửi 1 transaction trực tiếp
    task send_trans(transaction t);
        mbx.put(t);
    endtask

    // Task reset FIFO
    task reset_fifo();
        transaction t_rst;
        t_rst = new();
        t_rst.rst_n = 0;
        mbx.put(t_rst);
    endtask

    task run();
    endtask

endclass