// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {console} from "forge-std/console.sol";

contract Arithmetic {
    // ========== BASIC ARITHMETIC ==========

    /// @notice ADD opcode langsung - no overflow protection
    function addRaw(uint256 a, uint256 b) external pure returns (uint256 result) {
        assembly {
            result := add(a, b) // ADD opcode (0x01)
        }
    }

    /// @notice SUB opcode langsung - bisa underflow
    function subRaw(uint256 a, uint256 b) external pure returns (uint256 result) {
        assembly {
            result := sub(a, b) // SUB opcode (0x03)
        }
    }

    /// @notice MUL opcode langsung - no overflow protection
    function mulRaw(uint256 a, uint256 b) external pure returns (uint256 result) {
        assembly {
            result := mul(a, b) // MUL opcode (0x02)
        }
    }

    /// @notice DIV opcode langsung - returns 0 if b == 0
    function divRaw(uint256 a, uint256 b) external pure returns (uint256 result) {
        assembly {
            result := div(a, b) // DIV opcode (0x04)
        }
    }

    /// @notice SDIV - signed division
    function sdivRaw(int256 a, int256 b) external pure returns (int256 result) {
        assembly {
            result := sdiv(a, b) // SDIV opcode (0x05)
        }
    }

    /// @notice MOD opcode langsung - returns 0 if b == 0
    function modRaw(uint256 a, uint256 b) external pure returns (uint256 result) {
        assembly {
            result := mod(a, b) // MOD opcode (0x06)
        }
    }

    /// @notice SMOD - signed modulo
    function smodRaw(int256 a, int256 b) external pure returns (int256 result) {
        assembly {
            result := smod(a, b) // SMOD opcode (0x07)
        }
    }

    // ========== SPECIAL MODULO OPS ==========

    /// @notice ADDMOD - (a + b) % m with arbitrary precision
    function addModRaw(uint256 a, uint256 b, uint256 m) external pure returns (uint256 result) {
        assembly {
            result := addmod(a, b, m) // ADDMOD opcode (0x08)
        }
        // Kalau m == 0, returns 0
    }

    /// @notice MULMOD - (a * b) % m with arbitrary precision
    function mulModRaw(uint256 a, uint256 b, uint256 m) external pure returns (uint256 result) {
        assembly {
            result := mulmod(a, b, m) // MULMOD opcode (0x09)
        }
        // Ini powerful karena compute (a*b) di precision > 256 bit sebelum mod
    }

    // ========== EXPONENTIATION ==========

    /// @notice EXP opcode - base ** exponent
    function expRaw(uint256 base, uint256 exponent) external pure returns (uint256 result) {
        assembly {
            result := exp(base, exponent) // EXP opcode (0x0A)
        }
    }

    // ========== SIGN EXTENSION ==========

    /// @notice SIGNEXTEND - extend sign of byte
    /// @param b byte position (0-31)
    /// @param x value to extend
    function signExtendRaw(uint256 b, uint256 x) external pure returns (uint256 result) {
        assembly {
            result := signextend(b, x) // SIGNEXTEND opcode (0x0B)
        }
        // Contoh: signextend(0, 0xFF) = 0xFFFF...FF (negative)
        //         signextend(0, 0x7F) = 0x7F (positive)
    }

    // ========== DEMO FUNCTIONS - MENUNJUKKAN BEHAVIOR ==========

    /// @notice Demo overflow behavior
    /// @dev Panggil dengan (type(uint256).max, 1) untuk liat overflow
    function demoOverflow() external pure returns (uint256) {
        uint256 max = type(uint256).max;
        assembly {
            let result := add(max, 1) // Overflow! Result = 0
            mstore(0x0, result)
            return(0x0, 0x20)
        }
    }

    /// @notice Demo underflow behavior
    /// @dev Panggil dengan (0, 1) untuk liat underflow
    function demoUnderflow() external pure returns (uint256) {
        assembly {
            let result := sub(0, 1) // Underflow! Result = type(uint256).max
            mstore(0x0, result)
            return(0x0, 0x20)
        }
    }

    /// @notice Demo division by zero behavior
    function demoDivByZero(uint256 a) external pure returns (uint256) {
        assembly {
            let result := div(a, 0) // Returns 0, no revert!
            mstore(0x0, result)
            return(0x0, 0x20)
        }
    }

    /// @notice Demo ADDMOD advantage over manual mod
    /// @dev Shows why addmod is useful for preventing intermediate overflow
    function demoAddModAdvantage() external pure returns (uint256 manual, uint256 withAddmod) {
        uint256 a = type(uint256).max - 10;
        uint256 b = type(uint256).max - 10;
        uint256 m = 1000;
        console.log("a:", a);
        console.log("b:", b);
        console.log("m:", m);

        uint256 sum;

        // Manual way - akan overflow di intermediate step
        assembly {
            sum := add(a, b) // OVERFLOW!
            manual := mod(sum, m)
        }

        console.log("sum:", sum); // ADD THIS!
        console.log("manual:", manual);

        // ADDMOD way - tidak overflow karena internal precision lebih besar
        assembly {
            withAddmod := addmod(a, b, m) // CORRECT!
        }
    }

    // ========== HELPER VIEW FUNCTIONS ==========

    /// @notice Get max uint256 value
    function getMaxUint() external pure returns (uint256) {
        return type(uint256).max;
    }

    /// @notice Check if overflow would occur
    function willOverflow(uint256 a, uint256 b) external pure returns (bool) {
        return a > type(uint256).max - b;
    }
}
