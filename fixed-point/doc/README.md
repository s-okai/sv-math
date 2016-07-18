# fixed-point
SystemVerilog package for fixed-point arithmetic.

## Function Summary
|Type|Function|Synthesizable?|
|:------------|:------------------------------------------------------------------------------------------------|:----|
|`int`        |`fixed_point::get_width(FixedPoint a)`                                                           |Yes  |
|`FixedPoint` |`fixed_point::clean_value(FixedPoint a)`                                                         |Yes  |
|`FixedPoint` |`fixed_point::convert(FixedPoint a, int new_M, int new_Q)`                                       |Yes  |
|`FixedPoint` |`fixed_point::add(FixedPoint a, FixedPoint b)`                                                   |Yes  |
|`FixedPoint` |`fixed_point::subtract(FixedPoint a, FixedPoint b)`                                              |Yes  |
|`FixedPoint` |`fixed_point::multiply(FixedPoint a, FixedPoint b)`                                              |Yes  |
|`logic`      |`fixed_point::equal(FixedPoint a, FixedPoint b)`                                                 |Yes  |
|`FixedPoint` |`fixed_point::real_to_fixed(real real_val, int M, int Q)`                                        |Yes* |
|`FixedPoint` |`fixed_point::signed_to_fixed(logic signed [MAX_FIXED_POINT_WIDTH-1:0] signed_val, int M, int Q)`|Yes  |
|`FixedPoint` |`fixed_point::longint_to_fixed(longint int_val, int M, int Q)`                                   |Yes  |
|`FixedPoint` |`fixed_point::int_to_fixed(int int_val, int M, int Q)`                                           |Yes  |
|`real`       |`fixed_point::fixed_to_real(int int_val, int M, int Q)`                                          |Yes* |
|`void`       |`fixed_point::print(FixedPoint a)`                                                               |No   |

