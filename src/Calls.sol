// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

// Target contract for testing external calls
contract CallTarget {
    uint256 public value;
    address public sender;

    event ValueSet(uint256 newValue, address setter);

    function setValue(uint256 newValue) external payable {
        value = newValue;
        sender = msg.sender;
        emit ValueSet(newValue, msg.sender);
    }

    function getValue() external view returns (uint256) {
        return value;
    }

    function revertWithMessage() external pure {
        revert("Intentional revert");
    }

    function returnMultiple() external pure returns (uint256, address, bool) {
        return (42, address(0x1234), true);
    }

    receive() external payable {}
}

contract Calls {
    uint256 public value;
    address public lastCaller;

    event CallExecuted(bool success, bytes data);

    // ========== CALL OPERATIONS ==========

    /// @notice CALL - External call with value transfer
    /// @dev CALL(gas, address, value, argsOffset, argsSize, retOffset, retSize)
    function callRaw(address target, uint256 amount, bytes memory data)
        external
        payable
        returns (bool success, bytes memory returnData)
    {
        assembly {
            let dataPtr := add(data, 0x20)
            let dataSize := mload(data)

            // Allocate memory for return data
            let retPtr := mload(0x40)

            // CALL opcode (0xF1)
            success :=
                call(
                    gas(), // Forward all gas
                    target, // Target address
                    amount, // Value to send
                    dataPtr, // Input data offset
                    dataSize, // Input data size
                    retPtr, // Return data offset
                    0 // Return data size (0 = we'll use returndatasize)
                )

            // Get actual return data size
            let retSize := returndatasize()

            // Allocate return data
            returnData := mload(0x40)
            mstore(returnData, retSize)
            mstore(0x40, add(add(returnData, 0x20), retSize))

            // Copy return data
            returndatacopy(add(returnData, 0x20), 0, retSize)
        }
    }

    /// @notice STATICCALL - Read-only external call
    /// @dev STATICCALL(gas, address, argsOffset, argsSize, retOffset, retSize)
    function staticCallRaw(address target, bytes memory data)
        external
        view
        returns (bool success, bytes memory returnData)
    {
        assembly {
            let dataPtr := add(data, 0x20)
            let dataSize := mload(data)
            let retPtr := mload(0x40)

            // STATICCALL opcode (0xFA)
            success := staticcall(gas(), target, dataPtr, dataSize, retPtr, 0)

            let retSize := returndatasize()
            returnData := mload(0x40)
            mstore(returnData, retSize)
            mstore(0x40, add(add(returnData, 0x20), retSize))
            returndatacopy(add(returnData, 0x20), 0, retSize)
        }
    }

    /// @notice DELEGATECALL - Execute code in current context
    /// @dev DELEGATECALL(gas, address, argsOffset, argsSize, retOffset, retSize)
    function delegateCallRaw(address target, bytes memory data)
        external
        returns (bool success, bytes memory returnData)
    {
        assembly {
            let dataPtr := add(data, 0x20)
            let dataSize := mload(data)
            let retPtr := mload(0x40)

            // DELEGATECALL opcode (0xF4)
            success := delegatecall(gas(), target, dataPtr, dataSize, retPtr, 0)

            let retSize := returndatasize()
            returnData := mload(0x40)
            mstore(returnData, retSize)
            mstore(0x40, add(add(returnData, 0x20), retSize))
            returndatacopy(add(returnData, 0x20), 0, retSize)
        }
    }

    // ========== CALL PATTERNS ==========

    /// @notice Call with exact gas
    function callWithGas(address target, uint256 gasLimit, bytes memory data) external returns (bool success) {
        assembly {
            let dataPtr := add(data, 0x20)
            let dataSize := mload(data)

            success :=
                call(
                    gasLimit, // Exact gas limit
                    target,
                    0, // No value
                    dataPtr,
                    dataSize,
                    0,
                    0
                )
        }
    }

    /// @notice Call and check return data
    function callAndDecode(address target) external returns (uint256 result) {
        bytes memory data = abi.encodeWithSignature("getValue()");

        assembly {
            let dataPtr := add(data, 0x20)
            let dataSize := mload(data)
            let retPtr := mload(0x40)

            let success := call(gas(), target, 0, dataPtr, dataSize, retPtr, 0x20)

            if iszero(success) { revert(0, 0) }

            result := mload(retPtr)
        }
    }

    /// @notice Transfer ETH (assembly version of .transfer())
    function transferEth(address payable recipient, uint256 amount) external {
        assembly {
            // Use CALL with 0 input data and 2300 gas
            let success := call(2300, recipient, amount, 0, 0, 0, 0)

            if iszero(success) { revert(0, 0) }
        }
    }

    /// @notice Send ETH (assembly version of .send())
    function sendEth(address payable recipient, uint256 amount) external returns (bool success) {
        assembly {
            success := call(2300, recipient, amount, 0, 0, 0, 0)
        }
    }

    // ========== DELEGATECALL PATTERNS ==========

    /// @notice Proxy pattern using delegatecall
    function executeViaProxy(address implementation, bytes memory data) external returns (bytes memory) {
        (bool success, bytes memory returnData) = implementation.delegatecall(data);
        require(success, "Delegatecall failed");
        return returnData;
    }

    /// @notice Library pattern using delegatecall
    function useLibrary(address libAddr, bytes memory data) external returns (bool success) {
        assembly {
            let dataPtr := add(data, 0x20)
            let dataSize := mload(data)

            success := delegatecall(gas(), libAddr, dataPtr, dataSize, 0, 0)
        }
    }

    // ========== REENTRANCY PROTECTION ==========

    uint256 private _status = 1;
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    /// @notice Nonreentrant modifier implemented in assembly
    function nonReentrantCall(address target, bytes memory data) external returns (bool) {
        assembly {
            // Load status
            let status := sload(_status.slot)

            // Require status == _NOT_ENTERED
            if eq(status, _ENTERED) { revert(0, 0) }

            // Set status = _ENTERED
            sstore(_status.slot, _ENTERED)
        }

        // Make external call
        (bool success,) = target.call(data);

        assembly {
            // Reset status = _NOT_ENTERED
            sstore(_status.slot, _NOT_ENTERED)
        }

        return success;
    }

    // ========== CALL RETURN HANDLING ==========

    /// @notice Handle successful and failed calls
    function safeCall(address target, bytes memory data) external returns (bool success, bytes memory returnData) {
        (success, returnData) = target.call(data);

        if (!success) {
            // Bubble up revert reason
            assembly {
                let returnDataSize := mload(returnData)
                revert(add(returnData, 0x20), returnDataSize)
            }
        }
    }

    /// @notice Try-catch pattern in assembly
    function tryCall(address target, bytes memory data) external returns (bool success, bytes memory returnData) {
        assembly {
            let dataPtr := add(data, 0x20)
            let dataSize := mload(data)
            let retPtr := mload(0x40)

            success := call(gas(), target, 0, dataPtr, dataSize, retPtr, 0)

            let retSize := returndatasize()
            returnData := mload(0x40)
            mstore(returnData, retSize)
            mstore(0x40, add(add(returnData, 0x20), retSize))

            if gt(retSize, 0) { returndatacopy(add(returnData, 0x20), 0, retSize) }
        }
    }

    // ========== MULTICALL PATTERN ==========

    /// @notice Execute multiple calls in one transaction
    function multicall(address[] calldata targets, bytes[] calldata data)
        external
        returns (bool[] memory successes, bytes[] memory returnDatas)
    {
        require(targets.length == data.length, "Length mismatch");

        successes = new bool[](targets.length);
        returnDatas = new bytes[](targets.length);

        for (uint256 i = 0; i < targets.length; i++) {
            (successes[i], returnDatas[i]) = targets[i].call(data[i]);
        }
    }

    /// @notice Batch delegatecall
    function batchDelegatecall(bytes[] calldata data) external returns (bytes[] memory results) {
        results = new bytes[](data.length);

        for (uint256 i = 0; i < data.length; i++) {
            (bool success, bytes memory result) = address(this).delegatecall(data[i]);
            require(success, "Delegatecall failed");
            results[i] = result;
        }
    }

    // ========== GAS FORWARDING ==========

    /// @notice Forward exact amount of gas
    function forwardGas(address target, uint256 gasToForward, bytes memory data) external returns (bool success) {
        assembly {
            let dataPtr := add(data, 0x20)
            let dataSize := mload(data)

            success := call(gasToForward, target, 0, dataPtr, dataSize, 0, 0)
        }
    }

    /// @notice Forward 63/64 of gas (EIP-150)
    function forwardMostGas(address target, bytes memory data) external returns (bool success) {
        assembly {
            let dataPtr := add(data, 0x20)
            let dataSize := mload(data)

            // gas() returns remaining gas
            // 63/64 is automatically forwarded by EVM
            success := call(gas(), target, 0, dataPtr, dataSize, 0, 0)
        }
    }

    // ========== FALLBACK PATTERNS ==========

    /// @notice Forward all calls to implementation (proxy pattern)
    fallback() external payable {
        address implementation = address(0x1234); // Example implementation address

        assembly {
            // Copy calldata
            calldatacopy(0, 0, calldatasize())

            // Delegatecall to implementation
            let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)

            // Copy return data
            returndatacopy(0, 0, returndatasize())

            // Return or revert based on result
            switch result
            case 0 { revert(0, returndatasize()) }
            default { return(0, returndatasize()) }
        }
    }

    receive() external payable {}
}
