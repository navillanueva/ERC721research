// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../../src/ecosystem1/Staking.sol";
import "../../src/ecosystem1/ERC20.sol";
import "../../src/ecosystem1/ERC721.sol";
import "forge-std/console.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

contract StakingTest is IERC721Receiver, Test {
    MyNFT public nft;
    MyERC20 public erc20;
    Staking public staking;
    address deployer = address(this);
    address user = address(1);
    bytes32[] proof;

    event Staked(address indexed user, uint256 tokenId);
    event Unstaked(address indexed user, uint256 tokenId);

    function setUp() public {
        nft = new MyNFT(0xd33f2527cd0f37f892a86f8a33720f52156a0b6c65ff3bdeb2f2b0f82cc8baa6);
        erc20 = new MyERC20();
        staking = new Staking(address(nft), address(erc20));
        erc20.setOwner(address(staking)); // transfering ownership to the staking contract so it can mint new tokens
        proof.push(0xd33f2527cd0f37f892a86f8a33720f52156a0b6c65ff3bdeb2f2b0f82cc8baa6);
    }

    function testStakeEmitEvent() public {
        nft.mint(1, proof);
        nft.approve(address(staking), 1);
        vm.expectEmit(true, true, true, true);
        emit Staked(deployer, 1);
        staking.stake(1);
    }

    function testStakeFunctionality() public {
        nft.mint(1, proof);
        nft.approve(address(staking), 1);
        staking.stake(1);
        assertEq(nft.ownerOf(1), address(staking), "Staking contract should own the NFT.");
        assertEq(staking.stakingBalance(deployer), 1, "Staking balance should be incremented.");
    }

    function testUnstakeFunctionality() public {
        testStakeFunctionality();
        vm.warp(block.timestamp + 1 days);
        staking.unstake(1);
        assertEq(nft.ownerOf(1), deployer, "Deployer should get back the NFT after unstaking.");
        assertEq(staking.stakingBalance(deployer), 0, "Staking balance should be decremented upon unstaking.");
        assertEq(erc20.balanceOf(deployer), 10 * 10 ** 18, "Deployer should receive ERC20 tokens as rewards.");
    }

    function testUnstakeEmitEvent() public {
        nft.mint(1, proof);
        nft.approve(address(staking), 1);
        staking.stake(1);
        vm.warp(block.timestamp + 1 days); // Simulate the passing of 1 day
        vm.expectEmit(true, true, true, true);
        emit Unstaked(deployer, 1);
        staking.unstake(1);
    }

    function testFailUnstakeByNonOwner() public {
        testStakeFunctionality();
        vm.prank(address(2));
        console.log("This is address 2", address(2));
        vm.expectRevert("You do not own this token");
        staking.unstake(1);
    }

    /// ERC721Receiver implementation necessary because in Foundry the deployer is a smart contract (not a wallet like hardhat)
    function onERC721Received(address, address, uint256, bytes memory) external pure override returns (bytes4) {
        return this.onERC721Received.selector;
    }
}
