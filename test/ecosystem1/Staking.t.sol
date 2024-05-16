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
    bytes32[] proof;

    function setUp() public {
        nft = new MyNFT(0xd33f2527cd0f37f892a86f8a33720f52156a0b6c65ff3bdeb2f2b0f82cc8baa6);
        erc20 = new MyERC20();
        staking = new Staking(address(nft), address(erc20));
        proof.push(0xd33f2527cd0f37f892a86f8a33720f52156a0b6c65ff3bdeb2f2b0f82cc8baa6);
    }

    function testStakeFunctionality() public {
        // Mint the NFT to the deployer
        nft.mint(deployer, 1, proof);

        // Approve the staking contract to transfer the NFT
        nft.approve(address(staking), 1);

        // Stake the NFT
        staking.stake(1);

        // Assert the staking contract owns the NFT
        assertEq(nft.ownerOf(1), address(staking), "Staking contract should own the NFT.");

        // Assert the token owner is tracked correctly
        assertEq(staking.tokenOwners(1), deployer, "Token ownership should be tracked correctly.");

        // Assert the staking balance is incremented
        assertEq(staking.stakingBalance(deployer), 1, "Staking balance should be incremented.");
    }

    function testUnstakeFunctionality() public {
        // Mint and stake the NFT first
        testStakeFunctionality();

        // Simulate the passing of 1 day
        vm.warp(block.timestamp + 1 days);

        // Unstake the NFT
        staking.unstake(1);

        // Assert the deployer owns the NFT again
        assertEq(nft.ownerOf(1), deployer, "Deployer should get back the NFT after unstaking.");

        // Assert the staking balance is decremented
        assertEq(staking.stakingBalance(deployer), 0, "Staking balance should be decremented upon unstaking.");

        // Assert the deployer receives the ERC20 tokens as rewards
        assertEq(erc20.balanceOf(deployer), 10 * 10 ** 18, "Deployer should receive ERC20 tokens as rewards.");
    }

    function testFailUnstakeByNonOwner() public {
        // Mint and stake the NFT first
        testStakeFunctionality();

        // Another user tries to unstake
        vm.prank(address(2));
        vm.expectRevert("You do not own this token");
        staking.unstake(1); // This should fail
    }

    function testStakeEmitEvent() public {
        // Mint the NFT to the deployer
        nft.mint(deployer, 1, proof);

        // Approve the staking contract to transfer the NFT
        nft.approve(address(staking), 1);

        // Expect the Staked event to be emitted
        vm.expectEmit(true, true, true, true);
        emit Staked(deployer, 1);

        // Stake the NFT
        staking.stake(1);
    }

    function testUnstakeEmitEvent() public {
        // Mint the NFT to the deployer
        nft.mint(deployer, 1, proof);

        // Approve the staking contract to transfer the NFT
        nft.approve(address(staking), 1);

        // Stake the NFT
        staking.stake(1);

        // Simulate the passing of 1 day
        vm.warp(block.timestamp + 1 days);

        // Expect the Unstaked event to be emitted
        vm.expectEmit(true, true, true, true);
        emit Unstaked(deployer, 1);

        // Unstake the NFT
        staking.unstake(1);
    }
}
