// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Monumero} from "../src/Monumero.sol";

contract MonumeroTest is Test {
    address public berzan;
    Monumero public monumero;

    function setUp() public {
        berzan = makeAddr("berzan");
        monumero = new Monumero(berzan);
    }

    function test_Initialization() public view {
        assertEq(monumero.name(), "Monumero");
        assertEq(monumero.symbol(), "MONUMERO");
        assertEq(monumero.totalSupply(), 1);
        assertEq(monumero.ownerOf(0), berzan);
        assertEq(monumero.balanceOf(berzan), 1);
        assertEq(monumero.mintedBy(berzan), 0);
        assertEq(
            monumero.tokenURI(0),
            "data:application/json;base64,eyJuYW1lIjogIk1vbnVtZXJvICMwIiwiZGVzY3JpcHRpb24iOiAiRnVsbHkgb24tY2hhaW4gbnVtYmVyIG1pbnRlZCBvbiBGYXJjYXN0ZXIuIiwgImF0dHJpYnV0ZXMiOiBbeyJ0cmFpdF90eXBlIjogIk51bWJlciIsICJ2YWx1ZSI6ICIwIn1dLCAiaW1hZ2UiOiAiZGF0YTppbWFnZS9zdmcreG1sO2Jhc2U2NCxQSE4yWnlCNGJXeHVjejBuYUhSMGNEb3ZMM2QzZHk1M015NXZjbWN2TWpBd01DOXpkbWNuSUhacFpYZENiM2c5SnpBZ01DQXlNRFE0SURJd05EZ25JSGRwWkhSb1BTY3lNRFE0SnlCb1pXbG5hSFE5SnpJd05EZ25Qanh3WVhSb0lHWnBiR3c5SnlNMU1XWmtNREFuSUdROUowMHdJREJvTWpBME9DNHdNM1l5TURRNExqQXpTREJXTUZvbklIUnlZVzV6Wm05eWJTMXZjbWxuYVc0OUp6RXdNalF1TUROd2VDQXhNREkwTGpBemNIZ25MejQ4ZEdWNGRDQjRQU2N4TWk0eE5EY25JSGs5SnkweE9TNHpOelluSUdacGJHdzlKeU13WWpNNE1EQW5JR1p2Ym5RdFptRnRhV3g1UFNkemVYTjBaVzB0ZFdrbklHWnZiblF0YzJsNlpUMG5NemcwSnlCbWIyNTBMWGRsYVdkb2REMG5OekF3SnlCemRIbHNaVDBuZDJocGRHVXRjM0JoWTJVNmNISmxKeUIwWlhoMExXRnVZMmh2Y2owbmJXbGtaR3hsSno0OGRITndZVzRnZUQwbk1UQXlOQzR3TlNjZ2VUMG5NVEUyT1M0Mk15Y2dkR1Y0ZEMxa1pXTnZjbUYwYVc5dVBTZHZkbVZ5YkdsdVpTQnpiMnhwWkNCamIyeHZjaWh6Y21kaUlERWdNU0F4THk0NEtTY2dkMjl5WkMxemNHRmphVzVuUFNjd0p6NGpNRHd2ZEhOd1lXNCtQQzkwWlhoMFBqd3ZjM1puUGc9PSJ9"
        );
    }

    function test_Mint() public {
        address minter = makeAddr("minter");
        vm.startPrank(minter);
        vm.deal(minter, 1 ether);

        monumero.mint{value: 1 ether}();
        assertEq(monumero.totalSupply(), 2);
        assertEq(monumero.ownerOf(1), minter);
        assertEq(monumero.balanceOf(minter), 1);
        assertEq(monumero.mintedBy(minter), 1);

        address anotherMinter = makeAddr("anotherMinter");
        vm.startPrank(anotherMinter);
        vm.deal(anotherMinter, 1 ether);

        monumero.mint{value: 1 ether}();
        assertEq(monumero.totalSupply(), 3);
        assertEq(monumero.ownerOf(2), anotherMinter);
        assertEq(monumero.balanceOf(anotherMinter), 1);
        assertEq(monumero.mintedBy(anotherMinter), 2);
    }

    function test_CannotMintMoreThanOnce() public {
        address minter = makeAddr("minter");
        vm.startPrank(minter);
        vm.deal(minter, 1 ether);

        monumero.mint{value: 1 ether}();
        assertEq(monumero.totalSupply(), 2);
        assertEq(monumero.ownerOf(1), minter);
        assertEq(monumero.balanceOf(minter), 1);
        assertEq(monumero.mintedBy(minter), 1);

        vm.deal(minter, 1 ether);
        vm.expectRevert();
        monumero.mint{value: 1 ether}();
    }

    function test_CannotMintWithoutPaying() public {
        address minter = makeAddr("minter");
        vm.startPrank(minter);
        vm.deal(minter, 1 ether);

        vm.expectRevert();
        monumero.mint{value: 0.5 ether}();
    }
}
