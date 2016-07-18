/*  Unit Tests for Fixed-point Arithemetic Package
 *
 *  Description:
 *      Units tests for the fixed-point arithemtic package.
 *
 *  Synthesizable:
 *      No.
 *
 *  References:
 *      None.
 *
 *  Notes:
 *      None.
 *
 */

import fixed_point::*;

module fixed_point_tb();

    FixedPoint a;
    FixedPoint b;
    FixedPoint c;

    function void test_convert();
        FixedPoint a;
        a = '{
            M : 15,
            Q : 16,
            value : 64'h3fff_ffff_ffff_ffff // NOTE: This value is not "clean"
        };

        // Test convert(), increase M
        a = convert(a, 16, 16);
        assert(a.M == 16) else $error("Failed to increase M: Incorrect M.");
        assert(a.Q == 16) else $error("Failed to increase M: Incorrect Q.");
        assert(a.value == 64'h1fff_ffff_8000_0000) else $error("Failed to increase M: Incorrect value.");

        // Test convert(), decrease M
        a = convert(a, 15, 16);
        assert(a.M == 15) else $error("Failed to decrease M: Incorrect M.");
        assert(a.Q == 16) else $error("Failed to decrease M: Incorrect Q.");
        assert(a.value == 64'h3fff_ffff_0000_0000) else $error("Failed to decrease M: Incorrect value.");

        // Test convert(), increase Q
        a = convert(a, 15, 17);
        assert(a.M == 15) else $error("Failed to increase Q: Incorrect M.");
        assert(a.Q == 17) else $error("Failed to increase Q: Incorrect Q.");
        assert(a.value == 64'h3fff_ffff_0000_0000) else $error("Failed to increase Q: Incorrect value.");

        // Test convert(), decrease Q
        a = convert(a, 15, 16);
        assert(a.M == 15) else $error("Failed to decrease Q: Incorrect M.");
        assert(a.Q == 16) else $error("Failed to decrease Q: Incorrect Q.");
        assert(a.value == 64'h3fff_ffff_0000_0000) else $error("Failed to decrease Q: Incorrect value.");
    endfunction

    function void test_add();
        FixedPoint a;
        FixedPoint b;
        FixedPoint c;

        a = '{
            M : 15,
            Q : 16,
            value : 64'h3fff_ffff_ffff_ffff // NOTE: This value is not "clean"
        };

        b = '{
            M : 15,
            Q : 16,
            value : 64'h4000_0000_0000_0000
        };

        // Test addition with same format.
        c = add(a, b);
        assert(c.M == 15) else $error("Failed to add values: Incorrect M.");
        assert(c.Q == 16) else $error("Failed to add values: Incorrect Q.");
        assert(c.value == 64'h7fff_ffff_0000_0000) else $error("Failed to add values: Incorrect value.");
    endfunction

	function void test_subtract();
        FixedPoint a;
        FixedPoint b;
        FixedPoint c;

        a = '{
            M : 15,
            Q : 16,
            value : 64'h4000_0000_0000_0000
        };

        b = '{
            M : 15,
            Q : 16,
            value : 64'h3fff_ffff_ffff_ffff // NOTE: This value is not "clean"
        };

        // Test addition with same format.
        c = subtract(a, b);
        assert(c.M == 15) else $error("Failed to subtract values: Incorrect M.");
        assert(c.Q == 16) else $error("Failed to subtract values: Incorrect Q.");
        assert(c.value == 64'h0000_0001_0000_0000) else $error("Failed to subtract values: Incorrect value.");
    endfunction

    // TODO: Should handle case where inputs are not "clean"
    function void test_multiply();
        FixedPoint a;
        FixedPoint b;
        FixedPoint c;

        a = '{
            M : 15,
            Q : 16,
            value : 64'h0003_0000_0000_0000
        };

        b = '{
            M : 15,
            Q : 16,
            value : 64'h0002_0000_0000_0000
        };

        // Test multiply with same format.
        c = multiply(a, b);
        assert(c.M == 30) else $error("Failed to multiply values: Incorrect M.");
        assert(c.Q == 16) else $error("Failed to multiply values: Incorrect Q.");
        assert(c.value == 64'h0000_000C_0000_0000) else $error("Failed to multiply values: Incorrect value.");
    endfunction

    function void test_signed_to_fixed();
        logic signed [23:0] a;
        FixedPoint b;

        a = 10;
        b = signed_to_fixed(a, 15, 16);
        assert(b.M == 15) else $error("Failed to cast from positive signed to fixed: Incorrect M.");
        assert(b.Q == 16) else $error("Failed to cast from postive signed to fixed: Incorrect Q.");
        assert(b.value == 64'h000A_0000_0000_0000) else $error("Failed to cast from positive signed to fixed: Incorrect value.");

        a = -10;
        b = signed_to_fixed(a, 15, 16);
        assert(b.M == 15) else $error("Failed to cast from negative signed to fixed: Incorrect M.");
        assert(b.Q == 16) else $error("Failed to cast from negative signed to fixed: Incorrect Q.");
        assert(b.value == 64'hFFF6_0000_0000_0000) else $error("Failed to cast from negative signed to fixed: Incorrect value.");
    endfunction

    function void test_longint_to_fixed();
        longint a;
        FixedPoint b;

        a = 10;
        b = longint_to_fixed(a, 15, 16);
        assert(b.M == 15) else $error("Failed to cast from positive longint to fixed: Incorrect M.");
        assert(b.Q == 16) else $error("Failed to cast from positive longint to fixed: Incorrect Q.");
        assert(b.value == 64'h000A_0000_0000_0000) else $error("Failed to cast from positive longint to fixed: Incorrect value.");

        a = -10;
        b = longint_to_fixed(a, 15, 16);
        assert(b.M == 15) else $error("Failed to cast from negative longint to fixed: Incorrect M.");
        assert(b.Q == 16) else $error("Failed to cast from negative longint to fixed: Incorrect Q.");
        assert(b.value == 64'hFFF6_0000_0000_0000) else $error("Failed to cast from negative longint to fixed: Incorrect value.");
    endfunction

    function void test_int_to_fixed();
        int a;
        FixedPoint b;

        a = 10;
        b = int_to_fixed(a, 15, 16);
        assert(b.M == 15) else $error("Failed to cast from positive int to fixed: Incorrect M.");
        assert(b.Q == 16) else $error("Failed to cast from positive int to fixed: Incorrect Q.");
        assert(b.value == 64'h000A_0000_0000_0000) else $error("Failed to cast from positive int to fixed: Incorrect value.");

        a = -10;
        b = int_to_fixed(a, 15, 16);
        assert(b.M == 15) else $error("Failed to cast from negative int to fixed: Incorrect M.");
        assert(b.Q == 16) else $error("Failed to cast from negative int to fixed: Incorrect Q.");
        assert(b.value == 64'hFFF6_0000_0000_0000) else $error("Failed to cast from negative int to fixed: Incorrect value.");
    endfunction

    function void test_real_to_fixed();
        real a;
        FixedPoint b;

        a = 2.5;
        b = real_to_fixed(a, 15, 16);
        assert(b.M == 15) else $error("Failed to cast from positive real to fixed: Incorrect M.");
        assert(b.Q == 16) else $error("Failed to cast from positive real to fixed: Incorrect Q.");
        assert(b.value == 64'h0002_8000_0000_0000) else $error("Failed to cast from positive real to fixed: Incorrect value.");

        //return b;
        a = -2.5;
        b = real_to_fixed(a, 15, 16);
        assert(b.M == 15) else $error("Failed to cast from negative real to fixed: Incorrect M.");
        assert(b.Q == 16) else $error("Failed to cast from negative real to fixed: Incorrect Q.");
        assert(b.value == 64'hFFFD_8000_0000_0000) else $error("Failed to cast from negative real to fixed: Incorrect value.");
    endfunction

    function void test_equal();
        FixedPoint a;
        FixedPoint b;

        a = '{
            M : 15,
            Q : 16,
            value : 64'h4000_0000_0000_0000
        };

        b = '{
            M : 15,
            Q : 16,
            value : 64'h4000_0000_ffff_ffff
        };

        // Test addition with same format.
        assert(equal(a, b)) else $error("Failed comparison: equal() failed on unclean values.");
        assert(!equal(real_to_fixed(2.0, 15, 16), real_to_fixed(2.5, 15, 16))) else $error("Failed comparison: equal() failed on non-equal values.");
        assert(equal(real_to_fixed(2.5, 15, 16), real_to_fixed(2.5, 15, 16))) else $error("Failed comparison: equal() failed on equal values.");
    endfunction

    initial
        begin

        // Test convert()
        test_convert();

        // Test add()
        test_add();

        // Test subtract()
        test_subtract();

        // Test mult()
        test_multiply();

        // TODO: Test non-same format.

        // Test signed_to_fixed()
        test_signed_to_fixed();

        // Test longint_to_fixed()
        test_longint_to_fixed();

        // Test int_to_fixed()
        test_int_to_fixed();

        // Test real_to_fixed()
        test_real_to_fixed();

        // Test equal()
        test_equal();
        $stop;
    end

endmodule
