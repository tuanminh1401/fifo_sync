class coverage;
    transaction t;
    mailbox mbx;

    covergroup fifo_cg;

        // 1. Coverage cho tín hiệu Ghi (wr_en)
        WR_EN_CP: coverpoint t.wr_en {
            bins wr_0 = {0};
            bins wr_1 = {1};
        }

        // 2. Coverage cho tín hiệu Đọc (rd_en)
        RD_EN_CP: coverpoint t.rd_en {
            bins rd_0 = {0};
            bins rd_1 = {1};
        }

        // 3. Coverage cho cờ FULL
        FULL_CP: coverpoint t.full {
            bins not_full = {0};
            bins is_full  = {1};
        }

        // 4. Coverage cho cờ EMPTY
        EMPTY_CP: coverpoint t.empty {
            bins not_empty = {0};
            bins is_empty  = {1};
        }

        // 5. Cross Coverage: Đọc và Ghi đồng thời
        RW_CROSS: cross WR_EN_CP, RD_EN_CP;

        // 6. Cross Coverage Nâng cao: Đọc/Ghi kết hợp với Cờ Full/Empty
        CORNER_CROSS: cross WR_EN_CP, RD_EN_CP, FULL_CP, EMPTY_CP {
            // Loại bỏ trường hợp không thể xảy ra (Vừa Full vừa Empty)
            ignore_bins invalid_full_empty = binsof(FULL_CP.is_full) && binsof(EMPTY_CP.is_empty);
        }

    endgroup

    function new(mailbox mbx);
        this.mbx = mbx;
        fifo_cg  = new();
    endfunction

    task run();
        forever begin
            mbx.get(t);
            fifo_cg.sample();
        end
    endtask

endclass