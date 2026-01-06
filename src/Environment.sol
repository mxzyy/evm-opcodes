// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

contract Environment {
    // ========== MESSAGE CONTEXT ==========

    /// @notice CALLER - Get msg.sender
    function getCaller() external view returns (address sender) {
        assembly {
            sender := caller() // CALLER opcode (0x33)
        }
    }

    /// @notice CALLVALUE - Get msg.value
    function getCallValue() external payable returns (uint256 value) {
        assembly {
            value := callvalue() // CALLVALUE opcode (0x34)
        }
    }

    /// @notice CALLDATASIZE - Get msg.data.length
    function getCallDataSize() external pure returns (uint256 size) {
        assembly {
            size := calldatasize() // CALLDATASIZE opcode (0x36)
        }
    }

    /// @notice CALLDATALOAD - Load 32 bytes from calldata
    function getCallDataAt(uint256 offset) external pure returns (bytes32 data) {
        assembly {
            data := calldataload(offset) // CALLDATALOAD opcode (0x35)
        }
    }

    /// @notice CALLDATACOPY - Copy calldata to memory
    function copyCallData() external pure returns (bytes memory) {
        assembly {
            let size := calldatasize()
            let ptr := mload(0x40)

            // CALLDATACOPY(destOffset, offset, size)
            calldatacopy(ptr, 0, size) // CALLDATACOPY opcode (0x37)

            // Update free memory pointer
            mstore(0x40, add(ptr, size))

            // Return as bytes
            mstore(sub(ptr, 0x20), size)
            return(sub(ptr, 0x20), add(size, 0x20))
        }
    }

    // ========== TRANSACTION CONTEXT ==========

    /// @notice ORIGIN - Get tx.origin
    function getOrigin() external view returns (address originAddr) {
        assembly {
            originAddr := origin() // ORIGIN opcode (0x32)
        }
    }

    /// @notice GASPRICE - Get tx.gasprice
    function getGasPrice() external view returns (uint256 gasPrice) {
        assembly {
            gasPrice := gasprice() // GASPRICE opcode (0x3A)
        }
    }

    /// @notice GAS - Get remaining gas
    function getRemainingGas() external view returns (uint256 remainingGas) {
        assembly {
            remainingGas := gas() // GAS opcode (0x5A)
        }
    }

    // ========== CONTRACT CONTEXT ==========

    /// @notice ADDRESS - Get address(this)
    function getAddress() external view returns (address addr) {
        assembly {
            addr := address() // ADDRESS opcode (0x30)
        }
    }

    /// @notice BALANCE - Get balance of address
    function getBalance(address account) external view returns (uint256 balanceValue) {
        assembly {
            balanceValue := balance(account) // BALANCE opcode (0x31)
        }
    }

    /// @notice SELFBALANCE - Get balance of this contract
    function getSelfBalance() external view returns (uint256 balanceValue) {
        assembly {
            balanceValue := selfbalance() // SELFBALANCE opcode (0x47)
        }
    }

    /// @notice CODESIZE - Get size of this contract's code
    function getCodeSize() external pure returns (uint256 size) {
        assembly {
            size := codesize() // CODESIZE opcode (0x38)
        }
    }

    /// @notice CODECOPY - Copy contract code to memory
    function copyCode(uint256 offset, uint256 length) external pure returns (bytes memory) {
        bytes memory code = new bytes(length);
        assembly {
            let ptr := add(code, 0x20)
            codecopy(ptr, offset, length) // CODECOPY opcode (0x39)
        }
        return code;
    }

    // ========== EXTERNAL CONTRACT INFO ==========

    /// @notice EXTCODESIZE - Get size of external contract's code
    function getExtCodeSize(address account) external view returns (uint256 size) {
        assembly {
            size := extcodesize(account) // EXTCODESIZE opcode (0x3B)
        }
    }

    /// @notice EXTCODECOPY - Copy external contract's code
    function getExtCode(address account) external view returns (bytes memory) {
        uint256 size;
        assembly {
            size := extcodesize(account)
        }

        bytes memory code = new bytes(size);
        assembly {
            let ptr := add(code, 0x20)
            extcodecopy(account, ptr, 0, size) // EXTCODECOPY opcode (0x3C)
        }
        return code;
    }

    /// @notice EXTCODEHASH - Get keccak256 hash of external contract's code
    function getExtCodeHash(address account) external view returns (bytes32 hash) {
        assembly {
            hash := extcodehash(account) // EXTCODEHASH opcode (0x3F)
        }
    }

    /// @notice Check if address is contract
    function isContract(address account) external view returns (bool) {
        assembly {
            let size := extcodesize(account)
            mstore(0x0, gt(size, 0))
            return(0x0, 0x20)
        }
    }

    // ========== BLOCK CONTEXT ==========

    /// @notice BLOCKHASH - Get hash of recent block
    function getBlockHash(uint256 blockNumber) external view returns (bytes32 hash) {
        assembly {
            hash := blockhash(blockNumber) // BLOCKHASH opcode (0x40)
        }
    }

    /// @notice COINBASE - Get block.coinbase (miner address)
    function getCoinbase() external view returns (address coinbaseAddr) {
        assembly {
            coinbaseAddr := coinbase() // COINBASE opcode (0x41)
        }
    }

    /// @notice TIMESTAMP - Get block.timestamp
    function getTimestamp() external view returns (uint256 timestampValue) {
        assembly {
            timestampValue := timestamp() // TIMESTAMP opcode (0x42)
        }
    }

    /// @notice NUMBER - Get block.number
    function getBlockNumber() external view returns (uint256 numberValue) {
        assembly {
            numberValue := number() // NUMBER opcode (0x43)
        }
    }

    /// @notice PREVRANDAO - Get block.prevrandao (replaces DIFFICULTY post-merge)
    function getPrevRandao() external view returns (uint256 randao) {
        assembly {
            randao := prevrandao() // PREVRANDAO opcode (0x44)
        }
    }

    /// @notice GASLIMIT - Get block.gaslimit
    function getGasLimit() external view returns (uint256 gasLimit) {
        assembly {
            gasLimit := gaslimit() // GASLIMIT opcode (0x45)
        }
    }

    /// @notice CHAINID - Get block.chainid
    function getChainId() external view returns (uint256 chainId) {
        assembly {
            chainId := chainid() // CHAINID opcode (0x46)
        }
    }

    /// @notice BASEFEE - Get block.basefee (EIP-1559)
    function getBaseFee() external view returns (uint256 baseFee) {
        assembly {
            baseFee := basefee() // BASEFEE opcode (0x48)
        }
    }

    /// @notice BLOBBASEFEE - Get blob base fee (EIP-4844)
    function getBlobBaseFee() external view returns (uint256 blobBaseFee) {
        assembly {
            blobBaseFee := blobbasefee() // BLOBBASEFEE opcode (0x4A)
        }
    }

    /// @notice BLOBHASH - Get versioned hash of blob (EIP-4844)
    function getBlobHash(uint256 index) external view returns (bytes32 hash) {
        assembly {
            hash := blobhash(index) // BLOBHASH opcode (0x49)
        }
    }

    // ========== RETURN DATA ==========

    /// @notice RETURNDATASIZE - Get size of return data from last call
    /// @dev Only works after an external call
    function getReturnDataSize() external view returns (uint256 size) {
        // Need to make a call first
        (bool success,) = address(this).staticcall(abi.encodeWithSignature("getAddress()"));
        require(success, "Call failed");

        assembly {
            size := returndatasize() // RETURNDATASIZE opcode (0x3D)
        }
    }

    /// @notice RETURNDATACOPY - Copy return data to memory
    function getReturnData() external view returns (bytes memory) {
        // Make a call first
        (bool success,) = address(this).staticcall(abi.encodeWithSignature("getAddress()"));
        require(success, "Call failed");

        bytes memory data;
        assembly {
            let size := returndatasize()
            data := mload(0x40)
            mstore(data, size)
            mstore(0x40, add(add(data, 0x20), size))

            // RETURNDATACOPY(destOffset, offset, size)
            returndatacopy(add(data, 0x20), 0, size) // RETURNDATACOPY opcode (0x3E)
        }
        return data;
    }

    // ========== REAL-WORLD USE CASES ==========

    /// @notice Only allow EOA (no contracts)
    function onlyEOA() external view returns (bool) {
        assembly {
            // tx.origin == msg.sender means caller is EOA
            let isEOA := eq(origin(), caller())
            mstore(0x0, isEOA)
            return(0x0, 0x20)
        }
    }

    /// @notice Require minimum ETH sent
    function requireMinimumValue(uint256 minValue) external payable {
        assembly {
            if lt(callvalue(), minValue) { revert(0, 0) }
        }
    }

    /// @notice Time-locked function (only after certain timestamp)
    function requireAfterTimestamp(uint256 unlockTime) external view {
        assembly {
            if lt(timestamp(), unlockTime) { revert(0, 0) }
        }
    }

    /// @notice Block number-based deadline
    function requireBeforeBlock(uint256 deadline) external view {
        assembly {
            if gt(number(), deadline) { revert(0, 0) }
        }
    }

    /// @notice Get detailed call context
    function getCallContext()
        external
        payable
        returns (
            address sender,
            address originAddr,
            uint256 value,
            uint256 gasPrice,
            uint256 gasRemaining,
            uint256 blockNumber,
            uint256 timestampValue
        )
    {
        assembly {
            sender := caller()
            originAddr := origin()
            value := callvalue()
            gasPrice := gasprice()
            gasRemaining := gas()
            blockNumber := number()
            timestampValue := timestamp()
        }
    }

    /// @notice Get detailed block context
    function getBlockContext()
        external
        view
        returns (
            uint256 numberValue,
            uint256 timestampValue,
            uint256 basefeeValue,
            uint256 gaslimitValue,
            uint256 chainidValue,
            address coinbaseAddr,
            uint256 prevrandaoValue
        )
    {
        assembly {
            numberValue := number()
            timestampValue := timestamp()
            basefeeValue := basefee()
            gaslimitValue := gaslimit()
            chainidValue := chainid()
            coinbaseAddr := coinbase()
            prevrandaoValue := prevrandao()
        }
    }

    /// @notice Verify contract deployment on specific chain
    function verifyChain(uint256 expectedChainId) external view returns (bool) {
        assembly {
            let currentChainId := chainid()
            let isCorrectChain := eq(currentChainId, expectedChainId)
            mstore(0x0, isCorrectChain)
            return(0x0, 0x20)
        }
    }

    /// @notice Calculate effective gas price (EIP-1559)
    /// @dev effectiveGasPrice = min(maxFeePerGas, baseFee + maxPriorityFeePerGas)
    function getEffectiveGasPrice() external view returns (uint256) {
        assembly {
            let txGasPrice := gasprice()
            let blockBaseFee := basefee()
            // The actual calculation is done by the EVM
            // gasprice() already returns the effective gas price
            mstore(0x0, txGasPrice)
            return(0x0, 0x20)
        }
    }

    // Accept ETH
    receive() external payable {}
}
