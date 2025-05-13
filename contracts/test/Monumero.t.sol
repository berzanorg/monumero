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
            "data:application/json;base64,eyJuYW1lIjogIk1vbnVtZXJvICMwIiwiZGVzY3JpcHRpb24iOiAiRnVsbHkgb24tY2hhaW4gTW9uYWQgVGVzdG5ldCBudW1iZXIgbWludGVkIG9uIEZhcmNhc3Rlci4iLCAiaW1hZ2UiOiAiZGF0YTppbWFnZS9zdmcreG1sO2Jhc2U2NCw8c3ZnIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgdmlld0JveD0iMCAwIDIwNDggMjA0OCIgd2lkdGg9IjIwNDgiIGhlaWdodD0iMjA0OCI+PHBhdGggZmlsbD0iIzUxZmQwMCIgZD0iTTAgMGgyMDQ4LjAzdjIwNDguMDNIMFYwWiIgdHJhbnNmb3JtLW9yaWdpbj0iMTAyNC4wM3B4IDEwMjQuMDNweCIvPjx0ZXh0IHg9IjEyLjE0NyIgeT0iLTE5LjM3NiIgZmlsbD0iIzBiMzgwMCIgZm9udC1mYW1pbHk9InN5c3RlbS11aSIgZm9udC1zaXplPSIzODQiIGZvbnQtd2VpZ2h0PSI3MDAiIHN0eWxlPSJ3aGl0ZS1zcGFjZTpwcmUiIHRleHQtYW5jaG9yPSJtaWRkbGUiPjx0c3BhbiB4PSIxMDI0LjA1IiB5PSIxMTY5LjYzIiB0ZXh0LWRlY29yYXRpb249Im92ZXJsaW5lIHNvbGlkIGNvbG9yKHNyZ2IgMSAxIDEvLjgpIiB3b3JkLXNwYWNpbmc9IjAiPiMwPC90c3Bhbj48L3RleHQ+PC9zdmc+In0="
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
