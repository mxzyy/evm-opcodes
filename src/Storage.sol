// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

contract Storage {
    // ========== STATE VARIABLES (STORAGE) ==========

    uint256 public counter;                          // slot 0
    address public owner;                            // slot 1
    bool public isActive;                            // slot 2 (packed with next vars if small enough)
    uint128 public smallNum1;                        // slot 2 (packed)
    uint128 public smallNum2;                        // slot 2 (packed)

    mapping(address => uint256) public balances;     // slot 3
    mapping(address => mapping(address => uint256)) public allowances; // slot 4

    uint256[] public dynamicArray;                   // slot 5

    struct User {
        uint256 id;
        address wallet;
        uint256 balance;
        bool active;
    }
    mapping(address => User) public users;           // slot 6

    // ========== RAW STORAGE OPERATIONS ==========

    /// @notice SLOAD - Read from storage slot
    function sloadRaw(uint256 slot) external view returns (uint256 value) {
        assembly {
            value := sload(slot) // SLOAD opcode (0x54)
        }
    }

    /// @notice SSTORE - Write to storage slot
    function sstoreRaw(uint256 slot, uint256 value) external {
        assembly {
            sstore(slot, value) // SSTORE opcode (0x55)
        }
    }

    // ========== BASIC STORAGE OPERATIONS ==========

    /// @notice Increment counter (demonstrates SLOAD + SSTORE pattern)
    function incrementCounter() external returns (uint256) {
        assembly {
            let slot := 0 // counter is at slot 0
            let currentValue := sload(slot)
            let newValue := add(currentValue, 1)
            sstore(slot, newValue)
            mstore(0x0, newValue)
            return(0x0, 0x20)
        }
    }

    /// @notice Set owner address
    function setOwner(address newOwner) external {
        assembly {
            sstore(1, newOwner) // owner is at slot 1
        }
    }

    /// @notice Get owner address
    function getOwner() external view returns (address) {
        assembly {
            let ownerAddr := sload(1)
            mstore(0x0, ownerAddr)
            return(0x0, 0x20)
        }
    }

    // ========== STORAGE PACKING DEMO ==========

    /// @notice Set both uint128 values (storage packing)
    /// @dev Both values packed into slot 2
    function setPackedValues(uint128 val1, uint128 val2) external {
        assembly {
            // Pack two uint128 into one uint256
            // val2 in high 128 bits, val1 in low 128 bits
            let packed := or(shl(128, val2), val1)
            sstore(2, packed)
        }
    }

    /// @notice Get packed values from slot 2
    function getPackedValues() external view returns (uint128 val1, uint128 val2) {
        assembly {
            let packed := sload(2)
            // Extract low 128 bits
            val1 := and(packed, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF)
            // Extract high 128 bits
            val2 := shr(128, packed)
        }
    }

    // ========== MAPPING OPERATIONS ==========

    /// @notice Set balance for address in mapping
    /// @dev Mapping slot = keccak256(key . slot)
    function setBalance(address account, uint256 amount) external {
        assembly {
            // Store key (account) at memory position 0x0
            mstore(0x0, account)
            // Store mapping slot (3) at memory position 0x20
            mstore(0x20, 3)
            // Compute keccak256(key . slot)
            let mappingSlot := keccak256(0x0, 0x40)
            // Store value
            sstore(mappingSlot, amount)
        }
    }

    /// @notice Get balance from mapping
    function getBalance(address account) external view returns (uint256) {
        assembly {
            mstore(0x0, account)
            mstore(0x20, 3)
            let mappingSlot := keccak256(0x0, 0x40)
            let balance := sload(mappingSlot)
            mstore(0x0, balance)
            return(0x0, 0x20)
        }
    }

    /// @notice Set nested mapping value (allowances)
    /// @dev Nested mapping: keccak256(key2 . keccak256(key1 . slot))
    function setAllowance(address owner_, address spender, uint256 amount) external {
        assembly {
            // First level: keccak256(owner . slot4)
            mstore(0x0, owner_)
            mstore(0x20, 4) // allowances is at slot 4
            let firstHash := keccak256(0x0, 0x40)

            // Second level: keccak256(spender . firstHash)
            mstore(0x0, spender)
            mstore(0x20, firstHash)
            let finalSlot := keccak256(0x0, 0x40)

            // Store value
            sstore(finalSlot, amount)
        }
    }

    /// @notice Get nested mapping value
    function getAllowance(address owner_, address spender) external view returns (uint256) {
        assembly {
            mstore(0x0, owner_)
            mstore(0x20, 4)
            let firstHash := keccak256(0x0, 0x40)

            mstore(0x0, spender)
            mstore(0x20, firstHash)
            let finalSlot := keccak256(0x0, 0x40)

            let allowance := sload(finalSlot)
            mstore(0x0, allowance)
            return(0x0, 0x20)
        }
    }

    // ========== DYNAMIC ARRAY OPERATIONS ==========

    /// @notice Push to dynamic array
    /// @dev Array length at slot, elements at keccak256(slot) + index
    function pushToArray(uint256 value) external {
        assembly {
            let slot := 5 // dynamicArray is at slot 5

            // Read current length
            let length := sload(slot)

            // Store value at keccak256(slot) + length
            mstore(0x0, slot)
            let dataSlot := add(keccak256(0x0, 0x20), length)
            sstore(dataSlot, value)

            // Increment length
            sstore(slot, add(length, 1))
        }
    }

    /// @notice Get array length
    function getArrayLength() external view returns (uint256) {
        assembly {
            let length := sload(5)
            mstore(0x0, length)
            return(0x0, 0x20)
        }
    }

    /// @notice Get array element at index
    function getArrayElement(uint256 index) external view returns (uint256) {
        assembly {
            let slot := 5
            let length := sload(slot)

            // Bounds check
            if iszero(lt(index, length)) {
                revert(0, 0)
            }

            // Calculate element slot
            mstore(0x0, slot)
            let dataSlot := add(keccak256(0x0, 0x20), index)
            let value := sload(dataSlot)

            mstore(0x0, value)
            return(0x0, 0x20)
        }
    }

    // ========== STRUCT IN MAPPING ==========

    /// @notice Set user struct in mapping
    /// @dev Struct fields stored consecutively from base slot
    function setUser(address account, uint256 id, address wallet, uint256 balance, bool active) external {
        assembly {
            // Calculate base slot for this user
            mstore(0x0, account)
            mstore(0x20, 6) // users mapping at slot 6
            let baseSlot := keccak256(0x0, 0x40)

            // Store struct fields (consecutive slots)
            sstore(baseSlot, id)                    // User.id at baseSlot + 0
            sstore(add(baseSlot, 1), wallet)        // User.wallet at baseSlot + 1
            sstore(add(baseSlot, 2), balance)       // User.balance at baseSlot + 2
            sstore(add(baseSlot, 3), active)        // User.active at baseSlot + 3
        }
    }

    /// @notice Get user struct from mapping
    function getUser(address account) external view returns (uint256 id, address wallet, uint256 balance, bool active) {
        assembly {
            mstore(0x0, account)
            mstore(0x20, 6)
            let baseSlot := keccak256(0x0, 0x40)

            id := sload(baseSlot)
            wallet := sload(add(baseSlot, 1))
            balance := sload(add(baseSlot, 2))
            active := sload(add(baseSlot, 3))
        }
    }

    // ========== GAS OPTIMIZATION PATTERNS ==========

    /// @notice Demonstrate cold vs warm SLOAD
    /// @dev First SLOAD is cold (2100 gas), subsequent are warm (100 gas)
    function demonstrateColdWarmSload() external view returns (uint256, uint256, uint256) {
        uint256 val1;
        uint256 val2;
        uint256 val3;

        assembly {
            val1 := sload(0) // COLD SLOAD (2100 gas)
            val2 := sload(0) // WARM SLOAD (100 gas)
            val3 := sload(0) // WARM SLOAD (100 gas)
        }

        return (val1, val2, val3);
    }

    /// @notice Batch read multiple storage slots
    function batchRead(uint256[] calldata slots) external view returns (uint256[] memory values) {
        values = new uint256[](slots.length);
        assembly {
            let len := mload(slots)
            let valuesPtr := add(values, 0x20)
            let slotsPtr := add(slots.offset, 0)

            for { let i := 0 } lt(i, len) { i := add(i, 1) } {
                let slot := calldataload(add(slotsPtr, mul(i, 0x20)))
                let value := sload(slot)
                mstore(add(valuesPtr, mul(i, 0x20)), value)
            }
        }
    }

    /// @notice Clear storage slot (refund gas)
    /// @dev Setting storage to 0 gives gas refund
    function clearSlot(uint256 slot) external {
        assembly {
            sstore(slot, 0) // Gas refund!
        }
    }
}
