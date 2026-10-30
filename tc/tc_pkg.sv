package tc_package;

    import tb_fifo_sync_pkg::*;

    task tc_full_coverage(generator gen);
        transaction t;
        
        $display("\n==========================================");
        $display("RUNNING: FULL COVERAGE TESTSUITE");
        $display("==========================================\n");

        // 1. Reset Test
        gen.reset_fifo();
        #20ns; // Chờ 2 chu kỳ clock sau reset

        // 2. Ghi đầy FIFO
        for (int i = 0; i < DEPTH; i++) begin
            t = new();
            t.wr_en = 1; t.rd_en = 0; t.din = $urandom();
            gen.send_trans(t);
            #10ns;
        end

        // 3. Cố tình Ghi khi FULL (Overflow)
        t = new();
        t.wr_en = 1; t.rd_en = 0; t.din = 8'hFF;
        gen.send_trans(t);
        #10ns;

        // 4. Vừa Đọc vừa Ghi khi FULL
        t = new();
        t.wr_en = 1; t.rd_en = 1; t.din = 8'hA5;
        gen.send_trans(t);
        #10ns;

        // 5. Đọc rỗng FIFO (EMPTY)
        for (int i = 0; i < DEPTH; i++) begin
            t = new();
            t.wr_en = 0; t.rd_en = 1;
            gen.send_trans(t);
            #10ns; // <--- Chờ 1 cycle
        end

        // 6. Cố tình Đọc khi EMPTY (Underflow)
        t = new();
        t.wr_en = 0; t.rd_en = 1;
        gen.send_trans(t);
        #10ns;

        // 7. Vừa Đọc vừa Ghi khi EMPTY
        t = new();
        t.wr_en = 1; t.rd_en = 1; t.din = 8'h5A;
        gen.send_trans(t);
        #20ns;

    endtask

endpackage