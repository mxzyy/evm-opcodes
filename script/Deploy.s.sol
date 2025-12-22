// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {Arithmetic} from "../src/Arithmetic.sol";

contract ArithmeticOpcodesScript is Script {
    Arithmetic public arithmetic;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        arithmetic = new Arithmetic();
        vm.stopBroadcast();
    }
}
