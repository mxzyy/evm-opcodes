// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

contract Errors {
    // ========== CUSTOM ERRORS (0.8.4+) ==========

    error Unauthorized();
    error InsufficientBalance(uint256 available, uint256 required);
    error InvalidAddress(address addr);
    error ValueTooLow(uint256 value, uint256 minimum);
    error ValueTooHigh(uint256 value, uint256 maximum);

    // ========== REVERT OPERATIONS ==========

    /// @notice REVERT - Revert with no message
    function revertRaw() external pure {
        assembly {
            revert(0, 0) // REVERT opcode (0xFD)
        }
    }

    /// @notice REVERT with custom error selector
    function revertWithCustomError() external pure {
        assembly {
            // Unauthorized() selector = first 4 bytes of keccak256("Unauthorized()")
            mstore(0x0, 0x82b42900) // Example selector
            revert(0x0, 0x04)
        }
    }

    /// @notice REVERT with Error(string) message
    function revertWithMessage(string memory message) external pure {
        bytes memory messageBytes = bytes(message);

        assembly {
            let messageLen := mload(messageBytes)
            let ptr := mload(0x40)

            // Error(string) selector = 0x08c379a0
            mstore(ptr, 0x08c379a000000000000000000000000000000000000000000000000000000000)
            mstore(add(ptr, 0x04), 0x20) // offset to string
            mstore(add(ptr, 0x24), messageLen) // string length

            // Copy string data
            let dataPtr := add(messageBytes, 0x20)
            for { let i := 0 } lt(i, messageLen) { i := add(i, 0x20) } {
                mstore(add(add(ptr, 0x44), i), mload(add(dataPtr, i)))
            }

            let totalSize := add(0x44, and(add(messageLen, 0x1f), not(0x1f)))
            revert(ptr, totalSize)
        }
    }

    /// @notice REVERT with custom error and parameters
    function revertInsufficientBalance(uint256 available, uint256 required) external pure {
        assembly {
            let ptr := mload(0x40)

            // InsufficientBalance(uint256,uint256) selector
            mstore(ptr, 0xcd78605900000000000000000000000000000000000000000000000000000000)
            mstore(add(ptr, 0x04), available)
            mstore(add(ptr, 0x24), required)

            revert(ptr, 0x44)
        }
    }

    // ========== INVALID OPCODE ==========

    /// @notice INVALID - Consumes all gas and reverts
    function invalidOpcode() external pure {
        assembly {
            invalid() // INVALID opcode (0xFE)
        }
    }

    // ========== REQUIRE PATTERNS ==========

    /// @notice require() implementation
    function requireExample(uint256 value, uint256 minimum) external pure {
        assembly {
            if lt(value, minimum) {
                // Revert with "Value too low"
                mstore(0x0, 0x08c379a000000000000000000000000000000000000000000000000000000000)
                mstore(0x04, 0x20)
                mstore(0x24, 13) // "Value too low"
                mstore(0x44, "Value too low")
                revert(0x0, 0x64)
            }
        }
    }

    /// @notice require() with custom error
    function requireWithCustomError(uint256 value, uint256 minimum) external pure {
        if (value < minimum) {
            revert ValueTooLow(value, minimum);
        }
    }

    /// @notice Multiple require checks
    function multipleRequires(address addr, uint256 value) external pure {
        assembly {
            // Check address not zero
            if iszero(addr) {
                mstore(0x0, 0x82b42900) // Unauthorized()
                revert(0x0, 0x04)
            }

            // Check value > 0
            if iszero(value) {
                mstore(0x0, 0x82b42900)
                revert(0x0, 0x04)
            }
        }
    }

    // ========== ASSERT PATTERNS ==========

    /// @notice assert() - uses INVALID on failure (consumes all gas)
    function assertExample(uint256 value) external pure returns (uint256) {
        assembly {
            if iszero(value) {
                invalid() // Assert failure
            }

            mstore(0x0, value)
            return(0x0, 0x20)
        }
    }

    /// @notice Panic errors (0.8.0+)
    function panicError(uint256 errorCode) external pure {
        assembly {
            // Panic(uint256) selector = 0x4e487b71
            mstore(0x0, 0x4e487b7100000000000000000000000000000000000000000000000000000000)
            mstore(0x04, errorCode)
            revert(0x0, 0x24)
        }
    }

    /// @notice Panic: Division by zero (0x12)
    function panicDivisionByZero() external pure {
        assembly {
            mstore(0x0, 0x4e487b7100000000000000000000000000000000000000000000000000000000)
            mstore(0x04, 0x12)
            revert(0x0, 0x24)
        }
    }

    /// @notice Panic: Array out of bounds (0x32)
    function panicArrayOutOfBounds() external pure {
        assembly {
            mstore(0x0, 0x4e487b7100000000000000000000000000000000000000000000000000000000)
            mstore(0x04, 0x32)
            revert(0x0, 0x24)
        }
    }

    // ========== TRY-CATCH PATTERN ==========

    function riskyFunction(bool shouldFail) external pure returns (uint256) {
        if (shouldFail) {
            revert("Function failed");
        }
        return 42;
    }

    /// @notice Try-catch implemented in assembly
    function tryCatchExample(address target, bool shouldFail) external returns (bool success, uint256 result) {
        bytes memory data = abi.encodeWithSignature("riskyFunction(bool)", shouldFail);

        assembly {
            let dataPtr := add(data, 0x20)
            let dataSize := mload(data)
            let retPtr := mload(0x40)

            success := call(gas(), target, 0, dataPtr, dataSize, retPtr, 0x20)

            if success {
                result := mload(retPtr)
            }
            // If failed, success = false, result = 0 (default)
        }
    }

    /// @notice Catch and decode revert reason
    function catchRevertReason(address target, bytes memory data) external returns (string memory reason) {
        (bool success, bytes memory returnData) = target.call(data);

        if (!success) {
            assembly {
                let returnDataSize := mload(returnData)

                // Check if it's Error(string)
                if gt(returnDataSize, 0x44) {
                    let selector := mload(add(returnData, 0x20))

                    // Error(string) selector = 0x08c379a0
                    if eq(shr(224, selector), 0x08c379a0) {
                        // Decode string
                        let strLen := mload(add(returnData, 0x44))
                        reason := mload(0x40)
                        mstore(reason, strLen)

                        let reasonPtr := add(reason, 0x20)
                        let dataPtr := add(returnData, 0x64)

                        for { let i := 0 } lt(i, strLen) { i := add(i, 0x20) } {
                            mstore(add(reasonPtr, i), mload(add(dataPtr, i)))
                        }

                        mstore(0x40, add(reasonPtr, and(add(strLen, 0x1f), not(0x1f))))
                    }
                }
            }
        }
    }

    // ========== ERROR BUBBLING ==========

    /// @notice Bubble up revert from subcall
    function bubbleRevert(address target, bytes memory data) external {
        (bool success, bytes memory returnData) = target.call(data);

        if (!success) {
            assembly {
                let returnDataSize := mload(returnData)
                revert(add(returnData, 0x20), returnDataSize)
            }
        }
    }

    // ========== GAS-EFFICIENT ERRORS ==========

    /// @notice Gas-efficient custom error
    function efficientError() external pure {
        assembly {
            // Just 4 bytes selector, no parameters
            mstore(0x0, 0x82b42900)
            revert(0x0, 0x04)
        }
    }

    /// @notice Compare gas: string vs custom error
    function expensiveStringError() external pure {
        revert("This is a long error message that costs a lot of gas");
    }

    function cheapCustomError() external pure {
        revert Unauthorized();
    }
}
