`timescale 1ns/1ps

module tb_FIFO();

    // Khai báo các tham số khớp với thiết kế gốc
    parameter data_width = 8;
    parameter addr_width = 4;

    // Khai báo tín hiệu nội bộ để nối vào DUT (Device Under Test)
    logic clk;
    logic rst;
    logic wr_en;
    logic rd_en;
    logic [data_width - 1:0] wr_data;
    
    logic full;
    logic empty;
    logic [data_width - 1:0] rd_data;

    // 1. Khởi tạo thiết kế (Instantiation)
    FIFO #(
        .data_width(data_width),
        .addr_width(addr_width)
    ) dut (
        .clk(clk),
        .rst(rst),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .wr_data(wr_data),
        .full(full),
        .rd_data(rd_data),
        .empty(empty)
    );

    // 2. Tạo bộ phát xung nhịp (Clock Generator) - Chu kỳ 10ns (100MHz)
    always #5 clk = ~clk;

    // 3. Kịch bản kiểm tra (Test Sequence)
    initial begin
        // Trạng thái ban đầu
        clk = 0;
        wr_en = 0;
        rd_en = 0;
        wr_data = 0;

        // Reset hệ thống (Tích cực mức thấp theo logic if(!rst) của bạn)
        $display("[%0t] Áp dụng Reset...", $time);
        rst = 0;
        #20;
        rst = 1;
        #10;

        // ---------------------------------------------------------
        // Kịch bản 1: Test cờ FULL (Ghi liên tục 16 giá trị)
        // ---------------------------------------------------------
        $display("[%0t] BẮT ĐẦU TEST 1: Ghi dữ liệu cho đến khi FIFO đầy", $time);
        for (int i = 0; i < 16; i++) begin
            @(negedge clk); // Đợi sườn xuống để gán giá trị ổn định trước sườn lên
            wr_en = 1;
            wr_data = i + 8'hAA; // Ghi các giá trị AA, AB, AC...
        end
        @(negedge clk);
        wr_en = 0; // Ngừng ghi
        
        // Cố tình ghi thêm 1 byte khi đã FULL để xem mạch có chặn lại không
        @(negedge clk);
        wr_en = 1;
        wr_data = 8'hFF; 
        @(negedge clk);
        wr_en = 0;
        #20;

        // ---------------------------------------------------------
        // Kịch bản 2: Test cờ EMPTY (Đọc liên tục 16 giá trị)
        // ---------------------------------------------------------
        $display("[%0t] BẮT ĐẦU TEST 2: Đọc dữ liệu cho đến khi FIFO trống", $time);
        for (int i = 0; i < 16; i++) begin
            @(negedge clk);
            rd_en = 1;
        end
        @(negedge clk);
        rd_en = 0; // Ngừng đọc
        
        // Cố tình đọc thêm 1 byte khi đã EMPTY để kiểm tra mạch bảo vệ
        @(negedge clk);
        rd_en = 1;
        @(negedge clk);
        rd_en = 0;
        #20;

        // ---------------------------------------------------------
        // Kịch bản 3: Ghi và Đọc diễn ra cùng một lúc
        // ---------------------------------------------------------
        $display("[%0t] BẮT ĐẦU TEST 3: Đọc/Ghi đồng thời", $time);
        @(negedge clk);
        wr_en = 1; wr_data = 8'h55;
        rd_en = 1;
        @(negedge clk);
        wr_en = 0; rd_en = 0;

        // Kết thúc mô phỏng
        #50;
        $display("[%0t] MÔ PHỎNG HOÀN TẤT!", $time);
        $stop;
    end

endmodule