// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

contract ArithmeticOpcodes {
    // 1. Basic unsigned ops (udah lo punya)
    function add(uint256 a, uint256 b) external pure returns (uint256) {
        return a + b;
    }

    function sub(uint256 a, uint256 b) external pure returns (uint256) {
        return a - b;
    }

    function mul(uint256 a, uint256 b) external pure returns (uint256) {
        return a * b;
    }

    function div(uint256 a, uint256 b) external pure returns (uint256) {
        require(b != 0, "Division by zero");
        return a / b;
    }

    function mod(uint256 a, uint256 b) external pure returns (uint256) {
        require(b != 0, "Modulo by zero");
        return a % b;
    }

    // Unchecked versions to demonstrate unchecked ops
    function addUnchecked(uint256 a, uint256 b) external pure returns (uint256) {
        unchecked {
            return a + b;
        }
    }

    // 3. ADDMOD / MULMOD → opcode khusus
    function addMod(uint256 a, uint256 b, uint256 m) external pure returns (uint256) {
        return addmod(a, b, m);
    }

    function mulMod(uint256 a, uint256 b, uint256 m) external pure returns (uint256) {
        return mulmod(a, b, m);
    }

    // 4. EXP → perpangkatan
    function pow(uint256 base, uint256 exp_) external pure returns (uint256) {
        return base ** exp_;
    }
}
