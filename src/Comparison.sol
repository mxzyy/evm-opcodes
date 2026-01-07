// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

contract Comparison {
    // ========== COMPARISON OPERATIONS ==========

    /// @notice LT - Less Than (unsigned)
    function ltRaw(uint256 a, uint256 b) external pure returns (bool result) {
        assembly {
            result := lt(a, b) // LT opcode (0x10)
        }
    }

    /// @notice GT - Greater Than (unsigned)
    function gtRaw(uint256 a, uint256 b) external pure returns (bool result) {
        assembly {
            result := gt(a, b) // GT opcode (0x11)
        }
    }

    /// @notice SLT - Signed Less Than
    function sltRaw(int256 a, int256 b) external pure returns (bool result) {
        assembly {
            result := slt(a, b) // SLT opcode (0x12)
        }
    }

    /// @notice SGT - Signed Greater Than
    function sgtRaw(int256 a, int256 b) external pure returns (bool result) {
        assembly {
            result := sgt(a, b) // SGT opcode (0x13)
        }
    }

    /// @notice EQ - Equality check
    function eqRaw(uint256 a, uint256 b) external pure returns (bool result) {
        assembly {
            result := eq(a, b) // EQ opcode (0x14)
        }
    }

    /// @notice ISZERO - Check if value is zero
    function isZeroRaw(uint256 a) external pure returns (bool result) {
        assembly {
            result := iszero(a) // ISZERO opcode (0x15)
        }
    }

    // ========== BITWISE LOGIC OPERATIONS ==========

    /// @notice AND - Bitwise AND
    function andRaw(uint256 a, uint256 b) external pure returns (uint256 result) {
        assembly {
            result := and(a, b) // AND opcode (0x16)
        }
    }

    /// @notice OR - Bitwise OR
    function orRaw(uint256 a, uint256 b) external pure returns (uint256 result) {
        assembly {
            result := or(a, b) // OR opcode (0x17)
        }
    }

    /// @notice XOR - Bitwise XOR
    function xorRaw(uint256 a, uint256 b) external pure returns (uint256 result) {
        assembly {
            result := xor(a, b) // XOR opcode (0x18)
        }
    }

    /// @notice NOT - Bitwise NOT (one's complement)
    function notRaw(uint256 a) external pure returns (uint256 result) {
        assembly {
            result := not(a) // NOT opcode (0x19)
        }
    }

    // ========== REAL-WORLD USE CASES ==========

    /// @notice Check if address is zero address
    function isZeroAddress(address addr) external pure returns (bool) {
        assembly {
            let result := iszero(addr)
            mstore(0x0, result)
            return(0x0, 0x20)
        }
    }

    /// @notice Compare two addresses for equality
    function addressesEqual(address a, address b) external pure returns (bool) {
        assembly {
            let result := eq(a, b)
            mstore(0x0, result)
            return(0x0, 0x20)
        }
    }

    /// @notice Check if value is within range [min, max]
    function inRange(uint256 value, uint256 minValue, uint256 maxValue) external pure returns (bool) {
        assembly {
            // value >= min AND value <= max
            let geMin := iszero(lt(value, minValue))
            let leMax := iszero(gt(value, maxValue))
            let result := and(geMin, leMax)
            mstore(0x0, result)
            return(0x0, 0x20)
        }
    }

    /// @notice Bit flags example - check if specific bit is set
    /// @dev Used for permissions: 0x01 = READ, 0x02 = WRITE, 0x04 = EXECUTE
    function hasPermission(uint256 flags, uint256 permission) external pure returns (bool) {
        assembly {
            let masked := and(flags, permission)
            let result := eq(masked, permission)
            mstore(0x0, result)
            return(0x0, 0x20)
        }
    }

    /// @notice Set bit flag (OR operation)
    function setFlag(uint256 flags, uint256 flag) external pure returns (uint256) {
        assembly {
            let result := or(flags, flag)
            mstore(0x0, result)
            return(0x0, 0x20)
        }
    }

    /// @notice Clear bit flag (AND NOT operation)
    function clearFlag(uint256 flags, uint256 flag) external pure returns (uint256) {
        assembly {
            let cleared := not(flag)
            let result := and(flags, cleared)
            mstore(0x0, result)
            return(0x0, 0x20)
        }
    }

    /// @notice Toggle bit flag (XOR operation)
    function toggleFlag(uint256 flags, uint256 flag) external pure returns (uint256) {
        assembly {
            let result := xor(flags, flag)
            mstore(0x0, result)
            return(0x0, 0x20)
        }
    }

    /// @notice Min function using LT
    function min(uint256 a, uint256 b) external pure returns (uint256) {
        assembly {
            let isLess := lt(a, b)
            let result := add(mul(isLess, a), mul(iszero(isLess), b))
            mstore(0x0, result)
            return(0x0, 0x20)
        }
    }

    /// @notice Max function using GT
    function max(uint256 a, uint256 b) external pure returns (uint256) {
        assembly {
            let isGreater := gt(a, b)
            let result := add(mul(isGreater, a), mul(iszero(isGreater), b))
            mstore(0x0, result)
            return(0x0, 0x20)
        }
    }

    /// @notice Clamp value between min and max
    function clamp(uint256 value, uint256 minVal, uint256 maxVal) external pure returns (uint256) {
        assembly {
            // if value < min, use min; else use value
            let step1 := add(mul(lt(value, minVal), minVal), mul(iszero(lt(value, minVal)), value))
            // if step1 > max, use max; else use step1
            let result := add(mul(gt(step1, maxVal), maxVal), mul(iszero(gt(step1, maxVal)), step1))
            mstore(0x0, result)
            return(0x0, 0x20)
        }
    }

    /// @notice Check if signed number is negative
    function isNegative(int256 a) external pure returns (bool) {
        assembly {
            // If a < 0, slt returns 1
            let result := slt(a, 0)
            mstore(0x0, result)
            return(0x0, 0x20)
        }
    }

    /// @notice Absolute value using signed comparison
    function abs(int256 a) external pure returns (uint256) {
        assembly {
            let isNeg := slt(a, 0)
            // If negative, negate it; else keep it
            let result := add(mul(isNeg, sub(0, a)), mul(iszero(isNeg), a))
            mstore(0x0, result)
            return(0x0, 0x20)
        }
    }
}
