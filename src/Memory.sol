// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

contract Memory {
    // ========== MEMORY LAYOUT ==========
    // 0x00-0x3f: Scratch space (64 bytes)
    // 0x40-0x5f: Free memory pointer (32 bytes)
    // 0x60-0x7f: Zero slot (32 bytes)
    // 0x80+    : Dynamic allocations

    // ========== RAW MEMORY OPERATIONS ==========

    /// @notice MLOAD - Load 32 bytes from memory
    function mloadRaw(uint256 offset) external pure returns (bytes32 value) {
        assembly {
            value := mload(offset) // MLOAD opcode (0x51)
        }
    }

    /// @notice MSTORE - Store 32 bytes to memory
    function mstoreRaw(uint256 offset, uint256 value) external pure returns (bytes32) {
        assembly {
            mstore(offset, value) // MSTORE opcode (0x52)
            let loaded := mload(offset)
            mstore(0x0, loaded)
            return(0x0, 0x20)
        }
    }

    /// @notice MSTORE8 - Store 1 byte to memory
    function mstore8Raw(uint256 offset, uint256 value) external pure returns (bytes32) {
        assembly {
            mstore8(offset, value) // MSTORE8 opcode (0x53)
            let loaded := mload(offset)
            mstore(0x0, loaded)
            return(0x0, 0x20)
        }
    }

    /// @notice MSIZE - Get current memory size
    function msizeRaw() external pure returns (uint256 size) {
        assembly {
            size := msize() // MSIZE opcode (0x59)
        }
    }

    /// @notice MCOPY - Copy memory region (EIP-5656)
    /// @dev Available since Cancun upgrade
    function mcopyRaw(uint256 destOffset, uint256 srcOffset, uint256 length) external pure returns (bytes32) {
        assembly {
            // First store some data at source
            mstore(srcOffset, 0xDEADBEEF)

            // Copy from src to dest
            mcopy(destOffset, srcOffset, length) // MCOPY opcode (0x5E)

            // Return copied data
            let result := mload(destOffset)
            mstore(0x0, result)
            return(0x0, 0x20)
        }
    }

    // ========== FREE MEMORY POINTER ==========

    /// @notice Get free memory pointer
    function getFreeMemoryPointer() external pure returns (uint256 ptr) {
        assembly {
            ptr := mload(0x40) // Free memory pointer at 0x40
        }
    }

    /// @notice Allocate memory safely
    function allocateMemory(uint256 size) external pure returns (uint256 ptr) {
        assembly {
            // Get current free memory pointer
            ptr := mload(0x40)
            // Update free memory pointer
            mstore(0x40, add(ptr, size))
        }
    }

    /// @notice Demonstrate memory expansion cost
    /// @dev Each 32-byte word expansion costs gas (quadratic)
    function demonstrateMemoryExpansion() external pure returns (uint256 size1, uint256 size2, uint256 size3) {
        assembly {
            size1 := msize() // Initial size

            mstore(0x100, 0x1234) // Expand to 0x120
            size2 := msize()

            mstore(0x1000, 0x5678) // Expand to 0x1020
            size3 := msize()
        }
    }

    // ========== SCRATCH SPACE USAGE ==========

    /// @notice Use scratch space for temporary computation
    /// @dev Scratch space (0x00-0x3f) can be used between statements
    function useScratchSpace(uint256 a, uint256 b) external pure returns (uint256 result) {
        assembly {
            // Use scratch space for temporary storage
            mstore(0x00, a)
            mstore(0x20, b)

            // Load and compute
            let x := mload(0x00)
            let y := mload(0x20)
            result := add(x, y)
        }
    }

    // ========== ABI ENCODING/DECODING ==========

    /// @notice Manual ABI encode single uint256
    function abiEncodeSingleUint(uint256 value) external pure returns (bytes memory) {
        bytes memory encoded = new bytes(32);
        assembly {
            // Write value at offset 0x20 (after length field)
            mstore(add(encoded, 0x20), value)
        }
        return encoded;
    }

    /// @notice Manual ABI encode two uint256 values
    function abiEncodeTwoUints(uint256 a, uint256 b) external pure returns (bytes memory) {
        bytes memory encoded = new bytes(64);
        assembly {
            let dataPtr := add(encoded, 0x20)
            mstore(dataPtr, a)
            mstore(add(dataPtr, 0x20), b)
        }
        return encoded;
    }

    /// @notice Manual ABI decode single uint256
    function abiDecodeSingleUint(bytes calldata data) external pure returns (uint256 value) {
        assembly {
            value := calldataload(data.offset)
        }
    }

    /// @notice Encode function selector with arguments
    /// @dev Selector = first 4 bytes of keccak256("transfer(address,uint256)")
    function encodeFunctionCall(address to, uint256 amount) external pure returns (bytes memory) {
        bytes memory data = new bytes(68); // 4 + 32 + 32
        bytes4 selector = bytes4(keccak256("transfer(address,uint256)"));

        assembly {
            let dataPtr := add(data, 0x20)

            // Store selector (4 bytes)
            mstore(dataPtr, selector)

            // Store address (32 bytes, left-padded)
            mstore(add(dataPtr, 0x04), to)

            // Store amount (32 bytes)
            mstore(add(dataPtr, 0x24), amount)
        }

        return data;
    }

    // ========== DYNAMIC ARRAYS IN MEMORY ==========

    /// @notice Create dynamic array in memory
    function createDynamicArray(uint256[] calldata values) external pure returns (uint256[] memory) {
        uint256[] memory arr = new uint256[](values.length);

        assembly {
            let len := calldataload(values.offset)
            let srcPtr := add(values.offset, 0x20)
            let destPtr := add(arr, 0x20)

            // Copy array elements
            for { let i := 0 } lt(i, len) { i := add(i, 1) } {
                let value := calldataload(add(srcPtr, mul(i, 0x20)))
                mstore(add(destPtr, mul(i, 0x20)), value)
            }
        }

        return arr;
    }

    /// @notice Sum array in memory
    function sumArray(uint256[] memory arr) external pure returns (uint256 total) {
        assembly {
            let len := mload(arr)
            let dataPtr := add(arr, 0x20)

            for { let i := 0 } lt(i, len) { i := add(i, 1) } {
                let value := mload(add(dataPtr, mul(i, 0x20)))
                total := add(total, value)
            }
        }
    }

    // ========== STRING OPERATIONS ==========

    /// @notice Get string length
    function getStringLength(string memory str) external pure returns (uint256) {
        assembly {
            let length := mload(str)
            mstore(0x0, length)
            return(0x0, 0x20)
        }
    }

    /// @notice Concatenate two strings
    function concatenateStrings(string memory a, string memory b) external pure returns (string memory) {
        bytes memory bytesA = bytes(a);
        bytes memory bytesB = bytes(b);
        string memory result = new string(bytesA.length + bytesB.length);

        assembly {
            let lenA := mload(bytesA)
            let lenB := mload(bytesB)
            let totalLen := add(lenA, lenB)

            // Store total length
            mstore(result, totalLen)

            let resultPtr := add(result, 0x20)
            let aPtr := add(bytesA, 0x20)
            let bPtr := add(bytesB, 0x20)

            // Copy string A
            for { let i := 0 } lt(i, lenA) { i := add(i, 0x20) } { mstore(add(resultPtr, i), mload(add(aPtr, i))) }

            // Copy string B
            for { let i := 0 } lt(i, lenB) { i := add(i, 0x20) } {
                mstore(add(add(resultPtr, lenA), i), mload(add(bPtr, i)))
            }
        }

        return result;
    }

    // ========== RETURN DATA ==========

    /// @notice Return multiple values using memory
    function returnMultipleValues(uint256 a, uint256 b, uint256 c) external pure returns (uint256, uint256, uint256) {
        assembly {
            // Store values in memory
            mstore(0x0, a)
            mstore(0x20, b)
            mstore(0x40, c)

            // Return 96 bytes (3 * 32)
            return(0x0, 0x60)
        }
    }

    /// @notice Custom return with specific memory layout
    function customReturn(bytes32 data) external pure {
        assembly {
            mstore(0x0, data)
            return(0x0, 0x20)
        }
    }

    // ========== MEMORY SAFETY PATTERNS ==========

    /// @notice Safe memory allocation with bounds check
    function safeAllocate(uint256 size) external pure returns (uint256 ptr, uint256 newSize) {
        assembly {
            ptr := mload(0x40)
            newSize := add(ptr, size)

            // Check for overflow
            if lt(newSize, ptr) { revert(0, 0) }

            mstore(0x40, newSize)
        }
    }

    /// @notice Zero out memory region
    function zeroMemory(uint256 offset, uint256 length) external pure returns (bool) {
        assembly {
            // Calculate end
            let end := add(offset, length)

            // Zero out in 32-byte chunks
            for { let i := offset } lt(i, end) { i := add(i, 0x20) } { mstore(i, 0) }

            mstore(0x0, 1)
            return(0x0, 0x20)
        }
    }

    /// @notice Copy bytes efficiently
    function copyBytes(bytes memory source) external pure returns (bytes memory) {
        bytes memory dest = new bytes(source.length);

        assembly {
            let len := mload(source)
            let words := div(add(len, 31), 32) // Round up to 32-byte words

            let srcPtr := add(source, 0x20)
            let destPtr := add(dest, 0x20)

            // Copy word by word
            for { let i := 0 } lt(i, words) { i := add(i, 1) } {
                mstore(add(destPtr, mul(i, 0x20)), mload(add(srcPtr, mul(i, 0x20))))
            }
        }

        return dest;
    }
}
