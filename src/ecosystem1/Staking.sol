// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC721.sol";
import "./ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Staking is IERC721Receiver, Ownable {
    MyNFT public nft;
    MyERC20 public erc20;

    struct StakedToken {
        address owner;
        uint256 stakedAt;
    }

    mapping(uint256 => StakedToken) public tokenOwners;
    mapping(address => uint256) public stakingBalance;

    event Staked(address indexed user, uint256 tokenId);
    event Unstaked(address indexed user, uint256 tokenId);
    event RewardPaid(address indexed user, uint256 reward);

    uint256 constant REWARD_RATE = 10 * 10 ** 18; // 10 tokens per 24 hours

    constructor(address _nft, address _erc20) Ownable(msg.sender) {
        nft = MyNFT(_nft);
        erc20 = MyERC20(_erc20);
    }

    function stake(uint256 tokenId) public {
        require(nft.ownerOf(tokenId) == msg.sender, "You do not own this token");

        nft.safeTransferFrom(msg.sender, address(this), tokenId);
        tokenOwners[tokenId] = StakedToken(msg.sender, block.timestamp);
        stakingBalance[msg.sender]++;

        emit Staked(msg.sender, tokenId);
    }

    function unstake(uint256 tokenId) public {
        require(tokenOwners[tokenId].owner == msg.sender, "You do not own this token");

        payReward(tokenId);
        nft.safeTransferFrom(address(this), msg.sender, tokenId);
        stakingBalance[msg.sender]--;
        delete tokenOwners[tokenId];

        emit Unstaked(msg.sender, tokenId);
    }

    function payReward(uint256 tokenId) public {
        StakedToken memory staked = tokenOwners[tokenId];
        require(staked.owner == msg.sender, "You do not own this token");

        uint256 stakingTime = block.timestamp - staked.stakedAt;
        uint256 reward = (stakingTime / 1 days) * REWARD_RATE;

        if (reward > 0) {
            erc20.mint(staked.owner, reward);
            emit RewardPaid(staked.owner, reward);
        }
    }

    function onERC721Received(address, address, uint256, bytes calldata) external pure override returns (bytes4) {
        return this.onERC721Received.selector;
    }
}
