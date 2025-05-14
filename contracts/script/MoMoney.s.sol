// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {MoMoney} from "../src/MoMoney.sol";

contract MoMoneyScript is Script {
    MoMoney public moMoney;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        moMoney = new MoMoney(vm.envAddress("BERZAN"));

        vm.stopBroadcast();
    }
}
