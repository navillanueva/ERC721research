// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../../src/ecosystem1/ERC20.sol";

contract ERC20Test is Test {
    MyERC20 token;
    address owner = address(1);
    address nonOwner = address(2);

    function setUp() public {
        vm.prank(owner);
        token = new MyERC20();
    }

    function testMint() public {
        vm.startPrank(owner);
        token.mint(owner, 1000);
        assertEq(token.balanceOf(owner), 1000, "Owner should have 1000 tokens after minting.");
        vm.stopPrank();
    }

    function testFailMintByNonOwner() public {
        vm.startPrank(nonOwner);
        token.mint(nonOwner, 1000); // This should fail
    }

    function testFailMintBeyondLimit() public {
        vm.startPrank(owner);
        token.mint(owner, type(uint256).max); // This should fail due to overflow
        vm.stopPrank();
    }
}
