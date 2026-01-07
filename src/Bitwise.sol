// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

contract Bitwise {
    // ========== SHIFT OPERATIONS ==========

    /// @notice SHL - Shift Left (logical)
    /// @dev result = value << shift
    function shlRaw(uint256 value, uint256 shift) external pure returns (uint256 result) {
        assembly {
            result := shl(shift, value) // SHL opcode (0x1B)
        }
    }

    /// @notice SHR - Shift Right (logical)
    /// @dev result = value >> shift (zero-fill)
    function shrRaw(uint256 value, uint256 shift) external pure returns (uint256 result) {
        assembly {
            result := shr(shift, value) // SHR opcode (0x1C)
        }
    }

    /// @notice SAR - Shift Arithmetic Right
    /// @dev result = value >> shift (sign-extend)
    function sarRaw(int256 value, uint256 shift) external pure returns (int256 result) {
        assembly {
            result := sar(shift, value) // SAR opcode (0x1D)
        }
    }

    /// @notice BYTE - Extract byte from word
    /// @dev Returns the byte at position `index` (0-31, 0 is most significant)
    function byteRaw(uint256 index, bytes32 value) external pure returns (bytes1 result) {
        assembly {
            result := byte(index, value) // BYTE opcode (0x1A)
        }
    }

    // ========== MULTIPLICATION/DIVISION BY POWERS OF 2 ==========

    /// @notice Multiply by 2^n using left shift
    function mulByPowerOf2(uint256 value, uint256 n) external pure returns (uint256) {
        assembly {
            let result := shl(n, value) // value * (2^n)
            mstore(0x0, result)
            return(0x0, 0x20)
        }
    }

    /// @notice Divide by 2^n using right shift
    function divByPowerOf2(uint256 value, uint256 n) external pure returns (uint256) {
        assembly {
            let result := shr(n, value) // value / (2^n)
            mstore(0x0, result)
            return(0x0, 0x20)
        }
    }

    /// @notice Signed division by 2^n using arithmetic right shift
    function signedDivByPowerOf2(int256 value, uint256 n) external pure returns (int256) {
        assembly {
            let result := sar(n, value) // Preserves sign bit
            mstore(0x0, result)
            return(0x0, 0x20)
        }
    }

    // ========== BIT MANIPULATION ==========

    /// @notice Get specific bit at position
    function getBit(uint256 value, uint256 position) external pure returns (bool) {
        assembly {
            // Shift right to position, then AND with 1
            let bit := and(shr(position, value), 1)
            mstore(0x0, bit)
            return(0x0, 0x20)
        }
    }

    /// @notice Set bit at position to 1
    function setBit(uint256 value, uint256 position) external pure returns (uint256) {
        assembly {
            // Create mask: 1 << position, then OR
            let mask := shl(position, 1)
            let result := or(value, mask)
            mstore(0x0, result)
            return(0x0, 0x20)
        }
    }

    /// @notice Clear bit at position (set to 0)
    function clearBit(uint256 value, uint256 position) external pure returns (uint256) {
        assembly {
            // Create mask: NOT(1 << position), then AND
            let mask := not(shl(position, 1))
            let result := and(value, mask)
            mstore(0x0, result)
            return(0x0, 0x20)
        }
    }

    /// @notice Toggle bit at position
    function toggleBit(uint256 value, uint256 position) external pure returns (uint256) {
        assembly {
            // Create mask: 1 << position, then XOR
            let mask := shl(position, 1)
            let result := xor(value, mask)
            mstore(0x0, result)
            return(0x0, 0x20)
        }
    }

    /// @notice Count leading zeros
    /// @dev Returns number of zero bits before first 1 bit
    function countLeadingZeros(uint256 value) external pure returns (uint256 count) {
        assembly {
            // Binary search approach
            if iszero(value) {
                count := 256
                mstore(0x0, count)
                return(0x0, 0x20)
            }

            count := 0

            // Check upper 128 bits
            if iszero(shr(128, value)) {
                count := add(count, 128)
                value := shl(128, value)
            }

            // Check upper 64 bits
            if iszero(shr(192, value)) {
                count := add(count, 64)
                value := shl(64, value)
            }

            // Check upper 32 bits
            if iszero(shr(224, value)) {
                count := add(count, 32)
                value := shl(32, value)
            }

            // Check upper 16 bits
            if iszero(shr(240, value)) {
                count := add(count, 16)
                value := shl(16, value)
            }

            // Check upper 8 bits
            if iszero(shr(248, value)) {
                count := add(count, 8)
                value := shl(8, value)
            }

            // Check upper 4 bits
            if iszero(shr(252, value)) {
                count := add(count, 4)
                value := shl(4, value)
            }

            // Check upper 2 bits
            if iszero(shr(254, value)) {
                count := add(count, 2)
                value := shl(2, value)
            }

            // Check upper 1 bit
            if iszero(shr(255, value)) { count := add(count, 1) }
        }
    }

    // ========== MASK OPERATIONS ==========

    /// @notice Create mask with n lower bits set
    /// @dev mask = (1 << n) - 1
    function createLowerMask(uint256 n) external pure returns (uint256) {
        assembly {
            let result := sub(shl(n, 1), 1)
            mstore(0x0, result)
            return(0x0, 0x20)
        }
    }

    /// @notice Extract lower n bits
    function extractLowerBits(uint256 value, uint256 n) external pure returns (uint256) {
        assembly {
            let mask := sub(shl(n, 1), 1)
            let result := and(value, mask)
            mstore(0x0, result)
            return(0x0, 0x20)
        }
    }

    /// @notice Extract bits from position [start, start+length)
    function extractBits(uint256 value, uint256 start, uint256 length) external pure returns (uint256) {
        assembly {
            // Shift right to start position
            let shifted := shr(start, value)
            // Create mask for length bits
            let mask := sub(shl(length, 1), 1)
            // Apply mask
            let result := and(shifted, mask)
            mstore(0x0, result)
            return(0x0, 0x20)
        }
    }

    /// @notice Insert bits at position
    function insertBits(uint256 value, uint256 bits, uint256 position, uint256 length)
        external
        pure
        returns (uint256)
    {
        assembly {
            // Create mask for the bits to insert
            let bitMask := sub(shl(length, 1), 1)
            // Mask the input bits
            let maskedBits := and(bits, bitMask)
            // Shift to position
            let shiftedBits := shl(position, maskedBits)

            // Create clearing mask (zeros at insertion position)
            let clearMask := not(shl(position, bitMask))
            // Clear the target bits
            let cleared := and(value, clearMask)

            // Insert new bits
            let result := or(cleared, shiftedBits)
            mstore(0x0, result)
            return(0x0, 0x20)
        }
    }

    // ========== BYTE OPERATIONS ==========

    /// @notice Get byte at index (0 = most significant byte)
    function getByteAt(bytes32 value, uint256 index) external pure returns (uint8) {
        require(index < 32, "Index out of bounds");
        assembly {
            let b := byte(index, value)
            mstore(0x0, b)
            return(0x0, 0x20)
        }
    }

    /// @notice Reverse bytes (endianness swap)
    function reverseBytes32(bytes32 value) external pure returns (bytes32 result) {
        assembly {
            let temp := 0
            for { let i := 0 } lt(i, 32) { i := add(i, 1) } {
                let b := byte(i, value)
                temp := or(temp, shl(mul(sub(31, i), 8), b))
            }
            result := temp
        }
    }

    // ========== PACKING/UNPACKING ==========

    /// @notice Pack four uint64 into one uint256
    function packFourUint64(uint64 a, uint64 b, uint64 c, uint64 d) external pure returns (uint256) {
        assembly {
            let result := or(or(shl(192, a), shl(128, b)), or(shl(64, c), d))
            mstore(0x0, result)
            return(0x0, 0x20)
        }
    }

    /// @notice Unpack uint256 into four uint64
    function unpackToFourUint64(uint256 packed) external pure returns (uint64 a, uint64 b, uint64 c, uint64 d) {
        assembly {
            a := and(shr(192, packed), 0xFFFFFFFFFFFFFFFF)
            b := and(shr(128, packed), 0xFFFFFFFFFFFFFFFF)
            c := and(shr(64, packed), 0xFFFFFFFFFFFFFFFF)
            d := and(packed, 0xFFFFFFFFFFFFFFFF)
        }
    }

    /// @notice Pack address and uint96 into one uint256 (common pattern for tokens)
    function packAddressAndUint96(address addr, uint96 value) external pure returns (uint256) {
        assembly {
            let result := or(shl(96, addr), value)
            mstore(0x0, result)
            return(0x0, 0x20)
        }
    }

    /// @notice Unpack uint256 into address and uint96
    function unpackToAddressAndUint96(uint256 packed) external pure returns (address addr, uint96 value) {
        assembly {
            addr := shr(96, packed)
            value := and(packed, 0xFFFFFFFFFFFFFFFFFFFFFFFF)
        }
    }

    // ========== ALIGNMENT AND ROUNDING ==========

    /// @notice Round up to next power of 2
    function roundUpToPowerOf2(uint256 value) external pure returns (uint256) {
        assembly {
            // If already power of 2 or 0, return as is
            if iszero(and(value, sub(value, 1))) {
                mstore(0x0, value)
                return(0x0, 0x20)
            }

            // Fill all bits below the highest set bit
            value := or(value, shr(1, value))
            value := or(value, shr(2, value))
            value := or(value, shr(4, value))
            value := or(value, shr(8, value))
            value := or(value, shr(16, value))
            value := or(value, shr(32, value))
            value := or(value, shr(64, value))
            value := or(value, shr(128, value))

            // Add 1 to get next power of 2
            let result := add(value, 1)
            mstore(0x0, result)
            return(0x0, 0x20)
        }
    }

    /// @notice Check if value is power of 2
    function isPowerOf2(uint256 value) external pure returns (bool) {
        assembly {
            // Power of 2 has only one bit set: value & (value - 1) == 0
            let result := and(iszero(and(value, sub(value, 1))), iszero(iszero(value)))
            mstore(0x0, result)
            return(0x0, 0x20)
        }
    }

    /// @notice Align value to multiple (round up)
    /// @dev Requires alignment to be power of 2
    function alignUp(uint256 value, uint256 alignment) external pure returns (uint256) {
        assembly {
            // alignment must be power of 2
            let mask := sub(alignment, 1)
            let result := and(add(value, mask), not(mask))
            mstore(0x0, result)
            return(0x0, 0x20)
        }
    }

    /// @notice Align value to multiple (round down)
    function alignDown(uint256 value, uint256 alignment) external pure returns (uint256) {
        assembly {
            let mask := sub(alignment, 1)
            let result := and(value, not(mask))
            mstore(0x0, result)
            return(0x0, 0x20)
        }
    }
}
