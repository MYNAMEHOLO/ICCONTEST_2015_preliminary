module SET ( clk , rst, en, central, radius, mode, busy, valid, candidate );

input clk, rst;
input en;
input [23:0] central;
input [11:0] radius;
input [1:0] mode;
output reg busy;
output reg valid;
output reg [7:0] candidate;
// write my code here //
parameter IDLE = 0,
          GET = 1,
          CAL = 2,
          SCAN_MVX = 3,
          SCAN_MVY = 4,
          SCAN_DONE = 5;


reg [ 5: 0] cs,ns;

// define here
reg [3:0] x1;
reg [3:0] x2;
reg [3:0] x3;
reg [3:0] y1;
reg [3:0] y2;
reg [3:0] y3;
reg [3:0] r1;
reg [3:0] r2;
reg [3:0] r3;
reg [1:0] mode_r;
reg [3:0] scan_x;
reg [3:0] scan_y;

// combinational assignment
wire [8:0] square_plus_1;
wire [8:0] square_plus_2;
wire [8:0] square_plus_3;
wire belong1;
wire belong2;
wire belong3;
wire belong1n2;
wire belong2n3;
wire belong1n3;
wire belong_all;

wire [3:0] sign_x1;
wire [3:0] sign_x2;
wire [3:0] sign_x3;
wire [3:0] sign_y1;
wire [3:0] sign_y2;
wire [3:0] sign_y3;
wire [3:0] sign_r1;
wire [3:0] sign_r2;
wire [3:0] sign_r3;

// square x1,y1 and r1;
wire [7:0] sign_square_x1;
wire [7:0] sign_square_y1;
wire [7:0] sign_square_x2;
wire [7:0] sign_square_y2;
wire [7:0] sign_square_x3;
wire [7:0] sign_square_y3;
wire [7:0] sign_square_r1;
wire [7:0] sign_square_r2;
wire [7:0] sign_square_r3;
//circle 1
assign sign_x1 = (scan_x <= x1)? (x1 - scan_x):(scan_x - x1);
assign sign_y1 = (scan_y <= y1)? (y1 - scan_y):(scan_y - y1);
assign sign_r1 = r1;

//circle 2
assign sign_x2 = (scan_x <= x2)? (x2 - scan_x):(scan_x - x2);
assign sign_y2 = (scan_y <= y2)? (y2 - scan_y):(scan_y - y2);
assign sign_r2 = r2;

//cirecle3
assign sign_x3 = (scan_x <= x3)? (x3 - scan_x):(scan_x - x3);
assign sign_y3 = (scan_y <= y3)? (y3 - scan_y):(scan_y - y3);
assign sign_r3 = r3;

//mult circle1
assign sign_square_x1 = sign_x1 * sign_x1;
assign sign_square_y1 = sign_y1 * sign_y1;
assign sign_square_r1 = sign_r1 * sign_r1;
assign square_plus_1 = sign_square_x1 + sign_square_y1;
assign belong1 = (square_plus_1 <= sign_square_r1)? 1'b1: 1'b0;

//mult circle2
assign sign_square_x2 = sign_x2 * sign_x2;
assign sign_square_y2 = sign_y2 * sign_y2;
assign sign_square_r2 = sign_r2 * sign_r2;
assign square_plus_2 = sign_square_x2 + sign_square_y2;
assign belong2 = (square_plus_2 <= sign_square_r2)? 1'b1: 1'b0;

//mult circle3
assign sign_square_x3 = sign_x3 * sign_x3;
assign sign_square_y3 = sign_y3 * sign_y3;
assign sign_square_r3 = sign_r3 * sign_r3;
assign square_plus_3 = sign_square_x3 + sign_square_y3;
assign belong3 = (square_plus_3 <= sign_square_r3)? 1'b1: 1'b0;

//belong judgement

assign belong1n2 = (belong1 && belong2);
assign belong2n3 = (belong2 && belong3);
assign belong1n3 = (belong1 && belong3);
assign belong_all = (belong1 && belong2 && belong3);

// FSM here
/// cs machine
always@(posedge clk or posedge rst)begin
    if(rst)begin
        cs <= 'd0;
        cs[IDLE] <= 1'd1;
    end
    else cs <= ns;
end

//ns machine
always@(*)begin
    ns = 'd0;
    case(1'd1)
        cs[IDLE]:begin
            if(en) ns[GET] = 1'd1;
            else ns[IDLE] = 1'd1;
        end
        cs[GET]: ns[CAL] = 1'd1;
        cs[CAL]:begin
            if(scan_x == 4'd8 && scan_y == 4'd8) ns[SCAN_DONE] = 1'd1;
            else if(scan_x == 4'd8) ns[SCAN_MVY] = 1'd1;
            else ns[SCAN_MVX] = 1'd1; 
        end
        cs[SCAN_MVX]: ns[CAL] = 1'd1;
        cs[SCAN_MVY]: ns[CAL] = 1'd1;
        cs[SCAN_DONE]: ns[IDLE] = 1'd1;
        default: ns[IDLE] = 1'd1;
    endcase
end

// registered output logic
always@(posedge clk or posedge rst)begin
    if(rst)begin
        busy <= 1'd0;
        valid <= 1'd0;
        candidate <= 'd0;
        x1 <= 'd0;
        x2 <= 'd0;
        x3 <= 'd0;
        y1 <= 'd0;
        y2 <= 'd0;
        y3 <= 'd0;
        r1 <= 'd0;
        r2 <= 'd0;
        r3 <= 'd0;
        scan_x <= 4'd1;
        scan_y <= 4'd1;
        mode_r <= 'd0;
    end
    else begin
        case(1'd1)
            cs[IDLE]:begin 
                busy <= 1'd0;
                valid <= 1'd0;
                candidate <= 'd0;
                scan_x <= 4'd1;
                scan_y <= 4'd1;
            end
            cs[GET]: begin
                busy <= 1'd1;
                x1 <= central[23:20];
                y1 <= central[19:16];
                x2 <= central[15:12];
                y2 <= central[11:8];
                x3 <= central[7:4];
                y3 <= central[3:0];
                r1 <= radius[11:8];
                r2 <= radius[7:4];
                r3 <= radius[3:0];
                mode_r <= mode;
            end
            cs[CAL]:begin
                case(mode_r)
                    2'b00:begin
                        candidate <= (belong1)? (candidate + 1'd1): candidate;
                    end
                    2'b01:begin
                        candidate <= (belong1n2)? (candidate + 1'd1): candidate;
                    end
                    2'b10:begin
                        if(belong1n2) candidate <= candidate;
                        else if(belong1 || belong2) candidate <= candidate + 1'd1;
                    end
                    2'b11:begin
                        if(belong_all) candidate <= candidate;
                        else if(belong1n2 || belong1n3 || belong2n3) candidate <= candidate + 1'd1;
                    end
                endcase
            end
            cs[SCAN_MVX]:begin
                scan_x <= scan_x + 1'd1;
            end
            cs[SCAN_MVY]:begin
                scan_x <= 4'd1;
                scan_y <= scan_y + 1'd1;
            end
            cs[SCAN_DONE]:begin
                scan_x <= 4'd1;
                scan_y <= 4'd1;
                valid <= 1'd1;
                busy <= 1'd1;
            end
        endcase
    end
end

// ending
endmodule


