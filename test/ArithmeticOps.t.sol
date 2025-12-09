// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {ArithmeticOpcodes} from "../src/ArithmeticOps.sol";

contract ArithmeticOpcodesTest is Test {
    ArithmeticOpcodes public arithmeticOpcodes;

    function setUp() public {
        arithmeticOpcodes = new ArithmeticOpcodes();
    }

    function testAdd() public view {
        uint256 result = arithmeticOpcodes.add(2, 3);
        assertEq(result, 5);
    }
}
