module FIFO #(
    parameter data_width = 8,
    parameter addr_width = 4
) (
    input logic clk , rst ,
    input logic wr_en , rd_en ,
    input logic [data_width - 1:0] wr_data,
    output logic full,
    output logic [data_width - 1:0] rd_data ,
    output logic empty
);  
    localparam  Depth = 1 << addr_width ;
    logic [data_width - 1:0] mem [0:Depth - 1];
    logic [addr_width:0] rdptr , wrptr ;
    logic [addr_width:0] next_rdptr ,next_wrptr ;

    assign next_rdptr = rdptr + 1;
    assign next_wrptr = wrptr + 1;  

    always @(posedge clk ) begin
        if(!rst) begin
        wrptr <= 0 ;
        end
        else if(wr_en && !full) begin
        mem[wrptr[addr_width - 1:0]] <= wr_data;
        wrptr <= next_wrptr ;
        end
    end
    always @(posedge clk ) begin
        if(!rst) begin
            rd_data <= 0;
            rdptr <= 0;
        end
        else if (rd_en && !empty) begin
            rd_data <= mem[rdptr[addr_width-1:0]];
            rdptr <= next_rdptr;
        end
    end
    
    assign empty = (wrptr == rdptr);
    
    assign full = (wrptr[addr_width] != rdptr[addr_width])&&
                (wrptr[addr_width-1:0] == rdptr[addr_width-1:0]);
    
endmodule