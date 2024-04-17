// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC721.sol";
import "./ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

contract StakingContract is IERC721Receiver {
    MyNFT public nft;
    MyERC20 public erc20;
    mapping(uint256 => address) public tokenOwners;
    mapping(address => uint256) public stakingBalance;

    constructor(MyNFT _nft, MyERC20 _erc20) {
        nft = _nft;
        erc20 = _erc20;
    }

    function stake(uint256 tokenId) public {
        nft.safeTransferFrom(msg.sender, address(this), tokenId);
        tokenOwners[tokenId] = msg.sender;
        stakingBalance[msg.sender]++;
        erc20.mint(msg.sender, 10 * 10**18);  // Assuming ERC20 has 18 decimals
    }

    function unstake(uint256 tokenId) public {
        require(tokenOwners[tokenId] == msg.sender, "You do not own this token");
        nft.safeTransferFrom(address(this), msg.sender, tokenId);
        stakingBalance[msg.sender]--;
        tokenOwners[tokenId] = address(0);
    }

    function onERC721Received(
        address,
        address,
        uint256,
        bytes calldata
    ) external pure override returns (bytes4) {
        return this.onERC721Received.selector;
    }
}
