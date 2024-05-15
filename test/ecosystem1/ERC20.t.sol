// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../../src/ecosystem1/ERC20.sol";

contract MyERC20Test is Test {
    MyERC20 token;
    address owner = address(this);

    function setUp() public {
        token = new MyERC20();
    }

    function testInitialSupply() public view {
        assertEq(token.totalSupply(), 0);
    }

    function testMintingByOwner() public {
        token.mint(address(0x123), 1000);
        assertEq(token.balanceOf(address(0x123)), 1000);
    }

    function testMintingByNonOwner() public {
        address nonOwner = address(0x1234);
        vm.prank(nonOwner);

        // Expect the transaction to revert with the custom error from Ownable
        vm.expectRevert(abi.encodeWithSelector(Ownable.OwnableUnauthorizedAccount.selector, nonOwner));
        token.mint(address(0x5678), 1000);

        console.log("Non-owner address:", nonOwner);
        console.log("Owner address:", token.owner());
    }

    function testTransfer() public {
        token.mint(address(this), 1000);
        token.transfer(address(0x123), 500);
        assertEq(token.balanceOf(address(0x123)), 500);
        assertEq(token.balanceOf(address(this)), 500);
    }
}
