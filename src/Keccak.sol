// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

contract Keccak {
    // ========== KECCAK256 BASICS ==========

    /// @notice Raw KECCAK256 operation
    /// @dev SHA3 and KECCAK256 are the same opcode (0x20)
    function keccak256Raw(bytes memory data) external pure returns (bytes32 hash) {
        assembly {
            let dataPtr := add(data, 0x20)
            let dataLen := mload(data)
            hash := keccak256(dataPtr, dataLen) // KECCAK256 opcode (0x20)
        }
    }

    /// @notice Hash single uint256
    function hashUint256(uint256 value) external pure returns (bytes32) {
        assembly {
            mstore(0x0, value)
            let hash := keccak256(0x0, 0x20)
            mstore(0x0, hash)
            return(0x0, 0x20)
        }
    }

    /// @notice Hash two uint256 values
    function hashTwoUints(uint256 a, uint256 b) external pure returns (bytes32) {
        assembly {
            mstore(0x0, a)
            mstore(0x20, b)
            let hash := keccak256(0x0, 0x40)
            mstore(0x0, hash)
            return(0x0, 0x20)
        }
    }

    /// @notice Hash address
    function hashAddress(address addr) external pure returns (bytes32) {
        assembly {
            mstore(0x0, addr)
            let hash := keccak256(0x0, 0x20)
            mstore(0x0, hash)
            return(0x0, 0x20)
        }
    }

    /// @notice Hash string
    function hashString(string memory str) external pure returns (bytes32) {
        return keccak256(bytes(str));
    }

    // ========== MAPPING SLOT COMPUTATION ==========

    /// @notice Compute mapping storage slot
    /// @dev mapping(address => uint256): slot = keccak256(key . mappingSlot)
    function computeMappingSlot(address key, uint256 mappingSlot) external pure returns (bytes32 slot) {
        assembly {
            mstore(0x0, key)
            mstore(0x20, mappingSlot)
            slot := keccak256(0x0, 0x40)
        }
    }

    /// @notice Compute nested mapping slot
    /// @dev mapping(address => mapping(address => uint256))
    function computeNestedMappingSlot(address key1, address key2, uint256 mappingSlot)
        external
        pure
        returns (bytes32 slot)
    {
        assembly {
            // First level hash
            mstore(0x0, key1)
            mstore(0x20, mappingSlot)
            let firstHash := keccak256(0x0, 0x40)

            // Second level hash
            mstore(0x0, key2)
            mstore(0x20, firstHash)
            slot := keccak256(0x0, 0x40)
        }
    }

    /// @notice Compute dynamic array element slot
    /// @dev array[index] slot = keccak256(arraySlot) + index
    function computeArrayElementSlot(uint256 arraySlot, uint256 index) external pure returns (bytes32 slot) {
        assembly {
            mstore(0x0, arraySlot)
            let baseSlot := keccak256(0x0, 0x20)
            slot := add(baseSlot, index)
        }
    }

    // ========== FUNCTION SELECTORS ==========

    /// @notice Compute function selector
    /// @dev selector = first 4 bytes of keccak256("functionName(type1,type2)")
    function computeSelector(string memory signature) external pure returns (bytes4 selector) {
        bytes32 hash = keccak256(bytes(signature));
        assembly {
            selector := hash
        }
    }

    /// @notice Get selector for transfer(address,uint256)
    function getTransferSelector() external pure returns (bytes4) {
        return bytes4(keccak256("transfer(address,uint256)"));
    }

    /// @notice Get selector for approve(address,uint256)
    function getApproveSelector() external pure returns (bytes4) {
        return bytes4(keccak256("approve(address,uint256)"));
    }

    /// @notice Verify function selector
    function verifySelector(bytes memory data, bytes4 expectedSelector) external pure returns (bool) {
        bytes4 actualSelector;
        assembly {
            actualSelector := mload(add(data, 0x20))
        }
        return actualSelector == expectedSelector;
    }

    // ========== COMMITMENT SCHEMES ==========

    /// @notice Create commitment (hash of value + salt)
    /// @dev Used in commit-reveal schemes
    function createCommitment(uint256 value, bytes32 salt) external pure returns (bytes32 commitment) {
        assembly {
            mstore(0x0, value)
            mstore(0x20, salt)
            commitment := keccak256(0x0, 0x40)
        }
    }

    /// @notice Verify commitment
    function verifyCommitment(bytes32 commitment, uint256 value, bytes32 salt) external pure returns (bool) {
        bytes32 computed;
        assembly {
            mstore(0x0, value)
            mstore(0x20, salt)
            computed := keccak256(0x0, 0x40)
        }
        return computed == commitment;
    }

    // ========== MERKLE TREE OPERATIONS ==========

    /// @notice Hash two nodes (Merkle tree internal node)
    /// @dev Standard: hash(left . right) where left < right
    function hashPair(bytes32 a, bytes32 b) external pure returns (bytes32 hash) {
        assembly {
            // Sort: smaller hash first
            switch lt(a, b)
            case 1 {
                mstore(0x0, a)
                mstore(0x20, b)
            }
            default {
                mstore(0x0, b)
                mstore(0x20, a)
            }
            hash := keccak256(0x0, 0x40)
        }
    }

    /// @notice Verify Merkle proof
    /// @param leaf Leaf node to verify
    /// @param proof Array of sibling hashes
    /// @param root Expected Merkle root
    /// @param index Leaf index in tree
    function verifyMerkleProof(bytes32 leaf, bytes32[] memory proof, bytes32 root, uint256 index)
        external
        pure
        returns (bool)
    {
        bytes32 computedHash = leaf;

        for (uint256 i = 0; i < proof.length; i++) {
            bytes32 proofElement = proof[i];

            if (index % 2 == 0) {
                // Current node is left child
                computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
            } else {
                // Current node is right child
                computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
            }

            index = index / 2;
        }

        return computedHash == root;
    }

    /// @notice Compute Merkle root from leaves (simple binary tree)
    function computeMerkleRoot(bytes32[] memory leaves) external pure returns (bytes32) {
        require(leaves.length > 0, "Empty leaves");

        while (leaves.length > 1) {
            bytes32[] memory newLevel = new bytes32[]((leaves.length + 1) / 2);

            for (uint256 i = 0; i < leaves.length; i += 2) {
                if (i + 1 < leaves.length) {
                    newLevel[i / 2] = keccak256(abi.encodePacked(leaves[i], leaves[i + 1]));
                } else {
                    newLevel[i / 2] = leaves[i];
                }
            }

            leaves = newLevel;
        }

        return leaves[0];
    }

    // ========== SIGNATURE HASHING ==========

    /// @notice Compute EIP-712 domain separator
    function computeDomainSeparator(
        string memory name,
        string memory version,
        uint256 chainId,
        address verifyingContract
    ) external pure returns (bytes32) {
        return keccak256(
            abi.encode(
                keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
                keccak256(bytes(name)),
                keccak256(bytes(version)),
                chainId,
                verifyingContract
            )
        );
    }

    /// @notice Hash typed data (EIP-712)
    function hashTypedData(bytes32 domainSeparator, bytes32 structHash) external pure returns (bytes32) {
        return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
    }

    /// @notice Compute message hash for ECDSA (Ethereum Signed Message)
    function getEthSignedMessageHash(bytes32 messageHash) external pure returns (bytes32) {
        return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", messageHash));
    }

    // ========== UNIQUE ID GENERATION ==========

    /// @notice Generate unique ID from address and nonce
    function generateUniqueId(address user, uint256 nonce) external pure returns (bytes32) {
        return keccak256(abi.encodePacked(user, nonce));
    }

    /// @notice Generate unique ID with timestamp
    function generateTimestampedId(address user, uint256 timestamp) external view returns (bytes32) {
        return keccak256(abi.encodePacked(user, timestamp, block.number));
    }

    // ========== DETERMINISTIC ADDRESSES ==========

    /// @notice Compute CREATE2 address
    /// @dev address = keccak256(0xff . deployer . salt . keccak256(initCode))[12:]
    function computeCreate2Address(address deployer, bytes32 salt, bytes32 initCodeHash)
        external
        pure
        returns (address)
    {
        bytes32 hash = keccak256(abi.encodePacked(bytes1(0xff), deployer, salt, initCodeHash));
        return address(uint160(uint256(hash)));
    }

    /// @notice Compute CREATE address
    /// @dev address = keccak256(rlp([sender, nonce]))[12:]
    /// Note: This is simplified; actual RLP encoding is more complex
    function computeCreateAddress(address deployer, uint256 nonce) external pure returns (address) {
        // Simplified for demonstration
        bytes32 hash = keccak256(abi.encodePacked(deployer, nonce));
        return address(uint160(uint256(hash)));
    }

    // ========== COLLISION RESISTANCE DEMO ==========

    /// @notice Demonstrate that different inputs produce different hashes
    function demonstrateCollisionResistance(uint256 a, uint256 b)
        external
        pure
        returns (bytes32 hash1, bytes32 hash2, bool different)
    {
        hash1 = keccak256(abi.encodePacked(a));
        hash2 = keccak256(abi.encodePacked(b));
        different = (hash1 != hash2);
    }

    /// @notice Demonstrate avalanche effect (small input change = big hash change)
    function demonstrateAvalancheEffect() external pure returns (bytes32 hash1, bytes32 hash2) {
        hash1 = keccak256(abi.encodePacked(uint256(1)));
        hash2 = keccak256(abi.encodePacked(uint256(2)));
        // Hashes will be completely different despite input differing by only 1
    }
}
