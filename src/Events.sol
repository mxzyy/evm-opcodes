// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

contract Events {
    // ========== EVENT DEFINITIONS ==========

    event SimpleEvent();
    event EventWithValue(uint256 value);
    event EventWithIndexed(uint256 indexed id, address indexed sender, uint256 value);
    event EventWithMultipleIndexed(
        uint256 indexed id, address indexed sender, address indexed recipient, uint256 amount, uint256 timestamp
    );
    event EventWithString(string message);
    event EventWithBytes(bytes data);

    // ========== RAW LOG OPERATIONS ==========

    /// @notice LOG0 - Emit event with no topics
    /// @dev LOG0(offset, size)
    function log0Raw(bytes32 data) external {
        assembly {
            mstore(0x0, data)
            log0(0x0, 0x20) // LOG0 opcode (0xA0)
        }
    }

    /// @notice LOG1 - Emit event with 1 topic
    /// @dev LOG1(offset, size, topic1)
    function log1Raw(bytes32 data, bytes32 topic1) external {
        assembly {
            mstore(0x0, data)
            log1(0x0, 0x20, topic1) // LOG1 opcode (0xA1)
        }
    }

    /// @notice LOG2 - Emit event with 2 topics
    /// @dev LOG2(offset, size, topic1, topic2)
    function log2Raw(bytes32 data, bytes32 topic1, bytes32 topic2) external {
        assembly {
            mstore(0x0, data)
            log2(0x0, 0x20, topic1, topic2) // LOG2 opcode (0xA2)
        }
    }

    /// @notice LOG3 - Emit event with 3 topics
    /// @dev LOG3(offset, size, topic1, topic2, topic3)
    function log3Raw(bytes32 data, bytes32 topic1, bytes32 topic2, bytes32 topic3) external {
        assembly {
            mstore(0x0, data)
            log3(0x0, 0x20, topic1, topic2, topic3) // LOG3 opcode (0xA3)
        }
    }

    /// @notice LOG4 - Emit event with 4 topics (maximum)
    /// @dev LOG4(offset, size, topic1, topic2, topic3, topic4)
    function log4Raw(bytes32 data, bytes32 topic1, bytes32 topic2, bytes32 topic3, bytes32 topic4) external {
        assembly {
            mstore(0x0, data)
            log4(0x0, 0x20, topic1, topic2, topic3, topic4) // LOG4 opcode (0xA4)
        }
    }

    // ========== EVENT EMISSION PATTERNS ==========

    /// @notice Emit simple event (no data)
    function emitSimpleEvent() external {
        assembly {
            // Event signature = keccak256("SimpleEvent()")
            let sig := 0x4084f8d8c8a3db7cd8b0e6e6d3b2cf1b0e5d8e5e5e5e5e5e5e5e5e5e5e5e5e5e
            log1(0, 0, sig)
        }
    }

    /// @notice Emit event with single uint256 value
    function emitValueEvent(uint256 value) external {
        assembly {
            // Store value in memory
            mstore(0x0, value)

            // Emit: EventWithValue(uint256)
            let sig := keccak256(add(mload(0x40), 0), mload("EventWithValue(uint256)"))
            log1(0x0, 0x20, sig)
        }
    }

    /// @notice Emit event with indexed parameters
    /// @dev Indexed parameters become topics, non-indexed are data
    function emitIndexedEvent(uint256 id, address sender, uint256 value) external {
        assembly {
            // Store non-indexed data
            mstore(0x0, value)

            // Emit with event signature + indexed params as topics
            // EventWithIndexed(uint256 indexed id, address indexed sender, uint256 value)
            let sig := keccak256(add(mload(0x40), 0), mload("EventWithIndexed(uint256,address,uint256)"))

            log3(
                0x0,    // data offset
                0x20,   // data size
                sig,    // topic0: event signature
                id,     // topic1: indexed id
                sender  // topic2: indexed sender
            )
        }
    }

    /// @notice Emit Transfer event (ERC20 pattern)
    /// @dev Transfer(address indexed from, address indexed to, uint256 value)
    function emitTransfer(address from, address to, uint256 value) external {
        assembly {
            // Store non-indexed value
            mstore(0x0, value)

            // Transfer event signature = keccak256("Transfer(address,address,uint256)")
            let sig := 0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef

            log3(0x0, 0x20, sig, from, to)
        }
    }

    /// @notice Emit Approval event (ERC20 pattern)
    function emitApproval(address owner, address spender, uint256 value) external {
        assembly {
            mstore(0x0, value)

            // Approval event signature
            let sig := 0x8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925

            log3(0x0, 0x20, sig, owner, spender)
        }
    }

    // ========== COMPLEX EVENT DATA ==========

    /// @notice Emit event with string data
    function emitStringEvent(string memory message) external {
        bytes memory messageBytes = bytes(message);

        assembly {
            let sig := keccak256(add(mload(0x40), 0), mload("EventWithString(string)"))
            let dataPtr := add(messageBytes, 0x20)
            let dataSize := mload(messageBytes)

            // For dynamic types, need to include offset and length
            mstore(0x0, 0x20) // offset to string data
            mstore(0x20, dataSize) // string length

            // Copy string data
            let memPtr := 0x40
            for { let i := 0 } lt(i, dataSize) { i := add(i, 0x20) } {
                mstore(add(memPtr, i), mload(add(dataPtr, i)))
            }

            let totalSize := add(0x40, and(add(dataSize, 0x1f), not(0x1f)))
            log1(0x0, totalSize, sig)
        }
    }

    /// @notice Emit event with multiple data fields
    function emitComplexEvent(uint256 id, address user, uint256 amount, uint256 timestamp) external {
        assembly {
            // Store all non-indexed fields in memory
            mstore(0x0, user)
            mstore(0x20, amount)
            mstore(0x40, timestamp)

            let sig := keccak256(add(mload(0x40), 0), mload("ComplexEvent(uint256,address,uint256,uint256)"))

            log2(
                0x0,      // data offset
                0x60,     // data size (3 * 32 bytes)
                sig,      // topic0: signature
                id        // topic1: indexed id
            )
        }
    }

    // ========== EVENT FILTERING PATTERNS ==========

    /// @notice Emit event with multiple indexed fields for filtering
    function emitFilterableEvent(uint256 indexed category, address indexed user, bytes32 indexed action, uint256 value)
        external
    {
        assembly {
            mstore(0x0, value)

            let sig := keccak256(add(mload(0x40), 0), mload("FilterableEvent(uint256,address,bytes32,uint256)"))

            log4(0x0, 0x20, sig, category, user, action)
        }
    }

    // ========== ANONYMOUS EVENTS ==========

    /// @notice Emit anonymous event (no signature topic)
    /// @dev Anonymous events don't include signature as topic0
    event AnonymousEvent(uint256 indexed value) anonymous;

    function emitAnonymousEvent(uint256 value) external {
        assembly {
            // Anonymous event: no signature, just indexed params
            log1(0, 0, value)
        }
    }

    // ========== GAS OPTIMIZATION PATTERNS ==========

    /// @notice Batch emit multiple events
    function batchEmitEvents(uint256[] calldata values) external {
        bytes32 sig = keccak256("ValueEmitted(uint256)");

        for (uint256 i = 0; i < values.length; i++) {
            assembly {
                mstore(0x0, calldataload(add(values.offset, mul(i, 0x20))))
                log1(0x0, 0x20, sig)
            }
        }
    }

    /// @notice Emit event with minimal data
    function emitMinimalEvent(uint256 value) external {
        assembly {
            // Store value directly, emit with signature
            let sig := 0x1234567890123456789012345678901234567890123456789012345678901234
            log1(value, 0, sig) // Use value as offset, 0 size (clever trick)
        }
    }

    // ========== REAL-WORLD PATTERNS ==========

    /// @notice NFT Transfer event (ERC721)
    function emitNFTTransfer(address from, address to, uint256 tokenId) external {
        assembly {
            mstore(0x0, tokenId)

            // Transfer(address,address,uint256) - same sig as ERC20
            let sig := 0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef

            log4(
                0x0, 0x20,
                sig,
                from,
                to,
                tokenId  // tokenId as 4th topic for ERC721
            )
        }
    }

    /// @notice Deposit event (WETH pattern)
    function emitDeposit(address user, uint256 amount) external {
        assembly {
            mstore(0x0, amount)

            let sig := keccak256(add(mload(0x40), 0), mload("Deposit(address,uint256)"))
            log2(0x0, 0x20, sig, user)
        }
    }

    /// @notice Withdraw event (WETH pattern)
    function emitWithdraw(address user, uint256 amount) external {
        assembly {
            mstore(0x0, amount)

            let sig := keccak256(add(mload(0x40), 0), mload("Withdrawal(address,uint256)"))
            log2(0x0, 0x20, sig, user)
        }
    }

    /// @notice Swap event (Uniswap pattern)
    function emitSwap(address sender, uint256 amount0In, uint256 amount1In, uint256 amount0Out, uint256 amount1Out, address to)
        external
    {
        assembly {
            // Store non-indexed data
            mstore(0x0, amount0In)
            mstore(0x20, amount1In)
            mstore(0x40, amount0Out)
            mstore(0x60, amount1Out)
            mstore(0x80, to)

            let sig := keccak256(add(mload(0x40), 0), mload("Swap(address,uint256,uint256,uint256,uint256,address)"))

            log2(0x0, 0xa0, sig, sender)
        }
    }

    /// @notice Role granted event (AccessControl pattern)
    function emitRoleGranted(bytes32 role, address account, address sender) external {
        assembly {
            mstore(0x0, account)

            let sig := keccak256(add(mload(0x40), 0), mload("RoleGranted(bytes32,address,address)"))

            log3(0x0, 0x20, sig, role, sender)
        }
    }
}
