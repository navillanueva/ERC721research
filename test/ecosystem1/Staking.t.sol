// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../../src/ecosystem1/Staking.sol";
import "../../src/ecosystem1/ERC20.sol";
import "../../src/ecosystem1/ERC721.sol";

contract StakingTest is Test {
    MyNFT public nft;
    MyERC20 public erc20;
    Staking public staking;
    address deployer = address(this);
    address user = address(1);
    bytes32 merkleRoot = 0xd33f2527cd0f37f892a86f8a33720f52156a0b6c65ff3bdeb2f2b0f82cc8baa6;

    function setUp() public {
        nft = new MyNFT(merkleRoot);
        erc20 = new MyERC20();
        staking = new Staking(nft, erc20);
    }

    function testStakeFunctionality() public {
        vm.prank(deployer);
        nft.approve(address(staking), 1);
        vm.prank(deployer);
        staking.stake(1);

        assertEq(nft.ownerOf(1), address(staking), "Staking contract should own the NFT.");
        assertGt(erc20.balanceOf(deployer), 0, "Deployer should receive ERC20 tokens as rewards.");
        assertTrue(staking.tokenOwners(1) == deployer, "Token ownership should be tracked correctly.");
    }

    function testUnstakeFunctionality() public {
        testStakeFunctionality(); // Ensure the NFT is staked first

        vm.prank(deployer);
        staking.unstake(1);

        assertEq(nft.ownerOf(1), deployer, "Deployer should get back the NFT after unstaking.");
        assertEq(staking.stakingBalance(deployer), 0, "Staking balance should be decremented upon unstaking.");
    }

    function testFailUnstakeByNonOwner() public {
        testStakeFunctionality(); // First, stake the token

        vm.prank(address(2)); // Another user trying to unstake
        vm.expectRevert("You do not own this token");
        staking.unstake(1); // This should fail
    }
}
