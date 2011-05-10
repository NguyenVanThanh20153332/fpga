module VgaSyncGenerator(
    input  clk,
    output _hSync,
    output _vSync,
    output reg isVisible,
    output reg [9:0] counterX,
    output reg [8:0] counterY
);
    
    reg hSync, vSync;
    
    localparam [9:0] H_ACTIVE    = 10'd639;
    localparam [9:0] H_SYNC_LO   = 10'd656;
    localparam [9:0] H_SYNC_HI   = 10'd751;
    localparam [9:0] H_MAX       = 10'd799;
    
    localparam [8:0] V_ACTIVE    = 9'd479;
    localparam [8:0] V_SYNC_LO   = 9'd491;
    localparam [8:0] V_SYNC_HI   = 9'd492;
    localparam [8:0] V_MAX       = 9'd523;
         
    wire xIsMaxed = counterX == H_MAX;
    wire yIsMaxed = counterY == V_MAX;
    
    always @(posedge clk) begin
        if(xIsMaxed) begin
            counterX <= 0;
            counterY <= yIsMaxed ? 0 : counterY + 1;
        end else
            counterX <= counterX + 1;
    end
            
    always @(posedge clk) begin
        hSync <= H_SYNC_LO <= counterX && counterX <= H_SYNC_HI;
        vSync <= V_SYNC_LO <= counterY && counterY <= V_SYNC_HI;
        
        isVisible = counterX < H_ACTIVE && counterY < V_ACTIVE;
    end
            
    assign _hSync = ~hSync;
    assign _vSync = ~vSync;
endmodule