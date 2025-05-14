// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {MoMoney} from "../src/MoMoney.sol";

contract MoMoneyTest is Test {
    address public berzan;
    MoMoney public moMoney;

    function setUp() public {
        berzan = makeAddr("berzan");
        moMoney = new MoMoney(berzan);
    }

    function test_Initialization() public view {
        assertEq(moMoney.name(), "MoMoney");
        assertEq(moMoney.symbol(), "MOMONEY");
        assertEq(moMoney.totalSupply(), 1);
        assertEq(moMoney.ownerOf(0), berzan);
        assertEq(moMoney.balanceOf(berzan), 1);
        assertEq(moMoney.mintedBy(berzan), 0);
        assertEq(
            moMoney.tokenURI(0),
            "data:application/json;base64,eyJuYW1lIjogIk1vTW9uZXkgIzAiLCJkZXNjcmlwdGlvbiI6ICJNb01vbmV5IG1vcmUgcHJvYmxlbXMhIiwgImF0dHJpYnV0ZXMiOiBbeyJ0cmFpdF90eXBlIjogIk1hdGVyaWFsIiwgInZhbHVlIjogIkRpYW1vbmQifV0sICJpbWFnZSI6ICJkYXRhOmltYWdlL3N2Zyt4bWw7YmFzZTY0LFBITjJaeUI0Yld4dWN6MG5hSFIwY0RvdkwzZDNkeTUzTXk1dmNtY3ZNakF3TUM5emRtY25JSGRwWkhSb1BTY3lNRFE0SnlCb1pXbG5hSFE5SnpJd05EZ25Qanh3WVhSb0lHWnBiR3c5SnlNd01HWXdabVVuSUdROUowMHdJREJvTWpBME9IWXlNRFE0U0RCV01Gb25JSFJ5WVc1elptOXliUzF2Y21sbmFXNDlKekV3TWpSd2VDQXhNREkwY0hnbkx6NDhkR1Y0ZENCbWFXeHNQU2NqTURBek1UUmxKeUJ6ZEhKdmEyVXRkMmxrZEdnOUp6QW5JR1p2Ym5RdFptRnRhV3g1UFNkemVYTjBaVzB0ZFdrbklHWnZiblF0YzJsNlpUMG5OVEV5SnlCbWIyNTBMWGRsYVdkb2REMG5OekF3SnlCemRIbHNaVDBuZDJocGRHVXRjM0JoWTJVNmNISmxKeUIwWlhoMExXRnVZMmh2Y2owbmJXbGtaR3hsSno0OGRITndZVzRnZUQwbk1UQXlOQzR3TmljZ2VUMG5NVEl4T0M0d05pY2dkR1Y0ZEMxa1pXTnZjbUYwYVc5dVBTZHZkbVZ5YkdsdVpTQnpiMnhwWkNCamIyeHZjaWh6Y21kaUlERWdNU0F4THk0NEtTYytJekE4TDNSemNHRnVQand2ZEdWNGRENDhMM04yWno0PSJ9"
        );
    }

    function test_Mint() public {
        address minter = makeAddr("minter");
        vm.startPrank(minter);
        vm.deal(minter, 1 ether);

        moMoney.mint{value: 1 ether}();
        assertEq(moMoney.totalSupply(), 2);
        assertEq(moMoney.ownerOf(1), minter);
        assertEq(moMoney.balanceOf(minter), 1);
        assertEq(moMoney.mintedBy(minter), 1);

        address anotherMinter = makeAddr("anotherMinter");
        vm.startPrank(anotherMinter);
        vm.deal(anotherMinter, 1 ether);

        moMoney.mint{value: 1 ether}();
        assertEq(moMoney.totalSupply(), 3);
        assertEq(moMoney.ownerOf(2), anotherMinter);
        assertEq(moMoney.balanceOf(anotherMinter), 1);
        assertEq(moMoney.mintedBy(anotherMinter), 2);
    }

    function test_CannotMintMoreThanOnce() public {
        address minter = makeAddr("minter");
        vm.startPrank(minter);
        vm.deal(minter, 1 ether);

        moMoney.mint{value: 1 ether}();
        assertEq(moMoney.totalSupply(), 2);
        assertEq(moMoney.ownerOf(1), minter);
        assertEq(moMoney.balanceOf(minter), 1);
        assertEq(moMoney.mintedBy(minter), 1);

        vm.deal(minter, 1 ether);
        vm.expectRevert();
        moMoney.mint{value: 1 ether}();
    }

    function test_CannotMintWithoutPaying() public {
        address minter = makeAddr("minter");
        vm.startPrank(minter);
        vm.deal(minter, 1 ether);

        vm.expectRevert();
        moMoney.mint{value: 0.5 ether}();
    }
}
