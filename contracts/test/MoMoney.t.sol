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
            "data:application/json;base64,eyJuYW1lIjogIk1vTW9uZXkgIzAiLCJkZXNjcmlwdGlvbiI6ICJUaGUgZmlyc3QgcHVyZSBvbi1jaGFpbiBORlQgZXhwZXJpbWVudCBvbiBNb25hZCBUZXN0bmV0LiIsICJhdHRyaWJ1dGVzIjogW3sidHJhaXRfdHlwZSI6ICJNYXRlcmlhbCIsICJ2YWx1ZSI6ICJEaWFtb25kIn1dLCAiaW1hZ2UiOiAiZGF0YTppbWFnZS9zdmcreG1sO2Jhc2U2NCxQSE4yWnlCNGJXeHVjejBuYUhSMGNEb3ZMM2QzZHk1M015NXZjbWN2TWpBd01DOXpkbWNuSUhkcFpIUm9QU2N5TURRNEp5Qm9aV2xuYUhROUp6SXdORGduUGp4d1lYUm9JR1pwYkd3OUp5TXdNR1l3Wm1VbklHUTlKMDB3SURCb01qQTBPSFl5TURRNFNEQldNRm9uSUhSeVlXNXpabTl5YlMxdmNtbG5hVzQ5SnpFd01qUndlQ0F4TURJMGNIZ25MejQ4ZEdWNGRDQm1hV3hzUFNjak1EQXpNVFJsSnlCemRISnZhMlV0ZDJsa2RHZzlKekFuSUdadmJuUXRabUZ0YVd4NVBTZHplWE4wWlcwdGRXa25JR1p2Ym5RdGMybDZaVDBuTlRFeUp5Qm1iMjUwTFhkbGFXZG9kRDBuTnpBd0p5QnpkSGxzWlQwbmQyaHBkR1V0YzNCaFkyVTZjSEpsSnlCMFpYaDBMV0Z1WTJodmNqMG5iV2xrWkd4bEp6NDhkSE53WVc0Z2VEMG5NVEF5TkM0d05pY2dlVDBuTVRJeE9DNHdOaWNnZEdWNGRDMWtaV052Y21GMGFXOXVQU2R2ZG1WeWJHbHVaU0J6YjJ4cFpDQmpiMnh2Y2loemNtZGlJREVnTVNBeEx5NDRLU2MrSXpBOEwzUnpjR0Z1UGp3dmRHVjRkRDQ4TDNOMlp6ND0ifQ=="
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
