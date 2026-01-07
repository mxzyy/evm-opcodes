// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

contract ControlFlow {
    // ========== JUMP OPERATIONS ==========

    /// @notice PC - Get program counter
    /// @dev Note: PC opcode (0x58) is disallowed in strict assembly mode
    /// PC is position-dependent and can break with optimizer changes
    function getProgramCounter() external pure returns (uint256 pcAddress) {
        // PC instruction not available in modern Yul strict assembly
        // It would return the current position in the bytecode
        return 0;
    }

    /// @notice Demonstrate JUMP and JUMPDEST
    /// @dev Note: Modern Yul doesn't support arbitrary JUMP with labels
    /// This demonstrates the concept but uses structured control flow
    function demonstrateJump() external pure returns (uint256) {
        assembly {
            // In modern Yul, use structured control flow instead of JUMP
            // JUMPDEST is implicitly placed by the compiler at valid locations

            let result := 0x1234
            mstore(0x0, result)
            return(0x0, 0x20)
        }
    }

    /// @notice Demonstrate JUMPI (conditional jump)
    /// @dev JUMPI concept using structured if statement
    function demonstrateJumpi(bool condition) external pure returns (uint256) {
        assembly {
            // Modern Yul uses if statements instead of JUMPI with labels
            // The compiler generates JUMPI opcodes behind the scenes

            if condition {
                mstore(0x0, 0x600D) // GOOD
                return(0x0, 0x20)
            }

            // If condition is false, execution continues here
            mstore(0x0, 0xBAD)
            return(0x0, 0x20)
        }
    }

    // ========== IF/ELSE PATTERNS ==========

    /// @notice Simple if statement
    function ifStatement(uint256 value) external pure returns (uint256) {
        assembly {
            let result := 0

            // If value > 100
            if gt(value, 100) { result := 1 }

            mstore(0x0, result)
            return(0x0, 0x20)
        }
    }

    /// @notice If-else using switch
    function ifElseSwitch(uint256 value) external pure returns (uint256) {
        assembly {
            let result := 0

            switch gt(value, 100)
            case 1 { result := 0x600D }
            // Good
            default { result := 0xBAD } // Bad

            mstore(0x0, result)
            return(0x0, 0x20)
        }
    }

    /// @notice If-else using structured control flow
    function ifElseJumpi(uint256 value) external pure returns (uint256) {
        assembly {
            let condition := gt(value, 100)

            if condition {
                mstore(0x0, 0x600D)
                return(0x0, 0x20)
            }

            // Else branch
            mstore(0x0, 0xBAD)
            return(0x0, 0x20)
        }
    }

    /// @notice Nested if-else
    function nestedIfElse(uint256 value) external pure returns (uint256) {
        assembly {
            let result := 0

            switch lt(value, 50)
            case 1 { result := 1 }
            // value < 50
            default {
                switch lt(value, 100)
                case 1 { result := 2 }
                // 50 <= value < 100
                default { result := 3 } // value >= 100
            }

            mstore(0x0, result)
            return(0x0, 0x20)
        }
    }

    // ========== LOOP PATTERNS ==========

    /// @notice For loop - sum 1 to n
    function forLoop(uint256 n) external pure returns (uint256) {
        assembly {
            let sum := 0

            for { let i := 1 } lt(i, add(n, 1)) { i := add(i, 1) } { sum := add(sum, i) }

            mstore(0x0, sum)
            return(0x0, 0x20)
        }
    }

    /// @notice For loop with break (early exit)
    function forLoopWithBreak(uint256 n, uint256 breakAt) external pure returns (uint256) {
        assembly {
            let sum := 0
            let shouldBreak := 0

            for { let i := 1 } and(lt(i, add(n, 1)), iszero(shouldBreak)) { i := add(i, 1) } {
                // Break if i reaches breakAt
                if eq(i, breakAt) { shouldBreak := 1 }
                if iszero(shouldBreak) { sum := add(sum, i) }
            }

            mstore(0x0, sum)
            return(0x0, 0x20)
        }
    }

    /// @notice For loop with continue (skip iteration)
    function forLoopWithContinue(uint256 n) external pure returns (uint256) {
        assembly {
            let sum := 0

            for { let i := 1 } lt(i, add(n, 1)) { i := add(i, 1) } {
                // Skip even numbers - only add odd numbers
                if mod(i, 2) { sum := add(sum, i) }
            }

            mstore(0x0, sum)
            return(0x0, 0x20)
        }
    }

    /// @notice While loop pattern using for
    function whileLoop(uint256 n) external pure returns (uint256) {
        assembly {
            let i := 0
            let sum := 0

            for {} lt(i, n) {} {
                sum := add(sum, i)
                i := add(i, 1)
            }

            mstore(0x0, sum)
            return(0x0, 0x20)
        }
    }

    /// @notice Do-while loop pattern
    function doWhileLoop(uint256 n) external pure returns (uint256) {
        assembly {
            let i := 0
            let sum := 0
            let shouldContinue := 1

            for {} shouldContinue {} {
                sum := add(sum, i)
                i := add(i, 1)

                // Update continue condition
                shouldContinue := lt(i, n)
            }

            mstore(0x0, sum)
            return(0x0, 0x20)
        }
    }

    /// @notice Nested loops
    function nestedLoops(uint256 rows, uint256 cols) external pure returns (uint256) {
        assembly {
            let sum := 0

            for { let i := 0 } lt(i, rows) { i := add(i, 1) } {
                for { let j := 0 } lt(j, cols) { j := add(j, 1) } { sum := add(sum, add(i, j)) }
            }

            mstore(0x0, sum)
            return(0x0, 0x20)
        }
    }

    // ========== REQUIRE/REVERT PATTERNS ==========

    /// @notice Simple require using REVERT
    function requireExample(uint256 value) external pure returns (uint256) {
        assembly {
            // Require value > 100
            if iszero(gt(value, 100)) { revert(0, 0) } // REVERT opcode (0xFD)

            mstore(0x0, value)
            return(0x0, 0x20)
        }
    }

    /// @notice Revert with custom error message
    function revertWithMessage(uint256 value) external pure {
        assembly {
            if iszero(gt(value, 100)) {
                // Store error selector for Error(string)
                // Error(string) = 0x08c379a0
                mstore(0x0, 0x08c379a000000000000000000000000000000000000000000000000000000000)
                // Store offset to string (32 bytes after selector)
                mstore(0x04, 0x20)
                // Store string length
                mstore(0x24, 11) // "Value too low"
                // Store string data
                mstore(0x44, "Value too l")
                mstore(0x4f, "ow")

                // Revert with message
                revert(0x0, 0x64)
            }
        }
    }

    /// @notice Multiple requires
    function multipleRequires(uint256 a, uint256 b, uint256 c) external pure returns (uint256) {
        assembly {
            // Require a > 0
            if iszero(a) { revert(0, 0) }

            // Require b < 1000
            if iszero(lt(b, 1000)) { revert(0, 0) }

            // Require c != 42
            if eq(c, 42) { revert(0, 0) }

            let result := add(add(a, b), c)
            mstore(0x0, result)
            return(0x0, 0x20)
        }
    }

    // ========== ASSERT PATTERNS ==========

    /// @notice Assert-like check (uses INVALID opcode on failure)
    function assertExample(uint256 value) external pure returns (uint256) {
        assembly {
            // If assertion fails, use INVALID opcode
            if iszero(gt(value, 0)) { invalid() } // INVALID opcode (0xFE) - consumes all gas

            mstore(0x0, value)
            return(0x0, 0x20)
        }
    }

    // ========== SWITCH STATEMENTS ==========

    /// @notice Switch with multiple cases
    function switchStatement(uint256 value) external pure returns (string memory) {
        string memory result;

        assembly {
            switch value
            case 0 {
                // Return "zero"
                result := mload(0x40)
                mstore(result, 4)
                mstore(add(result, 0x20), "zero")
                mstore(0x40, add(result, 0x40))
            }
            case 1 {
                result := mload(0x40)
                mstore(result, 3)
                mstore(add(result, 0x20), "one")
                mstore(0x40, add(result, 0x40))
            }
            case 2 {
                result := mload(0x40)
                mstore(result, 3)
                mstore(add(result, 0x20), "two")
                mstore(0x40, add(result, 0x40))
            }
            default {
                result := mload(0x40)
                mstore(result, 5)
                mstore(add(result, 0x20), "other")
                mstore(0x40, add(result, 0x40))
            }
        }

        return result;
    }

    // ========== COMPLEX CONTROL FLOW ==========

    /// @notice Fibonacci using loops
    function fibonacci(uint256 n) external pure returns (uint256) {
        assembly {
            switch n
            case 0 {
                mstore(0x0, 0)
                return(0x0, 0x20)
            }
            case 1 {
                mstore(0x0, 1)
                return(0x0, 0x20)
            }
            default {
                let a := 0
                let b := 1
                let result := 0

                for { let i := 2 } lt(i, add(n, 1)) { i := add(i, 1) } {
                    result := add(a, b)
                    a := b
                    b := result
                }

                mstore(0x0, result)
                return(0x0, 0x20)
            }
        }
    }

    /// @notice Binary search in sorted array
    function binarySearch(uint256[] memory arr, uint256 target) external pure returns (int256) {
        assembly {
            let left := 0
            let right := sub(mload(arr), 1)
            let arrPtr := add(arr, 0x20)

            for {} iszero(gt(left, right)) {} {
                let mid := shr(1, add(left, right))
                let midValue := mload(add(arrPtr, mul(mid, 0x20)))

                switch lt(midValue, target)
                case 1 {
                    // midValue < target, search right half
                    left := add(mid, 1)
                }
                default {
                    switch gt(midValue, target)
                    case 1 {
                        // midValue > target, search left half
                        right := sub(mid, 1)
                    }
                    default {
                        // Found!
                        mstore(0x0, mid)
                        return(0x0, 0x20)
                    }
                }
            }

            // Not found, return -1
            mstore(0x0, not(0))
            return(0x0, 0x20)
        }
    }

    /// @notice Find maximum in array
    function findMax(uint256[] memory arr) external pure returns (uint256) {
        require(arr.length > 0, "Empty array");

        assembly {
            let len := mload(arr)
            let arrPtr := add(arr, 0x20)
            let maxVal := mload(arrPtr)

            for { let i := 1 } lt(i, len) { i := add(i, 1) } {
                let current := mload(add(arrPtr, mul(i, 0x20)))
                if gt(current, maxVal) { maxVal := current }
            }

            mstore(0x0, maxVal)
            return(0x0, 0x20)
        }
    }

    /// @notice Bubble sort
    function bubbleSort(uint256[] memory arr) external pure returns (uint256[] memory) {
        assembly {
            let len := mload(arr)
            let arrPtr := add(arr, 0x20)

            // Outer loop
            for { let i := 0 } lt(i, len) { i := add(i, 1) } {
                // Inner loop
                for { let j := 0 } lt(j, sub(len, add(i, 1))) { j := add(j, 1) } {
                    let jPtr := add(arrPtr, mul(j, 0x20))
                    let j1Ptr := add(arrPtr, mul(add(j, 1), 0x20))

                    let valJ := mload(jPtr)
                    let valJ1 := mload(j1Ptr)

                    // Swap if arr[j] > arr[j+1]
                    if gt(valJ, valJ1) {
                        mstore(jPtr, valJ1)
                        mstore(j1Ptr, valJ)
                    }
                }
            }
        }

        return arr;
    }

    /// @notice Early return pattern
    function earlyReturn(uint256 value) external pure returns (uint256) {
        assembly {
            // Early return if value is 0
            if iszero(value) {
                mstore(0x0, 0)
                return(0x0, 0x20)
            }

            // Early return if value > 1000
            if gt(value, 1000) {
                mstore(0x0, 1000)
                return(0x0, 0x20)
            }

            // Normal return
            mstore(0x0, value)
            return(0x0, 0x20)
        }
    }
}
