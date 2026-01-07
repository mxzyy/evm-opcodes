// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

// Simple contract for deployment testing
contract SimpleContract {
    uint256 public value;
    address public creator;

    constructor(uint256 _value) {
        value = _value;
        creator = msg.sender;
    }

    function setValue(uint256 newValue) external {
        value = newValue;
    }
}

// Contract with payable constructor
contract PayableContract {
    uint256 public receivedAmount;

    constructor() payable {
        receivedAmount = msg.value;
    }
}

contract ContractCreation {
    event ContractDeployed(address addr, uint256 value);

    // ========== CREATE OPCODE ==========

    /// @notice CREATE - Deploy contract using CREATE opcode
    /// @dev address = keccak256(rlp([sender, nonce]))[12:]
    function createRaw(bytes memory bytecode) external payable returns (address addr) {
        assembly {
            // CREATE(value, offset, size)
            addr :=
                create(
                    callvalue(), // value to send
                    add(bytecode, 0x20), // bytecode offset (skip length)
                    mload(bytecode) // bytecode size
                )

            // Check if deployment succeeded
            if iszero(addr) { revert(0, 0) }
        }

        emit ContractDeployed(addr, msg.value);
    }

    /// @notice Deploy SimpleContract using CREATE
    function deploySimpleContract(uint256 initialValue) external returns (address) {
        // Get bytecode
        bytes memory bytecode = abi.encodePacked(type(SimpleContract).creationCode, abi.encode(initialValue));

        address addr;
        assembly {
            addr := create(0, add(bytecode, 0x20), mload(bytecode))

            if iszero(addr) { revert(0, 0) }
        }

        return addr;
    }

    /// @notice Deploy with value
    function deployPayableContract() external payable returns (address) {
        bytes memory bytecode = type(PayableContract).creationCode;

        address addr;
        assembly {
            addr := create(callvalue(), add(bytecode, 0x20), mload(bytecode))

            if iszero(addr) { revert(0, 0) }
        }

        return addr;
    }

    // ========== CREATE2 OPCODE ==========

    /// @notice CREATE2 - Deploy contract with deterministic address
    /// @dev address = keccak256(0xff . sender . salt . keccak256(initCode))[12:]
    function create2Raw(bytes memory bytecode, bytes32 salt) external payable returns (address addr) {
        assembly {
            // CREATE2(value, offset, size, salt)
            addr := create2(callvalue(), add(bytecode, 0x20), mload(bytecode), salt)

            if iszero(addr) { revert(0, 0) }
        }

        emit ContractDeployed(addr, msg.value);
    }

    /// @notice Deploy SimpleContract using CREATE2
    function deploySimpleContractCreate2(uint256 initialValue, bytes32 salt) external returns (address) {
        bytes memory bytecode = abi.encodePacked(type(SimpleContract).creationCode, abi.encode(initialValue));

        address addr;
        assembly {
            addr := create2(0, add(bytecode, 0x20), mload(bytecode), salt)

            if iszero(addr) { revert(0, 0) }
        }

        return addr;
    }

    /// @notice Predict CREATE2 address before deployment
    function predictCreate2Address(bytes memory bytecode, bytes32 salt) external view returns (address) {
        bytes32 hash = keccak256(abi.encodePacked(bytes1(0xff), address(this), salt, keccak256(bytecode)));

        return address(uint160(uint256(hash)));
    }

    /// @notice Verify CREATE2 deployment
    function verifyCreate2(bytes memory bytecode, bytes32 salt, address expectedAddr) external view returns (bool) {
        address predicted = this.predictCreate2Address(bytecode, salt);
        return predicted == expectedAddr;
    }

    // ========== FACTORY PATTERN ==========

    address[] public deployedContracts;

    /// @notice Factory: deploy multiple contracts
    function deployMultiple(uint256[] calldata values) external returns (address[] memory) {
        address[] memory addrs = new address[](values.length);

        for (uint256 i = 0; i < values.length; i++) {
            bytes memory bytecode = abi.encodePacked(type(SimpleContract).creationCode, abi.encode(values[i]));

            address addr;
            assembly {
                addr := create(0, add(bytecode, 0x20), mload(bytecode))
            }

            addrs[i] = addr;
            deployedContracts.push(addr);
        }

        return addrs;
    }

    /// @notice Get all deployed contracts
    function getDeployedContracts() external view returns (address[] memory) {
        return deployedContracts;
    }

    // ========== MINIMAL PROXY (EIP-1167) ==========

    /// @notice Deploy minimal proxy clone
    /// @dev Minimal proxy bytecode: 0x3d602d80600a3d3981f3363d3d373d3d3d363d73[implementation]5af43d82803e903d91602b57fd5bf3
    function deployClone(address implementation) external returns (address clone) {
        bytes20 implementationBytes = bytes20(implementation);

        assembly {
            let ptr := mload(0x40)

            // Minimal proxy bytecode
            mstore(ptr, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
            mstore(add(ptr, 0x14), implementationBytes)
            mstore(add(ptr, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)

            clone := create(0, ptr, 0x37)

            if iszero(clone) { revert(0, 0) }
        }
    }

    /// @notice Deploy minimal proxy clone using CREATE2
    function deployCloneCreate2(address implementation, bytes32 salt) external returns (address clone) {
        bytes20 implementationBytes = bytes20(implementation);

        assembly {
            let ptr := mload(0x40)

            mstore(ptr, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
            mstore(add(ptr, 0x14), implementationBytes)
            mstore(add(ptr, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)

            clone := create2(0, ptr, 0x37, salt)

            if iszero(clone) { revert(0, 0) }
        }
    }

    /// @notice Predict clone address
    function predictCloneAddress(address implementation, bytes32 salt) external view returns (address) {
        bytes20 implementationBytes = bytes20(implementation);

        bytes memory bytecode;
        assembly {
            bytecode := mload(0x40)
            mstore(bytecode, 0x37) // length

            let ptr := add(bytecode, 0x20)
            mstore(ptr, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
            mstore(add(ptr, 0x14), implementationBytes)
            mstore(add(ptr, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)

            mstore(0x40, add(ptr, 0x37))
        }

        return this.predictCreate2Address(bytecode, salt);
    }

    // ========== SELF-DESTRUCT FACTORY ==========

    /// @notice Deploy contract that self-destructs
    function deployTempContract() external returns (address) {
        bytes memory bytecode = hex"6080604052348015600e575f5ffd5b5060405160405180910390f3fe";

        address addr;
        assembly {
            addr := create(0, add(bytecode, 0x20), mload(bytecode))
        }

        return addr;
    }

    // ========== INIT CODE PATTERNS ==========

    /// @notice Get contract creation code
    function getCreationCode() external pure returns (bytes memory) {
        return type(SimpleContract).creationCode;
    }

    /// @notice Get contract runtime code
    function getRuntimeCode() external pure returns (bytes memory) {
        return type(SimpleContract).runtimeCode;
    }

    /// @notice Compute init code hash for CREATE2
    function computeInitCodeHash(bytes memory bytecode) external pure returns (bytes32) {
        return keccak256(bytecode);
    }

    // ========== CONSTRUCTOR PATTERNS ==========

    /// @notice Deploy with complex constructor
    function deployWithComplexConstructor(uint256 value, address addr, string memory str) external returns (address) {
        // Encode constructor parameters
        bytes memory constructorParams = abi.encode(value, addr, str);

        // Combine creation code with constructor params
        bytes memory bytecode = abi.encodePacked(type(SimpleContract).creationCode, constructorParams);

        address deployed;
        assembly {
            deployed := create(0, add(bytecode, 0x20), mload(bytecode))
        }

        return deployed;
    }

    // ========== GAS OPTIMIZATION ==========

    /// @notice Check deployment cost
    function estimateDeploymentCost(bytes memory bytecode) external returns (uint256) {
        uint256 gasBefore = gasleft();

        address addr;
        assembly {
            addr := create(0, add(bytecode, 0x20), mload(bytecode))
        }

        uint256 gasAfter = gasleft();
        return gasBefore - gasAfter;
    }
}
