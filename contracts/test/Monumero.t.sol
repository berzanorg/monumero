// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Monumero} from "../src/Monumero.sol";

contract MonumeroTest is Test {
    Monumero public monumero;

    function setUp() public {
        monumero = new Monumero();
    }

    function test_Sum() public pure {
        assertEq(1 + 1, uint256(2));
    }
}
