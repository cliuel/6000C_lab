module bram11 
(
    input   wire            CLK,
    input   wire    [3:0]   WE,
    input   wire            EN,
    input   wire    [31:0]  Di,
    output  reg     [31:0]  Do,  // 修改为寄存器
    input   wire    [11:0]   A
);

    //  11 words
    reg [31:0] RAM[0:10];
    reg [11:0] r_A;

    always @(posedge CLK) begin
        r_A <= A;
    end

    always @(posedge CLK) begin
        if (EN) begin
            if (WE != 4'b0000) begin
                // 直接更新 Do 以匹配写入的数据
                Do <= Di;
            end
            else begin
                // 读模式：Do 输出 RAM[r_A>>2]
                if (r_A>>2 < 11)
                    Do <= RAM[r_A>>2];
                else
                    Do <= 32'h00000000;  // 防止访问超出范围
            end
        end
    end

    always @(posedge CLK) begin
        if (EN) begin
            if (WE[0]) RAM[A>>2][7:0]  <= Di[7:0];
            if (WE[1]) RAM[A>>2][15:8] <= Di[15:8];
            if (WE[2]) RAM[A>>2][23:16] <= Di[23:16];
            if (WE[3]) RAM[A>>2][31:24] <= Di[31:24];
        end
    end

endmodule
