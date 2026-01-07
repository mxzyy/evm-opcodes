// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

contract DataStructures {
    // ========== ARRAYS ==========

    uint256[] public dynamicArray;
    uint256[5] public fixedArray;

    /// @notice Push to dynamic array
    function pushToArray(uint256 value) external {
        dynamicArray.push(value);
    }

    /// @notice Pop from dynamic array
    function popFromArray() external {
        dynamicArray.pop();
    }

    /// @notice Get array element
    function getArrayElement(uint256 index) external view returns (uint256) {
        return dynamicArray[index];
    }

    /// @notice Set array element
    function setArrayElement(uint256 index, uint256 value) external {
        dynamicArray[index] = value;
    }

    /// @notice Get array length
    function getArrayLength() external view returns (uint256) {
        return dynamicArray.length;
    }

    /// @notice Sum all array elements (assembly loop)
    function sumArray() external view returns (uint256 sum) {
        assembly {
            let slot := dynamicArray.slot
            let length := sload(slot)

            // Calculate base slot for elements
            mstore(0x0, slot)
            let baseSlot := keccak256(0x0, 0x20)

            for { let i := 0 } lt(i, length) { i := add(i, 1) } {
                let value := sload(add(baseSlot, i))
                sum := add(sum, value)
            }
        }
    }

    // ========== MAPPINGS ==========

    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) public allowances;

    /// @notice Set balance
    function setBalance(address account, uint256 amount) external {
        balances[account] = amount;
    }

    /// @notice Get balance (assembly)
    function getBalanceAsm(address account) external view returns (uint256 bal) {
        assembly {
            mstore(0x0, account)
            mstore(0x20, balances.slot)
            let slot := keccak256(0x0, 0x40)
            bal := sload(slot)
        }
    }

    /// @notice Set allowance (nested mapping)
    function setAllowance(address owner, address spender, uint256 amount) external {
        allowances[owner][spender] = amount;
    }

    // ========== STRUCTS ==========

    struct User {
        uint256 id;
        address wallet;
        uint256 balance;
        bool active;
        string name;
    }

    mapping(address => User) public users;

    /// @notice Create user struct
    function createUser(address account, uint256 id, uint256 balance, string memory userName) external {
        users[account] = User({id: id, wallet: account, balance: balance, active: true, name: userName});
    }

    /// @notice Get user struct
    function getUser(address account) external view returns (User memory) {
        return users[account];
    }

    /// @notice Update user balance (assembly)
    function updateUserBalanceAsm(address account, uint256 newBalance) external {
        assembly {
            // Calculate user struct base slot
            mstore(0x0, account)
            mstore(0x20, users.slot)
            let baseSlot := keccak256(0x0, 0x40)

            // balance is at offset 2 in struct (id=0, wallet=1, balance=2)
            sstore(add(baseSlot, 2), newBalance)
        }
    }

    // ========== ENUMS ==========

    enum Status {
        Pending,
        Active,
        Completed,
        Cancelled
    }

    Status public currentStatus;

    function setStatus(Status status) external {
        currentStatus = status;
    }

    function getStatus() external view returns (Status) {
        return currentStatus;
    }

    // ========== BYTES ==========

    bytes public dynamicBytes;
    bytes32 public fixedBytes;

    function setBytes(bytes memory data) external {
        dynamicBytes = data;
    }

    function getBytes() external view returns (bytes memory) {
        return dynamicBytes;
    }

    function setByte32(bytes32 data) external {
        fixedBytes = data;
    }

    /// @notice Extract byte from bytes32
    function extractByte(bytes32 data, uint256 index) external pure returns (bytes1) {
        require(index < 32, "Index out of bounds");
        return data[index];
    }

    // ========== STRINGS ==========

    string public name;

    function setName(string memory newName) external {
        name = newName;
    }

    function getName() external view returns (string memory) {
        return name;
    }

    /// @notice Get string length (assembly)
    function getNameLength() external view returns (uint256 length) {
        assembly {
            let slot := name.slot
            let data := sload(slot)

            // Check if short string (length in last byte)
            let isShort := iszero(and(data, 1))

            if isShort {
                // Short string: length = last byte / 2
                length := shr(1, and(data, 0xff))
            }
            if iszero(isShort) {
                // Long string: length in slot, data at keccak256(slot)
                length := shr(1, data)
            }
        }
    }

    // ========== NESTED STRUCTURES ==========

    struct Order {
        uint256 id;
        address buyer;
        address seller;
        Item[] items;
        uint256 totalPrice;
    }

    struct Item {
        uint256 productId;
        uint256 quantity;
        uint256 price;
    }

    Order[] public orders;

    function createOrder(address buyer, address seller, uint256 totalPrice) external returns (uint256 orderId) {
        orderId = orders.length;
        orders.push();
        Order storage order = orders[orderId];
        order.id = orderId;
        order.buyer = buyer;
        order.seller = seller;
        order.totalPrice = totalPrice;
    }

    function addItemToOrder(uint256 orderId, uint256 productId, uint256 quantity, uint256 price) external {
        orders[orderId].items.push(Item({productId: productId, quantity: quantity, price: price}));
    }

    // ========== MEMORY ARRAYS ==========

    function createMemoryArray(uint256 length) external pure returns (uint256[] memory) {
        uint256[] memory arr = new uint256[](length);
        for (uint256 i = 0; i < length; i++) {
            arr[i] = i * 2;
        }
        return arr;
    }

    function sumMemoryArray(uint256[] memory arr) external pure returns (uint256 sum) {
        for (uint256 i = 0; i < arr.length; i++) {
            sum += arr[i];
        }
    }

    // ========== CALLDATA ARRAYS ==========

    function sumCalldataArray(uint256[] calldata arr) external pure returns (uint256 sum) {
        for (uint256 i = 0; i < arr.length; i++) {
            sum += arr[i];
        }
    }

    /// @notice Slice calldata array (assembly)
    function sliceCalldataArray(uint256[] calldata arr, uint256 start, uint256 end)
        external
        pure
        returns (uint256[] memory result)
    {
        require(start <= end && end <= arr.length, "Invalid range");

        uint256 length = end - start;
        result = new uint256[](length);

        assembly {
            let srcPtr := add(arr.offset, mul(start, 0x20))
            let destPtr := add(result, 0x20)

            for { let i := 0 } lt(i, length) { i := add(i, 1) } {
                let value := calldataload(add(srcPtr, mul(i, 0x20)))
                mstore(add(destPtr, mul(i, 0x20)), value)
            }
        }
    }

    // ========== PACKED STRUCTS (GAS OPTIMIZATION) ==========

    struct PackedData {
        uint128 value1;
        uint64 value2;
        uint32 value3;
        uint16 value4;
        uint8 value5;
        bool flag;
    }

    PackedData public packedData;

    function setPackedData(uint128 v1, uint64 v2, uint32 v3, uint16 v4, uint8 v5, bool flag) external {
        packedData = PackedData(v1, v2, v3, v4, v5, flag);
    }

    // ========== BIT ARRAYS ==========

    uint256 private bitArray;

    function setBitInArray(uint256 index) external {
        require(index < 256, "Index out of bounds");
        bitArray |= (1 << index);
    }

    function clearBitInArray(uint256 index) external {
        require(index < 256, "Index out of bounds");
        bitArray &= ~(1 << index);
    }

    function getBitInArray(uint256 index) external view returns (bool) {
        require(index < 256, "Index out of bounds");
        return (bitArray & (1 << index)) != 0;
    }

    // ========== LINKED LIST (STORAGE) ==========

    struct Node {
        uint256 value;
        uint256 next; // ID of next node
    }

    mapping(uint256 => Node) public linkedList;
    uint256 public headId;
    uint256 public nextId = 1;

    function appendToList(uint256 value) external {
        uint256 newId = nextId++;
        linkedList[newId] = Node(value, 0);

        if (headId == 0) {
            headId = newId;
        } else {
            // Find tail
            uint256 currentId = headId;
            while (linkedList[currentId].next != 0) {
                currentId = linkedList[currentId].next;
            }
            linkedList[currentId].next = newId;
        }
    }

    function getListValues() external view returns (uint256[] memory) {
        // Count nodes
        uint256 count = 0;
        uint256 currentId = headId;
        while (currentId != 0) {
            count++;
            currentId = linkedList[currentId].next;
        }

        // Collect values
        uint256[] memory values = new uint256[](count);
        currentId = headId;
        for (uint256 i = 0; i < count; i++) {
            values[i] = linkedList[currentId].value;
            currentId = linkedList[currentId].next;
        }

        return values;
    }
}
