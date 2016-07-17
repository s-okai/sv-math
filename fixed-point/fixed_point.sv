/*  Fixed-point Arithemetic Package
 *
 *  Description:
 *      A fixed-point arithemtic package.
 *
 *  Synthesizable:
 *      Yes.
 *
 *  References:
 *      None.
 *
 *  Notes:
 *      None.
 *
 */

package fixed_point;
    localparam MAX_FIXED_POINT_WIDTH = 64;  // Max width a fixed-point value can take.

    typedef struct packed {
        int M;  // # of integer bits.
        int Q;  // # of fractional bits.
        logic signed [(MAX_FIXED_POINT_WIDTH-1):0] value;   // Binary value, left-justified. Includes additional sign-bit.
    } FixedPoint;

    // TODO: Returns the width of the fixed-point value. width = M + Q + 1 (signed bit)
    function int get_width(FixedPoint a);
        return a.M + a.Q + 1;
    endfunction

    function int max(int a, int b);
        return (a > b) ? a : b;
    endfunction

    function int min(int a, int b);
        return (a < b) ? a : b;
    endfunction

    function FixedPoint set_value;
        input FixedPoint fp;
        input signed [(MAX_FIXED_POINT_WIDTH-1):0] value;

        fp.value = value << (MAX_FIXED_POINT_WIDTH - get_width(fp));

        set_value = fp;
    endfunction

    function FixedPoint convert(FixedPoint a, int new_M, int new_Q);
        FixedPoint converted_a;

        // Zero out value field so we don't end up with X's
        converted_a.value = 0;

        // If new Q is larger, need to << to right pad, otherwise need to >>> to right truncate.
        //convert.value = (new_Q > a.Q) ? (a.value << (new_Q - a.Q)) : (a.value >>> (a.Q - new_Q));

        // If new M is larger, need to >>> to left pad, otherwise need to << to left truncate.
        converted_a.value = (new_M > a.M) ? (a.value >>> (new_M - a.M)) : (a.value << (a.M - new_M));

        // Take on the new M and Q.
        converted_a.M = new_M;
        converted_a.Q = new_Q;

        return converted_a;
    endfunction

    // Returns the sum of a and b in significant figures.
    function FixedPoint add(FixedPoint a, FixedPoint b);
        FixedPoint ext_a;
        FixedPoint ext_b;
        FixedPoint c;

        // Extend both values for addition.
        ext_a = convert(a, max(a.M, b.M), max(a.Q, b.Q));
        ext_b = convert(b, max(a.M, b.M), max(a.Q, b.Q));

        // NOTE: This assumes no overflow...
        // Get # of relevant bits for addition.
        c.M = ext_a.M;
        c.Q = ext_a.Q;

        //add.value = ext_a.value[(MAX_FIXED_POINT_WIDTH-1):(MAX_FIXED_POINT_WIDTH-max_width)] + ext_b.value[(MAX_FIXED_POINT_WIDTH-1):(MAX_FIXED_POINT_WIDTH-max_width)];
        c.value = ext_a.value + ext_b.value;

        // Reduce based on significant figures.
        c = convert(c, max(a.M, b.M), min(a.Q, b.Q));

        return c;
    endfunction

    // Returns the difference of a and b in significant figures.
    function FixedPoint subtract(FixedPoint a, FixedPoint b);
        FixedPoint ext_a;
        FixedPoint ext_b;
        FixedPoint c;

        // Extend both values for subtraction.
        ext_a = convert(a, max(a.M, b.M), max(a.Q, b.Q));
        ext_b = convert(b, max(a.M, b.M), max(a.Q, b.Q));

        // NOTE: This assumes no overflow...
        // Get # of relevant bits for subtraction.
        c.M = ext_a.M;
        c.Q = ext_a.Q;

        //subtract.value = ext_a.value[(MAX_FIXED_POINT_WIDTH-1):(MAX_FIXED_POINT_WIDTH-max_width)] - ext_b.value[(MAX_FIXED_POINT_WIDTH-1):(MAX_FIXED_POINT_WIDTH-max_width)];
        c.value = ext_a.value - ext_b.value;

        // Reduce based on significant figures.
        c = convert(c, max(a.M, b.M), min(a.Q, b.Q));

        return c;
    endfunction

    // TODO: mult
    function FixedPoint mult(FixedPoint a, FixedPoint b);
        FixedPoint c;

        logic signed [((MAX_FIXED_POINT_WIDTH * 2)-1):0] temp_value;

        // NOTE: This assumes no overflow...
        // Reduce based on significant figures. Sorta.
        c.M = a.M + b.M;
        c.Q = min(a.Q, b.Q);

        // Multiply.
        temp_value = a.value * b.value;
        temp_value = temp_value << 1;   // Remove extra sign bit.
        c.value = temp_value >>> MAX_FIXED_POINT_WIDTH; // Shift the result to get desired width.

        return c;
    endfunction

    // TODO: mult2

    // TODO: div2

endpackage // fixed-point
