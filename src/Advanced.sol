// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

// ========== MODIFIERS ==========

contract Advanced {
    address public owner;
    bool private locked;

    constructor() {
        owner = msg.sender;
    }

    /// @notice onlyOwner modifier
    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    /// @notice onlyOwner implemented in assembly
    modifier onlyOwnerAsm() {
        assembly {
            let sender := caller()
            let ownerAddr := sload(owner.slot)

            if iszero(eq(sender, ownerAddr)) { revert(0, 0) }
        }
        _;
    }

    /// @notice Reentrancy guard modifier
    modifier nonReentrant() {
        require(!locked, "Reentrant call");
        locked = true;
        _;
        locked = false;
    }

    /// @notice Reentrancy guard in assembly
    modifier nonReentrantAsm() {
        assembly {
            let isLocked := sload(locked.slot)

            if isLocked { revert(0, 0) }

            sstore(locked.slot, 1)
        }
        _;
        assembly {
            sstore(locked.slot, 0)
        }
    }

    function restrictedFunction() external view onlyOwner returns (bool) {
        return true;
    }

    function protectedFunction() external nonReentrant returns (bool) {
        return true;
    }

    // ========== INHERITANCE ==========

    /// @notice Transfer ownership
    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "Zero address");
        owner = newOwner;
    }
}

// Base contract
abstract contract Base {
    uint256 public baseValue;

    function setBaseValue(uint256 value) external virtual {
        baseValue = value;
    }

    function getBaseValue() external view virtual returns (uint256) {
        return baseValue;
    }
}

// Derived contract
contract Derived is Base {
    uint256 public derivedValue;

    function setDerivedValue(uint256 value) external {
        derivedValue = value;
    }

    // Override base function
    function setBaseValue(uint256 value) external override {
        baseValue = value * 2;
    }
}

// ========== INTERFACES ==========

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 amount) external returns (bool);
}

contract InterfaceUser {
    function getBalance(address token, address account) external view returns (uint256) {
        return IERC20(token).balanceOf(account);
    }

    function transferTokens(address token, address to, uint256 amount) external returns (bool) {
        return IERC20(token).transfer(to, amount);
    }
}

// ========== ABSTRACT CONTRACTS ==========

abstract contract AbstractToken {
    string public name;
    string public symbol;
    uint8 public decimals;

    constructor(string memory _name, string memory _symbol, uint8 _decimals) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
    }

    function totalSupply() external view virtual returns (uint256);
    function balanceOf(address account) external view virtual returns (uint256);
}

contract ConcreteToken is AbstractToken {
    mapping(address => uint256) private balances;
    uint256 private _totalSupply;

    constructor() AbstractToken("MyToken", "MTK", 18) {
        _totalSupply = 1000000 * 10 ** 18;
        balances[msg.sender] = _totalSupply;
    }

    function totalSupply() external view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) external view override returns (uint256) {
        return balances[account];
    }
}

// ========== LIBRARIES ==========

library Math {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "Underflow");
        return a - b;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) return 0;
        uint256 c = a * b;
        require(c / a == b, "Overflow");
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "Division by zero");
        return a / b;
    }
}

contract UsingLibrary {
    using Math for uint256;

    function calculate(uint256 a, uint256 b) external pure returns (uint256) {
        return a.add(b).mul(2);
    }
}

// ========== USING FOR ==========

library ArrayLib {
    function sum(uint256[] memory arr) internal pure returns (uint256 total) {
        for (uint256 i = 0; i < arr.length; i++) {
            total += arr[i];
        }
    }

    function average(uint256[] memory arr) internal pure returns (uint256) {
        require(arr.length > 0, "Empty array");
        return sum(arr) / arr.length;
    }
}

contract UsingForExample {
    using ArrayLib for uint256[];

    function getSum(uint256[] memory numbers) external pure returns (uint256) {
        return numbers.sum();
    }

    function getAverage(uint256[] memory numbers) external pure returns (uint256) {
        return numbers.average();
    }
}

// ========== MULTIPLE INHERITANCE ==========

contract A {
    uint256 public valueA;

    function setA(uint256 value) public virtual {
        valueA = value;
    }
}

contract B {
    uint256 public valueB;

    function setB(uint256 value) public virtual {
        valueB = value;
    }
}

contract C is A, B {
    function setBoth(uint256 value) external {
        setA(value);
        setB(value);
    }
}

// ========== DIAMOND INHERITANCE ==========

contract Base1 {
    function foo() external pure virtual returns (string memory) {
        return "Base1";
    }
}

contract Base2 {
    function foo() external pure virtual returns (string memory) {
        return "Base2";
    }
}

contract Diamond is Base1, Base2 {
    // Must override to resolve ambiguity
    function foo() external pure override(Base1, Base2) returns (string memory) {
        return "Diamond";
    }
}

// ========== PROXY PATTERN ==========

contract Implementation {
    uint256 public value;

    function setValue(uint256 newValue) external {
        value = newValue;
    }

    function getValue() external view returns (uint256) {
        return value;
    }
}

contract Proxy {
    address public implementation;

    constructor(address _implementation) {
        implementation = _implementation;
    }

    fallback() external payable {
        address impl = implementation;
        assembly {
            calldatacopy(0, 0, calldatasize())
            let result := delegatecall(gas(), impl, 0, calldatasize(), 0, 0)
            returndatacopy(0, 0, returndatasize())

            switch result
            case 0 { revert(0, returndatasize()) }
            default { return(0, returndatasize()) }
        }
    }

    receive() external payable {}
}

// ========== UPGRADEABLE PATTERN ==========

contract UpgradeableProxy {
    bytes32 private constant IMPLEMENTATION_SLOT = keccak256("eip1967.proxy.implementation");
    bytes32 private constant ADMIN_SLOT = keccak256("eip1967.proxy.admin");

    constructor(address _implementation, address _admin) {
        assembly {
            // EIP-1967: keccak256("eip1967.proxy.implementation") - 1
            sstore(0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc, _implementation)
            // EIP-1967: keccak256("eip1967.proxy.admin") - 1
            sstore(0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103, _admin)
        }
    }

    function upgradeTo(address newImplementation) external {
        assembly {
            let admin := sload(0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103)
            let sender := caller()

            if iszero(eq(sender, admin)) { revert(0, 0) }

            sstore(0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc, newImplementation)
        }
    }

    fallback() external payable {
        assembly {
            let impl := sload(0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc)
            calldatacopy(0, 0, calldatasize())
            let result := delegatecall(gas(), impl, 0, calldatasize(), 0, 0)
            returndatacopy(0, 0, returndatasize())

            switch result
            case 0 { revert(0, returndatasize()) }
            default { return(0, returndatasize()) }
        }
    }

    receive() external payable {}
}

// ========== FALLBACK & RECEIVE ==========

contract FallbackExample {
    event FallbackCalled(bytes data);
    event ReceiveCalled(uint256 amount);

    // Called when ETH is sent with empty calldata
    receive() external payable {
        emit ReceiveCalled(msg.value);
    }

    // Called when function doesn't exist or ETH sent with data
    fallback() external payable {
        emit FallbackCalled(msg.data);
    }
}

// ========== IMMUTABLE & CONSTANT ==========

contract Constants {
    // Constant: replaced at compile time
    uint256 public constant MAX_SUPPLY = 1000000;
    address public constant DEAD_ADDRESS = address(0xdead);

    // Immutable: set in constructor, stored in code
    uint256 public immutable deploymentTime;
    address public immutable deployer;

    constructor() {
        deploymentTime = block.timestamp;
        deployer = msg.sender;
    }
}

// ========== ASSEMBLY-HEAVY CONTRACT ==========

contract AssemblyHeavy {
    function efficientTransfer(address from, address to, uint256 amount) external {
        assembly {
            // Load balances mapping slot
            let balancesSlot := 0

            // Calculate from balance slot
            mstore(0x0, from)
            mstore(0x20, balancesSlot)
            let fromSlot := keccak256(0x0, 0x40)
            let fromBalance := sload(fromSlot)

            // Check sufficient balance
            if lt(fromBalance, amount) { revert(0, 0) }

            // Calculate to balance slot
            mstore(0x0, to)
            let toSlot := keccak256(0x0, 0x40)
            let toBalance := sload(toSlot)

            // Update balances
            sstore(fromSlot, sub(fromBalance, amount))
            sstore(toSlot, add(toBalance, amount))
        }
    }
}
