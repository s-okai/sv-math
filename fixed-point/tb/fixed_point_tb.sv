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
            value : 64'h3fff_ffff_ffff_ffff
        };

        // Test convert(), increase M
        a = convert(a, 16, 16);
        assert(a.M == 16) else $error("Failed to increase M: Incorrect M.");
        assert(a.Q == 16) else $error("Failed to increase M: Incorrect Q.");
        assert(a.value == 64'h1fff_ffff_ffff_ffff) else $error("Failed to increase M: Incorrect value.");

        // Test convert(), decrease M
        a = convert(a, 15, 16);
        assert(a.M == 15) else $error("Failed to decrease M: Incorrect M.");
        assert(a.Q == 16) else $error("Failed to decrease M: Incorrect Q.");
        assert(a.value == 64'h3fff_ffff_ffff_fffe) else $error("Failed to decrease M: Incorrect value.");

        // Test convert(), increase Q
        a = convert(a, 15, 17);
        assert(a.M == 15) else $error("Failed to increase Q: Incorrect M.");
        assert(a.Q == 17) else $error("Failed to increase Q: Incorrect Q.");
        assert(a.value == 64'h3fff_ffff_ffff_fffe) else $error("Failed to increase Q: Incorrect value.");

        // Test convert(), decrease Q
        a = convert(a, 15, 16);
        assert(a.M == 15) else $error("Failed to decrease Q: Incorrect M.");
        assert(a.Q == 16) else $error("Failed to decrease Q: Incorrect Q.");
        assert(a.value == 64'h3fff_ffff_ffff_fffe) else $error("Failed to decrease Q: Incorrect value.");
    endfunction

    initial
        begin

        test_convert();

        // TODO: Test same format arithemtic
        a = '{
            M : 15,
            Q : 16,
            value : 64'h3fff_ffff_ffff_ffff
        };

        b = '{
            M : 15,
            Q : 16,
            value : 64'h4000_0000_0000_0000
        };

        // Test addition with same format.
        c = add(a, b);
        assert(c.M == 15);
        assert(c.Q == 16);
        assert(c.value == 64'h7fff_ffff_ffff_ffff);

        // TODO: Test subtract with same format.


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
        c = mult(a, b);
        assert(c.M == 30);
        assert(c.Q == 16);
        assert(c.value == 64'h0000_000C_0000_0000);

        // TODO: Test non-same format.

    end

endmodule
