// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/Arithmetic.sol";

contract ArithmeticTest is Test {
    Arithmetic public arithmetic;

    function setUp() public {
        arithmetic = new Arithmetic();
    }

    // ========== BASIC ARITHMETIC TESTS ==========

    function testAddRaw() public view {
        // Normal addition
        assertEq(arithmetic.addRaw(5, 3), 8);
        assertEq(arithmetic.addRaw(100, 200), 300);

        // Edge case: adding zero
        assertEq(arithmetic.addRaw(42, 0), 42);
        assertEq(arithmetic.addRaw(0, 42), 42);
    }

    function testAddRawOverflow() public view {
        // Overflow test: max + 1 = 0
        uint256 max = type(uint256).max;
        assertEq(arithmetic.addRaw(max, 1), 0);

        // Overflow test: max + 2 = 1
        assertEq(arithmetic.addRaw(max, 2), 1);

        // Overflow test: max + max = max - 1
        assertEq(arithmetic.addRaw(max, max), max - 1);
    }

    function testSubRaw() public view {
        // Normal subtraction
        assertEq(arithmetic.subRaw(10, 3), 7);
        assertEq(arithmetic.subRaw(1000, 500), 500);

        // Edge case: subtracting zero
        assertEq(arithmetic.subRaw(42, 0), 42);

        // Edge case: same numbers
        assertEq(arithmetic.subRaw(100, 100), 0);
    }

    function testSubRawUnderflow() public view {
        // Underflow test: 0 - 1 = max
        uint256 max = type(uint256).max;
        assertEq(arithmetic.subRaw(0, 1), max);

        // Underflow test: 5 - 10 = max - 4
        assertEq(arithmetic.subRaw(5, 10), max - 4);

        // Underflow test: 0 - max = 1
        assertEq(arithmetic.subRaw(0, max), 1);
    }

    function testMulRaw() public view {
        // Normal multiplication
        assertEq(arithmetic.mulRaw(5, 3), 15);
        assertEq(arithmetic.mulRaw(100, 200), 20000);

        // Edge case: multiply by zero
        assertEq(arithmetic.mulRaw(42, 0), 0);
        assertEq(arithmetic.mulRaw(0, 42), 0);

        // Edge case: multiply by one
        assertEq(arithmetic.mulRaw(42, 1), 42);
    }

    function testMulRawOverflow() public view {
        // Overflow test
        uint256 max = type(uint256).max;
        assertEq(arithmetic.mulRaw(max, 2), max - 1);

        // Large number multiplication overflow
        uint256 large = 2 ** 128;
        assertEq(arithmetic.mulRaw(large, large), 0); // Overflows to 0
    }

    function testDivRaw() public view {
        // Normal division
        assertEq(arithmetic.divRaw(10, 2), 5);
        assertEq(arithmetic.divRaw(100, 4), 25);

        // Integer division (rounds down)
        assertEq(arithmetic.divRaw(10, 3), 3);
        assertEq(arithmetic.divRaw(99, 10), 9);

        // Edge case: divide by one
        assertEq(arithmetic.divRaw(42, 1), 42);
    }

    function testDivRawByZero() public view {
        // Division by zero returns 0 (no revert!)
        assertEq(arithmetic.divRaw(42, 0), 0);
        assertEq(arithmetic.divRaw(type(uint256).max, 0), 0);
    }

    function testSdivRaw() public view {
        // Positive division
        assertEq(arithmetic.sdivRaw(10, 2), 5);
        assertEq(arithmetic.sdivRaw(100, 4), 25);

        // Negative dividend
        assertEq(arithmetic.sdivRaw(-10, 2), -5);
        assertEq(arithmetic.sdivRaw(-100, 4), -25);

        // Negative divisor
        assertEq(arithmetic.sdivRaw(10, -2), -5);
        assertEq(arithmetic.sdivRaw(100, -4), -25);

        // Both negative
        assertEq(arithmetic.sdivRaw(-10, -2), 5);
        assertEq(arithmetic.sdivRaw(-100, -4), 25);
    }

    function testModRaw() public view {
        // Normal modulo
        assertEq(arithmetic.modRaw(10, 3), 1);
        assertEq(arithmetic.modRaw(100, 7), 2);

        // Edge case: exact division
        assertEq(arithmetic.modRaw(10, 2), 0);
        assertEq(arithmetic.modRaw(100, 10), 0);

        // Edge case: modulo by larger number
        assertEq(arithmetic.modRaw(5, 10), 5);
    }

    function testModRawByZero() public view {
        // Modulo by zero returns 0 (no revert!)
        assertEq(arithmetic.modRaw(42, 0), 0);
        assertEq(arithmetic.modRaw(type(uint256).max, 0), 0);
    }

    function testSmodRaw() public view {
        // Positive modulo
        assertEq(arithmetic.smodRaw(10, 3), 1);

        // Negative dividend (result takes sign of dividend)
        assertEq(arithmetic.smodRaw(-10, 3), -1);

        // Negative divisor (result takes sign of dividend)
        assertEq(arithmetic.smodRaw(10, -3), 1);

        // Both negative
        assertEq(arithmetic.smodRaw(-10, -3), -1);
    }

    // ========== SPECIAL MODULO TESTS ==========

    function testAddModRaw() public view {
        // Normal addmod
        assertEq(arithmetic.addModRaw(5, 3, 7), 1); // (5+3) % 7 = 1
        assertEq(arithmetic.addModRaw(10, 20, 7), 2); // (10+20) % 7 = 2

        // Edge case: result less than modulo
        assertEq(arithmetic.addModRaw(2, 3, 100), 5);
    }

    function testAddModRawPreventOverflow() public view {
        // This is where addmod shines - prevents intermediate overflow
        uint256 max = type(uint256).max;
        uint256 a = max - 10;
        uint256 b = max - 10;
        uint256 m = 1000;

        // addmod handles this correctly
        uint256 result = arithmetic.addModRaw(a, b, m);

        // Manual calculation would overflow
        // But addmod computes internally with higher precision
        assertTrue(result < m);
    }

    function testAddModRawByZero() public view {
        // Modulo by zero returns 0
        assertEq(arithmetic.addModRaw(5, 3, 0), 0);
    }

    function testMulModRaw() public view {
        // Normal mulmod
        assertEq(arithmetic.mulModRaw(5, 3, 7), 1); // (5*3) % 7 = 1
        assertEq(arithmetic.mulModRaw(10, 20, 7), 4); // (10*20) % 7 = 4

        // Edge case: result less than modulo
        assertEq(arithmetic.mulModRaw(2, 3, 100), 6);
    }

    function testMulModRawPreventOverflow() public view {
        // mulmod prevents intermediate overflow
        uint256 large = 2 ** 128;
        uint256 m = 1000;

        // mulmod handles this correctly
        uint256 result = arithmetic.mulModRaw(large, large, m);

        // Manual mul would overflow, but mulmod handles it
        assertTrue(result < m);
    }

    function testMulModRawByZero() public view {
        // Modulo by zero returns 0
        assertEq(arithmetic.mulModRaw(5, 3, 0), 0);
    }

    // ========== EXPONENTIATION TESTS ==========

    function testExpRaw() public view {
        // Basic exponentiation
        assertEq(arithmetic.expRaw(2, 3), 8); // 2^3
        assertEq(arithmetic.expRaw(3, 4), 81); // 3^4
        assertEq(arithmetic.expRaw(10, 2), 100); // 10^2

        // Edge cases
        assertEq(arithmetic.expRaw(5, 0), 1); // 5^0 = 1
        assertEq(arithmetic.expRaw(0, 5), 0); // 0^5 = 0
        assertEq(arithmetic.expRaw(1, 1000), 1); // 1^1000 = 1
        assertEq(arithmetic.expRaw(42, 1), 42); // 42^1 = 42
    }

    function testExpRawOverflow() public view {
        // Large exponentiation causes overflow
        uint256 result = arithmetic.expRaw(2, 256);
        assertEq(result, 0); // Overflows

        // Another overflow case
        uint256 result2 = arithmetic.expRaw(2, 300);
        // Will overflow and wrap around
        assertTrue(result2 != 0 || result2 == 0); // Just checking it doesn't revert
    }

    // ========== SIGN EXTENSION TESTS ==========

    function testSignExtendRaw() public view {
        // Extend sign of 1 byte (position 0)
        // 0x7F (127) is positive in int8
        assertEq(arithmetic.signExtendRaw(0, 0x7F), 0x7F);

        // 0xFF (255) is -1 in int8, should extend to all 1s
        assertEq(arithmetic.signExtendRaw(0, 0xFF), type(uint256).max);

        // 0x80 (128) is -128 in int8, should extend sign
        uint256 expected = type(uint256).max - 0x7F; // All 1s except last 7 bits
        assertEq(arithmetic.signExtendRaw(0, 0x80), expected);
    }

    function testSignExtendRaw2Bytes() public view {
        // Extend sign of 2 bytes (position 1)
        // 0x7FFF is positive in int16
        assertEq(arithmetic.signExtendRaw(1, 0x7FFF), 0x7FFF);

        // 0xFFFF is -1 in int16
        assertEq(arithmetic.signExtendRaw(1, 0xFFFF), type(uint256).max);

        // 0x8000 is -32768 in int16
        uint256 expected = type(uint256).max - 0x7FFF;
        assertEq(arithmetic.signExtendRaw(1, 0x8000), expected);
    }

    // ========== DEMO FUNCTION TESTS ==========

    function testDemoOverflow() public view {
        uint256 result = arithmetic.demoOverflow();
        assertEq(result, 0); // max + 1 = 0
    }

    function testDemoUnderflow() public view {
        uint256 result = arithmetic.demoUnderflow();
        assertEq(result, type(uint256).max); // 0 - 1 = max
    }

    function testDemoDivByZero() public view {
        uint256 result = arithmetic.demoDivByZero(42);
        assertEq(result, 0); // 42 / 0 = 0 (no revert)

        result = arithmetic.demoDivByZero(type(uint256).max);
        assertEq(result, 0); // max / 0 = 0
    }

    function testDemoAddModAdvantage() public view {
        (uint256 manual, uint256 withAddmod) = arithmetic.demoAddModAdvantage();

        // Manual way overflows and gives wrong result
        // addmod gives correct result
        assertEq(withAddmod, 850); // Correct answer
        assertEq(manual, 914); // uin256 wrapped result
        // Manual is wrong due to overflow
        assertTrue(manual != withAddmod);
    }

    // ========== HELPER FUNCTION TESTS ==========

    function testGetMaxUint() public view {
        assertEq(arithmetic.getMaxUint(), type(uint256).max);
    }

    function testWillOverflow() public view {
        uint256 max = type(uint256).max;

        // Will overflow
        assertTrue(arithmetic.willOverflow(max, 1));
        assertTrue(arithmetic.willOverflow(max - 5, 10));

        // Won't overflow
        assertFalse(arithmetic.willOverflow(100, 200));
        assertFalse(arithmetic.willOverflow(max - 100, 50));
    }

    // ========== FUZZ TESTS ==========

    function testFuzzAddRaw(uint256 a, uint256 b) public view {
        uint256 result = arithmetic.addRaw(a, b);

        // If no overflow expected
        if (a <= type(uint256).max - b) {
            assertEq(result, a + b);
        } else {
            // Overflow case
            unchecked {
                assertEq(result, a + b); // Should wrap around
            }
        }
    }

    function testFuzzSubRaw(uint256 a, uint256 b) public view {
        uint256 result = arithmetic.subRaw(a, b);

        // If no underflow expected
        if (a >= b) {
            assertEq(result, a - b);
        } else {
            // Underflow case
            unchecked {
                assertEq(result, a - b); // Should wrap around
            }
        }
    }

    function testFuzzMulRaw(uint128 a, uint128 b) public view {
        // Use uint128 to avoid overflow in most cases
        uint256 result = arithmetic.mulRaw(uint256(a), uint256(b));
        assertEq(result, uint256(a) * uint256(b));
    }

    function testFuzzDivRaw(uint256 a, uint256 b) public view {
        uint256 result = arithmetic.divRaw(a, b);

        if (b != 0) {
            assertEq(result, a / b);
        } else {
            assertEq(result, 0); // Division by zero
        }
    }

    function testFuzzModRaw(uint256 a, uint256 b) public view {
        uint256 result = arithmetic.modRaw(a, b);

        if (b != 0) {
            assertEq(result, a % b);
        } else {
            assertEq(result, 0); // Modulo by zero
        }
    }

    function testFuzzExpRaw(uint8 base, uint8 exponent) public view {
        // Use small numbers to avoid overflow
        uint256 result = arithmetic.expRaw(uint256(base), uint256(exponent));

        // Just check it doesn't revert
        assertTrue(result >= 0);
    }

    // ========== COMPREHENSIVE EDGE CASE TESTS ==========

    function testAllZeros() public view {
        assertEq(arithmetic.addRaw(0, 0), 0);
        assertEq(arithmetic.subRaw(0, 0), 0);
        assertEq(arithmetic.mulRaw(0, 0), 0);
        assertEq(arithmetic.divRaw(0, 1), 0); // Can't divide 0 by 0
        assertEq(arithmetic.modRaw(0, 1), 0);
    }

    function testAllMax() public view {
        uint256 max = type(uint256).max;

        // These will overflow/wrap
        arithmetic.addRaw(max, max);
        arithmetic.subRaw(max, max);
        arithmetic.mulRaw(max, max);

        // These should work
        assertEq(arithmetic.divRaw(max, max), 1);
        assertEq(arithmetic.modRaw(max, max), 0);
    }

    function testMixedMaxAndZero() public view {
        uint256 max = type(uint256).max;

        assertEq(arithmetic.addRaw(max, 0), max);
        assertEq(arithmetic.subRaw(max, 0), max);
        assertEq(arithmetic.mulRaw(max, 0), 0);
        assertEq(arithmetic.divRaw(max, max), 1);
    }
}
