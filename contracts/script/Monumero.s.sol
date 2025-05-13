// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Monumero} from "../src/Monumero.sol";

contract MonumeroScript is Script {
    Monumero public monumero;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        monumero = new Monumero();

        vm.stopBroadcast();
    }
}
