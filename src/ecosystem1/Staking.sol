// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC721.sol";
import "./ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Staking is IERC721Receiver, Ownable {
    MyNFT public nft;
    MyERC20 public erc20;
    mapping(uint256 => address) public tokenOwners;
    mapping(address => uint256) public stakingBalance;
    mapping(uint256 => uint256) public stakingTimestamps;

    event Staked(address indexed user, uint256 tokenId);
    event Unstaked(address indexed user, uint256 tokenId);

    constructor(address _nft, address _erc20) Ownable(msg.sender) {
        nft = MyNFT(_nft);
        erc20 = MyERC20(_erc20);
    }

    function stake(uint256 tokenId) public {
        nft.safeTransferFrom(msg.sender, address(this), tokenId);
        tokenOwners[tokenId] = msg.sender;
        stakingBalance[msg.sender]++;
        stakingTimestamps[tokenId] = block.timestamp;
        emit Staked(msg.sender, tokenId);
    }

    function unstake(uint256 tokenId) public {
        require(tokenOwners[tokenId] == msg.sender, "You do not own this token");
        nft.safeTransferFrom(address(this), msg.sender, tokenId);
        stakingBalance[msg.sender]--;
        tokenOwners[tokenId] = address(0);

        uint256 stakedDuration = block.timestamp - stakingTimestamps[tokenId];
        uint256 reward = (stakedDuration / 1 days) * 10 * 10 ** 18;
        erc20.mint(msg.sender, reward);

        emit Unstaked(msg.sender, tokenId);
    }

    function onERC721Received(address, address, uint256, bytes memory) external pure override returns (bytes4) {
        return this.onERC721Received.selector;
    }
}
