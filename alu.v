module alu(input [31:0] a, b,
           input [2:0] f,
           output [31:0] result,
           output zero,
           output overflow,
           output carry,
           output negative);
    
    wire [31:0] b_tmp;
    wire [31:0] sum;
    wire of;

    assign b_tmp = (f[0] == 1'b1) ? ~b : b;
    assign sum = a + b_tmp + f[0];
    assign of = ~(a[31] ^ b[31] ^ f[0]) & (a[31] ^ sum[31]) & ~f[1];

    assign result = (f == 3'b000 || f == 3'b001) ? sum[31:0] :
                    (f == 3'b010) ? (a & b) :
                    (f == 3'b011) ? (a | b) :
                    (f == 3'b101) ? {31'b0, of ^ sum[31]} :
                    32'b0;
    
    assign zero = &(~result);
    assign overflow = of;
    assign carry = sum[31] & ~f[1];
    assign negative = result[31];

endmodule
