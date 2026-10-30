class environment;

    generator  gen;
    driver     drv;
    monitor    mon;
    scoreboard sco;
    coverage   cov;

    mailbox gen2drv;
    mailbox mon2sco;
    mailbox mon2cov;

    virtual tb_fifo_sync_inf vif;

    function new(virtual tb_fifo_sync_inf vif);
        this.vif = vif;

        // 1. Khởi tạo các Mailbox
        gen2drv = new();
        mon2sco = new();
        mon2cov = new();

        // 2. Khởi tạo từng component (Đúng tham số & Đúng vị trí)
        gen = new(gen2drv);               
        drv = new(vif, gen2drv);          
        mon = new(vif, mon2sco, mon2cov); 
        sco = new(mon2sco);               
        cov = new(mon2cov);             
    endfunction

    task test();
        fork
            gen.run();
            drv.run();
            mon.run();
            sco.run();
            cov.run();
        join_any
    endtask

    task post_test();
        #200;
        sco.report();
    endtask

    task run();
        test();
        post_test();
        $finish;
    endtask

endclass