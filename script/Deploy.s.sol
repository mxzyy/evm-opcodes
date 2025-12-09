// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {ArithmeticOpcodes} from "../src/ArithmeticOps.sol";

contract ArithmeticOpcodesScript is Script {
    ArithmeticOpcodes public arithmeticOpcodes;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        arithmeticOpcodes = new ArithmeticOpcodes();
        vm.stopBroadcast();
    }
}
